import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop/Product.dart';

class Orders extends ChangeNotifier {
  List<Map> _items = [];
  List<Map> _ordItems = [];
  User user = FirebaseAuth.instance.currentUser;

  List<Map> get items {
    return _items;
  }

  List<Map> get ordItems {
    return _ordItems;
  }

  notifyOnChange() {
    if (user.uid == 'eHyTIPsm2KZeoYPvHgG1aDOp2mw1') {
      CollectionReference reference1 = FirebaseFirestore.instance.collection(
          'ordersPending');
      reference1.snapshots().listen((querySnapshot) {
        //querySnapshot.docChanges.forEach((change) {
        // Do something with change
        getOrdReq();

        // });
      });
    }
  }

  notifyOnChange1() {
    CollectionReference reference1 = FirebaseFirestore.instance.collection(
        'userOrders');
    reference1.snapshots().listen((querySnapshot) {
      //querySnapshot.docChanges.forEach((change) {
      // Do something with change
      GetOrders();
      // });
    });
  }


  Future<void> getOrdReq() async {

    if(user.uid == 'eHyTIPsm2KZeoYPvHgG1aDOp2mw1'){

      var collection = FirebaseFirestore.instance.collection('ordersPending');
      var snapshot = await collection.get();
      List<Map> tempitems = [];
      print('order items is ${snapshot.docs.isNotEmpty}');

      if(snapshot.docs.isNotEmpty){
        for(int i=0;i< [...snapshot.docs.map((doc)=> doc.data())].length;i++) {
          tempitems.add(
              {
                'id': [...snapshot.docs.map((doc) => doc.data())][i]['id'],
                'title': [...snapshot.docs.map((doc) => doc.data())][i]['title'],
                'description': [...snapshot.docs.map((doc) => doc.data())][i]['description'],
                'price': [...snapshot.docs.map((doc) => doc.data())][i]['price'],
                'discount': [...snapshot.docs.map((doc) => doc.data())][i]['discount'],
                'index': [...snapshot.docs.map((doc) => doc.data())][i]['index'],
                'docId': [...snapshot.docs.map((doc) => doc.data())][i]['docId'],
                'userId': [...snapshot.docs.map((doc) => doc.data())][i]['userId'],
                'image': [...snapshot.docs.map((doc) => doc.data())][i]['image'],
                'address': [...snapshot.docs.map((doc) => doc.data())][i]['address'],
                'DateTime': [...snapshot.docs.map((doc) => doc.data())][i]['DateTime'],

              }
          );
        }
      }

        //_items.clear();
        print('orders fetched ${tempitems}');
        _ordItems = tempitems;
        notifyListeners();
      }
    }


void updateOrder(index){
    //print("imageurl field value is ${_items[index]['image']}");
  _items[index] = {
    'id':_items[index]['id'],
    'title':_items[index]['title'],
    'description':_items[index]['description'],
    'price':_items[index]['price'],
    'discount': _items[index]['discount'],
    'cancelOrder':false,
    'deliveryStatus':false,
    'rateFirstTime':false,
    'ratingsCountInc':false,
    'image':_items[index]['image'],
    'address':_items[index]['address'],
    'DateTime':_items[index]['DateTime']

  };
notifyListeners();
}

  void updateOrder1(index){
    //print("imageurl field value is ${_items[index]['image']}");
    _items[index] = {
      'id':_items[index]['id'],
      'title':_items[index]['title'],
      'description':_items[index]['description'],
      'price':_items[index]['price'],
      'discount': _items[index]['discount'],
      'cancelOrder':true,
      'deliveryStatus':false,
      'rateFirstTime':false,
      'ratingsCountInc':false,
      'image':_items[index]['image'],
      'address':_items[index]['address'],
      'DateTime':_items[index]['DateTime']

    };
    notifyListeners();
  }

  int get itemCount {
    return _items.length;
  }


