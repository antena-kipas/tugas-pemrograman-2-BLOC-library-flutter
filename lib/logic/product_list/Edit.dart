import '../../models/product.dart';

class EditProductLogic {
  static Product editProduct({
    required Product oldProduct,
    required String name,
    required double price,
    required String description,
    required String category,
  }) {
    final index = globalProducts.indexOf(oldProduct);

    if (index == -1) {
      throw Exception("Produk tidak ditemukan");
    }

    final updatedProduct = Product(
      name: name,
      price: price,
      description: description,
      category: category,
      imageUrl: oldProduct.imageUrl,
    );

    globalProducts[index] = updatedProduct;

    return updatedProduct;
  }
}