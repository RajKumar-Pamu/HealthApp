import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practice/HomePage.dart';
import 'package:practice/PhoneAuth.dart';


Future <void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth _auth=FirebaseAuth.instance;
  runApp(MaterialApp(
      home:StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (context,snapshot){
          return snapshot.hasData?Home():PhoneAuth();
        },
      ),

  ));
}
