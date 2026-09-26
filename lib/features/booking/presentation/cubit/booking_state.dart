import 'package:equatable/equatable.dart';
import 'package:bookers/core/errors/failures.dart';
import 'package:bookers/core/utils/time_formatter.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';
import 'package:bookers/features/booking/domain/entities/booking_status.dart';
import 'package:bookers/features/booking/domain/entities/slot_entity.dart';
import 'package:bookers/features/booking/domain/entities/user_booking_entity.dart';


class BookingState extends Equatable {
  const BookingState({
    required this.slots,
    required this.selectedDuration,
    this.selectedStartIndex,
    this.selectedIndices = const {},
    this.validStartIndices = const {},
    this.failure,
    this.suggestedAlternativeIndex,
    this.allAvailableAlternatives = const [],
    this.userBookings = const [],
    this.isArabic = true,
    this.isBookingConfirmed = false,
    this.focusedSlotIndex,
    this.showDiagnosticModal = false,
  });

  final List<SlotEntity> slots;
  final BookingDuration selectedDuration;
  final int? selectedStartIndex;
  final Set<int> selectedIndices;
  final Set<int> validStartIndices;
  final Failure? failure;
  final int? suggestedAlternativeIndex;
  final List<int> allAvailableAlternatives;
  final List<UserBookingEntity> userBookings;
  final bool isArabic;
  final bool isBookingConfirmed;
  final int? focusedSlotIndex;
  final bool showDiagnosticModal;

  bool get hasValidSelection => failure == null && selectedIndices.isNotEmpty;

  String? get startTimeFormatted {
    if (selectedStartIndex != null && selectedIndices.isNotEmpty) {
      return TimeFormatter.formatMinutesTo12H(
        slots[selectedStartIndex!].startMinutes,
        arabic: isArabic,
      );
    }
    return null;
  }

  String? get endTimeFormatted {
    if (selectedIndices.isNotEmpty) {
      final maxIndex = selectedIndices.reduce((a, b) => a > b ? a : b);
      return TimeFormatter.formatMinutesTo12H(
        slots[maxIndex].endMinutes,
        arabic: isArabic,
      );
    }
    return null;
  }

  String get durationLabel => isArabic ? selectedDuration.labelArabic : selectedDuration.labelEnglish;

  /// إرجاع حالة الخانة مع مراعاة التحديد الحالي
  BookingStatus getDisplayStatus(int index) {
    if (selectedIndices.contains(index)) {
      return BookingStatus.selected;
    }
    return slots[index].status;
  }

  BookingState copyWith({
    List<SlotEntity>? slots,
    BookingDuration? selectedDuration,
    int? selectedStartIndex,
    bool clearStartIndex = false,
    Set<int>? selectedIndices,
    Set<int>? validStartIndices,
    Failure? failure,
    bool clearFailure = false,
    int? suggestedAlternativeIndex,
    bool clearAlternative = false,
    List<int>? allAvailableAlternatives,
    List<UserBookingEntity>? userBookings,
    bool? isArabic,
    bool? isBookingConfirmed,
    int? focusedSlotIndex,
    bool clearFocus = false,
    bool? showDiagnosticModal,
  }) {
    return BookingState(
      slots: slots ?? this.slots,
      selectedDuration: selectedDuration ?? this.selectedDuration,
      selectedStartIndex: clearStartIndex ? null : (selectedStartIndex ?? this.selectedStartIndex),
      selectedIndices: selectedIndices ?? this.selectedIndices,
      validStartIndices: validStartIndices ?? this.validStartIndices,
      failure: clearFailure ? null : (failure ?? this.failure),
      suggestedAlternativeIndex:
          clearAlternative ? null : (suggestedAlternativeIndex ?? this.suggestedAlternativeIndex),
      allAvailableAlternatives: allAvailableAlternatives ?? this.allAvailableAlternatives,
      userBookings: userBookings ?? this.userBookings,
      isArabic: isArabic ?? this.isArabic,
      isBookingConfirmed: isBookingConfirmed ?? false,
      focusedSlotIndex: clearFocus ? null : (focusedSlotIndex ?? this.focusedSlotIndex),
      showDiagnosticModal: showDiagnosticModal ?? this.showDiagnosticModal,
    );
  }

  @override
  List<Object?> get props => [
        slots,
        selectedDuration,
        selectedStartIndex,
        selectedIndices,
        validStartIndices,
        failure,
        suggestedAlternativeIndex,
        allAvailableAlternatives,
        userBookings,
        isArabic,
        isBookingConfirmed,
        focusedSlotIndex,
        showDiagnosticModal,
      ];
}
