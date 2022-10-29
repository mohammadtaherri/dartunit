
import 'dart:mirrors';
import 'annotations.dart';
import 'test_config.dart';

extension SymbolEx on Symbol{
  String extractName(){
    String str = toString();
    return str.substring(str.indexOf('"')+1, str.lastIndexOf('"'));
  }
}

extension LibraryMirrorEx on LibraryMirror {
  List<ClassMirror> get rootTestCases {
    List<ClassMirror> classes = List.empty(growable: true);

    for (final declaration in declarations.values)
      if (declaration.isRootTestCaseClass)
        classes.add(declaration as ClassMirror);

    return classes;
  }

  List<ClassMirror> get subTestCases {
    List<ClassMirror> classes = List.empty(growable: true);

    for (final declaration in declarations.values)
      if (declaration.isSubTestCaseClass)
        classes.add(declaration as ClassMirror);

    classes.sort((a, b){
      if(a.location!.sourceUri != b.location!.sourceUri)
        return -1;

      return a.location!.line.compareTo(b.location!.line);
    });

    return classes;
  }
}

extension DeclarationMirrorEX on DeclarationMirror{

  bool get isRootTestCaseClass =>
      isClass && 
      hasTestCaseAnnotation && 
      hasRootAnnotation;

  bool get isSubTestCaseClass => 
      isClass &&
      hasTestCaseAnnotation &&
      !hasRootAnnotation;

  bool get isTestMethod => 
      isInstanceMethod &&
      hasTestAnnotation &&
      !hasSetUpAnnotation &&
      !hasTearDownAnnotation &&
      !hasRootAnnotation &&
      !hasTestCaseAnnotation;

  bool get isSetUpMethod => 
      isInstanceMethod &&
      hasSetUpAnnotation &&
      !hasTestAnnotation &&
      !hasTearDownAnnotation &&
      !hasRootAnnotation &&
      !hasTestCaseAnnotation;

  bool get isTearDownMethod =>
      isInstanceMethod &&
      hasTearDownAnnotation &&
      !hasTestAnnotation &&
      !hasSetUpAnnotation &&
      !hasRootAnnotation &&
      !hasTestCaseAnnotation;

  bool get isSetUpAllMethod =>
      isStaticMethod &&
      hasSetUpAllAnnotation &&
      !hasTearDownAllAnnotation;

  bool get isTearDownAllMethod => 
      isStaticMethod &&
      hasTearDownAllAnnotation &&
      !hasSetUpAllAnnotation;

  bool get hasAnnotation => metadata.isNotEmpty;
  bool get isClass => this is ClassMirror;
  bool get isMethod => this is MethodMirror;
  bool get isInstanceMethod => !isStaticMethod;
  bool get isStaticMethod => isMethod && (this as MethodMirror).isStatic;

  bool get hasRootAnnotation => _hasAnnotationOfType<Root>();
  bool get hasTestCaseAnnotation => _hasAnnotationOfType<TestCase>();
  bool get hasTestAnnotation => _hasAnnotationOfType<Test>();
  bool get hasSetUpAnnotation => _hasAnnotationOfType<SetUp>();
  bool get hasTearDownAnnotation => _hasAnnotationOfType<TearDown>();
  bool get hasSetUpAllAnnotation => _hasAnnotationOfType<SetUpAll>();
  bool get hasTearDownAllAnnotation => _hasAnnotationOfType<TearDownAll>();

  bool _hasAnnotationOfType<T>(){
    for(final annotation in metadata)
      if(annotation.type.reflectedType == T)
        return true;

    return false;
  }

  TestConfig? extractTestConfigIfPossible(){
    if(!hasTestAnnotation && !hasTestCaseAnnotation)
      return null;
    
    InstanceMirror instance = _getTestConfigSurroundedAnnotation()!;

    String getDescription() {
      dynamic description = instance.getFieldByName('description');
      return description == null || description.trim().isEmpty
          ? simpleName.extractName()
          : description;
    }

    return TestConfig(
      description: getDescription(),
      skip: instance.getFieldByName('skip'),
      retry: instance.getFieldByName('retry'),
      testOn: instance.getFieldByName('testOn'),
      onPlatform: instance.getFieldByName('onPlatform'),
    );
  }

  InstanceMirror? _getTestConfigSurroundedAnnotation() {
    if (!isMethod && !isClass) 
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
      if(declaration.isTestMethod)
        methods.add(declaration as MethodMirror);

    return methods;
  }

  MethodMirror? get setUp {
    for (final declaration in declarations.values)
      if(declaration.isSetUpMethod)
        return declaration as MethodMirror;

    return null;
  }

  MethodMirror? get tearDown {
    for (final declaration in declarations.values)
      if(declaration.isTearDownMethod)
        return declaration as MethodMirror;

    return null;
  }

  MethodMirror? get setUpAll {
    for (final declaration in declarations.values)
      if(declaration.isSetUpAllMethod)
        return declaration as MethodMirror;

    return null;
  }

  MethodMirror? get tearDownAll {
    for (final declaration in declarations.values)
      if(declaration.isTearDownAllMethod)
        return declaration as MethodMirror;

    return null;
  }

  bool isSubTypeOf(ClassMirror parent){
    if(!isClass)
      return false;

    return superclass?.reflectedType == parent.reflectedType;
  }
}

extension ClassMirrorListEx on List<ClassMirror> {
  List<ClassMirror> of(ClassMirror parent) {
    List<ClassMirror> classes = List.empty(growable: true);

    for (final classMirror in this)
      if (classMirror.isSubTypeOf(parent)) classes.add(classMirror);

    return classes;
  }
}


extension InstanceMirrorEX on InstanceMirror {
  dynamic getFieldByName(String name) {
    return getField(Symbol(name)).reflectee;
  }
}
