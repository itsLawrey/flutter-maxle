# Maxle 🦾

> A locally persistent, offline-first fitness companion built with Flutter to gamify your workouts and maintain consistency streaks.

[![Demo/Live App](https://img.shields.io/badge/Live_Demo-Link-blue)](https://itslawrey-flutter-demos.web.app/) 

## Visuals



## Tech Stack

* **Frontend:** Flutter / Dart 3.0
* **State Management:** Provider
* **Local Storage:** SharedPreferences (for offline-first capabilities)
* **Key Libraries:** `fl_chart` (for weight graphs), `table_calendar`, `google_fonts`

## Core Features

* **Weight Tracking & Analytics:** Easily log your daily weight and calculate weekly averages to identify trends, filtering out the noise of daily fluctuations.
* **Routine Management & Logging:** Pick your workout routines based on target muscle groups and locations, track elapsed time, and log completed exercises in real-time.
* **Smart Workout Resumption:** If you exit the app during an active session, Maxle remembers where you left off. On the next launch, it intelligently prompts you to resume your in-progress workout or save it securely to your history.
* **Workout History:** Browse your past workout sessions, including duration, exercises performed, and whether they were completed fully or partially off-schedule.
* **Gamification & Leveling System:** Turn fitness into an RPG. You earn XP for consecutive daily check-ins (10 XP) and weight logging (20 XP), progressing your profile through 10 ranks from Novice all the way to Demigod.
* **Consistency Streaks:** Keep the momentum going by checking in daily. Miss a day, and the streak resets, encouraging long-term discipline.
* **Profile Personalization:** Customize your experience by picking an avatar and defining your aspirant nickname.
* **Local-First Architecture:** All user data is preserved locally. Your app is entirely private, works without an internet connection, and operates with zero loading screens.

## Technical Architecture & Challenges

### State Management & Data Flow
I chose **Provider** for state management to guarantee a solid separation between the presentation layer and the app's business logic. Maxle handles state through two primary controllers: `AppProvider` (for user profiles, gamification, weight and streaks) and `WorkoutProvider` (for managing active workout flows). Isolating these controllers allowed me to optimize widget rebuilds, preventing complex screens from redrawing unnecessarily when simple states like the workout timer tick every second. This ensures smooth 60 FPS performance during workouts without memory leaks.

### Local Data Persistence & Offline-first Approach
One strict requirement I had for this side project was creating a fully offline-first experience. Using `SharedPreferences`, complex nested objects like workout histories, dates, and check-ins are serialized into JSON strings and stored right onto the device. A fun challenge here was handling date inconsistencies when compiling weekly weight averages or computing the weekly streak logic across different days. I addressed this by enforcing standard datetime constraints on the backend state to prevent any weird timezone conflicts or edge cases.

### Smart Workout Resumption
Managing app lifecycles asynchronously can be incredibly tricky. To ensure no data is lost if you minimize the app or shut it down during an intense workout, the `WorkoutProvider` frequently serializes the state—saving the elapsed time and all checked exercises into local storage. When the app is opened back up, the main scaffolding asynchronously restores the `active_workout_state`, intercepting the navigation router to prompt you to resume the context exactly where you left off. 

## Installation & Local Setup

To run this project locally, make sure you have the Flutter SDK installed on a fresh machine.

1. Clone the repository:
   ```bash
   git clone https://github.com/itsLawrey/flutter-maxle.git
   ```
2. Navigate into the application directory:
   ```bash
   cd flutter-maxle
   ```
3. Get the required local dependencies:
   ```bash
   flutter pub get
   ```
4. Build and run the application:
   ```bash
   flutter run
   ```
