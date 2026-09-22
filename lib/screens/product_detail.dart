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
      builder: (context) {
        return ConfirmDelete(
          onCancel: () {
            Navigator.pop(context);
          },
          onConfirm: () {
            DeleteProductLogic.deleteProduct(_product);

            Navigator.pop(context); // tutup dialog
            Navigator.pop(context); // kembali ke Home
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(_product.imageUrl, height: 200, fit: BoxFit.cover),
            ),
            SizedBox(height: 16),
            Text(_product.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Rp ${_product.price.toStringAsFixed(0)}", 
                style: TextStyle(fontSize: 20, color: Colors.green)),
            SizedBox(height: 16),
            Text("Deskripsi:", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(_product.description),
            Spacer(),
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