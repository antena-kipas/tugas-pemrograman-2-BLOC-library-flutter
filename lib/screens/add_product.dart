import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/product_form/product_form_bloc.dart';
import '../bloc/product_form/product_form_event.dart';
import '../bloc/product_form/product_form_state.dart';
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
  final ImagePicker _picker = ImagePicker();
  String? _selectedImagePath;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  void _saveProduct() {
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

    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harga produk tidak valid"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Trigger event BLoC
    context.read<ProductFormBloc>().add(
      SubmitAddProduct(
        name: _nameController.text,
        price: price,
        description: _descController.text,
        category: _categoryController.text,
        imagePath: _selectedImagePath!,
      ),
    );
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
      body: BlocListener<ProductFormBloc, ProductFormState>(
        listener: (context, state) {
          if (state is ProductFormSuccess) {
            Navigator.pop(context);
          } else if (state is ProductFormFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ProductFormBloc, ProductFormState>(
            builder: (context, state) {
              return ProductForm(
                formKey: _formKey,
                nameController: _nameController,
                priceController: _priceController,
                descController: _descController,
                categoryController: _categoryController,
                selectedImagePath: _selectedImagePath,
                onPickImage: _pickImage,
                isLoading: state is ProductFormLoading, // Update indikator loading dari BLoC
                onSubmit: _saveProduct,
              );
            },
          ),
        ),
      ),
    );
  }
}