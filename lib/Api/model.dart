

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final List<String> images;
  final Category category;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    required this.category,
  });

  // Factory method JSON se object banane ke liye
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      // Price double mein convert karna safe rehta hai
      price: (json['price'] as num).toDouble(), 
      description: json['description'],
      // Images array handle karne ka pro tarika
      images: List<String>.from(json['images']),
      category: Category.fromJson(json['category']),
    );
  }
}

class Category {
  final int id;
  final String name;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}