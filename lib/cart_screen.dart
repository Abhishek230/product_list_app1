import 'package:flutter/material.dart';
import 'package:product_list_app/all_cart_items.dart';
import 'package:product_list_app/dummyitems.dart';
import 'package:product_list_app/product.dart';
import 'package:provider/provider.dart';

import 'cart_item.dart';
import 'cart_provider.dart';

class CartScreen extends StatefulWidget {
  CartScreen({this.cartItemId,required this.id, super.key});
  int? cartItemId;
  final String id;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Product? productItem;
  int itemCount = 1;
  int? itemPrice;
  final _itemCountController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _itemCountController.dispose();
  }

  @override
  void initState() {
    super.initState();
    productItem = products.firstWhere((item) => item.id == widget.id);

    itemPrice = productItem!.price;

    _itemCountController.text = itemCount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Detail'),
      ),
      body: SizedBox(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              productItem!.imageUrl,
              width: double.infinity,
              height: 200,
            ),
            Text(
              productItem!.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (itemCount == 0) {
                        itemPrice = productItem!.price;
                        return;
                      } else {
                        itemCount--;
                        if (itemCount == 0) {
                          itemPrice = productItem!.price;
                        } else {
                          itemPrice = productItem!.price * itemCount;
                          _itemCountController.text = itemCount.toString();
                        }
                      }
                    });
                  },
                  style: TextButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.blueAccent),
                  child: const Text(
                    '-',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                      color: Colors.grey,
                    ))),
                    controller: _itemCountController,
                    onChanged: (value) {
                      _itemCountController.text = value;
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      itemCount++;
                      itemPrice = productItem!.price * itemCount;
                      _itemCountController.text = itemCount.toString();
                    });
                  },
                  style: TextButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.blueAccent),
                  child: const Text(
                    '+',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Price: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(itemPrice.toString()),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.17,
            ),
            TextButton(
              onPressed: () async {
                if(widget.cartItemId==null) {

                  await Provider.of<CartProvider>(context, listen: false)
                      .addItem(
                      CartItem(
                          itemName: productItem!.name, imageUrl: productItem!.imageUrl, price: itemPrice!, quantity: itemCount)


                  );
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text('Added to Cart!'),
                  //     duration: Duration(seconds: 2),
                  //   ),
                  //);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                  const AllCartItems()
                  ));
                }else{
                  await Provider.of<CartProvider>(context, listen: false)
                      .addItem(
                      CartItem(
                        id: widget.cartItemId.toString(),
                          itemName: productItem!.name, imageUrl: productItem!.imageUrl, price: itemPrice!, quantity: itemCount)


                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Updated to Cart!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                fixedSize: const Size(300, 25),
              ),
              child: const Text('Save Item'),
            )
          ],
        ),
      )),
    );
  }
}
