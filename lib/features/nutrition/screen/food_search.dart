import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class FoodSearchScreen extends StatefulWidget {
  static const routName = "FoodSearchScreen";
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  static const Color accent = Color(0xFF94F608);

  // ضع API KEY تبعك هنا
  static const String calorieNinjasApiKey = "jfHQQo6J0+HBtXuuX9Km6g==phJ3UpPY06TpLuqz";

  final TextEditingController _controller = TextEditingController();

  bool _loading = false;
  NutritionResult? _result;
  String? _error;

  Future<void> _searchFood() async {
    final q = _controller.text.trim();
    if (q.isEmpty) {
      setState(() => _error = "اكتب اسم الأكل أولاً");
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });

    try {
      final res = await _fetchNutrition(q);

      if (res == null) {
        setState(() {
          _loading = false;
          _error = "ما لقينا نتيجة لـ: $q (جرّب اسم ثاني)";
        });
        return;
      }

      setState(() {
        _loading = false;
        _result = res;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = "صار خطأ: ${e.toString()}";
      });
    }
  }

  Future<NutritionResult?> _fetchNutrition(String query) async {
    final uri = Uri.parse(
      "https://api.calorieninjas.com/v1/nutrition?query=${Uri.encodeComponent(query)}",
    );

    final response = await http.get(
      uri,
      headers: {
        "X-Api-Key": calorieNinjasApiKey, // حسب التوثيق الرسمي
        "Accept": "application/json",
      },
    );

    // ديبَغ يساعدك تشوف شو بيرجع الـ API
    debugPrint("Status: ${response.statusCode}");
    debugPrint("Body: ${response.body}");

    if (response.statusCode == 401 || response.statusCode == 403) {
      // Unauthorized / Forbidden => غالبًا API KEY غلط
      throw Exception("API Key غير صحيح أو غير مفعّل (401/403)");
    }

    if (response.statusCode != 200) {
      throw Exception("API Error: ${response.statusCode}");
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = (data["items"] as List?) ?? [];
    if (items.isEmpty) return null;

    final item = items.first as Map<String, dynamic>;

    return NutritionResult(
      name: (item["name"] ?? query).toString(),
      calories: (item["calories"] ?? 0).toDouble(),
      proteinG: (item["protein_g"] ?? 0).toDouble(),
      carbsG: (item["carbohydrates_total_g"] ?? 0).toDouble(),
      fatG: (item["fat_total_g"] ?? 0).toDouble(),
      servingG: (item["serving_size_g"] ?? 100).toDouble(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1C2B06), Color(0xFF0B0F0A), Color(0xFF070A06)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: [
                SizedBox(height: 1.h),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Spacer(),
                    Text(
                      'Food Search',
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
      
                SizedBox(height: 2.h),
      
                // ===== Search Bar =====
                Container(
                  height: 6.2.h,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: accent.withOpacity(0.25)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.white.withOpacity(0.75)),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => _searchFood(),
                          decoration: InputDecoration(
                            hintText: "Search food (e.g. apple, rice, chicken)",
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.55)),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _loading ? null : _searchFood,
                        borderRadius: BorderRadius.circular(18),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(Icons.arrow_forward, color: accent),
                        ),
                      ),
                    ],
                  ),
                ),
      
                SizedBox(height: 2.h),
      
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _loading ? null : _searchFood,
                    child: _loading
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                        : Text(
                      "Search",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
      
                if (_error != null) ...[
                  SizedBox(height: 1.2.h),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
      
                SizedBox(height: 1.8.h),
      
                if (_result != null) _resultCard(_result!),
      
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultCard(NutritionResult r) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(18, 18, 18, 1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _chip("Food"),
              SizedBox(width: 2.w),
              _chip("${r.servingG.toStringAsFixed(0)}Gr"),
            ],
          ),
          SizedBox(height: 1.h),

          Text(
            _capitalize(r.name),
            style: GoogleFonts.poppins(
              fontSize: 22.sp,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 0.6.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Good For Diet",
                style: GoogleFonts.poppins(color: Colors.white60, fontSize: 15.sp),
              ),
              SizedBox(width: 4.w),
              Text(
                "${r.calories.toStringAsFixed(0)} kcal",
                style: GoogleFonts.poppins(color: Colors.white60, fontSize: 15.sp),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                child: _macroBox(
                  title: "Protein",
                  value: "${r.proteinG.toStringAsFixed(0)} gr",
                  icon: Icons.local_fire_department,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _macroBox(
                  title: "Carb",
                  value: "${r.carbsG.toStringAsFixed(0)} gr",
                  icon: Icons.bakery_dining,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _macroBox(
                  title: "Fat",
                  value: "${r.fatG.toStringAsFixed(0)} gr",
                  icon: Icons.opacity,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white70,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _macroBox({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 3.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
        color: Colors.black.withOpacity(0.10),
      ),
      child: Column(
        children: [
          Icon(icon, color: accent, size: 25.sp),
          SizedBox(height: 0.6.h),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.2.h),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white60,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

class NutritionResult {
  final String name;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double servingG;

  NutritionResult({
    required this.name,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.servingG,
  });
}
