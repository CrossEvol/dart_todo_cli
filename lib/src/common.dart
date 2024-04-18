import 'package:enum_to_string/enum_to_string.dart';
import 'package:json_annotation/json_annotation.dart';
import 'hive.dart';

part 'common.g.dart';

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

@JsonSerializable()
class Todo {
  String id = '';
  String title = '';
  String desc = '';
  Status status = Status.pending;
  Priority priority = Priority.medium;
  DateTime createAt = DateTime.now();
  DateTime updateAt = DateTime.now();

  Todo(this.id, this.title);

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}

extension TodoExtension on Todo {
  HiveTodo map2HiveTodo() {
    return HiveTodo(
        id, title, desc, status.name, priority.name, createAt, updateAt);
  }
}
