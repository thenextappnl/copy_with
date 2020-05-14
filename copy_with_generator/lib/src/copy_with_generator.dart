import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:copy_with_annotation/copy_with_annotation.dart';
import 'package:source_gen/source_gen.dart';

class CopyWithGenerator extends GeneratorForAnnotation<CopyWith> {
  @override
  FutureOr<String> generateForAnnotatedElement(Element element,
      ConstantReader annotation,
      BuildStep buildStep,) {
    final visitor = _ModelVisitor();
    element.visitChildren(visitor);

    final className = visitor.className;
    final methodInput = [];
    final constructorInput = [];

    for (var key in visitor.fields.keys) {
      FieldElement field = visitor.fields[key];

      if (_ignoreFieldElement(field)) {
        continue;
      }

      methodInput.add(
        '    ${field.type} ${field.name},',
      );

      constructorInput.add(
        '      ${field.name}: ${field.name} ?? this.${field.name},',
      );
    }

    final buffer = StringBuffer();

    buffer.writeln(
      'extension  \$${className}CopyWith on $className {'
          '  $className copyWith({${methodInput.join("\r\n")}}) {'
          '    return $className(${constructorInput.join("\r\n")});'
          '  }'
          '}',
    );

    return buffer.toString();
  }

  bool _ignoreFieldElement(FieldElement element) {
    final copyWithFieldAnnotation = element.metadata.firstWhere((e) {
      final constantValue = e.computeConstantValue();
      return TypeChecker.fromRuntime(CopyWithField)
          .isExactlyType(constantValue.type);
    }, orElse: () => element.getter.metadata.firstWhere((e) {
      final constantValue = e.computeConstantValue();
      return TypeChecker.fromRuntime(CopyWithField)
          .isExactlyType(constantValue.type);
    }, orElse: () => null));

    if (copyWithFieldAnnotation != null) {
      final constantValue = copyWithFieldAnnotation.computeConstantValue();
      return constantValue.getField('ignore').toBoolValue();
    }

    return false;
  }
}

class _ModelVisitor extends SimpleElementVisitor {
  DartType className;
  Map<String, FieldElement> fields = {};

  @override
  Object visitConstructorElement(ConstructorElement element) {
    className = element.type.returnType;
    return super.visitConstructorElement(element);
  }

  @override
  Object visitFieldElement(FieldElement element) {
    fields[element.name] = element;
    return super.visitFieldElement(element);
  }
}
