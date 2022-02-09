import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shop/Api/PushNotification.dart';
import 'package:shop/Profile/ProfileScreen.dart';
import 'package:shop/Widgets/Ratings.dart';
import 'package:shop/Widgets/Lottie.dart';
import '../main.dart';
import 'Orders.dart';

class PlaceOrder extends StatefulWidget {
  static const routename = '/PlaceOrder';

  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    final product = arguments['product'];
    return Scaffold(
      appBar: AppBar(

          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.grey,), onPressed: () {
               Navigator.pop(context);
              }
            )


      ),
      body: PlaceOrderWidget1(product),
    );
  }
}

class PlaceOrderWidget1 extends StatefulWidget {
  final product;
  PlaceOrderWidget1(this.product);

  @override
  _PlaceOrderWidget1State createState() => _PlaceOrderWidget1State();
}

class _PlaceOrderWidget1State extends State<PlaceOrderWidget1> with SingleTickerProviderStateMixin{
  AnimationController controller1;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller1= AnimationController(
     // duration: Duration(seconds: 3),
      vsync: this,
    );


    controller1.addStatusListener((status) async{
      if(status == AnimationStatus.completed){
        await Navigator.popAndPushNamed(context, OrdPlaced.routename);
        controller1.reset();
      }
    });


  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller1.dispose();

    super.dispose();
  }

  var _isloading = false;
  @override
  Widget build(BuildContext context)  {
    final order = Provider.of<Orders>(context,listen: false);
    final wid = MediaQuery.of(context).size.width;
    final id = widget.product.id;
    return _isloading?
        Center(child: LottieLoad()):Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 9,
          child: Container(
            //height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)*0.93,
            decoration: BoxDecoration(
              color: Colors.white10
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(

                    child: Card(

                      elevation: 5,
                      child: Column(
                        children: [
                          Container(
                            //height: 150,
                            margin: EdgeInsets.only(top: 5),
                            padding: EdgeInsets.all(8),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: wid * 0.75,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Text(widget.product.title,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,

                                            fontSize: 18,
                                          ),
                                        ),
                                      ),

                                      Ratings(widget.product),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, top:10),
                                        child: Text('\u{20B9} ${widget.product.price }',
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
                                        widget.product.imageUrl[0],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
                            addressData != null ?RichText(
                              text: TextSpan(
                                //text: 'Hello ',
                                //style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(text: addressData['FullName'], style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w400
                                  )),
                                  TextSpan(text: '\n\n${addressData['HouseNo']},  ${addressData['Area']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,

                                      )
                                  ),
                                  TextSpan(text: '\n${addressData['City']},  ${addressData['State']} - ${addressData['Pincode']} \n\nPh :- ${addressData['PhoneNo']} '

                                      ,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,

                                      )
                                  ),
                                  addressData['AltPhoneNo'] != null
                                      ?TextSpan(text: ' , ${addressData['AltPhoneNo']} '

                                      ,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,

                                      )
                                  ): SizedBox(height: 0,),
                                ],
                              ),
                            ):SizedBox(height: 0,),

                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProfileScreen())).then((value) => setState(() {}));
                              },
                              child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  //width: wid*0.5,
                                  padding: EdgeInsets.symmetric(vertical:15),
                                  decoration: BoxDecoration(
                                    //border: Border.all(color:Colors.white,width: 2 ),
                                    color: Color.fromRGBO(232, 207, 9,0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child:Center(
                                    child: Text(
                                      "Change or Add address",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  )
                              ),

                            ),
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
                                child: Text('\u{20B9} ${widget.product.price + widget.product.discount }',
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
                                child: Text('- \u{20B9} ${widget.product.discount}',
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
                                child: Text('\u{20B9} ${widget.product.price}',
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
                  ),
                  Container(
                    color: Colors.white,
                    margin:EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top:0 , left: 30,right: 30),
                            child: Text("Enjoy 100% Genuine Products ",

                              style: TextStyle(
                                fontWeight: FontWeight.w400,

                                fontSize: 20,

                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top:8 , left: 30,right: 30),
                            child: Text("Safe | Secure Payments ",

                              style: TextStyle(
                                //fontWeight: FontWeight.w400,
                                color: Colors.purple,
                                fontSize: 16,

                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),


        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(

                width: (MediaQuery.of(context).size.width)*0.50,
                //height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)*0.07,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text('\u{20B9} ${widget.product.price}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () async {

                  if(addressData==null){
                    var snackBar = SnackBar(content: Text('Add delivery address',textAlign: TextAlign.center));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }else{
                    try{
                      setState(() {
                        _isloading = true;
                      });
                      var user = await FirebaseAuth.instance.currentUser;
                      var id1= user.uid;

                      await order.addOrd(widget.product,addressData);
                      await PushNotification().sendNotification();
                      setState(() {
                        _isloading = false;
                      });
                      showDialog(
                          context: context,
                          builder: (ctx) => Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Lottie.asset(
                                    'assets/done.json',
                                    repeat: false,
                                    controller: controller1,
                                    onLoaded: (composition){
                                      controller1.duration = composition.duration;
                                      controller1.forward();
                                    }
                                ),
                                Text('Order Placed',textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18),
                                ),

                                const SizedBox(height: 16,)
                              ],
                            ),
                          )
                      );


                    }catch (error){
                      print(error);
                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('An error occurred!'),
                          content: Text('Something went wrong.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Okay'),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                Navigator.of(ctx).pop();
                              },
                            )
                          ],
                        ),
                      );
                    }
                  }

                },
                child: Container(
                  color: Colors.deepOrange,
                  width: (MediaQuery.of(context).size.width)*0.50,
                  //height : (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)*0.07,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text('Place Order',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class PlaceOrderWidget2 extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          Container(
            //height: 150,
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.all(8),
            child:Container()

          ),
        ],
      ),

    );
  }
}

