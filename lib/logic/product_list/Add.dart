import '../../services/api_service.dart';

class AddProductLogic {
  static Future<void> addProduct({
    required String name,
    required double price,
    required String description,
    required String category,
    required String imageUrl,
  }) async {
    final apiService = ApiService();
    
    final Map<String, dynamic> productData = {
      'name': name,
      'price': price.toInt(),
      'description': description,
      'category': category,
      'image_url': imageUrl,
    };

    await apiService.addProduct(productData);
  }
}