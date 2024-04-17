import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_todo_cli/src/common.dart';
import 'package:dart_todo_cli/src/hive.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

int compareTodoByPriorityThenTime(Todo t1, Todo t2) {
  var c1 = t1.priority.index.compareTo(t2.priority.index);
  if (c1 == 0) {
    var c2 = t1.updateAt.compareTo(t2.updateAt);
    if (c2 == 0) {
      return t1.createAt.compareTo(t2.createAt);
    } else {
      return c2;
    }
  } else {
    return t1.priority.index.compareTo(t2.priority.index);
  }
}

List<Todo> getTodosFromHive(Box box) {
  var todoList = box.values
      .map((e) => e as HiveTodo)
      .toList()
      .map((e) => e.map2Todo())
      .toList();
  return todoList;
}

void main(List<String> arguments) async {
  Hive.init(p.join(Directory.systemTemp.path, 'tmp'));
  Hive.registerAdapter(HiveTodoAdapter());

  var box = await Hive.openBox('todoBox');

  final runner = CommandRunner<String>('todo', 'Todo Cli')
    ..addCommand(AddCommand(box))
    ..addCommand(ListCommand(box))
    ..addCommand(RemoveCommand(box))
    ..addCommand(EditCommand())
    ..addCommand(ResetCommand(box));
  runner.argParser
      .addOption('sub_command', help: 'The subCommand will be invoked.');
  final output = await runner.run(arguments);
  print(output);
}

class AddCommand extends Command<String> {
  final Box box;

  @override
  String get name => 'add';

  @override
  String get description => 'Add a todo item.';

  @override
  FutureOr<String>? run() {
    var key = Uuid().v4();
    final title = argResults?['title'] ?? '';
    box.put(key, Todo(key, title).map2HiveTodo());
    return 'Add Todo#$title success.';
  }

  AddCommand(this.box) {
    argParser.addOption('title', help: 'Title of the Todo');
  }
}

class ListCommand extends Command<String> {
  late Box box;

  @override
  String get name => 'list';

  @override
  String get description =>
      'List all todo items, sort by priority then updateTime then createTime.';

  @override
  FutureOr<String>? run() {
    final verbose = argResults?['verbose'];
    List<Todo> todoList = getTodosFromHive(box);
    if (box.isEmpty) {
      return 'TodoList is Empty.';
    }
    if (verbose) {
      todoList.sort((t1, t2) => compareTodoByPriorityThenTime(t1, t2));
      int count = 0;
      print('TodoList ################################');
      for (var todo in todoList) {
        print(
            '$count ${todo.title} ${todo.priority} ${todo.status} ${todo.updateAt}');
        count++;
      }
    } else {
      todoList.sort((t1, t2) => compareTodoByPriorityThenTime(t1, t2));
      int count = 0;
      print('TodoList ################################');
      for (var todo in todoList) {
        print('$count ${todo.title}');
        count++;
      }
    }
    return '';
  }

  ListCommand(this.box) {
    argParser.addFlag('verbose',
        defaultsTo: false,
        abbr: 'v',
        help: 'List Todos in verbose formatter or not');
  }
}

class RemoveCommand extends Command<String> {
  late Box box;

  @override
  String get name => 'remove';

  @override
  String get description => 'Remove a todo item.';

  @override
  FutureOr<String>? run() {
    var index = int.parse(argResults?['index'] ?? '-1');
    index = index == -1 ? 0 : index;
    if (box.isEmpty) {
      return 'TodoList is Empty, do not need to remove anyone.';
    }
    List<Todo> todoList = getTodosFromHive(box);

    var removedTodo = todoList[index];
    if (removedTodo.id.isEmpty) {
      return 'Remove todo#$index#${removedTodo.title} failed.';
    }
    box.delete(removedTodo.id);
    return 'Remove todo#$index#${removedTodo.title} success.';
  }

  RemoveCommand(this.box) {
    argParser.addOption('index', help: 'Index of the Todo to be deleted.');
  }
}

class EditCommand extends Command<String> {
  @override
  String get name => 'edit';

  @override
  String get description => 'Edit a todo item.';

  @override
  FutureOr<String>? run() {
    return description;
  }

  EditCommand() {
    addSubcommand(EditTitleCommand());
    addSubcommand(EditDescCommand());
    addSubcommand(EditPriorityCommand());
  }
}

class EditTitleCommand extends Command<String> {
  @override
  String get name => 'edit title';

  @override
  String get description => 'Edit a todo title.';

  @override
  FutureOr<String>? run() {
    return description;
  }
}

class EditDescCommand extends Command<String> {
  @override
  String get name => 'edit desc';

  @override
  String get description => 'Edit a todo desc.';

  @override
  FutureOr<String>? run() {
    return description;
  }
}

class EditPriorityCommand extends Command<String> {
  @override
  String get name => 'edit priority';

  @override
  String get description => 'Edit a todo priority.';

  @override
  FutureOr<String>? run() {
    return description;
  }
}

class ResetCommand extends Command<String> {
  late Box box;

  @override
  String get name => 'reset';

  @override
  String get description => 'Reset to empty store.';

  @override
  FutureOr<String>? run() {
    if (box.isNotEmpty) {
      box.deleteAll(box.keys);
    }
    if (box.isEmpty) {
      return 'Reset Success.';
    }
    return 'Reset Failed.';
  }

  ResetCommand(this.box);
}
