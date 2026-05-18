# Mongol English Spark - Flutter Version

A Flutter version of the Mongol English Spark English learning platform for Mongolian students. This app provides placement tests, daily study tracking, grammar lessons with videos, and gamified arcade games.

## Features

- **Placement Test**: 12-question diagnostic to determine your English level
- **Learning Roadmap**: 5 levels with 5 units each (reading, grammar, vocabulary)
- **Daily Study Tracker**: Timer to track study minutes
- **Grammar Hub**: 26 grammar topics with video lessons and practice quizzes
- **Arcade Games**: Word Scramble, Word Puzzle, and Syntax Blaster
- **Profile**: Track your progress, EXP, and completed levels
- **Bilingual**: English and Mongolian language support
- **Dark Theme**: Cinematic dark mode by default

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app/
│   ├── app.dart             # Main app widget with routing
│   └── theme.dart           # Theme configuration (colors, styles)
├── models/
│   └── content.dart         # Quiz data, vocab, reading passages
├── providers/
│   ├── store_provider.dart  # State management (user data, progress)
│   └── i18n_provider.dart   # Internationalization (EN/MN)
├── widgets/
│   ├── app_header.dart      # Navigation header
│   └── quiz_runner.dart     # Reusable quiz component
└── pages/
    ├── login_page.dart      # Login/signup page
    ├── home_page.dart       # Home page with roadmap
    ├── grammar_page.dart    # Grammar lessons and videos
    ├── arcade_page.dart     # Arcade games
    └── profile_page.dart    # User profile and progress
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code (recommended)

### Installation

1. Navigate to the flutter_app directory:
```bash
cd flutter_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Dependencies

- `provider`: State management
- `shared_preferences`: Local storage for user data
- `flutter_localizations` & `intl`: Internationalization
- `youtube_player_flutter`: Video player for grammar lessons
- `flutter_svg`: SVG icon support
- `url_launcher`: Opening external links

## State Management

The app uses the Provider package for state management:

- **StoreProvider**: Manages user state (name, grade, EXP, progress, level statuses)
- **I18nProvider**: Manages language selection and translations

## Data Persistence

User data is persisted locally using SharedPreferences:
- User profile (name, grade)
- Study progress (EXP, study minutes)
- Level completion status
- Unit completion status
- Language preference

## Theme

The app uses a custom dark theme with cinematic colors:
- Primary: Purple (#9F7AEA)
- Accent: Cyan (#38BDF8)
- Amber: Orange (#F59E0B)
- Background: Dark navy (#1A1A2E)
- Card: Slightly lighter navy (#252542)

## Original React Version

This Flutter app is a direct conversion of the original React/TypeScript application located in the parent directory. All logic, features, and functionality have been preserved while adapting to Flutter's widget-based architecture.

## Key Differences from React Version

- **Routing**: Uses simple state-based routing instead of TanStack Router
- **State**: Uses Provider instead of React Context
- **Styling**: Uses Flutter ThemeData instead of Tailwind CSS
- **Components**: Flutter widgets instead of React components
- **Icons**: Material Icons instead of Lucide React
- **Video**: youtube_player_flutter instead of iframe

## License

This project maintains the same license as the original React version.
