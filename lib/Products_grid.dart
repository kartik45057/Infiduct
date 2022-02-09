import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Products.dart';
import 'package:shop/Products_Detail.dart';

import 'CART/cart.dart';
import 'Product.dart';
import 'Widgets/Lottie.dart';

class ProductsGrid extends StatefulWidget {

  @override
  _ProductsGridState createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
 bool loading = false;
  @override
  Widget build(BuildContext context) {

    final product =  Provider.of<Product>(context );
    final cart = Provider.of<Cart>(context);
    return loading?LottieLoad()
        :GestureDetector(
      onTap: () async {
        var isthere;
        try{
          setState(() {
            loading=true;
          });
          print("id of product is ${product.id}");
          isthere = await cart.MatchCartItems(product.id);
          print("value of isthere is ${isthere}");
          setState(() {
            loading=false;
          });
        }catch (error){
          print("error is there which is $error");

        }


        Navigator.of(context).pushNamed(ProductDetail.routename, arguments: {'product':product,'isthere':isthere});
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey
        ),
          padding: EdgeInsets.all(15),

        
          child:GridTile(child: Image.network(product.imageUrl[0],
                     fit: BoxFit.cover,
                ),
             footer: GridTileBar(
              backgroundColor: Colors.black87,
              title:Text(product.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400
                ),
                maxLines: 3,
                textAlign: TextAlign.center,
               // softWrap: true,
                // overflow: TextOverflow.visible,
              ),

            ),

        )
      ),
    );
  }
}
