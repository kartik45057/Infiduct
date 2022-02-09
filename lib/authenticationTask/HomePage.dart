/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/ProductsOverviewScreen.dart';
import 'package:shop/Widgets/Lottie.dart';
import 'package:shop/authenticationTask/Authentication.dart';

import '../main.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),

          builder: (context , snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return LottieLoad();
            } else if(snapshot.hasData){
              Navigator.pop(context);
              // return MyApp();
              // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MyApp()), (_) => false);
            }else if(snapshot.hasError){
              return Center(
                child: Text(
                  "Something Went Wrong",
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
              );
            }else{
              print("nothing happended");
              return Authenticate();
            }

          }
      ),
    );
  }
}*/
