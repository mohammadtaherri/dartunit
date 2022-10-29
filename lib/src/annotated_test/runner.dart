

import 'dart:io';
import 'dart:mirrors';

import './factory/facroty.dart';

void runTestsByLibraryName(String name){
  _runTests(_findLibraryByName(name));
}

Future<void> runTestsByLibraryPath({required String path}) async{
  _runTests(await _findLibraryByPath(path));
}

Future<void> _runTests(LibraryMirror library) async {
  TestSuiteFactoryForLibrary(libraryMirror: library)
      .createSuite()
      .call();
}

LibraryMirror _findLibraryByName(String name){
  return currentMirrorSystem().findLibrary(Symbol(name));
}

Future<LibraryMirror> _findLibraryByPath(String path) async{
  return await currentMirrorSystem().isolate.loadUri(_createUri(path));
}

Uri _createUri(String libraryPath) {
  final String sep = Platform.isWindows ? '\\' : '/';
  final String cwd = Directory.current.path;
  final String testPath = '${sep}test$sep';

  return Uri.file('$cwd$testPath$libraryPath', windows: Platform.isWindows);
}

