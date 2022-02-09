import 'package:flutter/cupertino.dart';
import 'package:shop/Products_Detail.dart';
import 'package:provider/provider.dart';

class Product with ChangeNotifier{

  final id;
  final title;
  final description;
  final ratings;
  final deliveryCharges;
  final estimatedDelivery;
  final price;
  final discount;
  final bool codAvailability;
  final availableQuantity;
  final List<String> imageUrl;
  final List<Map> productsHighlights;
  final List reviews;
  final ratingsCount;
  bool isfavorite = false;



  Product({this.id,this.title,this.description,this.ratings=0,this.price,this.imageUrl,this.ratingsCount=0,this.availableQuantity,
    this.isfavorite=false,this.deliveryCharges,this.estimatedDelivery,this.discount,this.codAvailability=true,
    this.productsHighlights,this.reviews});


  void toggleFavoriteStatus(){

    isfavorite = !isfavorite;
    notifyListeners();

  }

}

