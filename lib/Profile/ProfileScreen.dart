import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shop/Profile/AddressModel.dart';
import 'package:shop/main.dart';
import 'DeliveryAddress.dart';

class ProfileScreen extends StatefulWidget {
  static const routename = '/ProfileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((snapshot) async {
      //print(snapshot.data());
      print('listened');
      Provider.of<Address>(this.context,listen: false).GetAddresses();

    });
    // TODO: implement initState
    super.initState();
  }
@override
  void dispose() {
    // TODO: implement dispose

    super.dispose();


  }
  @override
  Widget build(BuildContext context) {
    final loadedItem = Provider.of<Address>(context);
    print('length is${loadedItem.items.length}');

    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
      ),
      body: Container(
          height: (MediaQuery.of(context).size.height),
        child: SingleChildScrollView(
          child: Column(
            children: [


             Container(
               width: double.infinity,

               height: MediaQuery.of(context).size.height * 0.3,
               color: Colors.blue,
               child: Center(
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(Icons.person,size: 150,color: Colors.white,),
                     Text(accountUserName,style: TextStyle(
                       fontSize: 24,
                       fontWeight: FontWeight.w400,
                       color: Colors.white
                     ),),

                   ],
                 ),
               ),
             ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DeliveryAddress()));
                },
                child: Container(
                  width: double.infinity,
                  //padding: EdgeInsets.all(10),
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:20.0,horizontal: 10),
                      child: Row(

                        children: [
                          Icon(Icons.add,color: Colors.indigo,),
                          Text(' Add a new address',
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.indigo,
                                fontWeight: FontWeight.w600
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                height: (MediaQuery.of(context).size.height )*0.7,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    //itemBuilder: (ctx , index) => BuildItem(loadedItem.items[index],index),
                    itemBuilder: (ctx , index) => Card(
                        elevation: 5,
                        child: RadioListTile(
                          value: index,
                          groupValue: selection,
                          secondary: IconButton(icon: Icon(Icons.delete_forever), onPressed: () async {
                            try {

                              await Provider.of<Address>(context, listen: false).removeItem( fullName:loadedItem.items[index]['FullName'] ,  phoneNo:loadedItem.items[index]['PhoneNo'] ,
                                  altPhoneNo:loadedItem.items[index]['AltPhoneNo'] ,  pincode:loadedItem.items[index]['Pincode'] ,
                                  state:loadedItem.items[index]['State'],  city:loadedItem.items[index]['City'] , houseNo:loadedItem.items[index]['HouseNo'] ,  area:loadedItem.items[index]['Area']);
                              await showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                //title: Text(''),
                                content: Text('Address removed successfully!'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Okay'),
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                  )
                                ],
                              ),
                            );

                            } catch (error) {
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
                            },
                            )
                            ],
                            ),
                            );
                            }
                            }
                          ),
                          title: RichText(
                            text: TextSpan(
                              //text: 'Hello ',
                              //style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(text: loadedItem.items[index]['FullName'], style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400
                                )),
                                TextSpan(text: '\n\n${loadedItem.items[index]['HouseNo']},  ${loadedItem.items[index]['Area']}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,

                                    )
                                ),
                                TextSpan(text: '\n${loadedItem.items[index]['City']},  ${loadedItem.items[index]['State']} - ${loadedItem.items[index]['Pincode']} \n\nPh :- ${loadedItem.items[index]['PhoneNo']} '

                                    ,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,

                                    )
                                ),
                                loadedItem.items[index]['AltPhoneNo'] != null
                                    ?TextSpan(text: ' , ${loadedItem.items[index]['AltPhoneNo']} '

                                    ,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,

                                    )
                                ): SizedBox(height: 0,),
                              ],
                            ),
                          ),
                          onChanged:( val) {
                            setState(() { selection = val; });
                            addressData = loadedItem.items[index];
                            print(loadedItem.items[index]['FullName']);
                            },
                          activeColor: Colors.green,
                        )
                    ),

                    itemCount: loadedItem.items.length,

                  ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

