import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:practice/Admin/AdminHomePage.dart';
import 'package:practice/Users/QuestionUpload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice/Users/ViewAnswer.dart';
import 'package:practice/Users/ViewMyAnswers.dart';
import 'package:practice/common/Profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userId;
  FirebaseAuth _auth =FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  Future<void>getData()async{
    userId= _auth.currentUser.uid;
    setState(() {});
  }
  void handleClick(String value) async{
    switch (value) {
      case 'Admin':
         Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminHome()));
        break;
      case 'SignOut':
        await FirebaseAuth.instance.signOut();
        break;
      case 'Profile':
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context,isscroll){
          return [
            SliverAppBar(
              floating: true,
              pinned: true,
              bottom:  TabBar(
                tabs: [
                  Tab(text: 'All Posts',),
                  Tab(text: 'My Posts',)
                ],
              ),
              actions: [
                PopupMenuButton<String>(
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    return {'Admin','Profile' ,'SignOut'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            )
          ];
        },
        body: TabBarView(
          children: [
            AllQuestions(),
            MyQuestions(userId: userId,),
          ],
        ),
      ),
    floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>QuesUpload()));
      },
    ),)
    );
  }
}

class AllQuestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaginateFirestore(
      isLive: true,
      itemsPerPage: 10,
      query: FirebaseFirestore.instance.collection('AllQuestions').orderBy('Question'),
      itemBuilderType: PaginateBuilderType.listView,
      itemBuilder: (index,context,snapshots){
        return Card(
          child: ListTile(
            title: Text(snapshots.data()['Question']??""),
            trailing: snapshots.data()['Answer']=='NA'?
            Text("NA",style: TextStyle(color: Colors.red),):
            Text("A",style: TextStyle(color: Colors.green),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAnswer(
                docId: snapshots.data()['DocId'],
                userId: snapshots.data()['UserId'],)));
            },
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class MyQuestions extends StatelessWidget {
  String userId;
  MyQuestions({this.userId});
  @override
  Widget build(BuildContext context) {
    return PaginateFirestore(
      isLive: true,
      query:FirebaseFirestore.instance.collection('Users').doc(userId.toString()).collection('Questions').orderBy('Question'),
      itemBuilderType: PaginateBuilderType.listView,
      itemBuilder: (index,context,snapshots){
        return Card(
          child: ListTile(
            title: Text(snapshots.data()['Question'].toString()??"Loading"),
            trailing: snapshots.data()['Answer']=='NULL'?
            Text("NA",style: TextStyle(color: Colors.red),):
            Text("A",style: TextStyle(color: Colors.green),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewMyAnswers(
                docId2:snapshots.data()['DocId'],
                docId: snapshots.reference.id,
                userId: snapshots.data()['UserId'],
              )));
            },
          ),
        );
      },
    );
  }
}

