import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Price extends StatefulWidget {
  var loadedProduct;
  Price(this.loadedProduct);

  @override
  _PriceState createState() => _PriceState();
}

class _PriceState extends State<Price> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left:20.0,right: 8),
          child: Text('\u{20B9} ${widget.loadedProduct.price}',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              color: Color.fromRGBO(232, 207, 9,0.9)
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Text(' ${widget.loadedProduct.price + widget.loadedProduct.discount}',

            style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.lineThrough

            ),
          ),
        ),
        Text(' ${(100 - (widget.loadedProduct.price * 100 / (widget.loadedProduct.discount + widget.loadedProduct.price))).toInt()}% Off',

          style: TextStyle(
            fontSize: 14,
            color: Colors.green,
            fontWeight: FontWeight.w500,

          ),
        ),

      ],
    );
  }
}
