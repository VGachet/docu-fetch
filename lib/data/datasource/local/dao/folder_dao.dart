import 'package:docu_fetch/domain/model/folder.dart';
import 'package:floor/floor.dart';

@dao
abstract class FolderDao {
  @Query('SELECT * FROM Folder')
  Future<List<Folder>> findAll();

  @Query('SELECT * FROM Folder WHERE id = :id')
  Future<Folder?> findFolderById(int id);

  @insert
  Future<int> insertFolder(Folder folder);

  @delete
  Future<int> deleteFolder(Folder folder);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateFolder(Folder folder);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateFolderList(List<Folder> folderList);
}
