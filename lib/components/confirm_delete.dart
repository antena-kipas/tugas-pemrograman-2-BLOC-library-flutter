import 'package:flutter/material.dart';

class ConfirmDelete extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmDelete({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Hapus Produk?"),
      content: const Text(
        "Apakah kamu yakin ingin menghapus produk ini?",
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text("Tidak"),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          child: const Text("Ya"),
        ),
      ],
    );
  }
}