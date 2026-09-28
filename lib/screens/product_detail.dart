import 'package:flutter/material.dart';
import '../models/product.dart';
import 'edit_product.dart';
import '../components/confirm_delete.dart';
import '../logic/product_list/Delete.dart';

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

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ConfirmDelete(
          onCancel: () {
            Navigator.pop(dialogContext);
          },
          onConfirm: () async {
            Navigator.pop(dialogContext);
            
            try {
              await DeleteProductLogic.deleteProduct(_product);
              
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
            }
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: _product.imageUrl != null
                ? Image.network(
                    'https://pos.cicd.web.id/assets/${_product.imageUrl}',
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 200, color: Colors.grey);
                    },
                  )
                : const Icon(Icons.image, size: 200),
            ),
            const SizedBox(height: 16),
            Text(_product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Rp ${_product.price.toStringAsFixed(0)}", 
                style: const TextStyle(fontSize: 20, color: Colors.green)),
            const SizedBox(height: 16),
            const Text("Deskripsi:", style: const TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }
}