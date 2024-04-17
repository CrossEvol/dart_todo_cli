enum Priority { high, medium, low }

enum Status { pending, completed }

class Todo {
  String id = '';
  String title = '';
  String desc = '';
  Status status = Status.pending;
  Priority priority = Priority.medium;
  DateTime createAt = DateTime.now();
  DateTime updateAt = DateTime.now();

  Todo(this.id,this.title);
}
