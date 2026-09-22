import '../../models/product.dart';

class DeleteProductLogic {
  static void deleteProduct(Product product) {
    final index = globalProducts.indexOf(product);

    if (index == -1) {
      throw Exception("Produk tidak ditemukan");
    }

    globalProducts.removeAt(index);
  }
}