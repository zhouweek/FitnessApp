import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class WorkoutRecord {
  final int? id;
  final String phone;
  final String workoutType;
  final int duration;
  final double calories;
  final String date;
  final String? image;

  WorkoutRecord({
    this.id,
    required this.phone,
    required this.workoutType,
    required this.duration,
    required this.calories,
    required this.date,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'workout_type': workoutType,
      'duration': duration,
      'calories': calories,
      'date': date,
      'image': image,
    };
  }

  factory WorkoutRecord.fromMap(Map<String, dynamic> map) {
    return WorkoutRecord(
      id: map['id'] as int?,
      phone: map['phone'] as String,
      workoutType: map['workout_type'] as String,
      duration: map['duration'] as int,
      calories: (map['calories'] as num).toDouble(),
      date: map['date'] as String,
      image: map['image'] as String?,
    );
  }

  static String getImageForType(String type) {
    switch (type) {
      case 'full_body_workout':
        return 'assets/images/Workout1.png';
      case 'lower_body_workout':
        return 'assets/images/Workout2.png';
      case 'ab_workout':
        return 'assets/images/Workout3.png';
      default:
        return 'assets/images/Workout1.png';
    }
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fitness_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE workout_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        phone TEXT NOT NULL,
        workout_type TEXT NOT NULL,
        duration INTEGER NOT NULL,
        calories REAL NOT NULL,
        date TEXT NOT NULL,
        image TEXT
      )
    ''');

    await db.execute('CREATE INDEX idx_workout_records_phone ON workout_records(phone)');
    await db.execute('CREATE INDEX idx_workout_records_date ON workout_records(date)');
    await db.execute('CREATE INDEX idx_workout_records_type ON workout_records(workout_type)');
  }

  Future<int> insertWorkoutRecord(WorkoutRecord record) async {
    final db = await database;
    return await db.insert('workout_records', record.toMap());
  }

  Future<List<WorkoutRecord>> getWorkoutRecords(String phone, {int? limit, int? offset}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'workout_records',
      where: 'phone = ?',
      whereArgs: [phone],
      orderBy: 'date DESC',
      limit: limit,
      offset: offset,
    );
    return maps.map((map) => WorkoutRecord.fromMap(map)).toList();
  }

  Future<List<WorkoutRecord>> getRecentWorkoutRecords(String phone, {int limit = 3}) async {
    return await getWorkoutRecords(phone, limit: limit);
  }

  Future<int> getWorkoutCountByDateRange(String phone, String workoutType, String startDate, String endDate) async {
    final db = await database;
    if (workoutType.isEmpty) {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM workout_records WHERE phone = ? AND date >= ? AND date <= ?',
        [phone, startDate, endDate],
      );
      return result.first['count'] as int;
    }
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM workout_records WHERE phone = ? AND workout_type = ? AND date >= ? AND date <= ?',
      [phone, workoutType, startDate, endDate],
    );
    return result.first['count'] as int;
  }

  Future<int> getTotalDurationByDateRange(String phone, String startDate, String endDate) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(duration) as total FROM workout_records WHERE phone = ? AND date >= ? AND date <= ?',
      [phone, startDate, endDate],
    );
    return (result.first['total'] as num?)?.toInt() ?? 0;
  }

  Future<double> getTotalCaloriesByDateRange(String phone, String startDate, String endDate) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(calories) as total FROM workout_records WHERE phone = ? AND date >= ? AND date <= ?',
      [phone, startDate, endDate],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<Map<String, int>> getWorkoutCountsByDate(String phone, String startDate, String endDate) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT date, COUNT(*) as count FROM workout_records WHERE phone = ? AND date >= ? AND date <= ? GROUP BY date',
      [phone, startDate, endDate],
    );
    Map<String, int> counts = {};
    for (var row in result) {
      counts[row['date'] as String] = row['count'] as int;
    }
    return counts;
  }

  Future<Map<String, Map<String, int>>> getWorkoutCountsByDateAndType(String phone, String startDate, String endDate) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT date, workout_type, COUNT(*) as count FROM workout_records WHERE phone = ? AND date >= ? AND date <= ? GROUP BY date, workout_type',
      [phone, startDate, endDate],
    );
    Map<String, Map<String, int>> data = {};
    for (var row in result) {
      String date = row['date'] as String;
      String type = row['workout_type'] as String;
      int count = row['count'] as int;
      data.putIfAbsent(date, () => {});
      data[date]![type] = count;
    }
    return data;
  }

  Future<int> deleteWorkoutRecord(int id) async {
    final db = await database;
    return await db.delete('workout_records', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getWorkoutCount(String phone) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM workout_records WHERE phone = ?',
      [phone],
    );
    return result.first['count'] as int;
  }

  Future<int> getDistinctWorkoutDays(String phone) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(DISTINCT date) as count FROM workout_records WHERE phone = ?',
      [phone],
    );
    return result.first['count'] as int;
  }

  Future<double> getTotalCalories(String phone) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(calories) as total FROM workout_records WHERE phone = ?',
      [phone],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<int> getTotalDuration(String phone) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(duration) as total FROM workout_records WHERE phone = ?',
      [phone],
    );
    return (result.first['total'] as num?)?.toInt() ?? 0;
  }

  Future<int> getConsecutiveWorkoutDays(String phone) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT DISTINCT date FROM workout_records WHERE phone = ? ORDER BY date DESC',
      [phone],
    );
    if (result.isEmpty) return 0;
    final dates = result.map((row) => row['date'] as String).toList();
    int streak = 1;
    for (int i = 0; i < dates.length - 1; i++) {
      try {
        final current = DateTime.parse(dates[i]);
        final next = DateTime.parse(dates[i + 1]);
        if (current.difference(next).inDays == 1) {
          streak++;
        } else {
          break;
        }
      } catch (e) {
        break;
      }
    }
    return streak;
  }

  Future<Map<String, int>> getWorkoutCountByType(String phone) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT workout_type, COUNT(*) as count FROM workout_records WHERE phone = ? GROUP BY workout_type',
      [phone],
    );
    Map<String, int> counts = {};
    for (var row in result) {
      counts[row['workout_type'] as String] = row['count'] as int;
    }
    return counts;
  }

  Future<int> getTodayWorkoutCount(String phone) async {
    final now = DateTime.now();
    final today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM workout_records WHERE phone = ? AND date = ?',
      [phone, today],
    );
    return result.first['count'] as int;
  }

  Future<double> getTodayCalories(String phone) async {
    final now = DateTime.now();
    final today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(calories) as total FROM workout_records WHERE phone = ? AND date = ?',
      [phone, today],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<int> getTodayDuration(String phone) async {
    final now = DateTime.now();
    final today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(duration) as total FROM workout_records WHERE phone = ? AND date = ?',
      [phone, today],
    );
    return (result.first['total'] as num?)?.toInt() ?? 0;
  }
}
