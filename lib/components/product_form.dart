import 'package:flutter/material.dart';
import 'dart:io';

class ProductForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController descController;
  final TextEditingController categoryController;
  final String? selectedImagePath;
  final VoidCallback onPickImage;
  final bool isLoading;
  final VoidCallback onSubmit;

  const ProductForm({
    Key? key,
    required this.formKey,
    required this.nameController,
    required this.priceController,
    required this.descController,
    required this.categoryController,
    required this.selectedImagePath,
    required this.onPickImage,
    required this.isLoading,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          GestureDetector(
            onTap: onPickImage,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: selectedImagePath != null
                  ? Image.file(
                      File(selectedImagePath!),
                      fit: BoxFit.cover,
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                        Text("Tap untuk memilih gambar"),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Nama Produk",
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nama produk harus diisi';
              }
              return null;
            },
          ),
          TextFormField(
            controller: priceController,
            decoration: const InputDecoration(
              labelText: "Harga",
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Harga harus diisi';
              }
              if (double.tryParse(value) == null) {
                return 'Harga harus berupa angka';
              }
              return null;
            },
          ),
          TextFormField(
            controller: descController,
            decoration: const InputDecoration(
              labelText: "Deskripsi",
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Deskripsi harus diisi';
              }
              return null;
            },
          ),
          TextFormField(
            controller: categoryController,
            decoration: const InputDecoration(
              labelText: "Kategori",
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Kategori harus diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  onPressed: onSubmit,
                  child: const Text("Simpan Produk"),
                ),
        ],
      ),
    );
  }
}