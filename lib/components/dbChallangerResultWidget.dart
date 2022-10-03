// import 'package:dota2_invoker/entities/dbChallangerResult.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// var refDb= FirebaseDatabase.instance.reference().child("challanger_table");

// class DbChallangerResultWidget extends StatelessWidget {
//   const DbChallangerResultWidget({
//     Key? key,
//   }) : super(key: key);
  
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<Event>(
//       stream: refDb.orderByChild("result").onValue,
//       builder: (context,event){
//         if (event.hasData) {
//           var liste=<DbChallangerResult>[];
//       var gelenveri=event.data!.snapshot.value;
//       if (gelenveri!=null) {
//             gelenveri.forEach((key,nesne){
//               var gelenkayit=DbChallangerResult.fromJson(key,nesne);
//               liste.add(gelenkayit);
//             });
//           }
//         return ListView.builder(
//           shrinkWrap: true,
//           itemCount:liste.length,
//           itemBuilder: (context,index){
//             return Card(
//               color: Color(0xFF444444),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("  ${index+1}.  "+liste[liste.length -1 -index].name,style: TextStyle(color: Color(0xFFEEEEEE), fontSize: 18),),
//                   Text(liste[liste.length -1 -index].time.toString(),style: TextStyle(color: Color(0xFFFFCC00), fontSize: 18),),
//                   Text(liste[liste.length -1 -index].result.toString()+"    ",style: TextStyle(color: Color(0xFF00FF00), fontSize: 18),),
//                 ],
//               ),
//             );
//           },
//         ); 
//         }
//         else{
//           return Container();
//         }
//       },
//     );
//   }
// }