import 'package:equatable/equatable.dart';
import '../../models/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> allProducts;
  final List<Product> displayedProducts;

  const ProductLoaded({
    required this.allProducts,
    required this.displayedProducts,
  });

  @override
  List<Object?> get props => [allProducts, displayedProducts];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductDeleteFailure extends ProductState {
  final String message;

  const ProductDeleteFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductDeleteSuccess extends ProductState {}