import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
//import 'package:path/path.dart' as path;

import 'package:provider/provider.dart';

import '../Product.dart';
import '../Products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _discountFocusNode = FocusNode();
  final _availQtyFocusnode = FocusNode();
  final _desFocusNode = FocusNode();
  final _imageUrlFocusnode = FocusNode();
  final _form = GlobalKey<FormState>();
  int num= 1;
  int N_O_F;

  File file;
  UploadTask task;

  bool _isLoading = false;

  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    discount: 0,
    availableQuantity: 0,
    description: '',
    productsHighlights: [],
    imageUrl: [],
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'discount':'',
    'availableQuantity':'',

    'imageUrl': '',
  };
  var _isInit = true;


  void didChangeDependencies() {
    if (_isInit) {
      var arguments = ModalRoute.of(this.context).settings.arguments as Map;
      final productId = arguments['id'];
      var arguments1 = ModalRoute.of(this.context).settings.arguments as Map;
      N_O_F=arguments1['num'];
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(this.context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'discount' : _editedProduct.discount.toString(),
          'availableQuantity' : _editedProduct.availableQuantity.toString(),
           //'imageUrl': _editedProduct.imageUrl.toString(),
          //'imageUrl': '',
        };

      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _priceFocusNode.dispose();
    _desFocusNode.dispose();
    _discountFocusNode.dispose();
    _availQtyFocusnode.dispose();
    super.dispose();
  }

  Future<void> _saveForm(context) async {
    print("save");

    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    if(_editedProduct.imageUrl.length==0){
      //return;
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Wait'),
          content: Text('image is required'),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
                //return;
              },
            )
          ],
        ),
      );
      return;
    }

    print("imageurl is ${_editedProduct.imageUrl}");

    _form.currentState.save();
    print("save 2");
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProd(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProd(_editedProduct);
      } catch (error) {
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
    // Navigator.of(context).pop();
  }

  void selectFile() async{
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null){
      return;
    }
    final path = result.files.single.path;
    setState(() {
      file = File(path);
    });
  }

  void uploadFile(context) async{
    _desFocusNode.unfocus();
    showLoaderDialog(context);
    if (file == null) return;
    final filename = basename(file.path);
    final destination = 'images/$filename';
    task = FirebaseApi.uploadFile(destination, file);

    if (task == null) return;

    final snapshot = await task.whenComplete((){});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print(urlDownload);
    _editedProduct.imageUrl.add(urlDownload.toString());

    if (urlDownload != null) {
      print("entry");
      _editedProduct = Product(
        title: _editedProduct.title,
        price: _editedProduct.price,
        discount: _editedProduct.discount,
        availableQuantity: _editedProduct.availableQuantity,
        description: _editedProduct.description,
        //imageUrl: [urlDownload.toString()],
        productsHighlights: _editedProduct.productsHighlights,
        imageUrl: _editedProduct.imageUrl,
        id: _editedProduct.id,
      );
      print("exit");

    }
    Navigator.pop(context);
    setState(() {
      num++;
    });
    //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Image uploaded!' , textAlign: TextAlign.center,), duration: Duration(seconds: 1),));

  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final fileName = file!=null ? basename(file.path): "no file chosen";


    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
           IconButton(icon: Icon(Icons.save), onPressed: (){
             _saveForm(context);
           })
        ],
      ),
      body:_isLoading ? Center(
        child: CircularProgressIndicator(),
          )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },

                onSaved: (value) {
                  _editedProduct = Product(
                    title: value,
                    price: _editedProduct.price,
                    discount: _editedProduct.discount,
                    availableQuantity: _editedProduct.availableQuantity,
                    description: _editedProduct.description,
                    id:_editedProduct.id,
                      productsHighlights: _editedProduct.productsHighlights,
                    imageUrl: _editedProduct.imageUrl
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null;
                },

              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_discountFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: double.parse(value),
                    discount: _editedProduct.discount,
                    availableQuantity: _editedProduct.availableQuantity,
                    description: _editedProduct.description,
                    productsHighlights: _editedProduct.productsHighlights,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
                },
              ),

              TextFormField(
                initialValue: _initValues['discount'],
                decoration: InputDecoration(labelText: 'discount'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _discountFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_availQtyFocusnode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    discount: double.parse(value),
                    availableQuantity: _editedProduct.availableQuantity,
                    description: _editedProduct.description,
                    productsHighlights: _editedProduct.productsHighlights,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
                },
              ),

              TextFormField(
                initialValue: _initValues['availableQuantity'],
                decoration: InputDecoration(labelText: 'Available Quantity'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _availQtyFocusnode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_desFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    discount: _editedProduct.discount,
                    availableQuantity: double.parse(value),
                    description: _editedProduct.description,
                    productsHighlights: _editedProduct.productsHighlights,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
                },
              ),


              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _desFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    discount: _editedProduct.discount,
                    availableQuantity: _editedProduct.availableQuantity,
                    description: value,
                    productsHighlights: _editedProduct.productsHighlights,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters long.';
                  }
                  return null;
                },
              ),

              SizedBox(
                height: 300,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    //shrinkWrap: true,
                  itemCount: N_O_F,
                    itemBuilder: (context,index) {
                       return TextFormField(

                         decoration: InputDecoration(labelText: 'Enter Feature-Value'),
                         textInputAction: TextInputAction.next,

                         onSaved: (value) {
                           List Fv = value.split('-');
                           Map Mfv = {Fv[0]:Fv[1]};
                           _editedProduct.productsHighlights.insert(index, Mfv);
                           _editedProduct = Product(
                               title: _editedProduct.title,
                               price: _editedProduct.price,
                               discount: _editedProduct.discount,
                               availableQuantity: _editedProduct.availableQuantity,
                               description: _editedProduct.description,
                               id:_editedProduct.id,
                               productsHighlights: _editedProduct.productsHighlights,
                               imageUrl: _editedProduct.imageUrl
                           );
                         },
                         validator: (value) {
                           if (value.isEmpty) {
                             return 'Please provide a value.';
                           }
                           return null;
                         },

                       );
                    }
                ),
              ),

              Column(
                children: [
                  ElevatedButton(onPressed: (){
                    selectFile();
                  }, child: Text("Select Image")),
                  Text(fileName),
                  ElevatedButton(onPressed: (){
                    uploadFile(context);
                  }, child: Text('Upload Image ${num}'))
                ],
              )

              /*Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 10,right: 15),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2,color: Colors.grey)
                    ),
                    child: _imageUrlController.text.isEmpty
                        ?Text('Enter a URL')
                        :FittedBox(
                      child: Image.network('_imageUrlController'),
                      fit: BoxFit.cover,
                    )
                    ,
                  ),

                  Expanded(

                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image url'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                    ),
                  ),

                ],
              )*/
            ],
          ),
        ),
      ),
    );
  }
}

class FirebaseApi{
  static UploadTask uploadFile(String destination , File file){
    try{
      final ref  = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    }catch(e){
      return null;
    }
  }
}
