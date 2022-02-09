import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/CART/cart.dart';
import 'package:shop/Drawer.dart';
import 'package:shop/Products.dart';
import 'package:shop/Products_grid.dart';
import 'package:shop/Widgets/Search.dart';
import 'Orders/Orders.dart';
import 'Product.dart';
import 'Products.dart';
import 'Profile/AddressModel.dart';

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  final scrollController = ScrollController();


  @override
  void initState()  {

    /*DatabaseReference rideRequestReference = FirebaseDatabase.instance.reference().child('products');
    rideRequestReference.onValue.listen((event)async {
      if (event.snapshot.value != null) {
        print(
            "sbhiuhif sbikhikihihnif fbiiuuhniuuhihjilfh fiuhjihjiujijf ${event
                .snapshot.value}");
        Provider.of<Products>(context,listen: false).fetchAndSetProducts1();
        //Products().fetchAndSetProducts1();

      }
    });*/

    CollectionReference reference = FirebaseFirestore.instance.collection('Products');
    reference.snapshots().listen((querySnapshot) {
      //querySnapshot.docChanges.forEach((change) {
        // Do something with change
        Provider.of<Products>(context,listen: false).fetchAndSetProd();
     // });
    });
    Provider.of<Orders>(context,listen: false).notifyOnChange();
    Provider.of<Orders>(context,listen: false).notifyOnChange1();

    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //scrollController.addListener(scrollListener);
    //Provider.of<Products>(context,listen: false).fetchNextUsers();

    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      //Provider.of<Products>(context).GetfavoriteItems();
      Provider.of<Cart>(context).GetCartItems();
      Provider.of<Address>(context).GetAddresses();
      Provider.of<Orders>(context).GetOrders();
      Provider.of<Products>(context).fetchAndSetProd().then((_){

        setState(() {
          _isLoading = false;
        });
      });
      Provider.of<Orders>(context).getOrdReq();
      /*Provider.of<Products>(context).fetchAndSetProducts().then((_) {

        setState(() {
          _isLoading = false;
        });
      });*/
    }


    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }

  /*void scrollListener() {
    if (scrollController.offset >=
        scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      if (Provider.of<Products>(context,listen: false).hasNext) {
        Provider.of<Products>(context,listen: false).fetchNextUsers();
      }
    }
  }*/


  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        backgroundColor: Colors.grey,

        title: Text("Infiduct",
        style: TextStyle(
          color: Colors.black
        ),),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Search()));
          })
        ],

      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
        child: GridView.builder(
          //controller: scrollController,
          gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
            childAspectRatio: 4/5
          ),
          itemCount: products.length,
          itemBuilder: (ctx,i) => ChangeNotifierProvider.value(
              value : products[i],
              child: ProductsGrid(

              ),

          )

        ),
      ),
    );
  }
}
