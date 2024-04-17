// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// CliGenerator
// **************************************************************************

T _$enumValueHelper<T>(Map<T, String> enumValues, String source) =>
    enumValues.entries
        .singleWhere(
          (e) => e.value == source,
          orElse: () => throw ArgumentError(
            '`$source` is not one of the supported values: '
            '${enumValues.values.join(', ')}',
          ),
        )
        .key;

Options _$parseOptionsResult(ArgResults result) => Options(
      result['help'] as bool,
      result['add'] as String,
      result['list'] as String,
      result['remove'] as String,
      result['edit'] as String,
      result['verbose'] as bool,
      _$enumValueHelper(
        _$PriorityEnumMapBuildCli,
        result['priority'] as String,
      ),
    );

const _$PriorityEnumMapBuildCli = <Priority, String>{
  Priority.high: 'high',
  Priority.medium: 'medium',
  Priority.low: 'low'
};

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addFlag(
    'help',
    abbr: 'h',
    help: 'Prints usage information.',
    negatable: false,
  )
  ..addOption(
    'add',
  )
  ..addOption(
    'list',
  )
  ..addOption(
    'remove',
  )
  ..addOption(
    'edit',
  )
  ..addFlag(
    'verbose',
  )
  ..addOption(
    'priority',
    abbr: 'l',
    defaultsTo: 'medium',
    allowed: ['high', 'medium', 'low'],
  );

final _$parserForOptions = _$populateOptionsParser(ArgParser());

Options parseOptions(List<String> args) {
  final result = _$parserForOptions.parse(args);
  return _$parseOptionsResult(result);
}
