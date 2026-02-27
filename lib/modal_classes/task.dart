class Task {
  bool? isDone;
  String? description;
  int? deadline;
  String? taskName;
  String? id;

  Task({this.isDone, this.description, this.deadline, this.taskName, this.id});

  Task.fromJson(Map<String, dynamic> json) {
    isDone = json['isDone'];
    description = json['description'];
    deadline = json['deadline'];
    taskName = json['taskName'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isDone'] = this.isDone;
    data['description'] = this.description;
    data['deadline'] = this.deadline;
    data['taskName'] = this.taskName;
    data['id'] = this.id;
    return data;
  }
}