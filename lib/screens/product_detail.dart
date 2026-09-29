import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';
import 'edit_product.dart';
import '../components/confirm_delete.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/product/product_state.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() {
    return _ProductDetailScreenState();
  }
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Product _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ConfirmDelete(
          onCancel: () {
            Navigator.pop(dialogContext);
          },
          onConfirm: () {
            // Tutup dialog konfirmasi terlebih dahulu
            Navigator.pop(dialogContext);
            
            // Tembakkan event delete ke BLoC
            context.read<ProductBloc>().add(DeleteProduct(_product));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_product.name)),
      // BlocListener untuk memantau status penghapusan
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductDeleteSuccess) {
            // Jika berhasil dihapus, kembali ke HomeScreen
            Navigator.pop(context);
          } else if (state is ProductDeleteFailure) {
            // Tampilkan error jika gagal
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bungkus gambar atau area tertentu dengan BlocBuilder (opsional jika ingin efek loading di detail)
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Center(
                    child: _product.imageUrl != null
                        ? Image.network(
                            'https://pos.cicd.web.id/assets/${_product.imageUrl}',
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image,
                                  size: 200, color: Colors.grey);
                            },
                          )
                        : const Icon(Icons.image, size: 200),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(_product.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Rp ${_product.price.toStringAsFixed(0)}",
                  style: const TextStyle(fontSize: 20, color: Colors.green)),
              const SizedBox(height: 16),
              const Text("Deskripsi:",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_product.description ?? 'Tidak ada deskripsi'),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final updatedProduct = await Navigator.push<Product>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProductScreen(
                              product: _product,
                            ),
                          ),
                        );
                        if (updatedProduct != null) {
                          setState(() {
                            _product = updatedProduct;
                          });
                        }
                      },
                      child: const Text("Edit"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showDeleteConfirmation,
                      child: const Text("Delete"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}