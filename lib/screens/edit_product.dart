import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/product_form/product_form_bloc.dart';
import '../bloc/product_form/product_form_event.dart';
import '../bloc/product_form/product_form_state.dart';
import '../models/product.dart';
import '../components/product_form.dart';

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
  final ImagePicker _picker = ImagePicker();
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(text: widget.product.price.toStringAsFixed(0));
    _descController = TextEditingController(text: widget.product.description);
    _categoryController = TextEditingController(text: widget.product.category);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  void _updateProduct() {
    if (!_formKey.currentState!.validate()) {
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

    // Trigger event Edit BLoC
    context.read<ProductFormBloc>().add(
      SubmitEditProduct(
        oldProduct: widget.product,
        name: _nameController.text,
        price: price,
        description: _descController.text,
        category: _categoryController.text,
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
        title: const Text("Edit Product"),
      ),
      body: BlocListener<ProductFormBloc, ProductFormState>(
        listener: (context, state) {
          if (state is ProductFormSuccess) {
            // Mengirim balik produk yang sudah di-update ke halaman detail
            Navigator.pop(context, state.updatedProduct);
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
                isLoading: state is ProductFormLoading, // Update dari state BLoC
                onSubmit: _updateProduct,
              );
            },
          ),
        ),
      ),
    );
  }
}