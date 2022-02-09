import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Product.dart';
import 'package:shop/Products.dart';

import 'Favorites.dart';
import 'Widgets/Reviews.dart';

class FavoriteProductDetail extends StatelessWidget {

  static const routename = '/FavoriteProductDetail';

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context).settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          Navigator.of(context).pushNamed(Favorites.routename);
        }),
      ),
      body: FavoriteProductsDetail2(product.id,product),
    );
  }
}

class FavoriteProductsDetail2 extends StatefulWidget {
  final id;
  final product;
  FavoriteProductsDetail2(this.id,this.product);
  @override
  _FavoriteProductsDetail2State createState() => _FavoriteProductsDetail2State();
}

class _FavoriteProductsDetail2State extends State<FavoriteProductsDetail2> {

  PageController controller = PageController();
  var currentPageValue = 0.0;
  @override
  Widget build(BuildContext context) {
    final loadedProduct = Provider.of<Products>(context).items.firstWhere((element) => element.id == widget.id);
    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)*0.9,
          //color: Colors.grey,
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                      children: [
                        Container(
                            height: 300,
                            color: Colors.white,
                            margin: EdgeInsets.only(top: 8,bottom: 30),
                            child: PageView.builder(

                              controller: controller,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Image.network(loadedProduct.imageUrl[index]),
                                );
                              },
                              itemCount: (loadedProduct.imageUrl).length,

                            )
                        ),

                        Positioned(
                          // bottom: 200,
                          right: 10,
                          top: 10,

                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: Container(
                                  height: 50.0,
                                  //margin: const EdgeInsets.only(bottom: 6.0),
                                  margin: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(2.0, 3.0), //(x,y)
                                        blurRadius: 6.0,
                                      ),
                                    ],

                                  ),
                                  child: IconButton(
                                      icon: Icon(widget.product.isfavorite ? Icons.favorite : Icons.favorite_outline),

                                      onPressed: (){

                                        setState(() {
                                          widget.product.toggleFavoriteStatus();
                                        });

                                      }
                                  ),
                                ),
                              ),


                              ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: Container(
                                  height: 50.0,
                                  //margin: const EdgeInsets.only(bottom: 6.0),
                                  margin: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(2.0, 3.0), //(x,y)
                                        blurRadius: 6.0,
                                      ),
                                    ],

                                  ),
                                  child: IconButton(
                                      icon: Icon(Icons.share), onPressed: (){}
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ]
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:15.0),
                    child: Text(loadedProduct.description,style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:15.0),
                    child: GestureDetector(
                      onTap: (){
                       // Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => Reviews()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical:5.0),
                        child: Row(
                          children: [
                            Container(
                              color: Colors.green,
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right:3.0),
                                    child: Text('${loadedProduct.ratings}',style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),),
                                  ),
                                  Icon(Icons.star,color: Colors.white,size: 13,),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Text('${loadedProduct.ratingsCount} ratings',style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),),
                            ),


                          ],
                        ),
                      ),
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:15.0),
                    child: Text('\u{20B9} ${loadedProduct.price}',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),


                  Container(
                    width: double.infinity,
                    //padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0,top: 10,bottom: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.delivery_dining,color: Colors.deepPurple,),
                                        /*Text('    ${widget.deliveryCharges}  | Delivery by ${widget.estimatedDelivery}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          //color: Colors.green,
                                        ),
                                      ),*/
                                        RichText(
                                          text: TextSpan(
                                            //text: 'Hello ',
                                            //style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: '    ${loadedProduct.deliveryCharges}  |', style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w500
                                              )),
                                              TextSpan(text: ' Delivery by ${loadedProduct.estimatedDelivery}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.w500
                                                  )
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    IconButton(icon: Icon(Icons.arrow_forward_ios_rounded), onPressed: (){})
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:5.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.cancel,color: Colors.red,),
                                          Text('    No Returns Applicable',
                                            style: TextStyle(
                                              fontSize: 15,
                                              //color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),

                                      IconButton(icon: Icon(Icons.arrow_forward_ios_rounded), onPressed: (){})
                                    ]
                                ),

                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:5.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      loadedProduct.codAvailability ? Row(
                                          children: [
                                            Icon(Icons.money,color: Colors.green,),
                                            Text('    Cash on Delivery Available',
                                              style: TextStyle(
                                                fontSize: 15,
                                                //color: Colors.green,
                                              ),
                                            )
                                          ]
                                      ):Row(
                                          children: [
                                            Icon(Icons.cancel,color: Colors.red,),
                                            Text('    Cash on Delivery NotAvailable',
                                              style: TextStyle(
                                                fontSize: 15,
                                                //color: Colors.green,
                                              ),
                                            )
                                          ]
                                      ),

                                      IconButton(icon: Icon(Icons.arrow_forward_ios_rounded), onPressed: (){})
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
                        padding: const EdgeInsets.symmetric(vertical:20.0,horizontal: 10),
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



                ]
            ),
          ),

        ),



        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: (){},
              child: Container(

                width: (MediaQuery.of(context).size.width)*0.50,
                height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)*0.07,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_shopping_cart,color: Colors.black,),
                    Text('ADD TO CART',style: TextStyle(color: Colors.black),)
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: (){},
              child: Container(
                color: Colors.deepOrange,
                width: (MediaQuery.of(context).size.width)*0.50,
                height : (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)*0.07,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.work,color: Colors.white,),
                    Text('BUY NOW',style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
            )
          ],
        ),

      ],
    );
  }
}

