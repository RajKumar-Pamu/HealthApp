import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ViewMyAnswers extends StatefulWidget {
  String docId,userId,docId2;
  ViewMyAnswers({this.userId,this.docId,this.docId2});

  @override
  _ViewMyAnswersState createState() => _ViewMyAnswersState(userId,docId,docId2);
}

class _ViewMyAnswersState extends State<ViewMyAnswers> {
  String docId,userId,answer,question,docId2;
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  _ViewMyAnswersState(String userId, String docId,String docId2){
    this.docId=docId;
    this.userId=userId;
    this.docId2=docId2;
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
                  child: SingleChildScrollView(child: Column(
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
            ElevatedButton(onPressed: ()async{
              _firestore.collection('Users').doc(userId).collection('Questions').doc(docId).delete();
              var res=await _firestore.collection('AllQuestions').doc(docId2).get();
              _firestore.collection('Admin').doc(res.data()['AdminId']).collection('Answered').doc(docId2).delete();
              _firestore.collection('AllQuestions').doc(docId2).delete();
              Navigator.pop(context);
            }, child: Text("Delete"))
          ],
        ),
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}
