import '../../models/product.dart';

class SearchProductLogic {
  static List<Product> searchProduct(List<Product> products, String keyword) {
    if (keyword.isEmpty) {
      return products;
    }

    return products
        .where(
          (product) => product.name
              .toLowerCase()
              .contains(keyword.toLowerCase()),
        )
        .toList();
  }
}