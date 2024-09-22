import 'package:intl/intl.dart';

class TaskModel {
  String? id;
  String name = "";
  String description = "";
  DateTime? createdDate;
  bool isCompleted = false;

  TaskModel(
      {required this.name,
      required this.description,
      required this.createdDate,
      required this.isCompleted});

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
    createdDate = DateTime.parse(json["Date"]);
    isCompleted = json["isCompleted"];
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "Date": createdDate?.microsecondsSinceEpoch,
      "isCompleted": isCompleted.toString()
    };
  }
}
