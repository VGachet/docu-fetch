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
            'CREATE TABLE IF NOT EXISTS `Pdf` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `path` TEXT, `url` TEXT NOT NULL, `version` REAL NOT NULL, `description` TEXT NOT NULL, `lastPageOpened` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Repository` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `url` TEXT NOT NULL, `name` TEXT)');

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
}

class _$PdfDao extends PdfDao {
  _$PdfDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _pdfInsertionAdapter = InsertionAdapter(
            database,
            'Pdf',
            (Pdf item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'path': item.path,
                  'url': item.url,
                  'version': item.version,
                  'description': item.description,
                  'lastPageOpened': item.lastPageOpened
                },
            changeListener),
        _pdfDeletionAdapter = DeletionAdapter(
            database,
            'Pdf',
            ['id'],
            (Pdf item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'path': item.path,
                  'url': item.url,
                  'version': item.version,
                  'description': item.description,
                  'lastPageOpened': item.lastPageOpened
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Pdf> _pdfInsertionAdapter;

  final DeletionAdapter<Pdf> _pdfDeletionAdapter;

  @override
  Future<List<Pdf>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM Pdf',
        mapper: (Map<String, Object?> row) => Pdf(
            id: row['id'] as int?,
            title: row['title'] as String,
            path: row['path'] as String?,
            url: row['url'] as String,
            version: row['version'] as double,
            description: row['description'] as String));
  }

  @override
  Stream<Pdf?> findPdfById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Pdf WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Pdf(
            id: row['id'] as int?,
            title: row['title'] as String,
            path: row['path'] as String?,
            url: row['url'] as String,
            version: row['version'] as double,
            description: row['description'] as String),
        arguments: [id],
        queryableName: 'Pdf',
        isView: false);
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
  Future<int> insertPdf(Pdf pdf) {
    return _pdfInsertionAdapter.insertAndReturnId(
        pdf, OnConflictStrategy.abort);
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
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _repositoryInsertionAdapter = InsertionAdapter(
            database,
            'Repository',
            (Repository item) => <String, Object?>{
                  'id': item.id,
                  'url': item.url,
                  'name': item.name
                },
            changeListener),
        _repositoryDeletionAdapter = DeletionAdapter(
            database,
            'Repository',
            ['id'],
            (Repository item) => <String, Object?>{
                  'id': item.id,
                  'url': item.url,
                  'name': item.name
                },
            changeListener);

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
            name: row['name'] as String?));
  }

  @override
  Stream<Repository?> findPdfById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Repository WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Repository(
            url: row['url'] as String,
            id: row['id'] as int?,
            name: row['name'] as String?),
        arguments: [id],
        queryableName: 'Repository',
        isView: false);
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
