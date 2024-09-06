import 'package:flutter/material.dart';
import 'package:product_list_app/cart_item.dart';
import 'package:provider/provider.dart';

import 'cart_provider.dart';

class AllCartItems extends StatefulWidget {
  const AllCartItems({super.key});

  @override
  State<AllCartItems> createState() => _AllCartItemsState();

}


class _AllCartItemsState extends State<AllCartItems> {
  List<CartItem> _cartItems=[];


//   @override
//   void initState() {
//
//     super.initState();
//     _fetchItems();
//
// }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _fetchItems();

  }


  Future<void> _fetchItems() async{
    final items=await Provider.of<CartProvider>(context).getAllItems();
    setState(() {
      _cartItems=items;
    });

    // print('bcg: ${_cartItems.first.itemName}');

  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Items'),
        actions: [
          Icon(Icons.shopping_cart, color: Colors.blueAccent,size: 40,),
          Text('Items: ${_cartItems.length}')
        ],
      ),
      body: ListView.builder(
            itemCount: _cartItems.length,
            itemBuilder: (context,index){
              final item=_cartItems[index];
              return ListTile(
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(item.imageUrl),
                    Text(item.itemName, textAlign: TextAlign.center,),
                    Text('Quantity: ${item.quantity}'),
                    Text('Price: ${item.price}'),
                    TextButton(style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),onPressed: (

                        ){
                      Provider.of<CartProvider>(context,listen: false,).removeItem(_cartItems[index].id!);
                    }, child: Text('Remove from cart',))

                  ],
                ),
              );
            },
      ),
    );
  }

}