  Future<void> GetOrders() async {

    _items.clear();
    print('items in the getorders method are  ${_items}');

    var collection = FirebaseFirestore.instance.collection('userOrders');
    var docSnapshot = await collection.doc(user.uid).get();
    Map<String, dynamic> data = docSnapshot.data();
    List<Map> tempitems = [];


    if (data != null) {
      if (data.length != null) {
        for (var i = 0; i < data.length; i++) {
          tempitems.add(
              {
                'id': data[i.toString()]['id'],
                'title': data[i.toString()]['title'],
                'description': data[i.toString()]['description'],
                'price': data[i.toString()]['price'],
                'discount': data[i.toString()]['discount'],
                'deliveryStatus': data[i.toString()]['deliveryStatus'],
                'cancelOrder': data[i.toString()]['cancelOrder'],
                'ratingCountInc': data[i.toString()]['ratingCountInc'],
                'image': data[i.toString()]['image'],
                'address': data[i.toString()]['address'],

              }
          );
        }
      }

      //print('orders fetched ${tempitems}');
      _items = tempitems;
      notifyListeners();
    }
  }

   Future<void> addOrd(Product product,var addressData) async {

     try{
       var Uo = await FirebaseFirestore.instance.collection('userOrders').doc(user.uid).get();
      // print("length of the data is ${Uo.data().length}");

       if(Uo.data()== null){

         DocumentReference docRef = await  FirebaseFirestore.instance.collection('ordersPending').add(
             {
               'id':product.id,
               'userId':user.uid,
               'title':product.title,
               'index':0,
               'description':product.description,
               'price':product.price,
               'discount':product.discount,
               'image':product.imageUrl,
               'address':addressData,
               'deliveryStatus':false,
               'cancelOrder':false,
               'rateFirstTime':true,
               'ratingCountInc':false,
               'DateTime':DateTime.now()
             }
         );
         await FirebaseFirestore.instance.collection('ordersPending').doc(docRef.id).update(
             {
               'id':product.id,
               'userId':user.uid,
               'docId':docRef.id,
               'title':product.title,
               'index':0,
               'description':product.description,
               'price':product.price,
               'discount':product.discount,
               'image':product.imageUrl,
               'address':addressData,
               'deliveryStatus':false,
               'cancelOrder':false,
               'rateFirstTime':true,
               'ratingCountInc':false,
               'DateTime':DateTime.now()
             }
         );
         await FirebaseFirestore.instance.collection('userOrders').doc(user.uid).set(
             {
               '0':{
                 'id':product.id,
                 'title':product.title,
                 'docId':docRef.id,
                 'description':product.description,
                 'price':product.price,
                 'discount':product.discount,
                 'image':product.imageUrl,
                 'address':addressData,
                 'deliveryStatus':false,
                 'cancelOrder':false,
                 'rateFirstTime':true,
                 'ratingCountInc':false,
                 'DateTime':DateTime.now()
               }
             }
         );

        /* _items.insert(0, {
           'id':product.id,
           'title':product.title,
           'description':product.description,
           'price':product.price,
           'discount':product.discount,
           'image':product.imageUrl,
           'address':addressData,
           'deliveryStatus':false,
           'cancelOrder':false,
           'rateFirstTime':true,
           'ratingCountInc':false,
           'DateTime':DateTime.now()
         });*/
       }else{

         DocumentReference docRef = await FirebaseFirestore.instance.collection('ordersPending').add(
             {
               'id':product.id,
               'userId':user.uid,
               'title':product.title,
               'index':Uo.data().length,
               'description':product.description,
               'price':product.price,
               'discount':product.discount,
               'image':product.imageUrl,
               'address':addressData,
               'deliveryStatus':false,
               'cancelOrder':false,
               'rateFirstTime':true,
               'ratingCountInc':false,
               'DateTime':DateTime.now()
             }
         );
         await FirebaseFirestore.instance.collection('ordersPending').doc(docRef.id).update(
             {
               'id':product.id,
               'userId':user.uid,
               'docId':docRef.id,
               'title':product.title,
               'index':Uo.data().length,
               'description':product.description,
               'price':product.price,
               'discount':product.discount,
               'image':product.imageUrl,
               'address':addressData,
               'deliveryStatus':false,
               'cancelOrder':false,
               'rateFirstTime':true,
               'ratingCountInc':false,
               'DateTime':DateTime.now()
             }
         );
         await FirebaseFirestore.instance.collection('userOrders').doc(user.uid).update(
             {
               Uo.data().length.toString() :{
                 'id':product.id,
                 'title':product.title,
                 'docId':docRef.id,
                 'description':product.description,
                 'price':product.price,
                 'discount':product.discount,
                 'image':product.imageUrl,
                 'address':addressData,
                 'deliveryStatus':false,
                 'cancelOrder':false,
                 'rateFirstTime':true,
                 'ratingCountInc':false,
                 'DateTime':DateTime.now()
               }
             }
         );



        /* _items.insert(Uo.data().length, {
           'id':product.id,
           'title':product.title,
           'description':product.description,
           'price':product.price,
           'discount':product.discount,
           'image':product.imageUrl,
           'address':addressData,
           'deliveryStatus':false,
           'cancelOrder':false,
           'rateFirstTime':true,
           'ratingCountInc':false,
           'DateTime':DateTime.now()
         });*/
       }



       //print("value of the _items is ${_items}");
       notifyListeners();
     }catch(e){
       print(e);
       throw e;

     }
   }




