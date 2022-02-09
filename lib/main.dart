import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shop/Admin/AllProductsScreen.dart';
import 'package:shop/Admin/EditProductScreen.dart';
import 'package:shop/Api/PushNotification.dart';
import 'package:shop/CART/CartDetail.dart';
import 'package:shop/CART/cart.dart';
import 'package:shop/Orders/Orders.dart';
import 'package:shop/Orders/PlaceOrder.dart';
import 'package:shop/Orders/orders_screen.dart';
import 'package:shop/Products.dart';
import 'package:shop/ProductsOverviewScreen.dart';
import 'package:shop/Products_Detail.dart';
import 'package:shop/Profile/DeliveryAddress.dart';
import 'package:shop/Widgets/Lottie.dart';
import 'package:shop/authenticationTask/Authentication.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shop/authenticationTask/GoogleSignIn.dart';
import 'FavoriteProductDetail.dart';
import 'Favorites.dart';
import 'Orders/OrderDetails.dart';
import 'Profile/AddressModel.dart';
import 'Profile/ProfileScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User user = FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}
DatabaseReference rideRequestReference = FirebaseDatabase.instance.reference().child('orders');

var addressData;
var selection = -1;
var accountUserName;

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
User user =FirebaseAuth.instance.currentUser;
final FirebaseMessaging fcm = FirebaseMessaging.instance;

@override
  Future<void> initState()  {
    // TODO: implement initState
    super.initState();
    PushNotification().getToken();

  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
        create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Address(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => GoogleSignInProvider(),
        )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: StreamBuilder(
           // stream: FirebaseAuth.instance.authStateChanges(),
            stream:  FirebaseAuth.instance.authStateChanges(),
            builder: (ctx,userSnapshot){
              if(userSnapshot.connectionState == ConnectionState.waiting){
                return LottieLoad();
              }
              else if(userSnapshot.hasData){
                return ProductsOverviewScreen();
              }else if(userSnapshot.hasError){
               return  Center(
                 child: Text(
                   "Something Went Wrong",
                   style: TextStyle(
                       fontSize: 16
                   ),
                 ),
               );
              }else{
                return Authenticate();
              }

            },
          ),


          routes: {
            ProductDetail.routename: (ctx) => ProductDetail(),
            FavoriteProductDetail.routename: (ctx) => FavoriteProductDetail(),
            Favorites.routename: (ctx) => Favorites(),
            CartDetail.routename: (ctx) => CartDetail(),
            Authenticate.routename:(ctx) => Login(),
            Authenticate.routename1:(ctx) => Register(),
            AllProductsScreen.routeName:(ctx) => AllProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            OrdersScreen.routeName:(ctx) => OrdersScreen(),
            PlaceOrder.routename:(ctx) =>PlaceOrder(),
            DeliveryAddress.routename:(ctx) => DeliveryAddress(),
            ProfileScreen.routename:(ctx) => ProfileScreen(),
            OrderDetails.routename:(ctx) => OrderDetails(),
            OrdPlaced.routename:(ctx) => OrdPlaced(),
          }
        ),

    );
  }
}


