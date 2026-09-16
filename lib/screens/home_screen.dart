import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_detail.dart';
import 'add_product.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Catalog")),
      body: ListView.builder(
        itemCount: globalProducts.length,
        itemBuilder: (context, index) {
          final product = globalProducts[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(product.name),
              subtitle: Text("Rp ${product.price.toStringAsFixed(0)}"),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(product: product),
                    ),
                  );
                },
                child: Text("Detail"),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Menunggu hasil dari halaman Add Product, lalu refresh UI
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductScreen()),
          );
          setState(() {}); // Memuat ulang list setelah produk ditambahkan
        },
        child: Icon(Icons.add),
      ),
    );
  }
}