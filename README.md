# 🧠 Quiz Hub — Flutter Quiz Learning App

A responsive Flutter quiz app that runs on **Web** and **Mobile**, built as a coding assessment demonstration.

---

## 📁 Project Structure

```
lib/
├── app/
│   ├── app.dart                # Root GetMaterialApp.router widget
│   └── di/
│       └── injection.dart      # GetIt service locator setup
├── core/
│   ├── constants/              # Colors, text styles, theme, app constants
│   ├── models/                 # AppUser, QuizCategory, TriviaQuestion, QuizResult
│   ├── network/                # DioClient, TriviaApiService
│   └── repositories/           # UserRepository, QuizRepository
├── features/
│   ├── home/                   # HomeScreen, UserController, HomeController, widgets
│   ├── countdown/              # CountdownScreen, CountdownController
│   ├── quiz/                   # QuizScreen, QuizController, OptionTile, TimerBar
│   └── result/                 # ResultScreen
├── routing/
│   └── app_router.dart         # GoRouter configuration
└── main.dart
test/
├── trivia_question_test.dart   # Unit tests for TriviaQuestion model
└── widget_test.dart            # Widget tests for OptionTile
```

---

## 🚀 How to Run

### Prerequisites
- Flutter SDK ≥ 3.8.1
- Dart SDK ≥ 3.8.1

### Install Dependencies
```bash
flutter pub get
```

### Run on Web
```bash
flutter run -d chrome
```

### Run on Mobile
```bash
# List available devices
flutter devices

# Run on a specific device
flutter run -d <device-id>
```

[//]: # (### Android Note)

[//]: # (The project's `gradle.properties` includes:)

[//]: # (```)

[//]: # (org.gradle.java.home=/Applications/Android Studio 3.app/Contents/jbr/Contents/Home)

[//]: # (```)

[//]: # (This is required because multiple Android Studio installations are present on the machine.)

[//]: # ()
[//]: # (---)

## ✅ Run Tests
```bash
flutter test
```

---

## 📱 App Flow

1. **Home Screen** — Shows user card (avatar, name, rank, score) and 5 quiz categories with individual progress bars
2. **Tap a Category** → fetches 10 questions from Open Trivia DB
3. **Countdown Screen** — Animated 3 → 2 → 1 → GO! countdown
4. **Quiz Screen** — One question at a time with 60-second timer:
   - Progress indicator at top (X/10 + %)
   - Question type badge (Multiple Choice / True or False)
   - Answer options with immediate feedback (green = correct, red = wrong)
   - "Correct!" / "Incorrect ❌" label on answer selection
   - 1-second delay then next question auto-advances
   - Timer auto-advances on timeout
5. **Result Screen** — Score card, grade, points earned, stats, encouragement + Back to Home
6. **Home updates** — Category progress and user score updated after each quiz

---

## 🏗️ Design Decisions

| Area | Choice | Reason |
|------|--------|--------|
| State Management | **GetX** | Reactive, lightweight, minimal boilerplate. Controllers scoped per feature. |
| Dependency Injection | **GetIt** | Simple service locator pattern. Easy to swap implementations for testing. |
| Navigation | **GoRouter** | Declarative routing, URL-based (works great on Web), type-safe extras. |
| Networking | **Dio** | Full-featured HTTP client, easy interceptors, better error typing than `http`. |
| Persistence | **SharedPreferences** | Persists user score and category progress between sessions (bonus feature). |
| Fonts | **Google Fonts (Poppins + Inter)** | Modern, clean typography across platforms. |
| Animations | **flutter_animate** | Declarative, composable animations with minimal code. |

---

## 🌐 API Reference

All quiz data is fetched from [Open Trivia DB](https://opentdb.com).

| Category | ID | Type |
|---|---|---|
| General Knowledge | 9 | multiple |
| Science & Nature | 17 | multiple |
| Mathematics | 19 | multiple |
| Books & English | 10 | multiple |
| True or False Mix | 9 | boolean |

**Example URL:**
```
https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiple
```

HTML entities in API responses (e.g. `&quot;`) are automatically decoded using `html_unescape`.

---

## ✨ Optional / Bonus Features Implemented

- ✅ **Local Storage** — User score & category progress persisted via `SharedPreferences`
- ✅ **True/False question type** handling (separate from MCQ)
- ✅ **Loading & Error states** with retry on quiz fetch failure
- ✅ **Back navigation disabled** during active quiz
- ✅ **Timer auto-advance** when 60-second timer expires
- ✅ **Animations** — flutter_animate for countdown, question slides, result reveal
- ✅ **Responsive UI** — works on web, large tablets, and phones
- ✅ **Grade system** (A+/A/B/C/D/F) based on accuracy
