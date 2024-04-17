import 'package:hive/hive.dart';

import 'common.dart';

part 'hive.g.dart';

@HiveType(typeId: 0)
class HiveTodo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String desc;

  @HiveField(3)
  String status;

  @HiveField(4)
  String priority;

  @HiveField(5)
  DateTime createAt;

  @HiveField(6)
  DateTime updateAt;

  HiveTodo(this.id, this.title, this.desc, this.status, this.priority,
      this.createAt, this.updateAt);
}

extension on HiveTodo {
  Todo map2Todo() {
    var todo = Todo(id, title);
    todo.desc = this.desc;
    todo.status = status.toStatus();
    todo.priority = priority.toPriority();
    todo.createAt = createAt;
    todo.updateAt = updateAt;
    return todo;
  }
}
