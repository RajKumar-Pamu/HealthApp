import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice/common/EditProfile.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userId,name="",mobile,email="";
  bool con=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  void getData()async{
    FirebaseAuth _auth=FirebaseAuth.instance;
    userId= _auth.currentUser.uid;
    mobile=_auth.currentUser.phoneNumber;
    var data= await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    try{
      name=data.data()['Name'];
      email=data.data()['Email'];
    }catch(e){
    }
    con=true;
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: con?SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 25,),
            CircleAvatar(
              radius: 80,
            ),
            SizedBox(height: 25,),
            Card(
              child: ListTile(
                title: Text("User Id"),
                subtitle: Text(userId??'Loading....'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Name"),
                subtitle: Text(name??""),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Phone"),
                subtitle: Text(mobile??"Loading"),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Email"),
                subtitle: Text(email??""),
              ),
            ),
            ElevatedButton(onPressed: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile(
                userId: userId,
                name: name,
                email: email,
              )));
              }, child: Text("Edit")),
          ],
        ),
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}
