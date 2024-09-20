class TaskModel {
  int? id;
  String name = "";
  String description = "";
  DateTime? createdDate;
  bool isCompleted = false;

  TaskModel.fromJson(Map<String,dynamic> json){
    id = json["id"];
    name = json["name"];
    description = json["description"];
    createdDate = DateTime.parse(json["date"]);
    isCompleted = json["isCompleted"];
  }

  Map<String,dynamic> toJson() {
    return {
      "id" : id,
      "name" : name,
      "description" : description,
      "date" : createdDate?.toIso8601String(),
      "isCompleted" : isCompleted
    };
  }
}