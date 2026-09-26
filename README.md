# Booker

A Flutter appointment booking application designed around an 18-slot daily schedule (9:00 AM to 6:00 PM). It models 30-minute intervals and enforces contiguity, boundary limits, and orphaned-slot avoidance.

## Architecture

The project follows Clean Architecture principles:

- **Domain**: Pure Dart business logic, entities, repository interfaces, and use cases with zero Flutter framework dependencies.
- **Data**: Local data source, data models, and repository implementation.
- **Presentation**: Flutter widgets, BLoC/Cubit state management, and responsive layouts.

## Core Features

- **Slot Model**: 18 discrete 30-minute intervals per day supporting 30m, 1h, 1.5h, and 2h booking durations.
- **Validation Pipeline**: Checks opening and closing boundaries, slot contiguity, and orphaned single-slot gaps via state simulation.
- **Alternative Slot Finder**: Recommends the closest valid alternative slot when a requested slot violates schedule constraints.
- **Localization**: Full support for Arabic (RTL) and English (LTR) using the Cairo typeface.
- **Responsive Layout**: Adaptive grid layouts scaled with ScreenUtil across mobile and tablet form factors.

## Project Structure

```
lib/
├── app.dart                           # Root MaterialApp, ScreenUtilInit, and L10n setup
├── main.dart                          # Entry point and GetIt DI initialization
├── core/
│   ├── errors/                        # Domain Failures & Exceptions
│   ├── localization/                  # Translations bridge
│   ├── services/                      # GetIt Service Locator
│   ├── theme/                         # Colors, Typography, Theme
│   └── utils/                         # Constants & TimeFormatter
├── l10n/                              # ARB localization files
└── features/
    └── booking/
        ├── data/                      # Local data source & repository
        ├── domain/                    # Entities, contracts, use cases
        └── presentation/              # Cubit and UI widgets
```

## Running Tests and Analysis

```bash
flutter analyze
flutter test
```
