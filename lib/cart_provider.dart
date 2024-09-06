import 'package:flutter/material.dart';

import 'cart_item.dart';
import 'database_helper.dart';

class CartProvider extends ChangeNotifier{
  Map<String, CartItem> _items = {};
  DatabaseHelper dbHelper = DatabaseHelper();

  CartProvider() {
    loadCartItemsFromDatabase();
  }

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  Future<void> addItem(
CartItem cartItem,
      ) async {

    if(cartItem.id==null){
      await dbHelper.insertOrUpdateCartItem(cartItem);
    }

    else{
      final existingCartItem = await getItemsFromCart(cartItem.id!);
      print('existingCartItem[0] ${existingCartItem[0]["id"]}');

      //     ? null
      //     : _items.values.firstWhere(
      //       (item) => item.id == cartItem.id,
      //   orElse: () => CartItem(itemName: cartItem.itemName, price: cartItem.price, quantity: cartItem.quantity, imageUrl: cartItem.imageUrl),


      if (existingCartItem.isNotEmpty) {
        // Update existing item quantity
        final updatedItem = CartItem(
          id: existingCartItem[0]['id'],
          itemName: existingCartItem[0]['itemName'],
          imageUrl: existingCartItem[0]['imageUrl'],
          price: existingCartItem[0]['price'],
          quantity: existingCartItem[0]['quantity'],
        );
        _items[updatedItem.id!] = updatedItem;

        // await dbHelper.insertOrUpdateCartItem(existingCartItem[0]);
      } else {
        // Insert new item
        final newCartItem = CartItem(
          itemName: cartItem.itemName,
          imageUrl: cartItem.imageUrl,
          price: cartItem.price,
          quantity: 1,
        );

        await dbHelper.insertOrUpdateCartItem(newCartItem);
    }

      final cartItems = await dbHelper.getCartItems();
      _items = {
        for (var item in cartItems) item.id!: item,
      };
    }
    notifyListeners();
  }

  Future<void> removeItem(String productId) async {
    _items.remove(productId);

    // Remove the item from the SQLite database
    await dbHelper.deleteCartItem(productId);
    notifyListeners();
  }

  Future<void> clearCart() async {
    _items = {};

    // Clear all items in the SQLite database
    await dbHelper.clearCart();
    notifyListeners();
  }

  Future<void> loadCartItemsFromDatabase() async {
    final cartItems = await dbHelper.getCartItems();
    _items = {
      for (var item in cartItems) item.id!: item,
    };
    notifyListeners();
  }
  Future<List<Map<String, dynamic>>> getItemsFromCart(String id) async{
    final cartItems = await dbHelper.getCartItemById(id);
    return cartItems;

  }
  Future<List<CartItem>> getAllItems() async{
    final carts=await dbHelper.getCartItems();
    return carts;
  }
}