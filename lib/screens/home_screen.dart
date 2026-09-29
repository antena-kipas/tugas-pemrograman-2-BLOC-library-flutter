import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/product/product_state.dart';
import '../services/api_service.dart';
import '../components/screen_input.dart';
import 'login_screen.dart';
import 'product_detail.dart';
import 'add_product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Panggil event untuk mengambil data saat widget pertama kali di-build
    context.read<ProductBloc>().add(FetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? SearchInput(
                onChanged: (keyword) {
                  // Memicu event pencarian ke BLoC
                  context.read<ProductBloc>().add(SearchProducts(keyword));
                },
              )
            : const Text("Product Catalog"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Note: Logout ini nanti bisa dipindah ke AuthBloc
              await ApiService().logout();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  // Reset pencarian jika fitur pencarian ditutup
                  context.read<ProductBloc>().add(const SearchProducts(''));
                }
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductInitial || state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } 
          
          if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(FetchProducts());
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (state is ProductLoaded) {
            if (state.displayedProducts.isEmpty) {
              return const Center(child: Text('Belum ada produk'));
            }

            return ListView.builder(
              itemCount: state.displayedProducts.length,
              itemBuilder: (context, index) {
                final product = state.displayedProducts[index];
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
                        // Refresh data setelah kembali dari detail/edit screen
                        if (mounted) {
                          context.read<ProductBloc>().add(FetchProducts());
                        }
                      },
                      child: const Text("Detail"),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductScreen(),
            ),
          );
          // Refresh data setelah selesai menambah produk
          if (mounted) {
            context.read<ProductBloc>().add(FetchProducts());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}