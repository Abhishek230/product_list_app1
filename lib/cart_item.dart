class CartItem {
  final String? id;
  final String itemName;
  final String imageUrl;
  final int price;
  int quantity;

  CartItem({
    this.id,
    required this.itemName,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'itemName': itemName,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
}
}
