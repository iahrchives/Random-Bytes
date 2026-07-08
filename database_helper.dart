import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    try {
      if (_database != null && _database!.isOpen) {
        await _database!.rawQuery('SELECT 1');
        return _database!;
      }
    } catch (e) {
      _database = null;
    }

    _database = await _initDB();
    return _database!;
  }

  Future<void> resetDatabase() async {
    String path = join(await getDatabasesPath(), 'retail.db');
    await deleteDatabase(path);
    _database = null;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'retail.db');
    return await openDatabase(
      path,
      version: 2,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT,
            phone TEXT,
            address TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            product_name TEXT,
            quantity INTEGER,
            status TEXT DEFAULT 'pending',
            created_at TEXT DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS orders(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER,
              product_name TEXT,
              quantity INTEGER,
              status TEXT DEFAULT 'pending',
              created_at TEXT DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
            )
          ''');
        }
      },
    );
  }

  Future<int> registerUser(String name, String email, String address, String password) async {
    final db = await database;
    return await db.insert('users', {
      'name': name.trim(),
      'email': email.trim().toLowerCase(),
      'address': address.trim(),
      'password': password.trim(),
      'phone': '',
    });
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'LOWER(email) = ? AND password = ?',
      whereArgs: [email.trim().toLowerCase(), password.trim()],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<bool> checkEmailExists(String email) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'LOWER(email) = ?',
      whereArgs: [email.trim().toLowerCase()],
    );
    return res.isNotEmpty;
  }

  Future<int> addOrder(int userId, String productName, int quantity) async {
    final db = await database;
    return await db.insert('orders', {
      'user_id': userId,
      'product_name': productName,
      'quantity': quantity,
    });
  }

  Future<List<Map<String, dynamic>>> getOrdersByUser(int userId) async {
    final db = await database;
    return await db.query(
      'orders',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  Future<int> placeOrder(int orderId) async {
    final db = await database;
    return await db.update(
      'orders',
      {'status': 'placed'},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }
}