import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/login_screen.dart';
import 'services/api_service.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/product/product_bloc.dart';
import 'bloc/product_form/product_form_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi ApiService satu kali untuk digunakan bersama
    final apiService = ApiService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(apiService: apiService),
        ),
        BlocProvider<ProductFormBloc>(
          create: (context) => ProductFormBloc(apiService: apiService),
        ),
      ],
      child: MaterialApp(
        title: 'Product Catalog',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}