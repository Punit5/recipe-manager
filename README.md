# Recipe Manager 🍳

A beautiful, cross-platform recipe management app built with Flutter. Store, search, and organize your favorite recipes with ease!

## ✨ Features

### Core Functionality
- 📝 **Add/Edit/Delete Recipes** - Complete recipe management with all essential fields
- 🔍 **Advanced Search** - Search across recipe titles, ingredients, and tags
- 🏷️ **Smart Filtering** - Filter by categories, cooking time, difficulty, and favorites
- ❤️ **Favorites System** - Mark and quickly access your favorite recipes
- 📸 **Photo Support** - Add photos to your recipes (mobile/desktop only)
- 🏪 **Offline Storage** - Works completely offline with local data storage

### User Experience
- 🎨 **Beautiful UI** - Clean, intuitive Material Design interface
- 📱 **Responsive Design** - Adapts perfectly to phones, tablets, and desktop
- 🌙 **Dark Mode** - Automatic dark/light theme based on system preferences
- ⚡ **Fast Performance** - Optimized database with indexed search
- 🎯 **Cross-Platform** - Runs on Android, iOS, Web, macOS, Windows, and Linux

### Recipe Details
- 🕐 **Timing Information** - Prep time, cook time, and total time tracking
- 👥 **Serving Size** - Track servings and scale recipes accordingly
- 📊 **Difficulty Levels** - Easy, Medium, and Hard classification
- 🏷️ **Tag System** - Organize with custom tags (vegetarian, quick, dessert, etc.)
- 📋 **Step-by-Step Instructions** - Clear, numbered cooking instructions
- 📝 **Notes Section** - Add personal notes and modifications

## 🚀 Quick Start

### Prerequisites
- [Flutter](https://flutter.dev/docs/get-started/install) (latest stable version)
- [Dart](https://dart.dev/get-dart) (comes with Flutter)

### Installation
1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/recipe_manager.git
   cd recipe_manager
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # Web (works everywhere)
   flutter run -d chrome
   
   # Mobile (requires emulator/device)
   flutter run
   
   # Desktop
   flutter run -d macos    # macOS
   flutter run -d windows  # Windows
   flutter run -d linux    # Linux
   ```

## 🛠️ Technical Details

### Architecture
- **Framework**: Flutter 3.x
- **State Management**: Provider pattern
- **Database**: SQLite (mobile/desktop) + SharedPreferences (web)
- **Storage**: Local file system for images
- **UI**: Material Design 3

### Project Structure
```
lib/
├── main.dart                      # App entry point
├── models/
│   └── recipe.dart               # Recipe data model
├── database/
│   ├── database_helper.dart      # SQLite database operations
│   └── web_database_helper.dart  # Web storage implementation
├── providers/
│   └── recipe_provider.dart      # State management
├── screens/
│   ├── home_screen.dart          # Main screen with search/filter
│   ├── recipe_detail_screen.dart # Recipe details view
│   └── add_recipe_screen.dart    # Add/edit recipe form
└── widgets/
    └── recipe_card.dart          # Recipe card component
```

### Key Dependencies
- `provider` - State management
- `sqflite` - SQLite database for mobile/desktop
- `shared_preferences` - Web storage
- `image_picker` - Photo capture/selection
- `path_provider` - File system access
- `flutter_staggered_grid_view` - Masonry layout

## 🎯 Usage Examples

### Adding a Recipe
1. Tap the "+" floating action button
2. Fill in recipe details (title, ingredients, instructions)
3. Set timing and difficulty
4. Add tags for easy categorization
5. Optionally add a photo
6. Tap "Save"

### Searching Recipes
- Use the search bar to find recipes by name, ingredients, or tags
- Apply quick filters with the filter chips
- Use advanced time filtering in the filter dialog

### Organizing Recipes
- Mark favorites by tapping the heart icon
- Use tags like "vegetarian", "quick", "dessert", "breakfast"
- Filter by difficulty level or cooking time

## 🌐 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android  | ✅ Full | Complete functionality |
| iOS      | ✅ Full | Complete functionality |
| Web      | ✅ Limited | No image upload (demo limitation) |
| macOS    | ✅ Full | Complete functionality |
| Windows  | ✅ Full | Complete functionality |
| Linux    | ✅ Full | Complete functionality |

## 🔧 Development

### Setting up for Development
1. Fork the repository
2. Clone your fork: `git clone https://github.com/yourusername/recipe_manager.git`
3. Create a feature branch: `git checkout -b feature/amazing-feature`
4. Install dependencies: `flutter pub get`
5. Make your changes
6. Test on multiple platforms
7. Commit: `git commit -m 'Add amazing feature'`
8. Push: `git push origin feature/amazing-feature`
9. Open a Pull Request

### Running Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Contributors
- Built with ❤️ using Claude Code

## 📞 Support

If you have any questions or run into issues, please:
1. Check the [Issues](https://github.com/yourusername/recipe_manager/issues) page
2. Create a new issue if needed
3. Provide as much detail as possible about your environment and the problem

## 🔮 Future Enhancements

- [ ] Cloud synchronization
- [ ] Recipe sharing between users
- [ ] Meal planning calendar
- [ ] Shopping list generation
- [ ] Recipe scaling calculator
- [ ] Import/export functionality
- [ ] Voice search
- [ ] Recipe recommendations
- [ ] Nutritional information
- [ ] Multiple language support

---

Made with 💫 Flutter and ❤️ for home cooks everywhere!