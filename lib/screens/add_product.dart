import 'package:flutter/material.dart';
import '../logic/product_list/Add.dart';
import '../components/product_form.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _categoryController = TextEditingController();
  
  bool _isLoading = false;

  Future<void> _saveProduct() async {
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

      AddProductLogic.addProduct(
        name: _nameController.text,
        price: price,
        description: _descController.text,
        category: _categoryController.text,
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll("Exception: ", "")),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
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
          onSubmit: _saveProduct,
        ),
      ),
    );
  }
}