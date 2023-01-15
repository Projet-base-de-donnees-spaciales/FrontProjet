class Role{
  int? id;
  String? name;
  Role({this.id,this.name});
  Map<String,dynamic> toJson()=>{
    "id":id,
    "name":name
  };
}