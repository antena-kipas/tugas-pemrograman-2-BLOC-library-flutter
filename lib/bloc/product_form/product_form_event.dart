import 'package:equatable/equatable.dart';
import '../../models/product.dart';

abstract class ProductFormEvent extends Equatable {
  const ProductFormEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAddProduct extends ProductFormEvent {
  final String name;
  final double price;
  final String description;
  final String category;
  final String imagePath;

  const SubmitAddProduct({
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [name, price, description, category, imagePath];
}

class SubmitEditProduct extends ProductFormEvent {
  final Product oldProduct;
  final String name;
  final double price;
  final String description;
  final String category;

  const SubmitEditProduct({
    required this.oldProduct,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
  });

  @override
  List<Object?> get props => [oldProduct, name, price, description, category];
}