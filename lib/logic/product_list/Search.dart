import '../../models/product.dart';

class SearchProductLogic {
  static List<Product> searchProduct(String keyword) {
    if (keyword.isEmpty) {
      return globalProducts;
    }

    return globalProducts
        .where(
          (product) => product.name
              .toLowerCase()
              .contains(keyword.toLowerCase()),
        )
        .toList();
  }
}