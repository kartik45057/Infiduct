import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Orders/Orders.dart';
import 'package:shop/Orders/PlaceOrder.dart';
import 'package:shop/Product.dart';
import 'package:shop/Products.dart';
import 'package:shop/Widgets/AddProDetails.dart';
import 'package:shop/Widgets/Ratings.dart';
import 'package:shop/Widgets/StyledImage.dart';
import 'package:shop/Widgets/price.dart';
import 'package:shop/badge.dart';
import 'CART/CartDetail.dart';
import 'CART/cart.dart';


class ProductDetail extends StatelessWidget {

  static const routename = '/ProductDetail';

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    final product = arguments['product'];
    final isthere = arguments['isthere'];
    final cart = Provider.of<Cart>(context);
    print('is there ${isthere}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        elevation: 0,

        actions: [
          Badge(
            child: IconButton(icon: Icon(Icons.favorite_border, color: Colors.white,), onPressed: (){
              //Navigator.popAndPushNamed(context, CartDetail.routename);
              Navigator.pushNamed(context, CartDetail.routename);
            }),
            value: cart.itemCount.toString(),
          )
        ],
      ),
      body: ProductsDetail2(product.id,product,isthere),
    );
  }
}

class ProductsDetail2 extends StatefulWidget {
   final id;
   final product;
   final bool isthere;
   ProductsDetail2(this.id,this.product,this.isthere);
  @override
  _ProductsDetail2State createState() => _ProductsDetail2State();
}

class _ProductsDetail2State extends State<ProductsDetail2> {

  PageController controller = PageController();

  var dup;
  var currentPageValue = 0.0;

  @override
  void initState() {
    dup = widget.isthere;

    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final loadedProduct = Provider.of<Products>(context).items.firstWhere((element) => element.id == widget.id);
    final cart = Provider.of<Cart>(context);
    double rate= double.parse(loadedProduct.ratings.toString());


    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex:5,
                  child: StyledImage(loadedProduct.imageUrl)
              ),

              Expanded(
                flex:4,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                    color: Colors.white
                  ),

                  child: SingleChildScrollView(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                                child: Text(loadedProduct.title, style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 28,
                                ),),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Ratings(loadedProduct),
                            )
                          ],
                        ),

                        loadedProduct.discount > 0
                            ? Price(loadedProduct)
                            : SizedBox(height: 0,),

                        loadedProduct.availableQuantity <= 0 ? Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 8),
                          child: Text('Out Of Stock',

                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,

                            ),
                          ),
                        ) : SizedBox(height: 0,),

                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20 , top: 20),
                          child: Text(loadedProduct.description, style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),),
                        ),

                        Container(
                          width: double.infinity,
                          //padding: EdgeInsets.all(10),
                          child: Card(
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 10, bottom: 10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.delivery_dining,
                                                color: Colors.deepPurple,),
                                              RichText(
                                                text: TextSpan(
                                                  //text: 'Hello ',
                                                  //style: DefaultTextStyle.of(context).style,
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                       // text: '    ${loadedProduct
                                                        //    .deliveryCharges}  |'
                                                      text: 'Free |',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.green,
                                                            fontWeight: FontWeight
                                                                .w500
                                                        )),
                                                    TextSpan(
                                                        //text: ' Delivery by ${loadedProduct
                                                          //  .estimatedDelivery}',
                                                      text:' Delivery within 7 days',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black87,
                                                            fontWeight: FontWeight
                                                                .w500
                                                        )
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          IconButton(icon: Icon(
                                              Icons.arrow_forward_ios_rounded),
                                              onPressed: () {})
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.cancel,
                                                  color: Colors.red,),
                                                Text('    No Returns Applicable',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    //color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            IconButton(icon: Icon(
                                                Icons.arrow_forward_ios_rounded),
                                                onPressed: () {})
                                          ]
                                      ),

                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            loadedProduct.codAvailability ? Row(
                                                children: [
                                                  Icon(Icons.money,
                                                    color: Colors.green,),
                                                  Text(
                                                    '    Cash on Delivery Available',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      //color: Colors.green,
                                                    ),
                                                  )
                                                ]
                                            ) : Row(
                                                children: [
                                                  Icon(Icons.cancel,
                                                    color: Colors.red,),
                                                  Text(
                                                    '    Cash on Delivery NotAvailable',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      //color: Colors.green,
                                                    ),
                                                  )
                                                ]
                                            ),
                                            IconButton(icon: Icon(
                                                Icons.arrow_forward_ios_rounded),
                                                onPressed: () {})
                                          ]
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          //padding: EdgeInsets.all(10),
                          child: Card(
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Product Details',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded),
                                ],
                              ),
                            ),
                          ),
                        ),

                        AddProDetails(loadedProduct.productsHighlights),
                      ]
                  ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (!dup) {
                            cart.addItem(productId: loadedProduct.id,
                                title: loadedProduct.title,
                                price: loadedProduct.price,
                                description: loadedProduct.description,
                                ratings: rate,
                                ratingsCount: loadedProduct.ratingsCount,
                                imageUrl: loadedProduct.imageUrl
                            );

                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Item added to Favorites!',
                                textAlign: TextAlign.center,),
                              duration: Duration(seconds: 1),));
                            setState(() {
                              dup = true;
                            });
                          }
                          else {
                            await Navigator.push(context, MaterialPageRoute(builder: (
                                BuildContext context) => CartDetail()));
                            Navigator.pop(context);
                          }
                        },
                        child: Container(

                          width: (MediaQuery.of(context).size.width) * 0.50,
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite_border, color: Colors.red,),
                              dup ? Text(' GO TO FAVORITE',
                                style: TextStyle(color: Colors.black),) : Text(
                                'ADD TO FAVORITE',
                                style: TextStyle(color: Colors.black),),
                            ],
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          if (widget.product.availableQuantity <= 0) {
                            var snackBar = SnackBar(content: Text(
                                'Currently item is Out Of Stock',
                                textAlign: TextAlign.center));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                          else {
                            Navigator.of(context).pushNamed(PlaceOrder.routename,
                                arguments: {'product': loadedProduct});
                          }
                        },
                        child: Container(
                          color: Colors.deepOrange,
                          width: (MediaQuery.of(context).size.width) * 0.50,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.work, color: Colors.white,),
                              Text('BUY NOW',
                                style: TextStyle(color: Colors.white),)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

