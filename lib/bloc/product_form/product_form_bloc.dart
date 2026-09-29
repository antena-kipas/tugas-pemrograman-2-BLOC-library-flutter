import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import '../../models/product.dart';
import 'product_form_event.dart';
import 'product_form_state.dart';

class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  final ApiService apiService;

  ProductFormBloc({required this.apiService}) : super(ProductFormInitial()) {
    on<SubmitAddProduct>(_onSubmitAddProduct);
    on<SubmitEditProduct>(_onSubmitEditProduct);
  }

  Future<void> _onSubmitAddProduct(SubmitAddProduct event, Emitter<ProductFormState> emit) async {
    emit(ProductFormLoading());
    try {
      final String imageUuid = await apiService.uploadImage(event.imagePath);
      
      final Map<String, dynamic> productData = {
        'name': event.name,
        'price': event.price.toInt(),
        'description': event.description,
        'category': event.category,
        'image_url': imageUuid,
      };
      
      await apiService.addProduct(productData);
      emit(const ProductFormSuccess());
    } catch (e) {
      emit(ProductFormFailure(e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> _onSubmitEditProduct(SubmitEditProduct event, Emitter<ProductFormState> emit) async {
    emit(ProductFormLoading());
    try {
      if (event.oldProduct.id == null) {
        throw Exception("ID Produk tidak ditemukan");
      }

      final Map<String, dynamic> updateData = {
        'name': event.name,
        'price': event.price.toInt(),
        'description': event.description,
        'category': event.category,
      };

      await apiService.updateProduct(event.oldProduct.id!, updateData);
      
      final updatedProduct = Product(
        id: event.oldProduct.id,
        name: event.name,
        price: event.price.toInt(),
        description: event.description,
        category: event.category,
        imageUrl: event.oldProduct.imageUrl,
        status: event.oldProduct.status,
        sort: event.oldProduct.sort,
        userCreated: event.oldProduct.userCreated,
        dateCreated: event.oldProduct.dateCreated,
        userUpdated: event.oldProduct.userUpdated,
        dateUpdated: event.oldProduct.dateUpdated,
        quantity: event.oldProduct.quantity,
      );

      emit(ProductFormSuccess(updatedProduct: updatedProduct));
    } catch (e) {
      emit(ProductFormFailure(e.toString().replaceAll("Exception: ", "")));
    }
  }
}