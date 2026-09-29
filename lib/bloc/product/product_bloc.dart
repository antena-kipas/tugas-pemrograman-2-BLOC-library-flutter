import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import '../../models/product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ApiService apiService;

  ProductBloc({required this.apiService}) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onFetchProducts(FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final response = await apiService.getProducts();
      final data = response.data['data'] as List;
      final loadedProducts = data.map((json) => Product.fromJson(json)).toList();
      
      emit(ProductLoaded(
        allProducts: loadedProducts,
        displayedProducts: loadedProducts,
      ));
    } catch (e) {
      emit(const ProductError('Gagal mengambil data produk'));
    }
  }

  void _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) {
    final currentState = state;
    if (currentState is ProductLoaded) {
      final keyword = event.keyword.toLowerCase();
      if (keyword.isEmpty) {
        emit(ProductLoaded(
          allProducts: currentState.allProducts,
          displayedProducts: currentState.allProducts,
        ));
      } else {
        final filtered = currentState.allProducts.where((product) {
          return product.name.toLowerCase().contains(keyword);
        }).toList();
        
        emit(ProductLoaded(
          allProducts: currentState.allProducts,
          displayedProducts: filtered,
        ));
      }
    }
  }


  Future<void> _onDeleteProduct(DeleteProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      if (event.product.id == null) {
        throw Exception("ID Produk tidak ditemukan");
      }
      
      await apiService.deleteProduct(event.product.id!);
      emit(ProductDeleteSuccess());
      
      // Setelah delete berhasil, jangan lupa untuk reload data produk terbaru
      add(FetchProducts());
      
    } catch (e) {
      emit(ProductDeleteFailure(e.toString().replaceAll("Exception: ", "")));
      // Kembalikan state ke posisi awal agar UI list tetap bisa dirender
      add(FetchProducts()); 
    }
  }
}