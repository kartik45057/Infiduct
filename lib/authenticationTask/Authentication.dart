import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import 'package:shop/Widgets/Lottie.dart';
import 'package:shop/authenticationTask/GoogleSignIn.dart';
import 'package:shop/main.dart';

class Authenticate extends StatelessWidget {

  static const routename = '/login';
  static const routename1 = '/signup';

  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Image(
            image: AssetImage('assets/img3.jpg'),
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,

          ),

          Positioned(
            bottom: 180,
            left: wid*0.15,

              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).pushNamed(Authenticate.routename1);
                },
                child: Container(
                  width: wid*0.7,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                        //border: Border.all(color:Colors.white,width: 2 ),
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:Center(
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  )
                ),
              )
          ),
          Positioned(
              bottom: 100,
              left: wid*0.20,

              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).pushNamed(Authenticate.routename);
                },
                child: Container(
                    width: wid*0.6,
                    
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        //border: Border.all(color:Colors.white,width: 2 ),
                        borderRadius: BorderRadius.circular(20),
                      color: Colors.purple
                    ),
                    child:Center(
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    )
                ),

              )
          )
        ],
      ),
    );
  }
}
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();

  String _email;
  String _email1;
  String _password;
  var isLoading = false;
  final _auth = FirebaseAuth.instance;

  void trySubmit() async{
    setState(() {
      isLoading = true;
    });
    UserCredential user;
    final isValid = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      _formkey.currentState.save();
    }

    try {
      user = await _auth.signInWithEmailAndPassword(email: _email, password: _password);
      await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MyApp()), (_) => false);
    }catch (err){
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.message),),);
      print(err.message);

    }
    setState(() {
      isLoading = false;
    });
    print(user);
  }

  void trySubmit1() async{

    UserCredential user;
    final isValid = _formkey1.currentState.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      _formkey1.currentState.save();
    }

    try {
       await _auth.sendPasswordResetEmail(email: _email1);
       Navigator.pop(context);
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pasword Reset Email has been sent!",
         style: TextStyle(
             fontSize: 16
         ),),),);
    }on FirebaseAuthException catch (err){
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.message),),);
      print(err.code);
      if(err.code =='user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No user found!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
        ),),),);
      }


    }

    print(user);
  }

  Widget buildSheet(double wid){
    return Padding(
      padding: const EdgeInsets.only(top: 20.0,left: 20,bottom: 20),
      child: Wrap(
       // mainAxisAlignment: MainAxisAlignment.start,

          children: [
            Padding(
              padding:EdgeInsets.only(top: 30),
              child: Text('Forgot password',
                style: TextStyle(
                    fontSize: 26,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87
                ),
              ),
            ),
            Padding(
              padding:EdgeInsets.only(top: 30, ),
              child: Text('Enter your email so that we can send you the password reset link',
                style: TextStyle(
                    fontSize: 15,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey
                ),
              ),
            ),

            Form(
                key: _formkey1,

                child: Container(

                  margin: EdgeInsets.only(top: 50),
                  child: Card(
                    elevation: 3,
                    child: Padding(
                        padding:EdgeInsets.only(left: 15, right: 15,
                            bottom:  MediaQuery.of(context).viewInsets.bottom
                        ),
                        child: TextFormField(
                            validator: (value) => EmailValidator.validate(value) ? null : "Please enter a valid email",

                            onSaved: (emailAddress){
                              _email1 = emailAddress;
                            },
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: [AutofillHints.email],
                            decoration: InputDecoration(
                              //border: InputBorder.none,
                              labelText: 'Email address',
                              //suffixIcon: Icon(Icons.perso n)
                            ))),
                  ),
                )
            ),
            Center(
              child: GestureDetector(
                    onTap: (){

                      trySubmit1();

                    },
                    child: Container(
                        width: wid*0.7,
                        //height: 50,
                        margin: EdgeInsets.only(top: 40),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          //border: Border.all(color:Colors.white,width: 2 ),
                          color: Color.fromRGBO(255, 183, 0, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:Center(
                          child: Text(
                            "Reset Password",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        )
                    ),

                  ),
            )

            ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double wid = MediaQuery.of(context).size.width;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    print(screenHeight*0.38);
    return Scaffold(

      body: isLoading
          ? Center(child: LottieLoad())
          : Container(
          height: screenHeight,
          //color: Colors.grey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(

                      height: screenHeight * 0.77,
                      width: wid,
                    ),
                    Positioned(

                        child: Image(
                          image: AssetImage('assets/img7.jpg'),
                          height: screenHeight*0.4,
                          width: wid,
                          fit: BoxFit.cover,

                        ),
                      ),


                    Positioned(

                        top: screenHeight*0.33,
                        left: wid*0.08,
                        child:Material(
                            elevation: 3,
                            child:Container(
                              padding: EdgeInsets.all(15),
                              //margin: EdgeInsets.only(left: 20,right: 20),
                              //height: screenHeight*0.38,
                              width: wid*0.84,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:5),
                                    child: Text('Login',
                                      style: TextStyle(
                                          fontSize: screenHeight*0.028,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.lightBlueAccent
                                      ),
                                    ),
                                  ),

                                  Form(
                                      key: _formkey,

                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,

                                        children: [
                                          Container(

                                            margin: EdgeInsets.only(top: 20),
                                            child: Card(
                                              elevation: 3,
                                              child: Padding(
                                                  padding:EdgeInsets.only(left: 15, right: 15, bottom: 3),
                                                  child: TextFormField(
                                                      validator: (value) => EmailValidator.validate(value) ? null : "Please enter a valid email",

                                                      onSaved: (emailAddress){
                                                        _email = emailAddress;
                                                      },
                                                      style: TextStyle(
                                                        fontSize: screenHeight * 0.02,
                                                      ),
                                                      keyboardType: TextInputType.emailAddress,
                                                      autofillHints: [AutofillHints.email],
                                                      decoration: InputDecoration(
                                                        //border: InputBorder.none,
                                                        labelText: 'Email address',
                                                        //suffixIcon: Icon(Icons.perso n)
                                                      ))),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 20),
                                            child: Card(
                                              elevation: 3,
                                              child: Padding(
                                                  padding: EdgeInsets.only(left: 15, right: 15, bottom:3),
                                                  child: TextFormField(
                                                      validator: (value){
                                                        if(value.length < 8){
                                                          return "Password must be atleast 8 characters long";
                                                        }
                                                        else{
                                                          return null;
                                                        }
                                                      },
                                                      onSaved: (pass){
                                                        _password =  pass;
                                                      },
                                                      style: TextStyle(
                                                        fontSize: screenHeight * 0.02,
                                                      ),
                                                      keyboardType: TextInputType.visiblePassword,
                                                      obscureText: true,
                                                      decoration: InputDecoration(
                                                        //border: InputBorder.none,
                                                        labelText: 'Password',

                                                      ))),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap: (){
                                              showModalBottomSheet(
                                                  isScrollControlled: true,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30) ,
                                                      topRight: Radius.circular(20)),
                                                ),
                                                  //backgroundColor: Colors.black12,
                                                  context: context,
                                                  builder: (context) => buildSheet(wid)
                                              );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top: 15, bottom: 35),
                                              child: Text('Forgot Password?',
                                                style: TextStyle(
                                                    fontSize: screenHeight * 0.018,
                                                    color: Colors.black54
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],

                                      )
                                  ),
                                ],
                              ),
                            )

                        )
                    ),


                  ],
                ),

                if (!isKeyboard)GestureDetector(
                  onTap: (){

                    trySubmit();

                  },
                  child: Container(
                      width: wid*0.5,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.012),
                      decoration: BoxDecoration(
                        //border: Border.all(color:Colors.white,width: 2 ),
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:Center(
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                              fontSize:  screenHeight * 0.02,
                              color: Colors.white,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      )
                  ),

                ),

                if (!isKeyboard)GestureDetector(
                  onTap: () async {
                    /*setState(() {
                      isLoading=true;
                    });*/
                    Navigator.pop(context);
                    final provider = Provider.of<GoogleSignInProvider>(context,listen: false);
                    await provider.googleLogin();
                    //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MyApp()), (_) => false);
                    //Navigator.pop(context);
                   /* setState(() {
                      isLoading=false;
                    });*/
                  },
                  child: Container(
                      width: wid*0.7,
                      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      padding: EdgeInsets.symmetric(vertical: screenHeight *0.008,),
                      decoration: BoxDecoration(
                        //border: Border.all(color:Colors.black45,width: 3 ),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Also Login With     ",
                            style: TextStyle(
                              fontSize: screenHeight * 0.018,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,

                            ),
                          ),

                          Image.asset('assets/img8.jpg',height: screenHeight*0.04,width: screenHeight*0.03,)


                        ],
                      )
                  ),

                ),
                if (!isKeyboard)GestureDetector(
                  onTap: () async{
                    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Register()), (_) => false);
                  },

                  child: RichText(
                    text: TextSpan(

                      children: <TextSpan>[
                        TextSpan(
                            text: 'Do not have an account?',
                            style: TextStyle(
                                fontSize: screenHeight * 0.018,
                                color: Colors.black54
                            )),
                        TextSpan(
                            text: '  Sign up',
                            style: TextStyle(
                                fontSize: screenHeight * 0.024,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                            )),

                      ],
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}




class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController _usernamecontrol = TextEditingController();
  TextEditingController _emailcontrol = TextEditingController();
  TextEditingController _passwordcontrol = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String _username;
  String _email;
  String _password;
  var isLoading =false;

  final _auth = FirebaseAuth.instance;

  void trySubmit() async{
    setState(() {
      isLoading = true;
    });

    //CircularProgressIndicator();
    UserCredential user;
    final isValid = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      _formkey.currentState.save();
    }
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
      await FirebaseFirestore.instance.collection('users')
          .doc(user.user.uid)
          .set({'username' : _username,'email':_email,'CartItemId':[] , 'cart' : [] , 'address' : []});
      await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MyApp()), (_) => false);
     }catch (err){
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.message),),);
      print(err.message);

    }

    setState(() {
      isLoading = false;
    });
    print(user);

  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double wid = MediaQuery.of(context).size.width;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: isLoading
          ? Center(child: LottieLoad())
          : Container(
        height: screenHeight,
        child: SingleChildScrollView(

          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: screenHeight * 0.8,
                    width: wid,
                  ),

                  Positioned(
                      child:Image(
                        image: AssetImage('assets/img10.jpg'),
                        height: screenHeight*0.4,
                        width: wid,
                        fit: BoxFit.cover,

                      ),
                  ),

                  Positioned(
                    top: screenHeight*0.33,
                      left: wid*0.36,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text('Register',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightBlueAccent,
                            letterSpacing: 1
                          ),
                        ),
                      ),
                  ),
                  Positioned(
                    top: screenHeight*0.4,
                      left: wid*0.08,
                      child: Container(
                        width: wid*0.84,
                        //height: screenHeight*0.38,
                        decoration: BoxDecoration(
                          border: Border.all(width:7,color: Colors.black12),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        padding: EdgeInsets.only(top: 10 , left: 10 , right: 10 ,bottom: 10),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              Container(

                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                      padding:EdgeInsets.only(left: 15, right: 15,bottom: 3),
                                      child: TextFormField(
                                        validator: (String value){

                                          if(value.isEmpty ){
                                            return "Enter valid username";
                                          }
                                          else{
                                            return null;
                                          }

                                        },

                                          onSaved: (name){
                                             _username=name;
                                          },
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            //height: 2.0,
                                            //color: Colors.black
                                          ),
                                          keyboardType: TextInputType.text,

                                          decoration: InputDecoration(
                                              //border: InputBorder.none,
                                              labelText: 'Username',
                                              //suffixIcon: Icon(Icons.person)
                                          ))),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                      padding:EdgeInsets.only(left: 15, right: 15, bottom: 3),
                                      child: TextFormField(
                                        validator: (value) => EmailValidator.validate(value) ? null : "Please enter a valid email",

                                          onSaved: (emailAddress){
                                             _email = emailAddress;
                                          },

                                          style: TextStyle(
                                            fontSize: 18,
                                            //height: 2.0,
                                            //color: Colors.black
                                          ),
                                          keyboardType: TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                              //border: InputBorder.none,
                                              labelText: 'Email Address',
                                              //suffixIcon: Icon(Icons.person)
                                          ))),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                      padding:EdgeInsets.only(left: 15, right: 15 ,bottom: 3),
                                      child: TextFormField(
                                        validator: (value){
                                          if(value.length < 8){
                                            return "Password must be atleast 8 characters long";
                                          }
                                          else{
                                            return null;
                                          }
                                        },
                                          onSaved: (pass){
                                            _password =  pass;
                                          },
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            //height: 2.0,
                                            //color: Colors.black
                                          ),
                                          keyboardType: TextInputType.visiblePassword,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            //border: InputBorder.none,
                                            labelText: 'Password',
                                            //suffixIcon: Icon(Icons.person)
                                          ))),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ),


                ],
              ),

              if (!isKeyboard) GestureDetector(
                onTap: (){
                  trySubmit();
                },
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    width: wid*0.5,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                    decoration: BoxDecoration(
                      //border: Border.all(color:Colors.white,width: 2 ),
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:Center(
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: screenHeight  * 0.022,
                            color: Colors.white,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    )
                ),

              ),

              if (!isKeyboard) GestureDetector(
                onTap: () async {
                  //Navigator.of(context).pushNamed(Authenticate.routename);
                  Navigator.pop(context);
                  final provider = Provider.of<GoogleSignInProvider>(context,listen: false);
                  await provider.googleLogin();
                },
                child: Container(
                    width: wid*0.7,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.symmetric(vertical: 8,),
                    decoration: BoxDecoration(
                      //border: Border.all(color:Colors.black45,width: 3 ),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue
                    ),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Also  Sign up  With     ",
                          style: TextStyle(
                            fontSize: screenHeight * 0.018,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,

                          ),
                        ),

                        Image.asset('assets/img8.jpg',height: screenHeight *0.035,width: 35,)


                      ],
                    )
                ),

              ),

              if (!isKeyboard) GestureDetector(
                onTap: () async{
                  await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Login()), (_) => false);
                },

                child: RichText(
                  text: TextSpan(

                    children: <TextSpan>[
                      TextSpan(
                          text: 'Already have an account?',
                          style: TextStyle(
                              fontSize: screenHeight *0.018,
                              color: Colors.black54
                          )),
                      TextSpan(
                          text: '  Sign in',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.black
                          )),



                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

