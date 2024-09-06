import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'cart_item.dart';

class DatabaseHelper{
  static final DatabaseHelper _instance=DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();
  factory DatabaseHelper(){
    return _instance;
  }
  Future<Database> get database async{
    if(_database!=null) {
      return _database!;
    }
    _database=await _initDatabase();
    return _database!;
  }
  Future<Database> _initDatabase() async{
    String path=join(await getDatabasesPath(), 'cart.db');
    return await openDatabase(path,
    version: 1,
    onCreate: _onCreate,
    );
  }
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        itemName TEXT,
        imageUrl TEXT,
        price INTEGER,
        quantity INTEGER
      )
    ''');
  }

  Future<void> insertOrUpdateCartItem(CartItem cartItem) async {
    final db = await database;

    if (cartItem.id != null) {
      // Update existing item
      await db.update(
        'cart',
        cartItem.toMap(),
        where: 'id = ?',
        whereArgs: [cartItem.id],
      );
    } else {
      // Insert new item
      await db.insert(
        'cart',
        cartItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart');

    return List.generate(maps.length, (i) {
      return CartItem(
        id: maps[i]['id'].toString(),
        itemName: maps[i]['itemName'],
        imageUrl: maps[i]['imageUrl'],
        price: maps[i]['price'],
        quantity: maps[i]['quantity'],
      );
    });
  }
  Future<void> deleteCartItem(String id) async {
    final db = await database;
    await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart');
  }
  Future<List<Map<String,dynamic>>> getCartItemById(String id) async{
    final id1=id as int;
    final db=await database;
    final cartItem=db.query('cart',where: 'id=?', whereArgs: [id1], limit: 1);
    return cartItem;
  }
}