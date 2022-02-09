import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop/Product.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shop/CART/cart.dart';
import 'package:shop/Api/PushNotification.dart';
import 'Admin/EditProductScreen.dart';

class Products with ChangeNotifier{

      List<Product> _items= [];
     List<Product> _favoitems = [];
      List<Product> _searchedItems= [];


     List<Product> get items{

       return [..._items];
     }



     Product findById(String id) {
       return _items.firstWhere((prod) => prod.id == id);
     }

      List<Product> get favoriteItems{
        return[..._favoitems];
      }

      List<Product> get searchedItems{
        return[..._searchedItems];
      }

      Future<void> GetfavoriteItems()  async{

        //return[..._items.where((element) => element.isfavorite).toList()];
        var user = await FirebaseAuth.instance.currentUser;
        var collection = FirebaseFirestore.instance.collection('users');
        var docSnapshot = await collection.doc(user.uid).get();
        Map<String, dynamic> data = docSnapshot.data();
        //print('djnijij dnjnjnd kk ${data}');
        print("lenght = ${data['favorites'][0]['price']}");
        final List<Product> loadedProducts = [];
        for(var i = 0;i< data['favorites'].length;i++){
          loadedProducts.add(Product(
            id: data['favorites'][i]['id'],
            isfavorite: data['favorites'][i]['isfavorite'],
            title: data['favorites'][i]['title'],
            description: data['favorites'][i]['description'],
            price: data['favorites'][i]['price'],
            imageUrl: [data['favorites'][i]['imageUrl'][0].toString()],
          ));
        }
        _favoitems = loadedProducts;
        notifyListeners();
      }

      Future<void> fetchAndSetProd() async {
        try{
          var snapshot = await FirebaseFirestore.instance.collection('Products').get();
          //print("snapshot of data is ${[...snapshot.docs.map((doc)=> doc.data())]}");
          final List<Product> loadedProducts = [];
          for(int i=0;i< [...snapshot.docs.map((doc)=> doc.data())].length;i++){
             List<String> imgList = [];
            for(int j=0;j< [...snapshot.docs.map((doc)=> doc.data())][i]['imageUrl'].length;j++){
              imgList.add([...snapshot.docs.map((doc)=> doc.data())][i]['imageUrl'][j].toString());

            }
            //print("length of imageurl is ${[[...snapshot.docs.map((doc)=> doc.data())][i]['imageUrl'][0]]}");
            //print('products highlights is ${[...snapshot.docs.map((doc)=> doc.data())][i]['productsHighlights']}');
             List<Map> ph=[];
             for(int j=0;j< [...snapshot.docs.map((doc)=> doc.data())][i]['productsHighlights'].length;j++){
               ph.add([...snapshot.docs.map((doc)=> doc.data())][i]['productsHighlights'][j]);
               //print('products highlights is ${[...snapshot.docs.map((doc)=> doc.data())][i]['productsHighlights'][j]}');

             }
            // print("ph is ${ph}");
            loadedProducts.add(Product(
              id: [...snapshot.docs.map((doc)=> doc.data())][i]['id'],
              title: [...snapshot.docs.map((doc)=> doc.data())][i]['title'],
              description: [...snapshot.docs.map((doc)=> doc.data())][i]['description'],
              price: [...snapshot.docs.map((doc)=> doc.data())][i]['price'],
              discount: [...snapshot.docs.map((doc)=> doc.data())][i]['discount'],
              ratings: [...snapshot.docs.map((doc)=> doc.data())][i]['ratings'],
              reviews: [...snapshot.docs.map((doc)=> doc.data())][i]['reviews'],
              ratingsCount: [...snapshot.docs.map((doc)=> doc.data())][i]['ratingsCount'],
              availableQuantity: [...snapshot.docs.map((doc)=> doc.data())][i]['availableQuantity'],
              productsHighlights: ph,
              imageUrl: imgList,
              //imageUrl: [[...snapshot.docs.map((doc)=> doc.data())][i]['imageUrl'][0]],
            ));
          }
          print("length of imageurl is ");
          //
          _items.clear();
          _items = loadedProducts;
          notifyListeners();
        }catch (error){
          print(error);

        }
      }

