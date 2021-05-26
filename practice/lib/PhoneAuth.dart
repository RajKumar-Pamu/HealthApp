import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuth extends StatefulWidget {
  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  FirebaseAuth _auth=FirebaseAuth.instance;
  String phonenumber,otp="",countryCode="+91";
  String verId="";
  int resendtoken;
  bool con=true;

  //to receive otp
  Future registerwithPhone()async{
    print(phonenumber);
    await _auth.verifyPhoneNumber(
        phoneNumber: countryCode+phonenumber,
        codeSent:(String verificationId,int resendtoken)async{
          verId=verificationId;
          resendtoken=resendtoken;
          con=!con;
          setState(() {print(verId);});
        },
        verificationCompleted:null,
        verificationFailed: null,
        codeAutoRetrievalTimeout: null,
        timeout: Duration(seconds: 10)
    );
  }
  //Resenf otp
  Future resendCode()async{
    await _auth.verifyPhoneNumber(
        phoneNumber: "+91"+phonenumber,
        forceResendingToken: resendtoken,
        codeSent:(String verificationId,[int forceResendingToken])async{
          verId=verificationId;
          resendtoken=forceResendingToken;
          setState(() {});
        },
        verificationCompleted:null,
        verificationFailed: null,
        codeAutoRetrievalTimeout: null,
        timeout: Duration(seconds: 10)
    );
  }

  //signin with phone
  Future signInwithPhone()async{
    PhoneAuthCredential credential=PhoneAuthProvider.credential(verificationId: verId, smsCode: otp);
    await _auth.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width/10,
                  right: MediaQuery.of(context).size.width/10
              ),
              child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelText: 'Phone',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  maxLength: 10,
                  onChanged: (val){phonenumber=val;}),
            ),

            con?ElevatedButton(onPressed: ()async{await registerwithPhone();}, child: Text("Submit")):
            Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width/10,
                  right: MediaQuery.of(context).size.width/10
              ),
              child: TextFormField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'OTP',
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(10)
                    )
                ),maxLength: 6,onChanged: (val){otp=val;},),
            ),
            con?Text(""):
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: ()async{await resendCode();}, child: Text("Resend OTP")),
                ElevatedButton(onPressed: ()async{await signInwithPhone();}, child: Text("Login"))
              ],
            )
          ],
        ),
      ),
    );
  }
}


