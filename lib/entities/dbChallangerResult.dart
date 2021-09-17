class DbChallangerResult {
  late String id;
  late String name;
  late int time;
  late int result;

  DbChallangerResult(this.id,this.name,this.time,this.result);

  factory DbChallangerResult.fromJson(String key,Map<dynamic,dynamic> json){
    return DbChallangerResult(key, json["name"] as String,json["time"] as int, json["result"] as int);
  }

}