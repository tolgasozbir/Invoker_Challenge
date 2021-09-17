import 'dart:collection';

import 'package:dota2_invoker/entities/dbResult.dart';
import 'package:firebase_database/firebase_database.dart';

class DbAccesLayer {

  var refDb= FirebaseDatabase.instance.reference().child("result_table");
  var refChallangerDb= FirebaseDatabase.instance.reference().child("challanger_table");

  Future<void> addDbValue(String name,int finalResult) async {
    var value=HashMap<String,dynamic>();
    value["name"]=name;
    value["result"]=finalResult;
    refDb.push().set(value);
  }

  Future<void> addDbChallangerValue(String name,int time,int finalResult) async {
    var value=HashMap<String,dynamic>();
    value["name"]=name;
    value["time"]=time;
    value["result"]=finalResult;
    refChallangerDb.push().set(value);
  }


  Future<void> getAllResultRealTime() async {
    refDb.onValue.listen((event) { 
      var values=event.snapshot.value;

      if (values!=null) {
        values.forEach((key,object){
          var value=DbResult.fromJson(key,object);

          print("********");
          print("key $key");
          print("sonuç ${value.name}");
          print("sonuç ${value.result}");

        });
      }
    });
  }

  Future<void> getAllResultOnce() async {
    refDb.orderByChild("result").limitToLast(5).once().then((DataSnapshot snapshot) { 
      var values=snapshot.value;

      if (values!=null) {
        values.forEach((key,object){
          var value=DbResult.fromJson(key,object);

          print("********");
          print("key $key");
          print("sonuç ${value.name}");
          print("sonuç ${value.result}");

        });
      }
    });
  }




}