import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/recipe.dart';
import 'web_database_helper.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  static WebDatabaseHelper? _webHelper;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  bool get isWeb => kIsWeb;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'recipes.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        ingredients TEXT NOT NULL,
        instructions TEXT NOT NULL,
        prepTime INTEGER NOT NULL,
        cookTime INTEGER NOT NULL,
        servings INTEGER NOT NULL,
        difficulty TEXT NOT NULL,
        tags TEXT NOT NULL,
        imagePath TEXT,
        isFavorite INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_title ON recipes(title)
    ''');

    await db.execute('''
      CREATE INDEX idx_tags ON recipes(tags)
    ''');

    await db.execute('''
      CREATE INDEX idx_favorite ON recipes(isFavorite)
    ''');
  }

  Future<int> insertRecipe(Recipe recipe) async {
    if (isWeb) {
      _webHelper ??= WebDatabaseHelper();
      return await _webHelper!.insertRecipe(recipe);
    }
    final db = await database;
    return await db.insert('recipes', recipe.toSQLiteMap());
  }

  Future<List<Recipe>> getAllRecipes() async {
    if (isWeb) {
      _webHelper ??= WebDatabaseHelper();
      return await _webHelper!.getAllRecipes();
    }
    final db = await database;
    final maps = await db.query('recipes', orderBy: 'updatedAt DESC');
    return maps.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<Recipe?> getRecipeById(int id) async {
    if (isWeb) {
      _webHelper ??= WebDatabaseHelper();
      return await _webHelper!.getRecipeById(id);
    }
    final db = await database;
    final maps = await db.query(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Recipe.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    final db = await database;
    final maps = await db.query(
      'recipes',
      where: 'title LIKE ? OR ingredients LIKE ? OR tags LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'updatedAt DESC',
    );
    return maps.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<List<Recipe>> getRecipesByTag(String tag) async {
    final db = await database;
    final maps = await db.query(
      'recipes',
      where: 'tags LIKE ?',
      whereArgs: ['%$tag%'],
      orderBy: 'updatedAt DESC',
    );
    return maps.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<List<Recipe>> getFavoriteRecipes() async {
    final db = await database;
    final maps = await db.query(
      'recipes',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'updatedAt DESC',
    );
    return maps.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<List<Recipe>> getRecipesByDifficulty(String difficulty) async {
    final db = await database;
    final maps = await db.query(
      'recipes',
      where: 'difficulty = ?',
      whereArgs: [difficulty],
      orderBy: 'updatedAt DESC',
    );
    return maps.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<List<Recipe>> getRecipesByTimeRange(int maxTime) async {
    final db = await database;
    final maps = await db.query(
      'recipes',
      where: '(prepTime + cookTime) <= ?',
      whereArgs: [maxTime],
      orderBy: 'updatedAt DESC',
    );
    return maps.map((map) => Recipe.fromMap(map)).toList();
  }

  Future<int> updateRecipe(Recipe recipe) async {
    if (isWeb) {
      _webHelper ??= WebDatabaseHelper();
      return await _webHelper!.updateRecipe(recipe);
    }
    final db = await database;
    return await db.update(
      'recipes',
      recipe.toSQLiteMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<int> deleteRecipe(int id) async {
    if (isWeb) {
      _webHelper ??= WebDatabaseHelper();
      return await _webHelper!.deleteRecipe(id);
    }
    final db = await database;
    return await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> toggleFavorite(int id) async {
    if (isWeb) {
      _webHelper ??= WebDatabaseHelper();
      return await _webHelper!.toggleFavorite(id);
    }
    final db = await database;
    final recipe = await getRecipeById(id);
    if (recipe != null) {
      return await db.update(
        'recipes',
        {'isFavorite': recipe.isFavorite ? 0 : 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    return 0;
  }

  Future<List<String>> getAllTags() async {
    if (isWeb) {
      _webHelper ??= WebDatabaseHelper();
      return await _webHelper!.getAllTags();
    }
    final db = await database;
    final maps = await db.query('recipes', columns: ['tags']);
    final allTags = <String>{};
    
    for (final map in maps) {
      final tags = (map['tags'] as String).split('|');
      allTags.addAll(tags.where((tag) => tag.isNotEmpty));
    }
    
    return allTags.toList()..sort();
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}