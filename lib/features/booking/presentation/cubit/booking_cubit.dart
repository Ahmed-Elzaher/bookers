import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';
import 'package:bookers/features/booking/domain/entities/slot_entity.dart';
import 'package:bookers/features/booking/domain/repositories/booking_repository.dart';
import 'package:bookers/features/booking/domain/use_cases/cancel_booking_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/confirm_booking_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/find_alternative_slot_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/get_all_alternatives_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/get_day_schedule_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/get_user_bookings_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/reset_schedule_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/validate_booking_use_case.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_state.dart';


class BookingCubit extends Cubit<BookingState> {
  BookingCubit({
    required GetDayScheduleUseCase getDayScheduleUseCase,
    required this.validateBookingUseCase,
    required this.confirmBookingUseCase,
    required this.resetScheduleUseCase,
    required this.findAlternativeSlotUseCase,
    required this.getAllAlternativesUseCase,
    required this.getUserBookingsUseCase,
    required this.cancelBookingUseCase,
    required this.repository,
  }) : super(
          BookingState(
            slots: getDayScheduleUseCase(),
            selectedDuration: BookingDuration.thirtyMin,
          ),
        ) {
    _updateValidStartIndices();
  }

  final ValidateBookingUseCase validateBookingUseCase;
  final ConfirmBookingUseCase confirmBookingUseCase;
  final ResetScheduleUseCase resetScheduleUseCase;
  final FindAlternativeSlotUseCase findAlternativeSlotUseCase;
  final GetAllAlternativesUseCase getAllAlternativesUseCase;
  final GetUserBookingsUseCase getUserBookingsUseCase;
  final CancelBookingUseCase cancelBookingUseCase;
  final BookingRepository repository;

  void toggleLanguage() {
    emit(state.copyWith(isArabic: !state.isArabic));
  }

  void dismissDiagnosticModal() {
    emit(state.copyWith(showDiagnosticModal: false));
  }

  void clearFocus() {
    emit(state.copyWith(clearFocus: true));
  }

  void selectSlot(int index) {
    if (index < 0 || index >= AppConstants.totalDaySlots) {
      return;
    }

    if (state.selectedIndices.contains(index) && state.hasValidSelection) {
      clearSelection();
      return;
    }

    _revalidateSelection(startIndex: index, duration: state.selectedDuration);
  }

  void selectAlternativeAndFocus(int index) {
    dismissDiagnosticModal();
    _revalidateSelection(
      startIndex: index,
      duration: state.selectedDuration,
      targetFocusIndex: index,
    );
  }

  void applySuggestedAlternative() {
    final altIndex = state.suggestedAlternativeIndex;
    if (altIndex != null) {
      selectAlternativeAndFocus(altIndex);
    }
  }

  void setDuration(BookingDuration duration) {
    if (state.selectedDuration == duration) {
      return;
    }

    final newValidStarts = _calculateValidStarts(duration, state.slots);

    if (state.selectedStartIndex != null) {
      _revalidateSelection(
        startIndex: state.selectedStartIndex!,
        duration: duration,
        validStarts: newValidStarts,
      );
    } else {
      emit(
        state.copyWith(
          selectedDuration: duration,
          validStartIndices: newValidStarts,
        ),
      );
    }
  }

  bool confirmBooking() {
    if (!state.hasValidSelection) {
      return false;
    }

    final bookedIndices = state.selectedIndices.toList();
    final updatedSlots = confirmBookingUseCase(bookedIndices);

    repository.createBookingTicket(
      bookedIndices: bookedIndices,
      duration: state.selectedDuration,
      isArabic: state.isArabic,
    );

    final updatedTickets = getUserBookingsUseCase();
    final newValidStarts = _calculateValidStarts(state.selectedDuration, updatedSlots);

    emit(
      state.copyWith(
        slots: updatedSlots,
        userBookings: updatedTickets,
        clearStartIndex: true,
        selectedIndices: const {},
        clearFailure: true,
        clearAlternative: true,
        allAvailableAlternatives: const [],
        validStartIndices: newValidStarts,
        isBookingConfirmed: true,
        showDiagnosticModal: false,
      ),
    );

    return true;
  }

  void cancelBooking(String bookingId) {
    final updatedSlots = cancelBookingUseCase(bookingId);
    final updatedTickets = getUserBookingsUseCase();
    final newValidStarts = _calculateValidStarts(state.selectedDuration, updatedSlots);

    emit(
      state.copyWith(
        slots: updatedSlots,
        userBookings: updatedTickets,
        validStartIndices: newValidStarts,
      ),
    );
  }

  void resetSchedule() {
    final defaultSlots = resetScheduleUseCase();
    final newValidStarts = _calculateValidStarts(BookingDuration.thirtyMin, defaultSlots);

    emit(
      BookingState(
        slots: defaultSlots,
        selectedDuration: BookingDuration.thirtyMin,
        validStartIndices: newValidStarts,
        userBookings: const [],
        isArabic: state.isArabic,
      ),
    );
  }

  void clearSelection() {
    emit(
      state.copyWith(
        clearStartIndex: true,
        selectedIndices: const {},
        clearFailure: true,
        clearAlternative: true,
        allAvailableAlternatives: const [],
        showDiagnosticModal: false,
      ),
    );
  }


  void _revalidateSelection({
    required int startIndex,
    required BookingDuration duration,
    Set<int>? validStarts,
    int? targetFocusIndex,
  }) {
    final validationResult = validateBookingUseCase(
      startIndex: startIndex,
      duration: duration,
      currentSlots: state.slots,
    );

    final currentValidStarts = validStarts ?? _calculateValidStarts(duration, state.slots);

    validationResult.fold(
      (failure) {
        final alternative = findAlternativeSlotUseCase(
          attemptedIndex: startIndex,
          duration: duration,
          currentSlots: state.slots,
        );

        final allAlternatives = getAllAlternativesUseCase(
          duration: duration,
          currentSlots: state.slots,
        );

        emit(
          state.copyWith(
            selectedDuration: duration,
            selectedStartIndex: startIndex,
            selectedIndices: const {},
            failure: failure,
            suggestedAlternativeIndex: alternative,
            allAvailableAlternatives: allAlternatives,
            validStartIndices: currentValidStarts,
            showDiagnosticModal: true,
            focusedSlotIndex: targetFocusIndex,
          ),
        );
      },
      (selectedIndicesList) {
        emit(
          state.copyWith(
            selectedDuration: duration,
            selectedStartIndex: startIndex,
            selectedIndices: selectedIndicesList.toSet(),
            clearFailure: true,
            clearAlternative: true,
            allAvailableAlternatives: const [],
            validStartIndices: currentValidStarts,
            showDiagnosticModal: false,
            focusedSlotIndex: targetFocusIndex ?? startIndex,
          ),
        );
      },
    );
  }

  void _updateValidStartIndices() {
    final validStarts = _calculateValidStarts(state.selectedDuration, state.slots);
    emit(state.copyWith(validStartIndices: validStarts));
  }

  Set<int> _calculateValidStarts(BookingDuration duration, List<SlotEntity> currentSlots) {
    final validSet = <int>{};
    for (int i = 0; i < AppConstants.totalDaySlots; i++) {
      final res = validateBookingUseCase(
        startIndex: i,
        duration: duration,
        currentSlots: currentSlots,
      );
      if (res.isRight()) {
        validSet.add(i);
      }
    }
    return validSet;
  }
}
