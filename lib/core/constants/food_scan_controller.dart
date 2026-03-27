import 'package:get/get.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class FoodScanController extends GetxController {
  // PerSize _bestPerSize() {
  //   for (final v in PerSize.values) {
  //     final name = v.name.toLowerCase();
  //     if (name.contains('100')) return v;
  //   }
  //   for (final v in PerSize.values) {
  //     final name = v.name.toLowerCase();
  //     if (name.contains('serv')) return v;
  //   }
  //   return PerSize.values.first;
  // }
  final isLoading = false.obs;
  final error = RxnString();

  final results = <Product>[].obs;
  final selectedProduct = Rxn<Product>();

  late final User _user;

  @override
  void onInit() {
    super.onInit();

    OpenFoodAPIConfiguration.userAgent = UserAgent(
      name: 'Fitova',
      url: 'https://example.com',
    );

    OpenFoodAPIConfiguration.globalLanguages = const [
      OpenFoodFactsLanguage.ENGLISH,
      OpenFoodFactsLanguage.ARABIC,
    ];
    OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.JORDAN;

    _user = User(
      userId: 'fitova_app',
      password: 'fitova_app',
    );
    OpenFoodAPIConfiguration.globalUser = _user;
  }

  Future<void> searchFoods(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;

    isLoading.value = true;
    error.value = null;
    selectedProduct.value = null;

    try {
      final config = ProductSearchQueryConfiguration(
        version: ProductQueryVersion.v3,
        parametersList: <Parameter>[
          // لازم List<String>
          SearchTerms(terms: <String>[q]),
          const PageSize(size: 25),
        ],
        fields: const [
          ProductField.NAME,
          ProductField.NUTRIMENTS,
          ProductField.IMAGE_FRONT_URL,
          ProductField.BRANDS,
          ProductField.QUANTITY,
          ProductField.BARCODE,
        ],
      );

      final SearchResult res = await OpenFoodAPIClient.searchProducts(
        _user,
        config,
      );

      results.assignAll(res.products ?? []);
      if (results.isEmpty) {
        error.value = "No results found. Try another keyword.";
      }
    } catch (e) {
      error.value = "Search failed: $e";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchByBarcode(String barcode) async {
    final code = barcode.trim();
    if (code.isEmpty) return;

    isLoading.value = true;
    error.value = null;
    results.clear();

    try {
      final queryConfig = ProductQueryConfiguration(
        code,
        version: ProductQueryVersion.v3,
        fields: const [
          ProductField.NAME,
          ProductField.NUTRIMENTS,
          ProductField.IMAGE_FRONT_URL,
          ProductField.BRANDS,
          ProductField.QUANTITY,
          ProductField.BARCODE,
        ],
      );

      final ProductResultV3 res = await OpenFoodAPIClient.getProductV3(
        queryConfig,
      );
      final id = res.result?.id;
      final found = (id == ProductResultV3.resultProductFound);

      if (found && res.product != null) {
        selectedProduct.value = res.product;
      } else {
        error.value = "Product not found for barcode: $code";
      }
    } catch (e) {
      error.value = "Barcode lookup failed: $e";
    } finally {
      isLoading.value = false;
    }
  }

  String productName(Product p) =>
      (p.productName?.trim().isNotEmpty ?? false) ? p.productName!.trim() : "Unknown product";

  String? imageUrl(Product p) => p.imageFrontUrl;

  double? kcal(Product p) => p.nutriments?.getValue(Nutrient.energyKCal, PerSize.serving);
  double? protein(Product p) => p.nutriments?.getValue(Nutrient.proteins, PerSize.serving);
  double? carbs(Product p) => p.nutriments?.getValue(Nutrient.carbohydrates, PerSize.serving);
  double? fat(Product p) => p.nutriments?.getValue(Nutrient.fat, PerSize.serving);
}