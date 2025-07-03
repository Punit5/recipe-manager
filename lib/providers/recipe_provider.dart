import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../database/database_helper.dart';

class RecipeProvider with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  String _searchQuery = '';
  String _selectedTag = '';
  String _selectedDifficulty = '';
  int _maxTime = 0;
  bool _showFavoritesOnly = false;

  List<Recipe> get recipes => _filteredRecipes;
  String get searchQuery => _searchQuery;
  String get selectedTag => _selectedTag;
  String get selectedDifficulty => _selectedDifficulty;
  int get maxTime => _maxTime;
  bool get showFavoritesOnly => _showFavoritesOnly;

  Future<void> loadRecipes() async {
    _recipes = await _databaseHelper.getAllRecipes();
    _applyFilters();
    notifyListeners();
  }

  Future<void> addRecipe(Recipe recipe) async {
    await _databaseHelper.insertRecipe(recipe);
    await loadRecipes();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await _databaseHelper.updateRecipe(recipe);
    await loadRecipes();
  }

  Future<void> deleteRecipe(int id) async {
    await _databaseHelper.deleteRecipe(id);
    await loadRecipes();
  }

  Future<void> toggleFavorite(int id) async {
    await _databaseHelper.toggleFavorite(id);
    await loadRecipes();
  }

  Future<Recipe?> getRecipeById(int id) async {
    return await _databaseHelper.getRecipeById(id);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setSelectedTag(String tag) {
    _selectedTag = tag;
    _applyFilters();
    notifyListeners();
  }

  void setSelectedDifficulty(String difficulty) {
    _selectedDifficulty = difficulty;
    _applyFilters();
    notifyListeners();
  }

  void setMaxTime(int time) {
    _maxTime = time;
    _applyFilters();
    notifyListeners();
  }

  void setShowFavoritesOnly(bool showFavorites) {
    _showFavoritesOnly = showFavorites;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedTag = '';
    _selectedDifficulty = '';
    _maxTime = 0;
    _showFavoritesOnly = false;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredRecipes = _recipes.where((recipe) {
      bool matchesSearch = _searchQuery.isEmpty ||
          recipe.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          recipe.ingredients.any((ingredient) =>
              ingredient.toLowerCase().contains(_searchQuery.toLowerCase())) ||
          recipe.tags.any((tag) =>
              tag.toLowerCase().contains(_searchQuery.toLowerCase()));

      bool matchesTag = _selectedTag.isEmpty || recipe.tags.contains(_selectedTag);

      bool matchesDifficulty = _selectedDifficulty.isEmpty ||
          recipe.difficulty.toLowerCase() == _selectedDifficulty.toLowerCase();

      bool matchesTime = _maxTime == 0 || recipe.totalTime <= _maxTime;

      bool matchesFavorites = !_showFavoritesOnly || recipe.isFavorite;

      return matchesSearch && matchesTag && matchesDifficulty && matchesTime && matchesFavorites;
    }).toList();
  }

  Future<List<String>> getAllTags() async {
    return await _databaseHelper.getAllTags();
  }

  List<Recipe> get favoriteRecipes => _recipes.where((recipe) => recipe.isFavorite).toList();
  
  List<Recipe> get recentRecipes => _recipes.take(5).toList();
}