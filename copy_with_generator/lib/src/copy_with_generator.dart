import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:copy_with_annotation/copy_with_annotation.dart';
import 'package:source_gen/source_gen.dart'
    show GeneratorForAnnotation, ConstantReader;

import 'type_checker.dart';

class CopyWithGenerator extends GeneratorForAnnotation<CopyWith> {
  @override
  FutureOr<String> generateForAnnotatedElement(Element element,
      ConstantReader annotation,
      BuildStep buildStep,) {
    final visitor = _ModelVisitor();
    element.visitChildren(visitor);

    final className = visitor.className;
    final hasJsonSerializable = _hasJsonSerializableAnnotation(element);

    final buffer = StringBuffer();

    buffer.writeln(
      '$className _\$${className}CopyWith($className instance,  Map<String, dynamic> overrides) {',
    );
    buffer.writeln(
      '  Map<String, dynamic> original = _\$${className}ToJson(instance);',
    );

    buffer.writeln('  Map<String, dynamic> copy = <String, dynamic> {');
    for (var key in visitor.fields.keys) {
      final fieldType = visitor.fields[key];
      final converterString = _getConverterString(
        fieldType,
        hasJsonSerializable,
      );

      String expression =
          'overrides.containsKey("$key") ? overrides["$key"]${converterString} : original["$key"]';
      buffer.writeln('  "$key": $expression,');
    }

    buffer.writeln('  };');
    buffer.writeln('  return _\$${className}FromJson(copy);');
    buffer.writeln('}');

    return buffer.toString();
  }

  _getConverterString(DartType fieldType, bool hasJsonSerializable) {
    final typeChecker = TypeChecker(fieldType);

    if (typeChecker.isDartDateTime) {
      return '?.toIso8601String()';
    }

    if (hasJsonSerializable && !typeChecker.isDartCoreList) {
      return '?.toJson()';
    }

    if (hasJsonSerializable && typeChecker.isDartCoreList) {
      return '?.map((e) => e?.toJson())?.toList()';
    }

    return '';
  }

  _hasJsonSerializableAnnotation(ClassElement element) {
    ElementAnnotation result = element.metadata.firstWhere((annotation) {
      return annotation.element is ConstructorElement &&
          annotation
              .computeConstantValue()
              .type
              .name == 'JsonSerializable';
    }, orElse: () => null);

    return result != null;
  }
}

class _ModelVisitor extends SimpleElementVisitor {
  DartType className;
  Map<String, DartType> fields = {};

  @override
  visitConstructorElement(ConstructorElement element) {
    className = element.type.returnType;
    return super.visitConstructorElement(element);
  }

  @override
  visitFieldElement(FieldElement element) {
    fields[element.name] = element.type;
    return super.visitFieldElement(element);
  }
}
