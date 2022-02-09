import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Reviews.dart';

class Ratings extends StatefulWidget {
  var loadedProduct;
  Ratings(this.loadedProduct);

  @override
  _RatingsState createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  @override
  Widget build(BuildContext context) {
    var num = widget.loadedProduct.ratings;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20.0),
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => Reviews(widget.loadedProduct)));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:5.0),
          child: Row(
            children: [
              Container(
                color: Color.fromRGBO(232, 207, 9,0.9),
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right:3.0),
                      child: Text('${(num.toStringAsFixed(1))}',style: TextStyle(
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
                child: Text('${widget.loadedProduct.ratingsCount} ratings',style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
