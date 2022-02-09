import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Products.dart';
import 'package:shop/Products_Detail.dart';

import 'FavoriteProductDetail.dart';
import 'Product.dart';

class FavoriteProductsGrid extends StatefulWidget {

  @override
  _FavoriteProductsGridState createState() => _FavoriteProductsGridState();
}

class _FavoriteProductsGridState extends State<FavoriteProductsGrid> {

  @override
  Widget build(BuildContext context) {

    final product =  Provider.of<Product>(context );
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(FavoriteProductDetail.routename, arguments: product);
      },
      child: ClipRRect(
          borderRadius: BorderRadius.circular(15),

          child: GridTile(child: Image.network(product.imageUrl[0],
            fit: BoxFit.cover,
          ),
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              title:Text(product.title,
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
