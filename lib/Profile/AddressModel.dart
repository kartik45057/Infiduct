import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shop/main.dart';

class AddressFields{
  final String FullName;
  final String PhoneNo;
  final String AltPhoneNo;
  final String Pincode;
  final String State;
  final String City;
  final String HouseNo;
  final String Area;

  AddressFields( this.AltPhoneNo , this.Area , this.City , this.FullName ,
      this.HouseNo , this.PhoneNo , this.Pincode , this.State);

}

class Address with ChangeNotifier{

  List<Map> _items= [];

  List<Map> get items{
    return _items;
  }

  int get itemCount{

    return _items.length;

  }



Future<void> GetAddresses()  async{
    //return[..._items.where((element) => element.isfavorite).toList()];

    User user = FirebaseAuth.instance.currentUser;
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(user.uid).get();
    Map<String, dynamic> data = docSnapshot.data();
    List<Map> tempitems= [];

    if(data['address']!= null){
      if(data['address'].length!=null){
        for(var i = 0;i< data['address'].length;i++){
          tempitems.add(
            {
              'FullName' : data['address'][i]['FullName'],
              'PhoneNo' : data['address'][i]['PhoneNo'],
              'AltPhoneNo' : data['address'][i]['AltPhoneNo'],
              'Pincode' : data['address'][i]['Pincode'],
              'State' : data['address'][i]['State'],
              'City' : data['address'][i]['City'],
              'HouseNo' : data['address'][i]['HouseNo'],
              'Area' : data['address'][i]['Area'],
            }
          );
        }
      }
      //_items.clear();
      print('tempitems ${tempitems}');
       _items = tempitems;

    }
    if(data['username']!= null){
       accountUserName = data['username'];
    }
    notifyListeners();
  }



  Future<void> addItem( {String fullName, String phoneNo , String altPhoneNo=null , String pincode ,
    String state , String city ,String houseNo , String area}) async {

    var user = await FirebaseAuth.instance.currentUser;
    var map = {
      'FullName' : fullName,
      'PhoneNo' : phoneNo,
      'AltPhoneNo' : altPhoneNo,
      'Pincode' : pincode,
      'State' : state,
      'City' : city,
      'HouseNo' : houseNo,
      'Area' : area,
    };
    
    try{
       await FirebaseFirestore.instance.collection('users').doc(user.uid).update({"address":FieldValue.arrayUnion([
        map
      ])});

      //_items.add(map);
      notifyListeners();
    }catch (error) {
      throw error;
    }


  }



  Future<void> removeItem({String fullName, String phoneNo , String altPhoneNo=null , String pincode ,
    String state , String city ,String houseNo , String area}) async {

    var user = await FirebaseAuth.instance.currentUser;
    var map = {
      'FullName' : fullName,
      'PhoneNo' : phoneNo,
      'AltPhoneNo' : altPhoneNo,
      'Pincode' : pincode,
      'State' : state,
      'City' : city,
      'HouseNo' : houseNo,
      'Area' : area,
    };
    //print('${fullName} , ${phoneNo}, ${altPhoneNo} , ${pincode}');
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({"address":FieldValue.arrayRemove([
      {
        'FullName' : fullName,
        'PhoneNo' : phoneNo,
        'AltPhoneNo' : altPhoneNo,
        'Pincode' : pincode,
        'State' : state,
        'City' : city,
        'HouseNo' : houseNo,
        'Area' : area,
      }

    ])});

    notifyListeners();
  }
}

