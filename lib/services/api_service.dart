import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://pos.cicd.web.id',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<Response> getProducts() async {
    return await dio.get('/items/products');
  }

  Future<Response> getProduct(String id) async {
    return await dio.get('/items/products/$id');
  }

  Future<Response> addProduct(Map<String, dynamic> data) async {
    return await dio.post(
      '/items/products',
      data: data,
    );
  }

  Future<Response> updateProduct(
    String id,
    Map<String, dynamic> data,
  ) async {
    return await dio.patch(
      '/items/products/$id',
      data: data,
    );
  }

  Future<Response> deleteProduct(String id) async {
    return await dio.delete(
      '/items/products/$id',
    );
  }
  Future<void> logout() async {
    try {
      await dio.post('/auth/logout');
    } catch (e) {
      // Handle error if needed
    }
  }

  Future<String> uploadImage(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });

    final response = await dio.post(
      '/files',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    return response.data['data']['id'];
  }
}