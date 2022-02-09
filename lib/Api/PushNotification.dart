import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

 class PushNotification {
   final FirebaseMessaging fcm = FirebaseMessaging.instance;
   final User user = FirebaseAuth.instance.currentUser;


  Future<void> getToken() async {
     var tff = await FirebaseFirestore.instance.collection('Token').doc('eHyTIPsm2KZeoYPvHgG1aDOp2mw1').get();


    String token;
    try {
      fcm.subscribeToTopic('all');

      await fcm.requestPermission(
        alert: true,

        badge: true,

        sound: true,
      );

      if(user.uid == 'eHyTIPsm2KZeoYPvHgG1aDOp2mw1'){


        await fcm.getToken().then((value) {
          print("value of token is ${value}");
          token = value;
        });
        print("value of token1 is ${tff['token']}");
        if(tff['token'] != token){
          print("value of token1 ");
          await FirebaseFirestore.instance.collection('Token').doc('eHyTIPsm2KZeoYPvHgG1aDOp2mw1').set({
            'token':token.toString()
          });
        }

      }



    }catch(e){
      print("error in sending push notification is ${e}");
      throw e;
    }
  }

  sendNotification() async {
    var tff = await FirebaseFirestore.instance.collection('Token').doc('eHyTIPsm2KZeoYPvHgG1aDOp2mw1').get();
    try{
      Map<String , String> headerMap = {
        'Content-Type':'application/json',
        'Authorization':"key=AAAAyG7FFH8:APA91bFTWh-ZhmQiBZbE6VpyqHJinqZTW-3imiYhPJSoUkf4dpPpAwwTt6cZJmOzWVl8t9E5E_MyjGBm8SL2SolITZ5oOC_msxC13eeiX2gkxqOA9OyjJFrZ4I66aWky9zzDRNZnrk5h"
      };
      Map notificationMap  = {
        'body': 'New order received',
        'title': 'Order',
      };

      Map dataMap ={
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id" : "1",
        "status": "done",

      };
      Map sendNotificationMap = {
        'notification':notificationMap,
        'data':dataMap,
        'priority':'high',
        'to':tff['token'],
      };

      var v =await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: headerMap,
          body: json.encode(sendNotificationMap)
      );
      print("value of v in sending push notification is ${v.body.toString()}");
      print("value of statuscode in sending push notification is ${v.statusCode}");
      print("value of request in sending push notification is ${v.headers}");
    }catch(e){
      throw e;
    }
  }

}