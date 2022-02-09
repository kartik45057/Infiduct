import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Products.dart';
import '../Products_grid.dart';

class Search extends StatefulWidget {


  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final TextEditingController searchController = TextEditingController();
  QuerySnapshot snapshotData;

  @override
  Widget build(BuildContext context) {
    final productClass = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: (){
          Navigator.pop(context);
        },),
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.search,color: Colors.black,), onPressed: (){
            productClass.queryData(searchController.text).then((value) {
              //snapshotData=value;
              //print("searched data is ${snapshotData.docs}");
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SearchedProducts()));

            });
          })
        ],

        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search    for    products',
            hintStyle:  TextStyle(color: Colors.grey, fontSize: 20),


          ),
          controller: searchController,
        ),
      ),
    );
  }
}

class SearchedProducts extends StatefulWidget {


  @override
  _SearchedProductsState createState() => _SearchedProductsState();
}

class _SearchedProductsState extends State<SearchedProducts> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.searchedItems;
    return Scaffold(
      appBar: AppBar(

        title: Text("Shop"),


      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
        child: GridView.builder(
          //controller: scrollController,
            gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 30,
                mainAxisSpacing: 15,
                childAspectRatio: 4/5
            ),
            itemCount: products.length,
            itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
              value : products[i],
              child: ProductsGrid(

              ),

            )

        ),
      ),
    );
  }
}
