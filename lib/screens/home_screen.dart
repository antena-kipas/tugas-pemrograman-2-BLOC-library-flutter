import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_detail.dart';
import 'add_product.dart';
import '../components/screen_input.dart';
import '../logic/product_list/Search.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Product> filteredProducts = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Saat awal, tampilkan semua produk
    filteredProducts = globalProducts; 
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? SearchInput(
                onChanged: (keyword) {
                  setState(() {
                    filteredProducts =
                        SearchProductLogic.searchProduct(keyword);
                  });
                },
              )
            : const Text("Product Catalog"),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;

                if (!_isSearching) {
                  filteredProducts = globalProducts;
                }
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(product.name),
              subtitle: Text("Rp ${product.price.toStringAsFixed(0)}"),
              trailing: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(
                        product: product,
                      ),
                    ),
                  );

                  setState(() {});
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