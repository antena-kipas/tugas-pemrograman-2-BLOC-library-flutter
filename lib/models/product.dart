class Product {
  final String? id;
  final String? status;
  final int? sort;
  final String? userCreated;
  final DateTime? dateCreated;
  final String? userUpdated;
  final DateTime? dateUpdated;

  final String name;
  final int price;
  final String? imageUrl;
  final String? category;
  final String? description;
  final int? quantity;

  Product({
    this.id,
    this.status,
    this.sort,
    this.userCreated,
    this.dateCreated,
    this.userUpdated,
    this.dateUpdated,
    required this.name,
    required this.price,
    this.imageUrl,
    this.category,
    this.description,
    this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      status: json['status'],
      sort: json['sort'],
      userCreated: json['user_created'],
      dateCreated: json['date_created'] != null
          ? DateTime.parse(json['date_created'])
          : null,
      userUpdated: json['user_updated'],
      dateUpdated: json['date_updated'] != null
          ? DateTime.parse(json['date_updated'])
          : null,
      name: json['name'] ?? '',
      price: int.tryParse(json['price'].toString()) ?? 0,
      imageUrl: json['image_url'],
      category: json['category'],
      description: json['description'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price.toString(),
      'image_url': imageUrl,
      'category': category,
      'description': description,
      'quantity': quantity,
    };
  }
}