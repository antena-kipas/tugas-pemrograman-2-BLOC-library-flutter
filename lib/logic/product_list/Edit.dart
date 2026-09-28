import '../../models/product.dart';
import '../../services/api_service.dart';

class EditProductLogic {
  static Future<Product> editProduct({
    required Product oldProduct,
    required String name,
    required double price,
    required String description,
    required String category,
  }) async {
    if (oldProduct.id == null) {
      throw Exception("ID Produk tidak ditemukan");
    }

    final apiService = ApiService();
    
    final Map<String, dynamic> updateData = {
      'name': name,
      'price': price.toInt(),
      'description': description,
      'category': category,
    };

    await apiService.updateProduct(oldProduct.id!, updateData);

    return Product(
      id: oldProduct.id,
      name: name,
      price: price.toInt(),
      description: description,
      category: category,
      imageUrl: oldProduct.imageUrl,
      status: oldProduct.status,
      sort: oldProduct.sort,
      userCreated: oldProduct.userCreated,
      dateCreated: oldProduct.dateCreated,
      userUpdated: oldProduct.userUpdated,
      dateUpdated: oldProduct.dateUpdated,
      quantity: oldProduct.quantity,
    );
  }
}