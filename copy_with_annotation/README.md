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

  Person({
    this.firstName,
    this.lastName,
    this.dateOfBirth,
  });
}
```

Building creates the corresponding part person.g.dart:

```dart
part of 'person.dart';

extension $PersonCopyWith on Person {
  Person copyWith({
    String firstName,
    String lastName,
    DateTime dateOfBirth,
  }) {
    return Person(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}
```

## Features and bugs
Please file feature requests and bugs at the Github Issue Tracker.

Github Issue tracker: https://github.com/thenextappnl/copy_with/issues

## Author
This CopyWith package is developed by [The Next App](https://www.thenextapp.nl). You can contact us at <info@thenextapp.nl>