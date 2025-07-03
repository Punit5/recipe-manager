import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';
import '../models/recipe.dart';
import 'recipe_detail_screen.dart';
import 'add_recipe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeProvider>().loadRecipes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Manager'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: Consumer<RecipeProvider>(
              builder: (context, provider, child) {
                if (provider.recipes.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant_menu, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No recipes found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add your first recipe!',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return MasonryGridView.count(
                  controller: _scrollController,
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  itemCount: provider.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = provider.recipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      onTap: () => _navigateToRecipeDetail(context, recipe),
                      onFavoriteToggle: () => _toggleFavorite(context, recipe.id!),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddRecipe(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search recipes, ingredients, or tags...',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          context.read<RecipeProvider>().setSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return Consumer<RecipeProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              FilterChip(
                label: const Text('Favorites'),
                selected: provider.showFavoritesOnly,
                onSelected: (selected) {
                  provider.setShowFavoritesOnly(selected);
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Easy'),
                selected: provider.selectedDifficulty == 'easy',
                onSelected: (selected) {
                  provider.setSelectedDifficulty(selected ? 'easy' : '');
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Medium'),
                selected: provider.selectedDifficulty == 'medium',
                onSelected: (selected) {
                  provider.setSelectedDifficulty(selected ? 'medium' : '');
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Hard'),
                selected: provider.selectedDifficulty == 'hard',
                onSelected: (selected) {
                  provider.setSelectedDifficulty(selected ? 'hard' : '');
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Quick (≤30 min)'),
                selected: provider.maxTime == 30,
                onSelected: (selected) {
                  provider.setMaxTime(selected ? 30 : 0);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filters'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Time Limit'),
            Consumer<RecipeProvider>(
              builder: (context, provider, child) {
                return Slider(
                  value: provider.maxTime.toDouble(),
                  min: 0,
                  max: 180,
                  divisions: 12,
                  label: provider.maxTime == 0 ? 'No limit' : '${provider.maxTime} min',
                  onChanged: (value) {
                    provider.setMaxTime(value.toInt());
                  },
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<RecipeProvider>().clearFilters();
              Navigator.pop(context);
            },
            child: const Text('Clear All'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _navigateToRecipeDetail(BuildContext context, Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  void _navigateToAddRecipe(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddRecipeScreen(),
      ),
    );
  }

  void _toggleFavorite(BuildContext context, int recipeId) {
    context.read<RecipeProvider>().toggleFavorite(recipeId);
  }
}