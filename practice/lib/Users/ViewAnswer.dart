import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ViewAnswer extends StatefulWidget {
  String docId,userId;
  ViewAnswer({this.userId,this.docId});
  @override
  _ViewAnswerState createState() => _ViewAnswerState(userId,docId);
}

class _ViewAnswerState extends State<ViewAnswer> {
  String docId,userId,answer,question;
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  _ViewAnswerState(String userId, String docId){
    this.docId=docId;
    this.userId=userId;
  }
  bool con=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  void getData()async{
     var data=await _firestore.collection('Users').doc(userId).collection('Questions').doc(docId).get();
     question=data.data()['Question'].toString();
     //print(question);
     answer=data.data()['Answer'].toString();
     if(answer=="NULL"){
       answer="Not Answered ";
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
            Card(
              margin: EdgeInsets.only(left: 10,right: 10,top: 10),
              child: Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Question :",style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Text(question??"Loading........"),
                    ],
                  )
              ),
            ),
            Card(
            margin: EdgeInsets.only(left: 10,right: 10,top: 10),
              child: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                  height: MediaQuery.of(context).size.height/2,
                  child: SingleChildScrollView(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Answer : ",style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10,),
                     Text(answer??"Loading......"),
                    ],
                  ))
              ),
            ),
            SizedBox(height: 10,),
            Card(
              child: ListTile(
                title: Text("Posted by"),
                subtitle: Text(userId??" "),
              ),
            )
          ],
        ),
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}
