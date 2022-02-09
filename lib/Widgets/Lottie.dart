import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieLoad extends StatefulWidget {

  @override
  _LottieLoadState createState() => _LottieLoadState();
}

class _LottieLoadState extends State<LottieLoad> with SingleTickerProviderStateMixin{

  AnimationController controller1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller1= AnimationController(
      //duration: Duration(seconds: 3),
      vsync: this,
    );



  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller1.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Center(
      child:  Lottie.asset(
          'assets/loadpaperplane.json',
      ),
    );
  }
}
class OrdPlaced extends StatefulWidget {
  static const routename = '/OrdPlaced';


  @override
  _OrdPlacedState createState() => _OrdPlacedState();
}

class _OrdPlacedState extends State<OrdPlaced> with SingleTickerProviderStateMixin{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(vertical: (MediaQuery.of(context).size.height)*0.1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black12,
              ),
              child: Lottie.asset(
                'assets/delivery-guy.json',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: Text("Order Placed Successfully!",
                style: TextStyle(
                  fontSize: 24,
                  wordSpacing: 1.5,
                  fontWeight: FontWeight.w400
                ),

              ),
            ),
            Text("Faster | Safe Delivery",
              style: TextStyle(
                  fontSize: 18,
                  wordSpacing: 1.5,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w400
              ),

            ),

          ],
        )
      ),
    );
  }
}

