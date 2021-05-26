import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:practice/Admin/AdminViewAnswer.dart';
import 'package:practice/Admin/StartAnswering.dart';
import 'package:practice/HomePage.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String userId;
  FirebaseAuth _auth =FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  Future <void> getData()async{
    userId=_auth.currentUser.uid;
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
        child: Scaffold(
         body: NestedScrollView(
          headerSliverBuilder: (context,isscrollable){
            return [
              SliverAppBar(
               // primary: true,
                floating: true,
                //snap: true,
                pinned: true,
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'All Questions',),
                    Tab(text:'My Answers')
                  ],
                ),
              )
            ];
          },
          body: TabBarView(children: [
            AllQuestions(),
            MyAnswers(usrId: userId,)
          ])
      ),
          floatingActionButton: ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewNAQuestions()));
          },child: Text("Start Answering"),),
    )
    );
  }
}

// ignore: must_be_immutable
class MyAnswers extends StatelessWidget {
  String usrId;
   MyAnswers({this.usrId});
   FirebaseFirestore _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    print(usrId);
    return PaginateFirestore(
        isLive: true,
        query: _firestore.collection('Admin').doc(usrId).collection('Answered').orderBy('QuestionId'),
        itemBuilderType: PaginateBuilderType.listView,
        itemsPerPage: 10,
        itemBuilder: (index,context,snap){

          return Card(
            child: ListTile(
              title: Text(snap.data()['Question'].toString()??"Loading"),
              onTap: ()async{
                var data=await _firestore.collection('AllQuestions').doc(snap.data()['QuestionId'].toString()).get();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminViewAnswer(
                  userId: data.data()['UserId'],
                  docId: data.data()['DocId'],
                )));
              },
             ),
          );
        },
    );
  }
}


