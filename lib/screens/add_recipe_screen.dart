import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';

class AddRecipeScreen extends StatefulWidget {
  final Recipe? recipe;

  const AddRecipeScreen({Key? key, this.recipe}) : super(key: key);

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _servingsController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagController = TextEditingController();

  List<String> _ingredients = [''];
  List<String> _instructions = [''];
  List<String> _tags = [];
  String _difficulty = 'easy';
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _loadExistingRecipe();
    }
  }

  void _loadExistingRecipe() {
    final recipe = widget.recipe!;
    _titleController.text = recipe.title;
    _prepTimeController.text = recipe.prepTime.toString();
    _cookTimeController.text = recipe.cookTime.toString();
    _servingsController.text = recipe.servings.toString();
    _notesController.text = recipe.notes ?? '';
    _ingredients = List.from(recipe.ingredients);
    _instructions = List.from(recipe.instructions);
    _tags = List.from(recipe.tags);
    _difficulty = recipe.difficulty;
    _imagePath = recipe.imagePath;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    _notesController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe == null ? 'Add Recipe' : 'Edit Recipe'),
        actions: [
          TextButton(
            onPressed: _saveRecipe,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(),
              const SizedBox(height: 16),
              _buildBasicInfoSection(),
              const SizedBox(height: 16),
              _buildIngredientsSection(),
              const SizedBox(height: 16),
              _buildInstructionsSection(),
              const SizedBox(height: 16),
              _buildTagsSection(),
              const SizedBox(height: 16),
              _buildNotesSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photo',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: _imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(_imagePath!),
                      fit: BoxFit.cover,
                    ),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Tap to add photo', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Recipe Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a recipe title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _prepTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Prep Time (min)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cookTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Cook Time (min)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _servingsController,
                    decoration: const InputDecoration(
                      labelText: 'Servings',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _difficulty,
                    decoration: const InputDecoration(
                      labelText: 'Difficulty',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'easy', child: Text('Easy')),
                      DropdownMenuItem(value: 'medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'hard', child: Text('Hard')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _difficulty = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ..._ingredients.asMap().entries.map((entry) {
                  final index = entry.key;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _ingredients[index],
                            decoration: InputDecoration(
                              labelText: 'Ingredient ${index + 1}',
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              _ingredients[index] = value;
                            },
                            validator: (value) {
                              if (index == 0 && (value == null || value.isEmpty)) {
                                return 'At least one ingredient is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: _ingredients.length > 1
                              ? () => setState(() => _ingredients.removeAt(index))
                              : null,
                        ),
                      ],
                    ),
                  );
                }),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Ingredient'),
                  onPressed: () => setState(() => _ingredients.add('')),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Instructions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ..._instructions.asMap().entries.map((entry) {
                  final index = entry.key;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _instructions[index],
                            decoration: InputDecoration(
                              labelText: 'Step ${index + 1}',
                              border: const OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            onChanged: (value) {
                              _instructions[index] = value;
                            },
                            validator: (value) {
                              if (index == 0 && (value == null || value.isEmpty)) {
                                return 'At least one instruction is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: _instructions.length > 1
                              ? () => setState(() => _instructions.removeAt(index))
                              : null,
                        ),
                      ],
                    ),
                  );
                }),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Step'),
                  onPressed: () => setState(() => _instructions.add('')),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _tagController,
                        decoration: const InputDecoration(
                          labelText: 'Add Tag',
                          border: OutlineInputBorder(),
                        ),
                        onFieldSubmitted: _addTag,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _addTag(_tagController.text),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () => setState(() => _tags.remove(tag)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'Additional notes (optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Image picker is not fully supported on web in this demo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image upload not available on web demo')),
      );
      return;
    }
    
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String path = '${directory.path}/recipe_images';
      final Directory imageDir = Directory(path);
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }
      
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String newPath = '$path/$fileName';
      await File(image.path).copy(newPath);
      
      setState(() {
        _imagePath = newPath;
      });
    }
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final recipe = Recipe(
        id: widget.recipe?.id,
        title: _titleController.text,
        ingredients: _ingredients.where((ingredient) => ingredient.isNotEmpty).toList(),
        instructions: _instructions.where((instruction) => instruction.isNotEmpty).toList(),
        prepTime: int.parse(_prepTimeController.text),
        cookTime: int.parse(_cookTimeController.text),
        servings: int.parse(_servingsController.text),
        difficulty: _difficulty,
        tags: _tags,
        imagePath: _imagePath,
        isFavorite: widget.recipe?.isFavorite ?? false,
        createdAt: widget.recipe?.createdAt ?? now,
        updatedAt: now,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      if (widget.recipe == null) {
        context.read<RecipeProvider>().addRecipe(recipe);
      } else {
        context.read<RecipeProvider>().updateRecipe(recipe);
      }

      Navigator.pop(context);
    }
  }
}