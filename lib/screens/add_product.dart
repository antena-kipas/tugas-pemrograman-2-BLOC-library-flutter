import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../logic/product_list/Add.dart';
import '../components/product_form.dart';
import '../services/api_service.dart';

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
  
  final ImagePicker _picker = ImagePicker();
  String? _selectedImagePath;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih gambar terlebih dahulu"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final price = double.tryParse(_priceController.text);

      if (price == null || price <= 0) {
        throw Exception("Harga produk tidak valid");
      }

      final apiService = ApiService();
      final String imageUuid = await apiService.uploadImage(_selectedImagePath!);

      await AddProductLogic.addProduct(
        name: _nameController.text,
        price: price,
        description: _descController.text,
        category: _categoryController.text,
        imageUrl: imageUuid,
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
          selectedImagePath: _selectedImagePath,
          onPickImage: _pickImage,
          isLoading: _isLoading,
          onSubmit: _saveProduct,
        ),
      ),
    );
  }
}