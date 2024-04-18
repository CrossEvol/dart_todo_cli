import 'package:dart_todo_cli/src/common.dart';
import 'package:test/test.dart';

void main() {
  group('Todo', () {
    test('toJson converts Todo to a JSON Map', () {
      // Create a sample Todo object
      final todo = Todo('1', 'Buy groceries');
      todo.desc = 'Milk, eggs, bread';
      todo.status = Status.completed;
      todo.priority = Priority.high;

      // Convert the Todo to a JSON Map
      final json = todo.toJson();

      // Assert that the JSON Map contains the expected data
      expect(json, {
        'id': '1',
        'title': 'Buy groceries',
        'desc': 'Milk, eggs, bread',
        'status': 'completed',
        'priority': 'high',
        'createAt': isA<String>(), // Datetime gets serialized to string
        'updateAt': isA<String>(),
      });
    });

    test('fromJson converts a JSON Map to a Todo object', () {
      // Define some sample JSON data
      final json = {
        'id': '2',
        'title': 'Finish homework',
        'desc': '...', // Optional field can be null
        'status': 'pending',
        'priority': 'low',
        'createAt': '2024-04-18T00:00:00.000Z', // Example datetime string
        'updateAt': '2024-04-18T00:00:00.000Z',
      };

      // Convert the JSON Map to a Todo object
      final todo = Todo.fromJson(json);

      // Assert that the Todo object has the expected values
      expect(todo.id, '2');
      expect(todo.title, 'Finish homework');
      expect(todo.desc, '...');
      expect(todo.status, Status.pending);
      expect(todo.priority, Priority.low);
      expect(todo.createAt, DateTime.parse(json['createAt']!));
      expect(todo.updateAt, DateTime.parse(json['updateAt']!));
    });
  });
}
