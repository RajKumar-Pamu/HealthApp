import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class QuesUpload extends StatelessWidget {
  String question;
  Future<void> upload()async{
    FirebaseFirestore _firestore=FirebaseFirestore.instance;
    var userId= FirebaseAuth.instance.currentUser.uid;
    var docRef=await _firestore.collection('Users').doc(userId).collection('Questions').add({
      'Question':question,
      'Answer':'NULL',
      'UserId':userId,
      'DocId':'NULL'
    });
    var docRef2= await _firestore.collection('AllQuestions').add({
      'Question':question,
      'UserId':userId,
      'DocId':docRef.id,
      'Answer':'NA',
    });
    docRef.update({'DocId':docRef2.id});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width/15,
              right: MediaQuery.of(context).size.width/15
            ),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Enter Your Question',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)
                )
              ),
              maxLines: 5,
              maxLength: 250,
              onChanged: (val){
                question=val;
              },
            ),
          ),
          ElevatedButton(onPressed: ()async{
            await upload();
            Navigator.pop(context);}, child: Text("Post"))
        ],
      ),
    );
  }
}
