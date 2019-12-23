import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class UserModule extends ChangeNotifier{


  final databaseReference = Firestore.instance;

  Future<Map<String, dynamic>> getUser(String id) async{
    DocumentSnapshot r = await databaseReference.document('users/$id').get();
    if(r.data == null){
      return null;
    } else {
      return {
        'username': r.data['username'],
        'email': r.data['email'],
      };
    }
  }

}