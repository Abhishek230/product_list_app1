import 'package:flutter/material.dart';
import 'package:product_list_app/cart_screen.dart';
import 'package:product_list_app/dummyitems.dart';
import 'package:product_list_app/product.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? productItem;

  @override
  void initState() {
    super.initState();
    productItem = products.firstWhere((proid) => proid.id == widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              productItem!.imageUrl,
              height: 200,
              width: double.infinity,
            ),
            Text(
              productItem!.name,
              style: const TextStyle(fontSize: 28),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Price:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.currency_rupee),
                Text(productItem!.price.toString())
              ],
            ),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(productItem!.description),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.17,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(id: productItem!.id),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                fixedSize: const Size(300, 25),
              ),
              child: const Text('Add to Cart'),
            )
          ],
        ),
      ),
    );
  }
}
