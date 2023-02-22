import 'package:sqflite/sqflite.dart';
import 'package:open_director/Editor/model/project.dart';
import 'package:open_director/Editor/model/generated_video.dart';

class ProjectDao {
  Database db;

  final migrationScripts = [
    '''
create table project (
  _id integer primary key autoincrement
  , title text not null
  , description text
  , date integer not null
  , duration integer not null
  , layersJson text
  , imagePath text
)
''',
    '''
create table generatedVideo (
  _id integer primary key autoincrement
  , projectId integer not null
  , path text not null
  , date integer not null
  , resolution text
  , thumbnail text
)
  ''',
  ];

  Future open() async {
    db = await openDatabase(
      'project',
      version: migrationScripts.length,
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (var i = oldVersion; i < newVersion; i++) {
          await db.execute(migrationScripts[i]);
        }
      },
    );
  }

  insert(Project project) async {
    if (db != null) {
      project.id = await db.insert('project', project.toMap());
      return project;
    }
  }

  insertGeneratedVideo(GeneratedVideo generatedVideo) async {
    if (db != null) {
      generatedVideo.id =
          await db.insert('generatedVideo', generatedVideo.toMap());
      return generatedVideo;
    }
  }

  get(int id) async {
    if (db != null) {
      List<Map> maps = await db.query('project',
          columns: [
            '_id',
            'title',
            'description',
            'date',
            'duration',
            'layersJson',
            'imagePath',
          ],
          where: '_id = ?',
          whereArgs: [id]);
      if (maps.length > 0) {
        return Project.fromMap(maps.first);
      }
      return null;
    }
  }

  findAll() async {
    if (db != null) {
      List<Map> maps = await db.query(
        'project',
        columns: [
          '_id',
          'title',
          'description',
          'date',
          'duration',
          'layersJson',
          'imagePath',
        ],
      );
      return maps.map((m) => Project.fromMap(m)).toList();
    }
  }

  findAllGeneratedVideo(int projectId) async {
    if (db != null) {
      List<Map> maps = await db.query('generatedVideo',
          columns: [
            '_id',
            'projectId',
            'path',
            'date',
            'resolution',
            'thumbnail',
          ],
          where: 'projectId = ?',
          whereArgs: [projectId],
          orderBy: '_id desc');
      return maps.map((m) => GeneratedVideo.fromMap(m)).toList();
    }
  }

  delete(int id) async {
    if (db != null) {
      return await db.delete('project', where: '_id = ?', whereArgs: [id]);
    }
  }

  deleteGeneratedVideo(int id) async {
    if (db != null) {
      return await db
          .delete('generatedVideo', where: '_id = ?', whereArgs: [id]);
    }
  }

  deleteAll() async {
    if (db != null) {
      return await db.delete('project');
    }
  }

  update(Project project) async {
    if (db != null) {
      return await db.update('project', project.toMap(),
          where: '_id = ?', whereArgs: [project.id]);
    }
  }

  Future close() async {
    if (db != null) {
      return db.close();
    }
  }
}
