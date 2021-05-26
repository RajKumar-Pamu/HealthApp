import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:practice/Admin/WriteAnswers.dart';
class ViewNAQuestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PaginateFirestore(
        isLive: true,
        itemBuilderType: PaginateBuilderType.listView,
        itemsPerPage: 12,
        query: FirebaseFirestore.instance.collection('AllQuestions').orderBy('Question'),
        itemBuilder: (index,context,snapshot){
          return snapshot.data()['Answer']=='NA'?Card(
            child: ListTile(
              title: Text(snapshot.data()['Question']),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>WriteAnswer(
                  userId: snapshot.data()['UserId'],
                  docId: snapshot.data()['DocId'],
                  docId2: snapshot.reference.id,
                )));
              },
            ),
          ):SizedBox();
        },
      ),
    );
  }
}
