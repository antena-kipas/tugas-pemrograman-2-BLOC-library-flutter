import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'product_detail.dart';
import 'add_product.dart';
import '../components/screen_input.dart';
import '../logic/product_list/Search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();

  List<Product> allProducts = [];
  List<Product> displayedProducts = [];

  bool isLoading = false;
  String? errorMessage;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await apiService.getProducts();
      final data = response.data['data'] as List;

      final loadedProducts = data
          .map(
            (json) => Product.fromJson(json),
          )
          .toList();

      setState(() {
        allProducts = loadedProducts;
        displayedProducts = loadedProducts;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal mengambil data produk';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? SearchInput(
                onChanged: (keyword) {
                  setState(() {
                    displayedProducts = SearchProductLogic.searchProduct(
                      allProducts,
                      keyword,
                    );
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
                  displayedProducts = allProducts;
                }
              });
            },
          ),
        ],
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductScreen(),
            ),
          );
          getProducts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: getProducts,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (displayedProducts.isEmpty) {
      return const Center(
        child: Text('Belum ada produk'),
      );
    }

    return ListView.builder(
      itemCount: displayedProducts.length,
      itemBuilder: (context, index) {
        final product = displayedProducts[index];

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: SizedBox(
              width: 50,
              height: 50,
              child: product.imageUrl != null
                  ? Image.network(
                      'https://pos.cicd.web.id/assets/${product.imageUrl}',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 40);
                      },
                    )
                  : const Icon(Icons.image, size: 40),
            ),
            title: Text(product.name),
            subtitle: Text(
              "Rp ${product.price.toStringAsFixed(0)}",
            ),
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
                getProducts();
              },
              child: const Text("Detail"),
            ),
          ),
        );
      },
    );
  }
}