      Future<void> addProd(Product product) async{

        try{

          DocumentReference docRef = await FirebaseFirestore.instance.collection('Products').add(
              {
                'title': product.title,
                'description': product.description,
                'productsHighlights':product.productsHighlights,
                'imageUrl': product.imageUrl,
                'price': product.price,
                'discount':product.discount,
                'ratings':product.ratings,
                'reviews':[],
                'ratingsCount':product.ratingsCount,
                'availableQuantity' : product.availableQuantity,

              }
          );

          final newProduct = Product(
            title: product.title,
            description: product.description,
            price: product.price,
            discount: product.discount,
            ratings: product.ratings,
            reviews: [],
            ratingsCount: product.ratingsCount,
            availableQuantity : product.availableQuantity,
            productsHighlights: product.productsHighlights,
            imageUrl: product.imageUrl,
            id: docRef.id,

          );

          await FirebaseFirestore.instance.collection('Products').doc(newProduct.id).update(
              {
                'title': newProduct.title,
                'description': newProduct.description,
                'productsHighlights':newProduct.productsHighlights,
                'imageUrl': newProduct.imageUrl,
                'price': newProduct.price,
                'discount' : newProduct.discount,
                'ratings':newProduct.ratings,
                'reviews':[],
                'ratingsCount':newProduct.ratingsCount,
                'availableQuantity' : newProduct.availableQuantity,
                'id':docRef.id,
              }
          );

          //_items.add(newProduct);

          // _items.insert(0, newProduct); // at the start of the list
          notifyListeners();

        }catch (error){
          print(error);

        }
      }


      Future<void> updateProd(String id, Product newProduct) async {
        final prodIndex = _items.indexWhere((prod) => prod.id == id);


          await FirebaseFirestore.instance.collection('Products').doc(id).update(
              {
                'title': newProduct.title,
                'description': newProduct.description,
                'productsHighlights':newProduct.productsHighlights,
                'imageUrl': newProduct.imageUrl,
                'price': newProduct.price,
                'discount' : newProduct.discount,
                'ratings':newProduct.ratings,
                'reviews':newProduct.reviews,
                'ratingsCount':newProduct.ratingsCount,
                'availableQuantity' : newProduct.availableQuantity,
                'id':id,
              }
          );

         if(prodIndex!=null){
           _items[prodIndex] = newProduct;
         }
          notifyListeners();

        }

      Future<void> deleteProd(String id) async{

        try{

          FirebaseFirestore docRef = FirebaseFirestore.instance;
          docRef.collection("Products").doc(id)
              .delete();
          //notifyListeners();

        }catch (error){
          throw error;
        }

      }
      
      Future queryData(String queryString) async{
        _searchedItems.clear();
        var snapshot = await FirebaseFirestore.instance.collection('Products').
               where('title',isEqualTo: queryString.toLowerCase() ).get();

        for(int i=0;i< [...snapshot.docs.map((doc)=> doc.data())].length;i++){
          _searchedItems.add(Product(
            id: [...snapshot.docs.map((doc)=> doc.data())][i]['id'],
            title: [...snapshot.docs.map((doc)=> doc.data())][i]['title'],
            description: [...snapshot.docs.map((doc)=> doc.data())][i]['description'],
            price: [...snapshot.docs.map((doc)=> doc.data())][i]['price'],
            discount: [...snapshot.docs.map((doc)=> doc.data())][i]['discount'],
            ratings: [...snapshot.docs.map((doc)=> doc.data())][i]['ratings'],
            ratingsCount: [...snapshot.docs.map((doc)=> doc.data())][i]['ratingsCount'],
            availableQuantity: [...snapshot.docs.map((doc)=> doc.data())][i]['availableQuantity'],
            imageUrl: [[...snapshot.docs.map((doc)=> doc.data())][i]['imageUrl'][0].toString()],
          ));
        }
        print("searched item is ${_searchedItems}");
      }


}







