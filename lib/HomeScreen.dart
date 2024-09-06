import 'package:flutter/material.dart';
// import 'package:product_list_app/cart_item.dart';
// import 'package:product_list_app/cart_provider.dart';
import 'package:product_list_app/cart_screen.dart';
import 'package:product_list_app/dummyitems.dart';
import 'package:product_list_app/product.dart';
// import 'package:product_list_app/product_detail_screen.dart';
// import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  //List<CartItem> _cartItems=[];
  List<Product> _filteredProducts=[];
 // String _searchQuery='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _filteredProducts=products;


  }
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
  void _filterProducts(String query) {
    List<Product> filtered = products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      if(_searchController.text.isEmpty){
        _filteredProducts=products;
      }
      else {
        _filteredProducts = filtered;
      }
    });
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Search Product",
            border: InputBorder.none,
          ),



          onChanged: (query){
   //         _searchQuery=query;
            _filterProducts(query);

            setState(() {

              if(query.isNotEmpty){
                _isSearching=true;


              }
              else{
                _isSearching=false;
              }
            });
          },
        ),
        leading: IconButton(onPressed: (){
          setState(() {
            if(_isSearching){
              _searchController.clear();
              _isSearching=false;
              _filteredProducts=products;
            }
          });
        }, icon: Icon(_isSearching?Icons.close:Icons.search)),
      ),
      body:





            _filteredProducts.isNotEmpty?ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context,index){
                return InkWell(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>CartScreen(id: _filteredProducts[index].id)));
                  },
                  child: ListTile(
                    subtitle: Column(

                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(_filteredProducts[index].imageUrl, height: 100, width: double.infinity,),
                        SizedBox(height: 25,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Expanded(
                              child: Text(_filteredProducts[index].name,
                                style: const TextStyle(fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            const Spacer(),

                            const Expanded(child: Icon(Icons.currency_rupee)),
                            Expanded(child: Text(_filteredProducts[index].price.toString()))
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },

            ): const Center(
              child: Text('No Products Found'),
            ));




  }

  // void _fetchItems() async{
  //   final items=await Provider.of<CartProvider>(context).getAllItems();
  //   _cartItems=items;
  //
  // }
}
class ProductCard extends StatelessWidget {
  const ProductCard({required this.product,super.key});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(


          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),

          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(product.imageUrl, height: 100, width: 100,),
              Row(
                children: [
                  Expanded(
                    child: Text(product.name,
                      style: const TextStyle(fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Expanded(child: Icon(Icons.currency_rupee)),
                  Expanded(child: Text(product.price.toString()))
                ],
              )
            ],
          ),
        ),
      ],


    );
  }
}

