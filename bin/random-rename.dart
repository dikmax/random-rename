#!/usr/bin/env dart

import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

class Renamer {
  String folder;

  Renamer(this.folder);

  void process() {
    Directory dir = new Directory(folder);
    List<FileSystemEntity> entities = dir.listSync();
    entities = new List.from(entities.where((entity) => entity is File));
    entities.shuffle();
    RegExp pattern = new RegExp(r'^\d+-(.*)$');
    for (int i = 0; i < entities.length; ++i) {
      FileSystemEntity entity = entities[i];
      String filename = path.basename(entity.path);
      Match match = pattern.firstMatch(filename);
      var newName = (i + 1).toString().padLeft(5, '0') + '-';
      if (match != null) {
        newName += match.group(1);
      } else {
        newName += filename;
      }
      if (filename != newName) {
        entity.renameSync(path.join(folder, newName));
      }
    }
  }
}

void main(List<String> args) {
  final parser = new ArgParser()
    ..addOption("folder", abbr: 'f');

  ArgResults argResults = parser.parse(args);

  Renamer renamer = new Renamer(argResults['folder']);
  renamer.process();
}
