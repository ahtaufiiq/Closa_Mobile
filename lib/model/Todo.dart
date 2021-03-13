class Todo {
  final String description;
  final bool status;
  final int timestamp;
  final int notificationId;
  final String type;
  final String userId;
  final String timeReminder;

  Todo(this.description, this.status, this.timestamp, this.notificationId,
      this.type, this.userId, this.timeReminder);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['status'] = this.status;
    data['timestamp'] = this.timestamp;
    data['notificationId'] = this.notificationId;
    data['type'] = this.type;
    data['userId'] = this.userId;
    data['timeReminder'] = this.timeReminder;
    return data;
  }
}
