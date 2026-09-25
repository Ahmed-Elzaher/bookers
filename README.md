# 📅 Booker - Smart Local Appointment Scheduling App

A production-grade, highly reliable offline appointment booking application built with **Flutter**, designed following strict **Clean Architecture**, **SOLID Principles**, and advanced **Constraint Satisfaction Algorithms**.

---

## 🚀 Key Architectural & Algorithmic Features

### 1. ⏱️ Discrete 18-Slot Schedule Structure
- Operating Hours: **9:00 AM – 6:00 PM** (9 continuous hours).
- The day is mathematically modeled as an array of **18 discrete 30-minute intervals** (`0` to `17`).
- Supported Booking Durations:
  - **30 Minutes** (1 slot)
  - **1 Hour** (2 consecutive slots)
  - **1.5 Hours** (3 consecutive slots)
  - **2 Hours** (4 consecutive slots)

### 2. 🛡️ 3-Tier Algorithmic Validation Pipeline
Pure Dart domain-layer enforcement (`ValidateBookingUseCase`):
1. **Bounds Check**: Prevents booking from exceeding the 6:00 PM boundary (`startIndex + span - 1 < 18`).
2. **Contiguity & Overlap Check**: Ensures all requested intervals are strictly consecutive and available.
3. **Isolated Gap Constraint (X O X)**:
   - Evaluated via a **Virtual Lookahead State Simulation**:
   - Rejects any reservation that leaves a single, unusable 30-minute interval isolated between two bookings, or between a booking and the day start/end boundaries.

### 3. 💡 Smart Alternatives Engine
- **Nearest-Neighbor Search**: Calculates $\min(|i - \text{attemptedIndex}|)$ to suggest the temporally closest valid slot.
- **Full Discovery**: Aggregates all viable alternatives in a centralized interactive diagnostic modal with animated auto-scroll and focus glow.

### 4. 📱 Responsive & Multilingual
- Fully responsive across all devices and aspect ratios using `flutter_screenutil`.
- Official Flutter SDK localization (`flutter_localizations` with `.arb` files) supporting **Arabic (RTL)** and **English (LTR)**.
- Unified typography powered by **Cairo** font.

### 5. 🎟️ Local Booking Management
- View confirmed booking tickets in the "My Bookings" bottom sheet.
- Instant booking cancellation with immediate state reversion and slot freeing.

---

## 🏛️ Clean Architecture Structure

```
lib/
├── app.dart                           # Root MaterialApp, ScreenUtilInit, and L10n setup
├── main.dart                          # Entry point and GetIt DI initialization
├── core/
│   ├── errors/                        # Domain Failures & Exceptions
│   ├── localization/                  # AppTranslations bridge
│   ├── services/                      # GetIt Service Locator
│   ├── theme/                         # AppColors, AppTextStyles, AppTheme
│   └── utils/                         # AppConstants & TimeFormatter
├── l10n/                              # Official ARB localization files (AR / EN)
└── features/
    └── booking/
        ├── data/                      # Local data source & repository implementation
        ├── domain/                    # Pure Dart entities, contracts, and use cases
        └── presentation/              # Bloc/Cubit and UI widgets
```

---

## 🧪 Testing & Code Quality

- **Lint Status**: Zero warnings or errors with strict analysis rules.
- **Unit & Widget Tests**: 100% passing test suite verifying bounds, overlaps, isolated gap edge cases, reactive revalidation, and cancellation.

```bash
flutter analyze
flutter test
```
