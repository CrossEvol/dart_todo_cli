import 'dart:async';

import 'package:args/command_runner.dart';

void main(List<String> arguments) async {
  final runner = CommandRunner<String>('todo', 'Todo Cli')
    ..addCommand(AddCommand())
    ..addCommand(ListCommand())
    ..addCommand(RemoveCommand())
    ..addCommand(EditCommand())
    ..addCommand(ResetCommand());
  runner.argParser
      .addOption('sub_command', help: 'The subCommand will be invoked.');
  final output = await runner.run(arguments);
  print(output);
}

class AddCommand extends Command<String> {
  @override
  String get name => 'add';

  @override
  String get description => 'Add a todo item.';

  @override
  FutureOr<String>? run() {
    return description;
  }

  AddCommand();
}

class ListCommand extends Command<String> {
  @override
  String get name => 'list';

  @override
  String get description =>
      'List all todo items, sort by priority then updateTime then createTime.';

  @override
  FutureOr<String>? run() {
    return description;
  }
}

class RemoveCommand extends Command<String> {
  @override
  String get name => 'remove';

  @override
  String get description => 'Remove a todo item.';

  @override
  FutureOr<String>? run() {
    return description;
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
  @override
  String get name => 'reset';

  @override
  String get description => 'Reset to empty store.';

  @override
  FutureOr<String>? run() {
    return description;
  }
}
