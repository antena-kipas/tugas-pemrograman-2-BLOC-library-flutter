class Product {
  final String name;
  final double price;
  final String description;
  final String category;
  final String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.description,
    this.category = '',
    required this.imageUrl,
  });
}

// Data awal (Dummy)
List<Product> globalProducts = [
  Product(
    name: "Mechanical Keyboard",
    price: 1500000,
    description: "Keyboard mekanik dengan switch merah, cocok untuk coding.",
    category: "Elektronik",
    imageUrl: "https://picsum.photos/200",
  ),
  Product(
    name: "Mouse Wireless",
    price: 350000,
    description: "Mouse ergonomis tanpa kabel.",
    category: "Elektronik",
    imageUrl: "https://picsum.photos/201",
  ),
];