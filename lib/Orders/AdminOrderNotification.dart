import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Orders.dart';

class AdminOrderNotification extends StatefulWidget {


  @override
  _AdminOrderNotificationState createState() => _AdminOrderNotificationState();
}

class _AdminOrderNotificationState extends State<AdminOrderNotification> {
  @override
  Widget build(BuildContext context) {
    final loadedItem = Provider.of<Orders>(context);
    var orderItems = loadedItem.ordItems;
    var wid = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,), onPressed: (){
            Navigator.pop(context);
          }),
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('Orders Received',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,

                  fontWeight: FontWeight.w500
              ),

            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.black12,
                //height: (MediaQuery.of(context).size.height )*0.8,
                height: MediaQuery.of(context).size.height *0.9,
                padding: EdgeInsets.all(10),

                child: ListView.builder(
                  itemCount: loadedItem.ordItems.length,
                  shrinkWrap: true,
                  itemBuilder: (ctx , index) => GestureDetector(
                    onTap: () async {
                      //Navigator.of(context).pushNamed(OrderDetails.routename, arguments: {'index':index});
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                          children: [
                            Container(
                              //height: 150,
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.all(8),
                              child:  Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex:2,

                                    child: Container(
                                      width: wid*0.75,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15,bottom: 10),
                                            child: Text(loadedItem.ordItems[index]['title'] ,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black87,
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),


                                          Padding(
                                            padding: const EdgeInsets.only(left:15.0,top: 20),
                                            child: Text('\u{20B9} ${loadedItem.ordItems[index]['price'] }',
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  color:Colors.grey,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child:Column(
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 70,
                                            color: Colors.red,

                                            child: Image.network(
                                              loadedItem.ordItems[index]['image'][0],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      )
                                  )
                                ],
                              ),

                            ),

                            GestureDetector(
                              onTap: () async {
                                //cart.removeItem(product.id);
                                await showDialog(context: context,
                                  builder: (ctx) => AlertDialog(

                                    title: Text("Are you sure?"),
                                    content: Text('Are you sure that order delivered successfully?'),
                                    actions: [
                                      TextButton(onPressed: () async {

                                        Navigator.of(context).pop(

                                          );

                                        print('order items is ${loadedItem.ordItems[index]['index']}');
                                        print('order items is ${loadedItem.ordItems.length}');
                                        print('index  is ${index}');
                                         await loadedItem.removeOrder1(
                                            index:loadedItem.ordItems[index]['index'],
                                            index1:index
                                        );


                                      },
                                          child: Text("Yes")
                                      ),
                                      TextButton(onPressed: (){

                                        Navigator.of(context).pop();
                                      },
                                          child: Text("No")
                                      )
                                    ],

                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text('Delivered',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54
                                    //fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),


                          ]
                      ),
                    ),
                  ),


                ),
              ),
            ),
          ],
        )

    );
  }
}
