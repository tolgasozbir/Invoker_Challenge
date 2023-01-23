import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants/app_strings.dart';
import '../models/with_timer_result.dart';
import '../services/database_service.dart';

class LeaderboardWithTimer extends StatelessWidget {
  LeaderboardWithTimer({Key? key,}) : super(key: key);
  
  final refDb = FirebaseDatabase.instance.reference().child(DatabaseTable.withTimer.name);
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Event>(
      stream: refDb.orderByChild("score").onValue,
      builder: (context,event){
        List<WithTimerResult> results = [];
        if (event.hasData) {
          var data = event.data!.snapshot.value as Map?;
          if (data != null) {
            results = data.values.map((e) => WithTimerResult.fromMap(Map<String, dynamic>.from(e))).toList();
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

  ListView resultBuilder(List<WithTimerResult> results) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount:results.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context,index){
        var textStyle = TextStyle(color: Color(0xFFEEEEEE), fontSize: 18);
        return Card(
          color: Color(0xFF444444),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "  ${index+1}.  " + results[results.length -1 -index].name,
                style: textStyle,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
              Text(
                results[results.length -1 -index].score.toString()+"  ",
                style: textStyle,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
            ],
          ),
        );
      },
    );
  }
}