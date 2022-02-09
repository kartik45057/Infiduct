import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CartItem{
  final String id;
  final String title;


  final  ratings;
  final int ratingsCount;
  final double price;
  final imageUrl;

  CartItem({
    @required this.title,
    @required this.price,
    @required this.id,
    @required this.ratingsCount,
    @required this.ratings,
    @required this.imageUrl
  });

}

class Cart with ChangeNotifier {


  Map<String, CartItem> _items = {};


  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }


  Future<bool> MatchCartItems(var id) async {
    var user = await FirebaseAuth.instance.currentUser;
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(user.uid).get();
    Map<String, dynamic> data = docSnapshot.data();
    print("data is ${data['CartItemId']}");
    if (data['CartItemId'] != null) {
      if (data['CartItemId'].length != null) {
        for (var i = 0; i < data['CartItemId'].length; i++) {
          if (data['CartItemId'][i]['id'] == id) {
            return true;
          }
        }
      }
    }
    return false;
  }


 Future<void> GetCartItems() async {
    //return[..._items.where((element) => element.isfavorite).toList()];
    var user = await FirebaseAuth.instance.currentUser;
    var collection = await FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(user.uid).get();
    Map<String, dynamic> data = docSnapshot.data();
    List cartId =[];

    if (data['CartItemId'] != null) {

      if (data['CartItemId'].length != null) {

        for (int i = 0; i < data['CartItemId'].length; i++) {

          cartId.insert(i, data['CartItemId'][i]['id']);
        }
        }
      }

    for (int i = 0; i < cartId.length; i++) {
      var querySnapshot = await FirebaseFirestore.instance.collection('Products').where(
        FieldPath.documentId, isEqualTo: cartId[i]
      ).get().then((event) {
        if (event.docs.isNotEmpty) {
          Map<String, dynamic> documentData = event.docs.single.data();
          _items.putIfAbsent(documentData['id'], () =>
              CartItem(
                  title: documentData['title'],
                  price: documentData['price'],
                  id: documentData['id'],
                  //quantity: documentData['quantity'],
                  ratings: documentData['ratings'],
                  ratingsCount: documentData['ratingsCount'],
                  //description: documentData['description'],
                  imageUrl: documentData['imageUrl'][0]
              )
          );
        }
      }).catchError((e) {
        print("error fetching data: $e");
        throw e;
      } );

    }

      notifyListeners();
  }


    Future<void> addItem(
        {String productId, String title, double price, String description, double ratings,
          int ratingsCount, var imageUrl}) async {
      var user = await FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
          {"CartItemId": FieldValue.arrayUnion([
            {
              'id': productId,
            }

          ])});

      //await FirebaseFirestore.instance.collection('users').doc(user.uid).;
     // if (_items.containsKey(productId)) {
        _items.putIfAbsent(productId, () =>
            CartItem(
                title: title,
                price: price,
                id: productId,
                // quantity: existingCartItem.quantity + 1,
                ratings: ratings,
                ratingsCount: ratingsCount,
                //description: existingCartItem.description,
                imageUrl: imageUrl[0]
            )
        );


        await FirebaseFirestore.instance.collection('users')
            .doc(user.uid)
            .update({"cart": FieldValue.arrayUnion([
          {
            'title': title,
            'price': price,
            'id': productId,
           // 'quantity': quantity + 1,
           // 'description': description,
            'ratings': ratings,
            'ratingsCount': ratingsCount,
            'imageUrl': imageUrl[0],
          }

        ])});

      notifyListeners();
    }


    Future<void> removeItem(CartItem product) async {

      _items.removeWhere((key, value) => value.id == product.id);
      var user = await FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
          {"cart": FieldValue.arrayRemove([
            {
              'title': product.title,
              'price': product.price,
              'id': product.id,
             // 'quantity': product.quantity,
              //'description': product.description,
              'ratings': product.ratings,
              'ratingsCount': product.ratingsCount,
              'imageUrl': product.imageUrl,
            }

          ])});
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
          {"CartItemId": FieldValue.arrayRemove([
            {

              'id': product.id,

            }

          ])});
      notifyListeners();
    }
  }


