import 'dart:math';

class Product {
  String id =
      '${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(10000)}';
  String name;
  String imageUrl;
  int price;
  String description;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
  });
}
