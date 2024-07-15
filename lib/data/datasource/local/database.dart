import 'dart:async';

import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/pdf_dao.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Pdf])
abstract class AppDatabase extends FloorDatabase {
  PdfDao get pdfDao;
}
