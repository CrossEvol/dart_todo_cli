// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
      json['id'] as String,
      json['title'] as String,
    )
      ..desc = json['desc'] as String
      ..status = $enumDecode(_$StatusEnumMap, json['status'])
      ..priority = $enumDecode(_$PriorityEnumMap, json['priority'])
      ..createAt = DateTime.parse(json['createAt'] as String)
      ..updateAt = DateTime.parse(json['updateAt'] as String);

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'desc': instance.desc,
      'status': _$StatusEnumMap[instance.status]!,
      'priority': _$PriorityEnumMap[instance.priority]!,
      'createAt': instance.createAt.toIso8601String(),
      'updateAt': instance.updateAt.toIso8601String(),
    };

const _$StatusEnumMap = {
  Status.pending: 'pending',
  Status.completed: 'completed',
};

const _$PriorityEnumMap = {
  Priority.high: 'high',
  Priority.medium: 'medium',
  Priority.low: 'low',
};
