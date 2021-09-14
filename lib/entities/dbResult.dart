class DbResult {
  late String id;
  late String name;
  late int result;

  DbResult(this.id,this.name,this.result);

  factory DbResult.fromJson(String key,Map<dynamic,dynamic> json){
    return DbResult(key, json["name"] as String, json["result"] as int);
  }

/*  factory DbResult.fromJson(Map<dynamic,dynamic>json){
    return DbResult(json["name"] as String, json["result"] as int );
  }*/

}