import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Product.dart';

import 'FavoriteProductsGrid.dart';
import 'Products.dart';

class Favorites extends StatelessWidget {
  static const routename = '/Favorites';

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    //final productData1 = Provider.of<Rebuild>(context);
    final  products = productData.favoriteItems;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body:  Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
        child: GridView.builder(
            gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 30,
                mainAxisSpacing: 15,
                childAspectRatio: 4/5
            ),
            itemCount: products.length,
            itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
              value : products[i],
              child: FavoriteProductsGrid()

            )

        ),
      ),

    );
  }
}
