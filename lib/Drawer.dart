import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Admin/AllProductsScreen.dart';
import 'package:shop/CART/CartDetail.dart';
import 'package:shop/Favorites.dart';
import 'package:shop/Orders/AdminOrderNotification.dart';
import 'package:shop/Orders/OrderHistory.dart';
import 'package:shop/Product.dart';
import 'package:shop/Products.dart';
import 'package:shop/Profile/DeliveryAddress.dart';
import 'package:shop/Profile/ProfileScreen.dart';

import 'Orders/orders_screen.dart';
import 'authenticationTask/GoogleSignIn.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user =FirebaseAuth.instance.currentUser;
    return Drawer(

        child: Material(
          color: Colors.blueGrey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 5),
            children: [
              const SizedBox(height: 48,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                color: Colors.lightBlue,
                child: ListTile(

                  leading: Icon((Icons.person),color: Colors.white,),

                  title: Text('Profile', style: TextStyle(
                    color: Colors.white,
                  ),
                  ),
                  onTap:(){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProfileScreen()));
                  },
                ),
              ),

              const SizedBox(height: 16,),

              ListTile(

                leading: Icon((Icons.favorite_outline),color: Colors.white,),

                title: Text('favorites', style: TextStyle(
                color: Colors.white,
                ),
              ),
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CartDetail()));
                },
              ),

              const SizedBox(height: 16,),

              /*ListTile(

                leading: Icon((Icons.shopping_cart),color: Colors.white,),

                title: Text('My cart', style: TextStyle(
                  color: Colors.white,
                ),
                ),
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CartDetail()));
                },
              ),

              const SizedBox(height: 16,),*/

              user.uid == 'eHyTIPsm2KZeoYPvHgG1aDOp2mw1' ? ListTile(

                leading: Icon((Icons.all_inclusive_outlined),color: Colors.white,),

                title: Text('All Products', style: TextStyle(
                  color: Colors.white,
                ),
                ),
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AllProductsScreen()));
                },
              ):const SizedBox(height: 1,),
              user.uid == 'eHyTIPsm2KZeoYPvHgG1aDOp2mw1' ? const SizedBox(height: 16,):const SizedBox(height: 1,),

              user.uid == 'eHyTIPsm2KZeoYPvHgG1aDOp2mw1' ? ListTile(

                leading: Icon((Icons.call_received),color: Colors.white,),

                title: Text('Order Received', style: TextStyle(
                  color: Colors.white,
                ),
                ),
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AdminOrderNotification()));
                },
              ):const SizedBox(height: 1,),


              const SizedBox(height: 16,),
              Divider(
                color: Colors.white,
              ),

             const SizedBox(height: 16,),
              ListTile(
                leading: Icon(Icons.payment,color: Colors.white,),
                title: Text('Orders', style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => OrderHistory()));
                },
              ),
              const SizedBox(height: 16,),
              buildMenuItem(
                text: 'Updates',
                icon : Icons.update,

              ),

              const SizedBox(height: 16,),
              ListTile(

                leading: Icon((Icons.logout),color: Colors.white,),

                title: Text('Logout', style: TextStyle(
                  color: Colors.white,
                ),
                ),
                onTap:(){showDialog(context: context,
                  builder: (ctx) => AlertDialog(

                    title: Text("Are you sure?"),
                    content: Text('Do you want to logout?'),
                    actions: [
                      TextButton(onPressed: () async {
                        //cart.removeItem(product.id);
                        Navigator.pop(context);

                          await Provider.of<GoogleSignInProvider>(context,listen: false).googleSignIn.disconnect();
                            FirebaseAuth.instance.signOut();

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
              ),

            ],
          ),
        ),

    );
  }
}

Widget buildMenuItem({ @required String text , @required IconData icon}){


  return ListTile(

      leading: Icon(icon,color: Colors.white,),

      title: Text(text, style: TextStyle(
        color: Colors.white,
      ),
      ),
      onTap:(){

      },
    );


}

