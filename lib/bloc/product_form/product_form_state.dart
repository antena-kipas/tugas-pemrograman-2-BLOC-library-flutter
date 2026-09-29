import 'package:equatable/equatable.dart';
import '../../models/product.dart';

abstract class ProductFormState extends Equatable {
  const ProductFormState();
  
  @override
  List<Object?> get props => [];
}

class ProductFormInitial extends ProductFormState {}

class ProductFormLoading extends ProductFormState {}

class ProductFormSuccess extends ProductFormState {
  final Product? updatedProduct; // Null jika Add, terisi jika Edit

  const ProductFormSuccess({this.updatedProduct});

  @override
  List<Object?> get props => [updatedProduct];
}

class ProductFormFailure extends ProductFormState {
  final String message;

  const ProductFormFailure(this.message);

  @override
  List<Object?> get props => [message];
}

