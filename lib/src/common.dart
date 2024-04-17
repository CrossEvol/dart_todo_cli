import 'package:enum_to_string/enum_to_string.dart';

import 'hive.dart';

enum Priority { high, medium, low }

extension StringToEnum on String {
  Priority toPriority() {
    return EnumToString.fromString(Priority.values, this)!;
  }

  Status toStatus() {
    return EnumToString.fromString(Status.values, this)!;
  }
}

enum Status { pending, completed }


class Todo {
  String id = '';
  String title = '';
  String desc = '';
  Status status = Status.pending;
  Priority priority = Priority.medium;
  DateTime createAt = DateTime.now();
  DateTime updateAt = DateTime.now();

  Todo(this.id, this.title);
}

extension TodoExtension on Todo {
  HiveTodo map2HiveTodo() {
    return HiveTodo(
        id, title, desc, status.name, priority.name, createAt, updateAt);
  }
}
