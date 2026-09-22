import 'package:flutter/material.dart';
import '../models/product.dart';
import '../components/product_form.dart';
import '../logic/product_list/Edit.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _descController;
  late final TextEditingController _categoryController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.product.name,
    );

    _priceController = TextEditingController(
      text: widget.product.price.toStringAsFixed(0),
    );

    _descController = TextEditingController(
      text: widget.product.description,
    );

    _categoryController = TextEditingController(
      text: widget.product.category,
    );
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));

      final price = double.tryParse(_priceController.text);

      if (price == null || price <= 0) {
        throw Exception("Harga produk tidak valid");
      }

      final updatedProduct = EditProductLogic.editProduct(
            oldProduct: widget.product,
            name: _nameController.text,
            price: price,
            description: _descController.text,
            category: _categoryController.text,
        );

        if (mounted) {
            Navigator.pop(context, updatedProduct);
        }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceAll("Exception: ", ""),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _categoryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProductForm(
          formKey: _formKey,
          nameController: _nameController,
          priceController: _priceController,
          descController: _descController,
          categoryController: _categoryController,
          isLoading: _isLoading,
          onSubmit: _updateProduct,
        ),
      ),
    );
  }
}