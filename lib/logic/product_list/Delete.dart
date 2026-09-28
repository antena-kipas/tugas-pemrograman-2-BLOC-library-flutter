import '../../models/product.dart';
import '../../services/api_service.dart';

class DeleteProductLogic {
  static Future<void> deleteProduct(Product product) async {
    if (product.id == null) {
      throw Exception("ID Produk tidak ditemukan");
    }

    final apiService = ApiService();
    await apiService.deleteProduct(product.id!);
  }
}