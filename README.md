# Word Memory Game

A Flutter application for learning English-French word pairs through an interactive memory game. Compatible with Windows, macOS, and Linux.

## Features
- Interactive word matching game
- English to French word pair learning
- Progress tracking and scoring
- Shuffle and reset functionality
- State management using BLoC/Cubit

## Architecture
The project uses a layered architecture inspired by Clean Architecture:

- **Domain Layer**: Contains business logic and interfaces
  - Entities (WordPair)
  - Repository interfaces
  - Use cases

- **Data Layer**: Handles data operations
  - Repository implementations
  - Data sources
  - Data models

- **Presentation Layer**: Manages UI and state
  - Cubit state management
  - UI widgets
  - Screen layouts

## Getting Started

### Setup
```bash
# Clone repository
git clone https://github.com/yourusername/word_memory.git

# Navigate to project directory
cd word_memory

# Install dependencies
flutter pub get

# Run app
flutter run
```

For platform-specific setup, run `flutter doctor` and follow the instructions for your operating system.

### Testing (not completed, will be updated)
```bash
# Run all tests
flutter test
```
## Project Structure
```
lib/
├── app/
├── domain/
├── data/
└── presentation/
    ├── cubit/
    ├── models/
    └── widgets/
```
