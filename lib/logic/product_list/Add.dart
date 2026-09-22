import '../../models/product.dart';

class AddProductLogic {
  static void addProduct({
    required String name,
    required double price,
    required String description,
    required String category,
  }) {
    final newProduct = Product(
      name: name,
      price: price,
      description: description,
      category: category,
      imageUrl: "https://picsum.photos/202",
    );

    globalProducts.add(newProduct);
  }
}