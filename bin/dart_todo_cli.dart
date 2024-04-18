import 'dart:async';
import 'dart:io';
import 'dart:convert';

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

List<Todo> getTodosFromHive(Box box, [Status? status]) {
  var todoList = box.values
      .map((e) => e as HiveTodo)
      .toList()
      .map((e) => e.map2Todo())
      .toList();
  if (status != null) {
    todoList = todoList.where((element) => element.status == status).toList();
  }
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
    ..addCommand(EditCommand(box))
    ..addCommand(ResetCommand(box))
    ..addCommand(ShowCommand(box));
  runner.argParser
      .addOption('sub_command', help: 'The subCommand will be invoked.');
  final output = await runner.run(arguments);
  print(output);
}

class ShowCommand extends Command<String> {
  late Box box;

  @override
  String get name => 'show';

  @override
  String get description => 'Show a todo item';

  @override
  FutureOr<String> run() {
    var index = int.parse(argResults?['index'] ?? '-1');
    if (index == -1) {
      print('Did not assign index, default first.');
    }
    if (box.isEmpty) {
      return 'TodoList is Empty, can not find anyone to show.';
    }
    var isJson = argResults?['json'];

    List<Todo> todoList = getTodosFromHive(box);
    todoList.sort((t1, t2) => compareTodoByPriorityThenTime(t1, t2));
    var showTodo = todoList[index];

    if (isJson) {
      final jsonString = JsonEncoder.withIndent('  ').convert(showTodo);
      print(jsonString);
      return '';
    } else {
      print('ID              ${showTodo.id}');
      print('Title           ${showTodo.title}');
      print('Desc            ${showTodo.desc}');
      print('Status          ${showTodo.status.name}');
      print('Priority        ${showTodo.priority.name}');
      print('CreateAt        ${showTodo.createAt}');
      print('UpdateAt        ${showTodo.updateAt}');
      return '';
    }
  }

  ShowCommand(this.box) {
    argParser.addOption('index',
        abbr: 'i', help: 'Index of the Todo to be edited.');
    argParser.addFlag('json',
        defaultsTo: false, help: 'Show todo in pretty Json');
    argParser.addFlag('text',
        defaultsTo: false, help: 'Show todo in text format');
  }
}

class AddCommand extends Command<String> {
  late Box box;

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
    argParser.addOption('title', abbr: 't', help: 'Title of the Todo');
    argParser.addOption('priority',
        abbr: 'p',
        help:
            'Priority of the Todo, only permits [${Priority.values.map((e) => e.name).join(', ')}]');
    argParser.addOption('desc', abbr: 'd', help: 'Title of the Todo');
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
    final status = argResults?['status'] as String;
    if (status.isNotEmpty &&
        !Status.values.map((e) => e.name).contains(status)) {
      return 'Status only permits [${Status.values.map((e) => e.name).join(', ')}].';
    }
    List<Todo> todoList =
        getTodosFromHive(box, status.isNotEmpty ? status.toStatus() : null);
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
    argParser.addOption('status',
        defaultsTo: '',
        abbr: 's',
        help:
            'Status only permits [${Status.values.map((e) => e.name).join(', ')}].');
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
    todoList.sort((t1, t2) => compareTodoByPriorityThenTime(t1, t2));
    var removedTodo = todoList[index];
    if (removedTodo.id.isEmpty) {
      return 'Remove todo#$index#${removedTodo.title} failed.';
    }
    box.delete(removedTodo.id);
    return 'Remove todo#$index#${removedTodo.title} success.';
  }

  RemoveCommand(this.box) {
    argParser.addOption('index',
        abbr: 'i', help: 'Index of the Todo to be deleted.');
  }
}

class EditCommand extends Command<String> {
  late Box box;

  @override
  String get name => 'edit';

  @override
  String get description => 'Edit a todo item.';

  @override
  FutureOr<String>? run() {
    return description;
  }

  EditCommand(this.box) {
    addSubcommand(EditTitleCommand(box));
    addSubcommand(EditDescCommand(box));
    addSubcommand(EditPriorityCommand(box));
  }
}

class EditTitleCommand extends Command<String> {
  late Box box;

  @override
  String get name => 'title';

  @override
  String get description => 'Edit a todo title.';

  @override
  FutureOr<String>? run() {
    var index = int.parse(argResults?['index'] ?? '-1');
    if (index == -1) {
      return 'Edit todo need assign index.';
    }
    var title = (argResults?['title'] ?? '') as String;
    if (title.isEmpty) {
      return 'Empty Title';
    }

    List<Todo> todoList = getTodosFromHive(box);
    todoList.sort((t1, t2) => compareTodoByPriorityThenTime(t1, t2));
    var editedTodo = todoList[index];
    editedTodo.title = title;
    box.put(editedTodo.id, editedTodo.map2HiveTodo());
    return 'Edit Todo#$index#$title success.';
  }

  EditTitleCommand(this.box) {
    argParser.addOption('index',
        abbr: 'i', help: 'Index of the Todo to be edited.');
    argParser.addOption('title',
        abbr: 'v', help: 'Title of the Todo will be updated to.');
  }
}

class EditDescCommand extends Command<String> {
  late Box box;

  @override
  String get name => 'desc';

  @override
  String get description => 'Edit a todo desc.';

  @override
  FutureOr<String>? run() {
    var index = int.parse(argResults?['index'] ?? '-1');
    if (index == -1) {
      return 'Edit todo need assign index.';
    }
    var desc = (argResults?['desc'] ?? '') as String;
    if (desc.isEmpty) {
      return 'Empty Desc';
    }

    List<Todo> todoList = getTodosFromHive(box);
    todoList.sort((t1, t2) => compareTodoByPriorityThenTime(t1, t2));
    var editedTodo = todoList[index];
    editedTodo.desc = desc;
    box.put(editedTodo.id, editedTodo.map2HiveTodo());
    return 'Edit Todo#$index#${desc.length > 20 ? "${desc.substring(0, 20)}..." : desc} success.';
  }

  EditDescCommand(this.box) {
    argParser.addOption('index',
        abbr: 'i', help: 'Index of the Todo to be edited.');
    argParser.addOption('desc',
        abbr: 'v', help: 'Desc of the Todo will be updated to.');
  }
}

class EditPriorityCommand extends Command<String> {
  late Box box;

  @override
  String get name => 'priority';

  @override
  String get description => 'Edit a todo priority.';

  @override
  FutureOr<String>? run() {
    var index = int.parse(argResults?['index'] ?? '-1');
    if (index == -1) {
      return 'Edit todo need assign index.';
    }
    var priority = (argResults?['priority'] ?? '') as String;
    if (priority.isEmpty) {
      return 'Empty Priority';
    }
    if (!Priority.values.map((e) => e.name).toList().contains(priority)) {
      return 'Priority value only permit [${Priority.values.map((e) => e.name).join(', ')}]';
    }

    List<Todo> todoList = getTodosFromHive(box);
    todoList.sort((t1, t2) => compareTodoByPriorityThenTime(t1, t2));
    var editedTodo = todoList[index];
    editedTodo.priority = priority.toPriority();
    box.put(editedTodo.id, editedTodo.map2HiveTodo());
    return 'Edit Todo#$index#$priority success.';
  }

  EditPriorityCommand(this.box) {
    argParser.addOption('index',
        abbr: 'i', help: 'Index of the Todo to be edited.');
    argParser.addOption('priority',
        abbr: 'v', help: 'Title of the Todo will be updated to.');
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
