import 'package:dota2_invoker/models/challenger_result.dart';
import 'package:dota2_invoker/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constants/app_strings.dart';

class LeaderboardChallanger extends StatelessWidget {
  LeaderboardChallanger({Key? key,}) : super(key: key);
  
  final refDb = FirebaseDatabase.instance.reference().child(DatabaseTable.challenger.name);
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Event>(
      stream: refDb.orderByChild("score").onValue,
      builder: (context,event){
        List<Challenger> results = [];
        if (event.hasData) {
          var data = event.data!.snapshot.value as Map?;
          if (data != null) {
            results = data.values.map((e) => Challenger.fromMap(Map<String, dynamic>.from(e))).toList();
          }
          return results.isNotEmpty 
            ? resultBuilder(results) 
            : LottieBuilder.network('https://assets7.lottiefiles.com/temporary_files/WoL9Wc.json');
        } 
        if (event.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        else{
          return LottieBuilder.network(
            'https://assets7.lottiefiles.com/packages/lf20_RaWlll5IJz.json',
            errorBuilder: (context, error, stackTrace) => Text(AppStrings.errorMessage),
          );
        }
      },
    );
  }

  ListView resultBuilder(List<Challenger> results) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount:results.length,
      itemBuilder: (context,index){
        return Card(
          color: Color(0xFF444444),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("  ${index+1}.  "+results[results.length -1 -index].name,style: TextStyle(color: Color(0xFFEEEEEE), fontSize: 18),),
              Text(results[results.length -1 -index].time.toString(),style: TextStyle(color: Color(0xFFFFCC00), fontSize: 18),),
              Text(results[results.length -1 -index].score.toString()+"    ",style: TextStyle(color: Color(0xFF00FF00), fontSize: 18),),
            ],
          ),
        );
      },
    ); 
  }
}