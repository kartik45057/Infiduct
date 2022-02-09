import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddProDetails extends StatefulWidget {
  List<Map> proHighlights;
  AddProDetails(this.proHighlights);

  @override
  _AddProDetailsState createState() => _AddProDetailsState();
}

class _AddProDetailsState extends State<AddProDetails> {
  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.proHighlights.length,
        itemBuilder: (context ,index){
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top:20.0,left: 10),
                  child: Text('👉',

                    style: TextStyle(
                        fontSize: 16,

                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top:20.0,left: 5),
                  child: Text(
                    ' ${widget.proHighlights[index].keys.toString().substring(1,widget.proHighlights[index].keys.toString().length-1)}',

                    style: TextStyle(
                      color: Colors.grey,
                        fontSize: 15
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top:20.0,right: 10,left: 20),
                  child: Text(''
                      '${widget.proHighlights[index].values.toString().substring(1,widget.proHighlights[index].values.toString().length-1)}',

                    style: TextStyle(
                        fontSize: 16,
                      wordSpacing: 1.5
                    ),
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}
