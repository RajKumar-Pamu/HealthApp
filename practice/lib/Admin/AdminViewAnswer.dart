import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:practice/Admin/EditAnswer.dart';

// ignore: must_be_immutable
class AdminViewAnswer extends StatefulWidget {
  String docId,userId;
  AdminViewAnswer({this.userId,this.docId});
  @override
  _AdminViewAnswerState createState() => _AdminViewAnswerState(userId,docId);
}

class _AdminViewAnswerState extends State<AdminViewAnswer> {
  String docId,userId,answer,question,docId2;
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  _AdminViewAnswerState(String userId, String docId){
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
    docId2=data.data()['DocId'].toString();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditAnswer(
                    userId: userId,
                    docId: docId,
                    docId2: docId2,
                  )));
                }, child: Text("Edit")),
                ElevatedButton(
                    onPressed: ()async{
                      await _firestore.collection('Users').doc(userId).collection('Questions').doc(docId).update(
                          {
                            'Answer':'NULL'
                          });
                      var res= await _firestore.collection('AllQuestions').doc(docId2).get();
                      await _firestore.collection('Admin').doc(res.data()['AdminId'].toString()).collection('Answered').doc(docId2).delete();
                      await _firestore.collection('AllQuestions').doc(docId2).update(
                          {
                            'AdminId':'NULL',
                            'Answer':'NA'
                          });
                      Navigator.pop(context);
                    },
                    child: Text("Delete Answer"))
              ],
            )
          ],
        ),
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}
