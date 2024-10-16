import 'package:docu_fetch/domain/model/pdf.dart';
import 'package:floor/floor.dart';

@dao
abstract class PdfDao {
  @Query('SELECT * FROM Pdf')
  Future<List<Pdf>> findAll();

  @Query('SELECT * FROM Pdf WHERE id = :id')
  Future<Pdf?> findPdfById(int id);

  @Query('SELECT * FROM Pdf WHERE folderId = :folderId')
  Future<List<Pdf>> findPdfListByFolderId(int folderId);

  @Query('SELECT * FROM Pdf WHERE folderId IS NULL')
  Future<List<Pdf>> findRootPdfList();

  @insert
  Future<int> insertPdf(Pdf pdf);

  @delete
  Future<int> deletePdf(Pdf pdf);

  @Query('UPDATE Pdf SET lastPageOpened = :lastPage WHERE id = :id')
  Future<void> updateLastPageOpened(int lastPage, int id);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updatePdf(Pdf pdf);
}
