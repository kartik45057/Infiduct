import 'dart:core';


import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Profile/AddressModel.dart';

class DeliveryAddress extends StatefulWidget {

  static const routename = '/DeliveryAddress';

  @override
  _DeliveryAddressState createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  final _PhoneFocusNode = FocusNode();
  final _AlternatePhoneFocusNode = FocusNode();
  final _StateFocusNode = FocusNode();
  final _PincodeFocusNode = FocusNode();
  final _CityFocusNode = FocusNode();
  final _HouseNOFocusNode = FocusNode();
  final _AreaFocusNode = FocusNode();
  final _form1 = GlobalKey<FormState>();

  var fullName='';
  var phoneNo='';
  var altPhoneNo ='';
  var pincode='';
  var state='';
  var city='';
  var houseNo='';
  var area='';

  var addField = false;
  bool _isLoading = false;

  Future<void> _saveForm(context) async {
    final isValid = _form1.currentState.validate();
    if (!isValid) {
      return;
    }
    _form1.currentState.save();
    setState(() {
      _isLoading = true;
    });


      try {
        print(area is String);
        await Provider.of<Address>(context, listen: false).addItem( fullName:fullName ,  phoneNo:phoneNo ,
            altPhoneNo:altPhoneNo ,  pincode:pincode ,
            state:state ,  city:city , houseNo:houseNo ,  area:area);
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            //title: Text(''),
            content: Text('Address added successfully!'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );

      } catch (error) {
        print(error);
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }




  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add delivery address'),
      ),
      body:_isLoading ? Center(
        child: CircularProgressIndicator(),
      )
          : Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _form1,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Full Name *',
                    border: new OutlineInputBorder(
                      //borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),

                  ),
                  textInputAction: TextInputAction.next,

                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_PhoneFocusNode);
                  },

                  onSaved: (value) {
                    fullName=value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a value.';
                    }
                    return null;
                  },

                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone No *',
                    border: new OutlineInputBorder(
                      //borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),

                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _PhoneFocusNode,

                  onSaved: (value) {
                    phoneNo=value;
                  },
                  validator: (value) {
                    if (value.length < 10){
                      return 'Please enter a valid PHONE NO.';
                    }
                    return null;
                  },
                ),
              ),

              addField ?
              Padding(
                padding: const EdgeInsets.symmetric(vertical:10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Alternate Phone No *',
                    border: new OutlineInputBorder(
                      //borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),

                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _AlternatePhoneFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_PincodeFocusNode);
                  },
                  onSaved: (value) {
                    altPhoneNo = value;
                  },
                  validator: (value) {
                    if (value.length < 10){
                      return 'Please enter a valid PHONE NO.';
                    }
                    return null;
                  },
                ),
              ) :GestureDetector(
                onTap: (){
                  setState(() {
                    addField = !addField;
                    FocusScope.of(context).requestFocus(_AlternatePhoneFocusNode);
                  });
                },
                child:Padding(
                  padding: const EdgeInsets.symmetric(vertical:10.0),
                  child: Text(
                    "+ Add alternate Phone number",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),

              ),


              Padding(
                padding: const EdgeInsets.symmetric(vertical:10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Pincode *',
                    border: new OutlineInputBorder(
                      //borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),

                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _PincodeFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_StateFocusNode);
                  },

                  onSaved: (value) {
                    pincode = value;
                  },
                  validator: (value) {
                    if (value.length < 6){
                      return 'Please enter a valid Pincode.';
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical:10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'State *',
                    border: new OutlineInputBorder(
                      //borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),

                  ),
                  textInputAction: TextInputAction.next,
                  focusNode: _StateFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_CityFocusNode);
                  },

                  onSaved: (value) {
                    state=value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid state name!';
                    }
                    return null;
                  },

                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical:10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'City *',
                    border: new OutlineInputBorder(
                      //borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),

                  ),
                  textInputAction: TextInputAction.next,
                  focusNode: _CityFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_HouseNOFocusNode);
                  },

                  onSaved: (value) {
                    city = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid city name!';
                    }
                    return null;
                  },

                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical:10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'House No *',
                    border: new OutlineInputBorder(
                      //borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),

                  ),
                  textInputAction: TextInputAction.next,
                  focusNode: _HouseNOFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_AreaFocusNode);
                  },

                  onSaved: (value) {
                    houseNo = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a House No!';
                    }
                    return null;
                  },

                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical:8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Area OR Colony name *',
                    border: new OutlineInputBorder(
                      //borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),

                  ),
                  textInputAction: TextInputAction.next,
                  focusNode: _AreaFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus();
                  },

                  onSaved: (value) {
                    area = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid colony name!';
                    }
                    return null;
                  },

                ),
              ),

              GestureDetector(
                onTap: (){
                  _saveForm(context);
                },
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    //width: wid*0.5,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                    decoration: BoxDecoration(
                      //border: Border.all(color:Colors.white,width: 2 ),
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:Center(
                      child: Text(
                        "Add address",
                        style: TextStyle(
                            fontSize: screenHeight  * 0.022,
                            color: Colors.white,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    )
                ),

              ),

            ],
          ),


        ),
      ),

    );
  }
}
