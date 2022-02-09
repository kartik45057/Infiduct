import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop/Admin/EditProductScreen.dart';
import 'package:shop/Products.dart';
//AllProductsScreen

class AllProductsScreen extends StatefulWidget {
  static const routeName = '/AllProducts';

  @override
  _AllProductsScreenState createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int N_o_f;
  //TextEditingController _c;
  String text;


  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    print("items length are ${productsData.items.length}");
    print("items are ${productsData.items[0]}");
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("All Products"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed:() async {
                //Navigator.of(context).pushNamed(EditProductScreen.routeName);
                await showDialog(
                    context: context,
                    builder: (ctx) => Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right:8.0 , left: 8, top: 15, bottom: 5),
                            child: TextField(
                              keyboardType: TextInputType.number,

                              decoration: InputDecoration(
                                  hintText: "No of features to add"

                              ),
                             // controller: _c,
                              onChanged: (value){

                                text = value;
                                print("the text is ${text}");
                              },
                            ),
                          ),
                          TextButton(
                              onPressed: (){

                                  N_o_f = int.parse(text);

                                Navigator.pop(context);
                              },
                              child: Text("SAVE")
                          )
                        ],
                      ),
                    )
                );
                //print("the text is ${N_o_f}");
                if(N_o_f!=null){
                  Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: {'num':N_o_f});
                }

              }
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            itemCount:  productsData.items.length,
            itemBuilder:(_,i) => Column(
              children: [
                Items(

                  productsData.items[i].title,
                  productsData.items[i].imageUrl,
                  productsData.items[i].id,
                  _scaffoldKey,
                ),
                Divider(
                  color: Colors.black87,
                )
              ],
            )
        ),
      ),
    );
  }
}


class Items extends StatefulWidget {
  String title;
  var imageUrl;
  String id;
  var _scaffoldKey;

  Items(this.title,this.imageUrl,this.id,this._scaffoldKey);
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  int N_o_f;
  //TextEditingController _c;
  String text;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(widget.title),
        leading: CircleAvatar(backgroundImage: NetworkImage(widget.imageUrl[0]),),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(icon: Icon(Icons.edit), onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (ctx) => Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right:8.0 , left: 8, top: 15, bottom: 5),
                            child: TextField(
                              keyboardType: TextInputType.number,

                              decoration: InputDecoration(
                                  hintText: "No of features to add"

                              ),
                              // controller: _c,
                              onChanged: (value){

                                text = value;
                                print("the text is ${text}");
                              },
                            ),
                          ),
                          TextButton(
                              onPressed: (){

                                N_o_f = int.parse(text);

                                Navigator.pop(context);
                              },
                              child: Text("SAVE")
                          )
                        ],
                      ),
                    )
                );
                //print("the text is ${N_o_f}");
                if(N_o_f!=null){
                  Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: {'num':N_o_f,'id':widget.id});
                }

               // Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: {'id':widget.id});
              }),
              IconButton(icon: Icon(Icons.delete), onPressed: () async{


                try {
                  await Provider.of<Products>(context, listen: false).deleteProd(widget.id);
                } catch (error) {
                  await showDialog(
                    context: widget._scaffoldKey.currentContext,
                    builder: (context) => AlertDialog(
                      title: Text('An error occurred!'),
                      content: Text('Something went wrong.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Okay'),
                          onPressed: () {
                            Navigator.of(context).pop();

                          },
                        )
                      ],
                    ),
                  );
                }

              })
            ],
          ),
        )
    );
  }
}


