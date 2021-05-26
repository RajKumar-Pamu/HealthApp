import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditAnswer extends StatefulWidget {
  String docId,userId,docId2;
  EditAnswer({this.userId,this.docId,this.docId2});
  @override
  _EditAnswerState createState() => _EditAnswerState(userId,docId,docId2);
}
class _EditAnswerState extends State<EditAnswer> {
  String docId,userId,answer,question,docId2;
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  _EditAnswerState(String userId, String docId,String docId2){
    this.docId=docId;
    this.userId=userId;
    this.docId2=docId2;
    print(docId);
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
      body:con? SingleChildScrollView(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Answer : ",style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10,),
                      SingleChildScrollView(
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Enter Your Answer',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)
                              )
                          ),
                          initialValue: answer,
                          maxLines: 10,
                          onChanged: (val){
                            answer=val;
                          },
                        ),
                      )
                    ],
                  )
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: ()async{
              await _firestore.collection('Users').doc(userId).collection('Questions').doc(docId).update(
                  {
                    'Answer':answer
                  });
              var adminUsrId=FirebaseAuth.instance.currentUser.uid;
              await FirebaseFirestore.instance.collection('AllQuestions').doc(docId2).update(
                  {
                    'AdminId':adminUsrId.toString(),
                    'Answer':'A'
                  });
              await _firestore.collection('Admin').doc(adminUsrId).collection('Answered').doc(docId2).set({
                'QuestionId':docId2,
                'Question':question
              });
              Navigator.pop(context);
            }, child: Text("Submit"))
          ],
        ),
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}
