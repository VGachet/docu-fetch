import 'dart:async';

import 'package:docu_fetch/data/datasource/local/dao/pdf_dao.dart';
import 'package:docu_fetch/data/datasource/local/dao/repository_dao.dart';
import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:docu_fetch/domain/model/repository.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Pdf, Repository])
abstract class AppDatabase extends FloorDatabase {
  PdfDao get pdfDao;
  RepositoryDao get repositoryDao;
}
