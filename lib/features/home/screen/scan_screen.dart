import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../../nutrition/screen/food_search.dart' show FoodSearchScreen;

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  // ====== CONFIG ======
  static const Color accent = Color(0xFF94F608);

  // ضع API KEY تبعك هنا
  static const String calorieNinjasApiKey = "jfHQQo6J0+HBtXuuX9Km6g==phJ3UpPY06TpLuqz";

  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  bool _loading = false;
  String? _detectedName;
  NutritionResult? _result;
  String? _error;

  Future<void> _scanFromCamera() async {
    setState(() {
      _error = null;
      _detectedName = null;
      _result = null;
    });

    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (picked == null) return;

    final file = File(picked.path);
    setState(() => _imageFile = file);

    await _runScan(file);
  }

  Future<void> _runScan(File file) async {
    setState(() => _loading = true);

    try {
      // 1) ML Kit: Image Labeling
      final inputImage = InputImage.fromFile(file);
      final labeler = ImageLabeler(
        options: ImageLabelerOptions(confidenceThreshold: 0.6),
      );

      final labels = await labeler.processImage(inputImage);
      await labeler.close();

      if (labels.isEmpty) {
        setState(() {
          _loading = false;
          _error = "ما قدرت أتعرف على الأكل. جرّب صورة أوضح 🙏";
        });
        return;
      }

      labels.sort((a, b) => b.confidence.compareTo(a.confidence));
      final bestLabel = labels.first.label.toLowerCase();
      setState(() => _detectedName = bestLabel);

      // 2) Nutrition API
      final nutrition = await _fetchNutrition(bestLabel);

      if (nutrition == null) {
        setState(() {
          _loading = false;
          _error =
          "تعرفنا على: $bestLabel لكن ما لقينا معلومات تغذية. جرّب تصوير أقرب أو نوع أكل أوضح.";
        });
        return;
      }

      setState(() {
        _result = nutrition;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = "صار خطأ أثناء السكان: $e";
      });
    }
  }

  Future<NutritionResult?> _fetchNutrition(String query) async {
    final uri = Uri.parse(
      "https://api.calorieninjas.com/v1/nutrition?query=${Uri.encodeComponent(query)}",
    );

    final res = await http.get(
      uri,
      headers: {"X-Api-Key": calorieNinjasApiKey},
    );

    if (res.statusCode != 200) return null;

    final data = jsonDecode(res.body) as Map<String, dynamic>;
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
  Widget build(BuildContext context) {
    return Container(
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
                  Text(
                    'Scan',
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              SizedBox(height: 2.h),

              // ====== PREVIEW CARD ======
              Container(
                height: 40.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: const Color.fromRGBO(18, 18, 18, 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: _imageFile == null
                      ? _emptyPreview()
                      : Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(_imageFile!, fit: BoxFit.cover),
                      // overlay خفيف
                      Container(
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // زر السكان
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
                  onPressed: _loading ? null : _scanFromCamera,
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
                    "Scan Food",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: (){Navigator.of(context).pushNamed(FoodSearchScreen.routName);},
                child: Text(
                  "Food Search",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 1.5.h),

              if (_detectedName != null)
                Text(
                  "Detected: $_detectedName",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.white70,
                  ),
                ),

              if (_error != null)
                Padding(
                  padding: EdgeInsets.only(top: 1.h),
                  child: Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: Colors.redAccent,
                    ),
                  ),
                ),

              SizedBox(height: 1.5.h),

              // ====== RESULT CARD ======
              if (_result != null) _resultCard(_result!),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyPreview() {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.image_outlined, color: Colors.white54, size: 42.sp),
              SizedBox(height: 1.h),
              Text(
                "No Image Preview",
                style: GoogleFonts.poppins(color: Colors.white54),
              ),
            ],
          ),
        ),

        // زوايا شكل سكان (اختياري)
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.all(5.w),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12, width: 1),
              ),
            ),
          ),
        ),
      ],
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
          // chips
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
                style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11.sp),
              ),
              SizedBox(width: 4.w),
              Text(
                "${r.calories.toStringAsFixed(0)} kcal",
                style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11.sp),
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
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white70,
          fontSize: 10.sp,
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
          Icon(icon, color: accent, size: 18.sp),
          SizedBox(height: 0.6.h),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.2.h),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white60,
              fontSize: 10.sp,
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
