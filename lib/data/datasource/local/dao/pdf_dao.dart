import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:floor/floor.dart';

@dao
abstract class PdfDao {
  @Query('SELECT * FROM Pdf')
  Future<List<Pdf>> findAll();

  @Query('SELECT * FROM Pdf WHERE id = :id')
  Stream<Pdf?> findPdfById(int id);

  @insert
  Future<void> insertPdf(Pdf pdf);

  @delete
  Future<void> deletePdf(Pdf pdf);

  @Query('UPDATE Pdf SET lastPageOpened = :lastPage WHERE id = :id')
  Future<void> updateLastPageOpened(int lastPage, String id);
}
