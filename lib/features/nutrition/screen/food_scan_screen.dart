import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import '../../../core/constants/food_scan_controller.dart';



class NutritionScreen extends StatelessWidget {
  static const String routName = 'NutritionScreen';
  NutritionScreen({super.key});

  final c = Get.put(FoodScanController());
  final _searchCtrl = TextEditingController();

  static const _bg = Color(0xFF0B0F0E);
  static const _card = Color(0xFF101615);
  static const _neon = Color(0xFF9AFF00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text('Nutrition'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SearchBar(
                controller: _searchCtrl,
                onSearch: () => c.searchFoods(_searchCtrl.text),
                neon: _neon,
                card: _card,
              ),
            ),

            const SizedBox(height: 12),

            // Scan barcode + quick barcode field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _ScanCard(
                neon: _neon,
                card: _card,
                onScanPressed: () {
                  // هنا تربط صفحة Scanner عندك (مثلاً: Get.toNamed('/scanner'))
                  // وبعد ما ترجع الباركود: c.fetchByBarcode(barcode);
                  Get.snackbar("Scan", "Connect your scanner screen and call fetchByBarcode(barcode).",
                      backgroundColor: _card, colorText: Colors.white);
                },
                onPasteBarcode: (barcode) => c.fetchByBarcode(barcode),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Obx(() {
                if (c.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (c.error.value != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        c.error.value!,
                        style: const TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (c.selectedProduct.value != null) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _ProductDetails(
                      p: c.selectedProduct.value!,
                      neon: _neon,
                      card: _card,
                      name: c.productName,
                      kcal: c.kcal,
                      protein: c.protein,
                      carbs: c.carbs,
                      fat: c.fat,
                      imageUrl: c.imageUrl,
                      onAdd: () {
                        // TODO: هنا تربطه بإضافة وجبة اليوم (Firebase / local)
                        Get.snackbar("Added", "Added to your day.",
                            backgroundColor: _card, colorText: Colors.white);
                      },
                    ),
                  );
                }

                // Search results list
                if (c.results.isEmpty) {
                  return const Center(
                    child: Text(
                      "Search foods or scan a barcode.",
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: c.results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final p = c.results[i];
                    return _ProductTile(
                      p: p,
                      neon: _neon,
                      card: _card,
                      title: c.productName(p),
                      kcal: c.kcal(p),
                      imageUrl: c.imageUrl(p),
                      onTap: () => c.selectedProduct.value = p,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onSearch,
    required this.neon,
    required this.card,
  });

  final TextEditingController controller;
  final VoidCallback onSearch;
  final Color neon;
  final Color card;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: neon.withOpacity(0.15)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white54),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSearch(),
              decoration: const InputDecoration(
                hintText: "Search foods...",
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: onSearch,
            icon: Icon(Icons.arrow_forward, color: neon),
          ),
        ],
      ),
    );
  }
}

class _ScanCard extends StatelessWidget {
  const _ScanCard({
    required this.neon,
    required this.card,
    required this.onScanPressed,
    required this.onPasteBarcode,
  });

  final Color neon;
  final Color card;
  final VoidCallback onScanPressed;
  final ValueChanged<String> onPasteBarcode;

  @override
  Widget build(BuildContext context) {
    final barcodeCtrl = TextEditingController();

    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: neon.withOpacity(0.18)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Scan Foods with OpenFoodFacts",
            style: TextStyle(color: neon, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            "Scan barcodes to get nutritional info (free database).",
            style: TextStyle(color: Colors.white60),
          ),
          const SizedBox(height: 12),

          // Scan button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: neon,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: onScanPressed,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("SCAN BARCODE"),
            ),
          ),

          const SizedBox(height: 12),

          // Manual barcode input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: barcodeCtrl,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Or paste barcode here (e.g. 737628064502)",
                    hintStyle: TextStyle(color: Colors.white38),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white12,
                  foregroundColor: neon,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => onPasteBarcode(barcodeCtrl.text),
                child: const Text("GO"),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.p,
    required this.neon,
    required this.card,
    required this.title,
    required this.kcal,
    required this.imageUrl,
    required this.onTap,
  });

  final Product p;
  final Color neon;
  final Color card;
  final String title;
  final num? kcal;
  final String? imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: card,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _Thumb(url: imageUrl, neon: neon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(
                      kcal != null ? "${kcal!.toStringAsFixed(0)} kcal" : "kcal: N/A",
                      style: TextStyle(color: neon.withOpacity(0.85)),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: neon.withOpacity(0.9)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({
    required this.p,
    required this.neon,
    required this.card,
    required this.name,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.imageUrl,
    required this.onAdd,
  });

  final Product p;
  final Color neon;
  final Color card;

  final String Function(Product) name;
  final num? Function(Product) kcal;
  final num? Function(Product) protein;
  final num? Function(Product) carbs;
  final num? Function(Product) fat;
  final String? Function(Product) imageUrl;

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final kcalVal = kcal(p);
    final proVal = protein(p);
    final carbVal = carbs(p);
    final fatVal = fat(p);

    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: neon.withOpacity(0.18)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Thumb(url: imageUrl(p), neon: neon, size: 64),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name(p),
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _MacroChip(label: "Calories", value: kcalVal != null ? kcalVal.toStringAsFixed(0) : "N/A", neon: neon),
              _MacroChip(label: "Protein (g)", value: proVal != null ? proVal.toStringAsFixed(0) : "N/A", neon: neon),
              _MacroChip(label: "Carbs (g)", value: carbVal != null ? carbVal.toStringAsFixed(0) : "N/A", neon: neon),
              _MacroChip(label: "Fat (g)", value: fatVal != null ? fatVal.toStringAsFixed(0) : "N/A", neon: neon),
            ],
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: neon,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: onAdd,
              child: const Text("ADD FOOD"),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Barcode: ${p.barcode ?? "N/A"}",
            style: const TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  const _MacroChip({required this.label, required this.value, required this.neon});
  final String label;
  final String value;
  final Color neon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: neon.withOpacity(0.12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: neon, fontSize: 16, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.url, required this.neon, this.size = 52});

  final String? url;
  final Color neon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: neon.withOpacity(0.15)),
        color: Colors.white10,
      ),
      clipBehavior: Clip.antiAlias,
      child: (url == null || url!.isEmpty)
          ? const Icon(Icons.fastfood, color: Colors.white54)
          : Image.network(url!, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
        return const Icon(Icons.fastfood, color: Colors.white54);
      }),
    );
  }
}
