
import 'dart:mirrors';
import 'annotations.dart';
import './test_config.dart';

extension SymbolEx on Symbol{
  String extractName(){
    String str = toString();
    return str.substring(str.indexOf('"')+1, str.lastIndexOf('"'));
  }
}

extension LibraryMirrorEx on LibraryMirror {

  List<ClassMirror> get rootTestCases {
    List<ClassMirror> classes = List.empty(growable: true);

    for(final declaration in declarations.values)
      if(declaration.isClassMirror)
        if (declaration.hasRootAnnotation)
          classes.add(declaration as ClassMirror);

    return classes;
  }

  List<ClassMirror> get allSubTestCases {
    List<ClassMirror> classes = List.empty(growable: true);

    for(final declaration in declarations.values)
      if(declaration.isClassMirror)
        if (!declaration.hasRootAnnotation)
          classes.add(declaration as ClassMirror);

    return classes;
  } 
}

extension DeclarationMirrorEX on DeclarationMirror{

  bool get hasAnnotation => metadata.isNotEmpty;
  bool get isClassMirror => this is ClassMirror;
  bool get isMethodMirror => this is MethodMirror;

  bool get hasRootAnnotation => _hasAnnotationOfType<Root>();
  bool get hasTestCaseAnnotation => _hasAnnotationOfType<TestCase>();
  bool get hasTestAnnotation => _hasAnnotationOfType<Test>();
  bool get hasSetUpAnnotation => _hasAnnotationOfType<SetUp>();
  bool get hasTearDownAnnotation => _hasAnnotationOfType<TearDown>();

  bool _hasAnnotationOfType<T>(){
    if(!isMethodMirror && !isClassMirror)
      return false;

    if(!hasAnnotation)
      return false;

    for(final annotation in metadata)
      if(annotation.type.reflectedType == T)
        return true;

    return false;
  }

  TestConfig? extractTestConfigIfPossible(){
    if(!hasTestAnnotation && !hasTestCaseAnnotation)
      return null;
    
    InstanceMirror annotation = _getTestConfigSurroundedAnnotation()!;

    return TestConfig(
      description: annotation.getFieldByName('description') ?? simpleName.extractName(),
      skip: annotation.getFieldByName('skip'),
      retry: annotation.getFieldByName('retry'),
      testOn: annotation.getFieldByName('testOn'),
      onPlatform: annotation.getFieldByName('onPlatform'),
    );
  }

  InstanceMirror? _getTestConfigSurroundedAnnotation() {
    if (!isMethodMirror && !isClassMirror) 
      return null;

    if (!hasAnnotation) 
      return null;

    for (final a in metadata)
      if (a.type.reflectedType == TestCase || a.type.reflectedType == Test) 
          return a;

    return null;
  }

}

extension ClassMirrorEX on ClassMirror {

  List<MethodMirror> get tests {
    List<MethodMirror> methods = List.empty(growable: true);

    for (final declaration in declarations.values)
      if(declaration.isMethodMirror)
        if (declaration.hasTestAnnotation)
          methods.add(declaration as MethodMirror);

    return methods;
  }

  MethodMirror? get setUp {
    for (final declaration in declarations.values)
      if(declaration.isMethodMirror)
        if (declaration.hasSetUpAnnotation) 
          return declaration as MethodMirror;

    return null;
  }

  MethodMirror? get tearDown {
    for (final declaration in declarations.values)
      if(declaration.isMethodMirror)
        if (declaration.hasTearDownAnnotation) 
          return declaration as MethodMirror;

    return null;
  }

  bool isSubTypeOf(ClassMirror parent){
    if(!isClassMirror)
      return false;

    return superclass?.reflectedType == parent.reflectedType;
  }
  
}

extension ClassMirrorListEx on List<ClassMirror>{

  List<ClassMirror> of(ClassMirror parent) {
    List<ClassMirror> classes = List.empty(growable: true);

    for(final classMirror in this)
      if(classMirror.isSubTypeOf(parent))
        classes.add(classMirror);

    return classes;
  }
}


extension InstanceMirrorEX on InstanceMirror{

  dynamic getFieldByName(String name){
    return getField(Symbol(name)).reflectee;
  }
}
