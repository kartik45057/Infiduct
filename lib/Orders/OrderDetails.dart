import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Products.dart';
import 'package:shop/Widgets/RatingBar.dart';

import 'Orders.dart';

class OrderDetails extends StatefulWidget {
  static const routename = '/OrderDetails';

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {

    final arguments = ModalRoute.of(context).settings.arguments as Map;
    final index = arguments['index'];
    final loadedItem = Provider.of<Orders>(context);
    final wid = MediaQuery.of(context).size.width;
    final item = Provider.of<Products>(context);
    final item1 = item.findById(item.items[index].id);
   // print("discount is ${loadedItem.items}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),

      body: Container(
        height: (MediaQuery.of(context).size.height )*0.9,
        child: SingleChildScrollView(
          child: Column(
            children: [

              Divider(
                color: Colors.grey,
                thickness: 1,
              ),

              GestureDetector(
                onTap: () async{
                  User user = await FirebaseAuth.instance.currentUser;
                  var Gfr2 = await FirebaseFirestore.instance.collection('userOrders').doc(user.uid).get();
                  //print('order items are ${loadedItem.items}');

                  bool rateFirstTimeRecv = Gfr2.data()[index.toString()]['rateFirstTime'];
                  if(loadedItem.items[index]['deliveryStatus']){
                    if(rateFirstTimeRecv){
                      await showDialog(context: context, builder: (ctx){
                        return RatingBar(index,item , loadedItem.items[index]['id'] , user);


                      });
                      /*await  FirebaseFirestore.instance.collection('users').doc(user.uid).
                    update({'Orders'[index]: FieldValue.arrayUnion({

                    })});*/
                      Navigator.of(context).pop();

                    }else{
                      var snackBar = SnackBar(content: Text('Rating and Review already added',textAlign: TextAlign.center));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:8.0 , bottom: 8 , left: 12),
                      child: Text(
                        "Rate and Review this product",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,

                        ),
                      ),
                    ),
                    IconButton(icon: Icon(Icons.arrow_forward_ios_rounded), onPressed: (){})
                  ],
                ),

              ),

              Divider(
                color: Colors.grey,
                thickness: 1,
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  child:Container(
                    padding: EdgeInsets.only(top:25 , left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        loadedItem.items[index]['address'] != null ?RichText(
                          text: TextSpan(
                            //text: 'Hello ',
                            //style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(text: loadedItem.items[index]['address']['FullName'], style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400
                              )),
                              TextSpan(text: '\n\n${loadedItem.items[index]['address']['HouseNo']},  ${loadedItem.items[index]['address']['Area']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,

                                  )
                              ),
                              TextSpan(text: '\n${loadedItem.items[index]['address']['City']},  ${loadedItem.items[index]['address']['State']} - ${loadedItem.items[index]['address']['Pincode']} \n\nPh :- ${loadedItem.items[index]['address']['PhoneNo']} '

                                  ,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,

                                  )
                              ),
                              loadedItem.items[index]['address']['AltPhoneNo'] != null
                                  ?TextSpan(text: ' , ${loadedItem.items[index]['address']['AltPhoneNo']} '

                                  ,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,

                                  )
                              ): SizedBox(height: 0,),
                            ],
                          ),
                        ):SizedBox(height: 0,),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: [

                      Padding(
                        padding: EdgeInsets.only(left:10,top: 10,bottom: 10),
                        child: Text('PRICE DETAILS',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left:10,top: 10,bottom: 10),
                            child: Text('Price',
                              style: TextStyle(

                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left:10,top: 10,bottom: 10, right: 15),
                            child: Text("\u{20B9} ${(loadedItem.items[index]['price']) + (loadedItem.items[index]['discount'])}" ,
                              style: TextStyle(
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left:10,top: 10,bottom: 10),
                            child: Text('discount',
                              style: TextStyle(
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left:10,top: 10,bottom: 10, right: 15),
                            child: Text('- \u{20B9} ${loadedItem.items[index]['discount']}',
                              style: TextStyle(
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left:10,top: 10,bottom: 10),
                            child: Text('DeliveryCharges',
                              style: TextStyle(

                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left:10,top: 10,bottom: 10,right:15),
                            child: Text('\u{20B9} 0',
                              style: TextStyle(

                              ),
                            ),
                          ),
                        ],
                      ),

                      Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left:10,top: 10,bottom: 10),
                            child: Text('Amount Payable',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left:10,top: 10,bottom: 10,right:15),
                            child: Text('\u{20B9} ${loadedItem.items[index]['price']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
              Container(
                child: Card(
                  elevation: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left:10,top: 10,bottom: 10),
                        child: Text('PAYMENT MODE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left:10,top: 10,bottom: 10,right:15),
                        child: Text('CASH ON DELIVERY',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
