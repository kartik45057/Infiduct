import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shop/Orders/Orders.dart';

import '../Product.dart';
import '../Products.dart';

class RatingBar extends StatefulWidget {
  var index;
  var item;
  //var item
  var item2;
  var user;
  RatingBar(this.index, this.item ,this.item2 , this.user);

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  @override
  Widget build(BuildContext context) {
    final loadedItem = Provider.of<Orders>(context);
    //Product editedProduct = widget.item1;
    print("value of items in ratingbar is ${loadedItem.items}");
    var proId = widget.item2;
    return RatingDialog(
      initialRating: 0,
        title: Text('Rating_Dialog'),
        message:
        Text('Tap a star to set your rating and review this product.'),
        image: const FlutterLogo(size: 50),
        submitButtonText: 'Submit',
        onSubmitted: (response) async{
          print('rating: ${response.rating}, comment: ${response.comment}');
          //editedProduct.reviews.insert(widget.index,response.comment);
          var Gfr = await  FirebaseFirestore.instance.collection('Products').doc(proId).get();

          //print('existing rating is _ ${}');
          List<dynamic> rev =Gfr.data()['reviews'];
          rev.add(response.comment);


         // if(!loadedItem.items[widget.index]['ratingCountInc']){
            //await loadedItem.updateOrder(widget.index);

            if(Gfr.data()['ratingsCount'] == 0) {
              var rate= Gfr.data();
              await  FirebaseFirestore.instance.collection('Products').doc(proId).
              update({'ratings': response.rating,'ratingsCount':Gfr.data()['ratingsCount']+1,'reviews': rev});
            }else {
              var rate= (Gfr.data()['ratings']+response.rating)/(Gfr.data()['ratingsCount']+1);
              //print('existing rating is _ ${rate}');
              await  FirebaseFirestore.instance.collection('Products').doc(proId).
              update({'ratings': (rate),'ratingsCount':Gfr.data()['ratingsCount']+1,'reviews': rev});
            }
            await FirebaseFirestore.instance.collection('userOrders').doc(widget.user.uid).update(
                {widget.index.toString():{
                  'id':loadedItem.items[widget.index]['id'],
                  'title':loadedItem.items[widget.index]['title'],
                  'description':loadedItem.items[widget.index]['description'],
                  'price':loadedItem.items[widget.index]['price'],
                  'discount': loadedItem.items[widget.index]['discount'],
                  'cancelOrder':false,
                  'deliveryStatus':true,
                  'rateFirstTime':false,
                  'ratingsCountInc':false,
                  'image':loadedItem.items[widget.index]['image'],
                  'address':loadedItem.items[widget.index]['address'],
                  'DateTime':loadedItem.items[widget.index]['DateTime']

                }
                }
                );
          print("value of items inside of the ratingbar is ${loadedItem.items}");
            loadedItem.updateOrder(widget.index);




        }
    );

  }
}
