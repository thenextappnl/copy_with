import 'package:analyzer/dart/element/type.dart';

class TypeChecker {
  DartType _type;

  TypeChecker(DartType type) {
    this._type = type;
  }

  bool get isDartCoreInt {
    return this._type.isDartCoreInt;
  }

  bool get isDartCoreDouble {
    return this._type.isDartCoreDouble;
  }

  bool get isDartCoreBool {
    return this._type.isDartCoreBool;
  }

  bool get isDartCoreString {
    return this._type.isDartCoreString;
  }

  bool get isDartCoreList {
    if (this._type.element == null) {
      return false;
    }
    return this._type.element.name == 'List' &&
        this._type.element.library.isDartCore;
  }

  bool get isDartDateTime {
    if (this._type.element == null) {
      return false;
    }
    return this._type.element.name == 'DateTime';
  }

  bool get isJsonSerializable {
    return !this._type.isDartCoreInt &&
        !this._type.isDartCoreDouble &&
        !this._type.isDartCoreBool &&
        !this._type.isDartCoreList;
  }
}
