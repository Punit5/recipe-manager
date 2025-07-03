class Recipe {
  final int? id;
  final String title;
  final List<String> ingredients;
  final List<String> instructions;
  final int prepTime;
  final int cookTime;
  final int servings;
  final String difficulty;
  final List<String> tags;
  final String? imagePath;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;

  Recipe({
    this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.difficulty,
    required this.tags,
    this.imagePath,
    this.isFavorite = false,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  Recipe copyWith({
    int? id,
    String? title,
    List<String>? ingredients,
    List<String>? instructions,
    int? prepTime,
    int? cookTime,
    int? servings,
    String? difficulty,
    List<String>? tags,
    String? imagePath,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      imagePath: imagePath ?? this.imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
      'difficulty': difficulty,
      'tags': tags,
      'imagePath': imagePath,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'notes': notes,
    };
  }

  Map<String, dynamic> toSQLiteMap() {
    return {
      'id': id,
      'title': title,
      'ingredients': ingredients.join('|'),
      'instructions': instructions.join('|'),
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
      'difficulty': difficulty,
      'tags': tags.join('|'),
      'imagePath': imagePath,
      'isFavorite': isFavorite ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'notes': notes,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    // Handle both SQLite (string with |) and JSON (list) formats
    List<String> parseStringList(dynamic value) {
      if (value is List) {
        return value.cast<String>();
      } else if (value is String) {
        return value.split('|').where((s) => s.isNotEmpty).toList();
      }
      return [];
    }

    return Recipe(
      id: map['id'],
      title: map['title'] ?? '',
      ingredients: parseStringList(map['ingredients']),
      instructions: parseStringList(map['instructions']),
      prepTime: map['prepTime'] ?? 0,
      cookTime: map['cookTime'] ?? 0,
      servings: map['servings'] ?? 1,
      difficulty: map['difficulty'] ?? 'easy',
      tags: parseStringList(map['tags']),
      imagePath: map['imagePath'],
      isFavorite: map['isFavorite'] == 1 || map['isFavorite'] == true,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      notes: map['notes'],
    );
  }

  int get totalTime => prepTime + cookTime;
}

enum RecipeCategory {
  breakfast,
  lunch,
  dinner,
  dessert,
  snack,
  appetizer,
  drink,
  other,
}

enum DifficultyLevel {
  easy,
  medium,
  hard,
}

enum DietaryRestriction {
  vegetarian,
  vegan,
  glutenFree,
  dairyFree,
  nutFree,
  lowCarb,
  keto,
  paleo,
}