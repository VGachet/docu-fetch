import 'package:docu_fetch/domain/model/repository.dart';
import 'package:floor/floor.dart';

@dao
abstract class RepositoryDao {
  @Query('SELECT * FROM Repository')
  Future<List<Repository>> findAll();

  @Query('SELECT * FROM Repository WHERE id = :id')
  Future<Repository?> findPdfById(int id);

  @insert
  Future<int> insertRepository(Repository repository);

  @delete
  Future<int> deleteRepository(Repository repository);
}
