// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PdfDao? _pdfDaoInstance;

  RepositoryDao? _repositoryDaoInstance;

  FolderDao? _folderDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Pdf` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `renamedTitle` TEXT, `path` TEXT, `url` TEXT, `version` REAL, `description` TEXT, `lastPageOpened` INTEGER NOT NULL, `folderId` INTEGER, `order` INTEGER NOT NULL, `isHorizontal` INTEGER NOT NULL, `isContinuous` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Repository` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `url` TEXT NOT NULL, `name` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Folder` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `parentFolder` INTEGER, `order` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PdfDao get pdfDao {
    return _pdfDaoInstance ??= _$PdfDao(database, changeListener);
  }

  @override
  RepositoryDao get repositoryDao {
    return _repositoryDaoInstance ??= _$RepositoryDao(database, changeListener);
  }

  @override
  FolderDao get folderDao {
    return _folderDaoInstance ??= _$FolderDao(database, changeListener);
  }
}

class _$PdfDao extends PdfDao {
  _$PdfDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _pdfInsertionAdapter = InsertionAdapter(
            database,
            'Pdf',
            (Pdf item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'renamedTitle': item.renamedTitle,
                  'path': item.path,
                  'url': item.url,
                  'version': item.version,
                  'description': item.description,
                  'lastPageOpened': item.lastPageOpened,
                  'folderId': item.folderId,
                  'order': item.order,
                  'isHorizontal': item.isHorizontal ? 1 : 0,
                  'isContinuous': item.isContinuous ? 1 : 0
                }),
        _pdfUpdateAdapter = UpdateAdapter(
            database,
            'Pdf',
            ['id'],
            (Pdf item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'renamedTitle': item.renamedTitle,
                  'path': item.path,
                  'url': item.url,
                  'version': item.version,
                  'description': item.description,
                  'lastPageOpened': item.lastPageOpened,
                  'folderId': item.folderId,
                  'order': item.order,
                  'isHorizontal': item.isHorizontal ? 1 : 0,
                  'isContinuous': item.isContinuous ? 1 : 0
                }),
        _pdfDeletionAdapter = DeletionAdapter(
            database,
            'Pdf',
            ['id'],
            (Pdf item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'renamedTitle': item.renamedTitle,
                  'path': item.path,
                  'url': item.url,
                  'version': item.version,
                  'description': item.description,
                  'lastPageOpened': item.lastPageOpened,
                  'folderId': item.folderId,
                  'order': item.order,
                  'isHorizontal': item.isHorizontal ? 1 : 0,
                  'isContinuous': item.isContinuous ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Pdf> _pdfInsertionAdapter;

  final UpdateAdapter<Pdf> _pdfUpdateAdapter;

  final DeletionAdapter<Pdf> _pdfDeletionAdapter;

  @override
  Future<List<Pdf>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM Pdf',
        mapper: (Map<String, Object?> row) => Pdf(
            id: row['id'] as int?,
            title: row['title'] as String,
            renamedTitle: row['renamedTitle'] as String?,
            path: row['path'] as String?,
            url: row['url'] as String?,
            version: row['version'] as double?,
            description: row['description'] as String?,
            lastPageOpened: row['lastPageOpened'] as int,
            folderId: row['folderId'] as int?,
            order: row['order'] as int,
            isHorizontal: (row['isHorizontal'] as int) != 0,
            isContinuous: (row['isContinuous'] as int) != 0));
  }

  @override
  Future<Pdf?> findPdfById(int id) async {
    return _queryAdapter.query('SELECT * FROM Pdf WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Pdf(
            id: row['id'] as int?,
            title: row['title'] as String,
            renamedTitle: row['renamedTitle'] as String?,
            path: row['path'] as String?,
            url: row['url'] as String?,
            version: row['version'] as double?,
            description: row['description'] as String?,
            lastPageOpened: row['lastPageOpened'] as int,
            folderId: row['folderId'] as int?,
            order: row['order'] as int,
            isHorizontal: (row['isHorizontal'] as int) != 0,
            isContinuous: (row['isContinuous'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<List<Pdf>> findPdfListByFolderId(int folderId) async {
    return _queryAdapter.queryList('SELECT * FROM Pdf WHERE folderId = ?1',
        mapper: (Map<String, Object?> row) => Pdf(
            id: row['id'] as int?,
            title: row['title'] as String,
            renamedTitle: row['renamedTitle'] as String?,
            path: row['path'] as String?,
            url: row['url'] as String?,
            version: row['version'] as double?,
            description: row['description'] as String?,
            lastPageOpened: row['lastPageOpened'] as int,
            folderId: row['folderId'] as int?,
            order: row['order'] as int,
            isHorizontal: (row['isHorizontal'] as int) != 0,
            isContinuous: (row['isContinuous'] as int) != 0),
        arguments: [folderId]);
  }

  @override
  Future<List<Pdf>> findRootPdfList() async {
    return _queryAdapter.queryList('SELECT * FROM Pdf WHERE folderId IS NULL',
        mapper: (Map<String, Object?> row) => Pdf(
            id: row['id'] as int?,
            title: row['title'] as String,
            renamedTitle: row['renamedTitle'] as String?,
            path: row['path'] as String?,
            url: row['url'] as String?,
            version: row['version'] as double?,
            description: row['description'] as String?,
            lastPageOpened: row['lastPageOpened'] as int,
            folderId: row['folderId'] as int?,
            order: row['order'] as int,
            isHorizontal: (row['isHorizontal'] as int) != 0,
            isContinuous: (row['isContinuous'] as int) != 0));
  }

  @override
  Future<void> updateLastPageOpened(
    int lastPage,
    int id,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Pdf SET lastPageOpened = ?1 WHERE id = ?2',
        arguments: [lastPage, id]);
  }

  @override
  Future<void> setNullFolderId(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Pdf SET folderId = NULL WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<int> insertPdf(Pdf pdf) {
    return _pdfInsertionAdapter.insertAndReturnId(
        pdf, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePdf(Pdf pdf) async {
    await _pdfUpdateAdapter.update(pdf, OnConflictStrategy.replace);
  }

  @override
  Future<int> deletePdf(Pdf pdf) {
    return _pdfDeletionAdapter.deleteAndReturnChangedRows(pdf);
  }
}

class _$RepositoryDao extends RepositoryDao {
  _$RepositoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _repositoryInsertionAdapter = InsertionAdapter(
            database,
            'Repository',
            (Repository item) => <String, Object?>{
                  'id': item.id,
                  'url': item.url,
                  'name': item.name
                }),
        _repositoryDeletionAdapter = DeletionAdapter(
            database,
            'Repository',
            ['id'],
            (Repository item) => <String, Object?>{
                  'id': item.id,
                  'url': item.url,
                  'name': item.name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Repository> _repositoryInsertionAdapter;

  final DeletionAdapter<Repository> _repositoryDeletionAdapter;

  @override
  Future<List<Repository>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM Repository',
        mapper: (Map<String, Object?> row) => Repository(
            url: row['url'] as String,
            id: row['id'] as int?,
            name: row['name'] as String));
  }

  @override
  Future<Repository?> findPdfById(int id) async {
    return _queryAdapter.query('SELECT * FROM Repository WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Repository(
            url: row['url'] as String,
            id: row['id'] as int?,
            name: row['name'] as String),
        arguments: [id]);
  }

  @override
  Future<int> insertRepository(Repository repository) {
    return _repositoryInsertionAdapter.insertAndReturnId(
        repository, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteRepository(Repository repository) {
    return _repositoryDeletionAdapter.deleteAndReturnChangedRows(repository);
  }
}

class _$FolderDao extends FolderDao {
  _$FolderDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _folderInsertionAdapter = InsertionAdapter(
            database,
            'Folder',
            (Folder item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'parentFolder': item.parentFolder,
                  'order': item.order
                }),
        _folderUpdateAdapter = UpdateAdapter(
            database,
            'Folder',
            ['id'],
            (Folder item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'parentFolder': item.parentFolder,
                  'order': item.order
                }),
        _folderDeletionAdapter = DeletionAdapter(
            database,
            'Folder',
            ['id'],
            (Folder item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'parentFolder': item.parentFolder,
                  'order': item.order
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Folder> _folderInsertionAdapter;

  final UpdateAdapter<Folder> _folderUpdateAdapter;

  final DeletionAdapter<Folder> _folderDeletionAdapter;

  @override
  Future<List<Folder>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM Folder',
        mapper: (Map<String, Object?> row) => Folder(
            title: row['title'] as String,
            order: row['order'] as int,
            id: row['id'] as int?,
            parentFolder: row['parentFolder'] as int?));
  }

  @override
  Future<Folder?> findFolderById(int id) async {
    return _queryAdapter.query('SELECT * FROM Folder WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Folder(
            title: row['title'] as String,
            order: row['order'] as int,
            id: row['id'] as int?,
            parentFolder: row['parentFolder'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<Folder>> findFolderListByParentId(int parentId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Folder WHERE parentFolder = ?1',
        mapper: (Map<String, Object?> row) => Folder(
            title: row['title'] as String,
            order: row['order'] as int,
            id: row['id'] as int?,
            parentFolder: row['parentFolder'] as int?),
        arguments: [parentId]);
  }

  @override
  Future<List<Folder>> findRootFolderList() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Folder WHERE parentFolder IS NULL',
        mapper: (Map<String, Object?> row) => Folder(
            title: row['title'] as String,
            order: row['order'] as int,
            id: row['id'] as int?,
            parentFolder: row['parentFolder'] as int?));
  }

  @override
  Future<void> setNullParentFolder(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Folder SET parentFolder = NULL WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<int> insertFolder(Folder folder) {
    return _folderInsertionAdapter.insertAndReturnId(
        folder, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateFolder(Folder folder) async {
    await _folderUpdateAdapter.update(folder, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateFolderList(List<Folder> folderList) async {
    await _folderUpdateAdapter.updateList(
        folderList, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteFolder(Folder folder) {
    return _folderDeletionAdapter.deleteAndReturnChangedRows(folder);
  }
}
