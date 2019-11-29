# copy_with_annotation

This package generates a copyWith method using [build_runner](https://pub.dev/packages/build_runner) and [json_serializable](https://pub.dev/packages/json_serializable)


## Installation

Add dependencies in your `pubspec.yaml`:

```yaml
dependencies:
  copy_with_annotation:

dev_dependencies:
  copy_with:
  build_runner:
```

## Usage

In class you want to write toString() method:

* Annotate the class with `ToString()`
* Override the `toString` method.

```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_annotation/copy_with_annotation.dart';

part 'person.g.dart';

@CopyWith()
@JsonSerializable()
class Person {
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  Map<String, dynamic> toJson() => _$PersonToJson(this);
  Person copyWith(Map<String, dynamic> overrides) => _$PersonCopyWith(this, overrides);
}
```

Building creates the corresponding part person.g.dart:

```dart
part of 'person.dart';

Person _$PersonCopyWith(Person instance, Map<String, dynamic> overrides) {
  Map<String, dynamic> original = _$PersonToJson(instance);
  Map<String, dynamic> copy = <String, dynamic>{
    "firstName": overrides.containsKey("firstName")
        ? overrides["firstName"]?.toJson()
        : original["firstName"],
    "lastName": overrides.containsKey("lastName")
        ? overrides["lastName"]?.toJson()
        : original["lastName"],
    "dateOfBirth": overrides.containsKey("dateOfBirth")
        ? overrides["dateOfBirth"]?.toIso8601String()
        : original["dateOfBirth"],
  };
  return _$PersonFromJson(copy);
}

Person _$PersonFromJson(Map<String, dynamic> json) {
  return Person(
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    dateOfBirth: json['dateOfBirth'] == null
        ? null
        : DateTime.parse(json['dateOfBirth'] as String),
  );
}

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
    };

```

## Features and bugs
Please file feature requests and bugs at the Github Issue Tracker.

Github Issue tracker: https://github.com/thenextappnl/copy_with/issues

## Author
This CopyWith package is developed by [The Next App](https://www.thenextapp.nl). You can contact us at <info@thenextapp.nl>