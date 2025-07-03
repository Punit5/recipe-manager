import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class WebDatabaseHelper {
  static const String _recipesKey = 'recipes';
  static const String _idCounterKey = 'recipe_id_counter';

  Future<int> insertRecipe(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    final recipes = await getAllRecipes();
    
    int newId = await _getNextId();
    final newRecipe = recipe.copyWith(id: newId);
    recipes.add(newRecipe);
    
    await _saveRecipes(recipes);
    return newId;
  }

  Future<List<Recipe>> getAllRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final recipesJson = prefs.getString(_recipesKey);
    
    if (recipesJson == null) return [];
    
    final List<dynamic> recipesList = json.decode(recipesJson);
    return recipesList.map((json) => Recipe.fromMap(json)).toList();
  }

  Future<Recipe?> getRecipeById(int id) async {
    final recipes = await getAllRecipes();
    try {
      return recipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    final recipes = await getAllRecipes();
    return recipes.where((recipe) {
      return recipe.title.toLowerCase().contains(query.toLowerCase()) ||
          recipe.ingredients.any((ingredient) =>
              ingredient.toLowerCase().contains(query.toLowerCase())) ||
          recipe.tags.any((tag) =>
              tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  Future<List<Recipe>> getRecipesByTag(String tag) async {
    final recipes = await getAllRecipes();
    return recipes.where((recipe) => recipe.tags.contains(tag)).toList();
  }

  Future<List<Recipe>> getFavoriteRecipes() async {
    final recipes = await getAllRecipes();
    return recipes.where((recipe) => recipe.isFavorite).toList();
  }

  Future<List<Recipe>> getRecipesByDifficulty(String difficulty) async {
    final recipes = await getAllRecipes();
    return recipes.where((recipe) => 
        recipe.difficulty.toLowerCase() == difficulty.toLowerCase()).toList();
  }

  Future<List<Recipe>> getRecipesByTimeRange(int maxTime) async {
    final recipes = await getAllRecipes();
    return recipes.where((recipe) => recipe.totalTime <= maxTime).toList();
  }

  Future<int> updateRecipe(Recipe recipe) async {
    final recipes = await getAllRecipes();
    final index = recipes.indexWhere((r) => r.id == recipe.id);
    
    if (index != -1) {
      recipes[index] = recipe;
      await _saveRecipes(recipes);
      return 1;
    }
    return 0;
  }

  Future<int> deleteRecipe(int id) async {
    final recipes = await getAllRecipes();
    final index = recipes.indexWhere((recipe) => recipe.id == id);
    
    if (index != -1) {
      recipes.removeAt(index);
      await _saveRecipes(recipes);
      return 1;
    }
    return 0;
  }

  Future<int> toggleFavorite(int id) async {
    final recipes = await getAllRecipes();
    final index = recipes.indexWhere((recipe) => recipe.id == id);
    
    if (index != -1) {
      recipes[index] = recipes[index].copyWith(isFavorite: !recipes[index].isFavorite);
      await _saveRecipes(recipes);
      return 1;
    }
    return 0;
  }

  Future<List<String>> getAllTags() async {
    final recipes = await getAllRecipes();
    final allTags = <String>{};
    
    for (final recipe in recipes) {
      allTags.addAll(recipe.tags);
    }
    
    return allTags.toList()..sort();
  }

  Future<void> _saveRecipes(List<Recipe> recipes) async {
    final prefs = await SharedPreferences.getInstance();
    final recipesJson = json.encode(recipes.map((recipe) => recipe.toMap()).toList());
    await prefs.setString(_recipesKey, recipesJson);
  }

  Future<int> _getNextId() async {
    final prefs = await SharedPreferences.getInstance();
    final currentId = prefs.getInt(_idCounterKey) ?? 0;
    final nextId = currentId + 1;
    await prefs.setInt(_idCounterKey, nextId);
    return nextId;
  }

  Future<void> close() async {
    // No cleanup needed for SharedPreferences
  }
}