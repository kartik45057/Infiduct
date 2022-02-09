import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/CART/cart.dart';
import 'package:shop/Widgets/Ratings.dart';

import '../Product.dart';
import '../Products.dart';
import '../Products_Detail.dart';


class CartDetail extends StatefulWidget {

  static const routename = '/CartDetail';
  @override
  _CartDetailState createState() => _CartDetailState();
}

class _CartDetailState extends State<CartDetail> {

  @override
  Widget build(BuildContext context) {


    //print(loadedItem.items[loadedItem.items.keys.elementAt(0)].price);

    return Scaffold(

        appBar: AppBar(
          title: Text("My Wishlist"),
          //leading: Text(loadedItem.items[0].price.toString()),
        ),

        body:Temporary()
    );
  }
}

class Temporary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final loadedItem = Provider.of<Cart>(context);
    final products = loadedItem.items;
    final wid = MediaQuery.of(context).size.width;
    return Container(
      height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight),

      //height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
                height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)*0.92,
            //height: MediaQuery.of(context).size.height *0.9,

                child: ListView.builder(
                  itemBuilder: (ctx , index) => BuildCartItem(loadedItem.items[loadedItem.items.keys.elementAt(index)]),
                  itemCount: loadedItem.items.length,
                ),
              ),
        ],
      ),
    );

  }
}


class BuildCartItem extends StatelessWidget {
  final CartItem product;

  BuildCartItem(
        this.product
      );

  @override
  Widget build(BuildContext context) {
    final wid = MediaQuery.of(context).size.width;
    final cart = Provider.of<Cart>(context,listen: true);
    final productsData = Provider.of<Products>(context);
    if(productsData.items.length>0){
      final products = productsData.items[productsData.items.indexWhere((element) => element.id == product.id)];
    }
    //print(productsData.items.indexWhere((element) => element.id == 'p3'));

    return GestureDetector(
      onTap: () async {
        print(product.id);
        var isthere;
        print("id of product is ${product.id}");
        isthere = await cart.MatchCartItems(product.id);
        print("value of isthere is ${isthere}");
        Navigator.of(context).pushNamed(ProductDetail.routename, arguments: {'product':product,'isthere':isthere});
      },
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Container(
              //height: 150,
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.all(8),
              child:  Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: wid*0.75,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(product.title ,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,

                              fontSize: 18,
                            ),
                          ),
                        ),
                        Ratings(product),
                        Padding(
                          padding: const EdgeInsets.only(left:20.0,top: 20),
                          child: Text('\u{20B9} ${product.price }',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                  Column(
                    children: [
                      Container(
                        height: 100,
                        width: 70,
                        color: Colors.red,

                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                        ),

                      ),

                    ],
                  )
                ],
              ),

            ),

            Divider(
              color: Colors.black54,
              thickness: 1,
            ),
            GestureDetector(
              onTap: (){
                 //cart.removeItem(product.id);
                showDialog(context: context,
                    builder: (ctx) => AlertDialog(

                      title: Text("Are you sure?"),
                      content: Text('Do you want to remove the item?'),
                      actions: [
                        TextButton(onPressed: (){
                          cart.removeItem(product);
                          Navigator.pop(context);
                        },
                            child: Text("Yes")
                        ),
                        TextButton(onPressed: (){

                          Navigator.of(context).pop();
                        },
                            child: Text("No")
                        )
                      ],
                    ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text('Remove item',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    //fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ],
        ),


      ),
    );
  }
}
