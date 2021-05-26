import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditProfile extends StatelessWidget {
  String name,email,userId;
  EditProfile({this.userId,this.name,this.email});
  Future <void> updateProfile()async{
    await FirebaseFirestore.instance.collection('Users').doc(userId).set({
      'Name':name,
      'Email':email
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(height: 25,),
          CircleAvatar(
            radius: 80,
          ),
          SizedBox(height: 25,),
          Container(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width/10,
                right: MediaQuery.of(context).size.width/10
            ),
            child: TextFormField(
              initialValue: name,
              decoration: InputDecoration(
                labelText: 'Enter Name',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                )
              ),
              maxLength: 15,
              onChanged: (val){
                name=val;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width/10,
                right: MediaQuery.of(context).size.width/10
            ),
            child: TextFormField(
              initialValue: email,
              decoration: InputDecoration(
                labelText: 'Enter Mail Id',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  )
              ),
              maxLength: 40,
              onChanged: (val){
                email=val;
              },
            ),
          ),
          ElevatedButton(onPressed: ()async{
            await updateProfile();
            Navigator.pop(context);
          }, child: Text("Update"))
        ],
      ),
    );
  }
}