    Future<void> removeOrder({var index }) async {

      /*try{
       FirebaseFirestore docRef = FirebaseFirestore.instance;
        docRef.collection("userOrders").doc().delete();
        //notifyListeners();
      }catch (error){
        throw error;
      }
      _items.removeAt(index);*/

      await FirebaseFirestore.instance.collection('userOrders').doc(user.uid).update(
          {index.toString():{
            'id':_items[index]['id'],
            'title':_items[index]['title'],
            'description':_items[index]['description'],
            'price':_items[index]['price'],
            'discount': _items[index]['discount'],
            'cancelOrder':true,
            'deliveryStatus':_items[index]['deliveryStatus'],
            'rateFirstTime':_items[index]['rateFirstTime'],
            'ratingsCountInc':_items[index]['ratingsCountInc'],
            'image':_items[index]['image'],
            'address':_items[index]['address'],
            'DateTime':_items[index]['DateTime']
          }
          }
      );

      FirebaseFirestore docRef = FirebaseFirestore.instance;
      await docRef.collection("ordersPending").doc(_ordItems[index]['docId']).delete();
      //print("value of items inside of the ratingbar is ${items}");
      updateOrder1(index);

      notifyListeners();
    }


Future<void> removeOrder1({var index,var index1 }) async {
  //print("order items to delete id is ");
  try {

    await FirebaseFirestore.instance.collection('userOrders').doc(_ordItems[index1]['userId']).update(
        {_ordItems[index1]['index'].toString():{
          'id':_ordItems[index1]['id'],
          'title':_ordItems[index1]['title'],
          'docId':_ordItems[index1]['docId'],
          'description':_ordItems[index1]['description'],
          'price':_ordItems[index1]['price'],
          'discount': _ordItems[index1]['discount'],
          'cancelOrder':false,
          'deliveryStatus':true,
          'rateFirstTime':true,
          'ratingsCountInc':true,
          'image':_ordItems[index1]['image'],
          'address':_ordItems[index1]['address'],
          'DateTime':_ordItems[index1]['DateTime']

        }
        }
    );
    //print("order items to delete id is ${_ordItems[index]['docId']}");
    await FirebaseFirestore.instance.collection('OrdersDelivered').add(
        {
          'id':_ordItems[index1]['id'],
          'userId':_ordItems[index1]['userId'],
          'docId':_ordItems[index1]['docId'],
          'title':_ordItems[index1]['title'],
          'index':_ordItems[index1]['index'],
          'description':_ordItems[index1]['description'],
          'price':_ordItems[index1]['price'],
          'discount':_ordItems[index1]['discount'],
          'image':_ordItems[index1]['image'],
          'address':_ordItems[index1]['address'],
          'DateTime':_ordItems[index1]['DateTime'],
        }

    );



    FirebaseFirestore docRef = FirebaseFirestore.instance;
    await docRef.collection("ordersPending").doc(_ordItems[index1]['docId']).delete();
    //notifyListeners();

     print("enter into add");

    //_ordItems.removeAt(index1);
    print("exit from add");
  }catch (error){
    print("error is ${error}");
    throw error;
  }
  //print("value of items inside of the ratingbar is ${items}");
  //updateOrder1(index);

  notifyListeners();
}

  Future<void> removeOrder2() async {
    FirebaseFirestore docRef = FirebaseFirestore.instance;
    //await docRef.collection("ordersPending").doc(_ordItems[index1]['docId']).delete();
  }

}


