import 'package:dartz/dartz.dart';
import 'package:bookers/core/errors/failures.dart';
import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/core/utils/time_formatter.dart';
import 'package:bookers/features/booking/domain/entities/booking_duration.dart';
import 'package:bookers/features/booking/domain/entities/booking_status.dart';
import 'package:bookers/features/booking/domain/entities/slot_entity.dart';

//! =========================================================
//! Use Case: ValidateBookingUseCase
//! =========================================================

class ValidateBookingUseCase {
  const ValidateBookingUseCase();

  /// فحص مسار القواعد المتتابع (Bounds ➔ Overlap ➔ Isolated Gap X O X)
  Either<Failure, List<int>> call({
    required int startIndex,
    required BookingDuration duration,
    required List<SlotEntity> currentSlots,
  }) {
    if (startIndex < 0 || startIndex >= AppConstants.totalDaySlots) {
      return const Left(
        OutOfBoundsFailure(
          message: 'مؤشر الخانة خارج حدود اليوم المسموح بها.',
        ),
      );
    }

    // 1. فحص خانة البداية (Start Slot)
    final startSlot = currentSlots[startIndex];
    if (startSlot.status != BookingStatus.available) {
      return Left(
        InvalidStartFailure(
          message: 'لا يمكن بدء الحجز من خانة ${startSlot.status.labelArabic} (${startSlot.rangeFormatted}).',
          startIndex: startIndex,
        ),
      );
    }

    // 2. فحص الحدود (Bounds Check): هل يتجاوز نهاية اليوم عند 6:00 م؟
    final int endIndex = startIndex + duration.slotCount - 1;
    if (endIndex >= AppConstants.totalDaySlots) {
      final availableRemainingMinutes = (AppConstants.totalDaySlots - startIndex) * AppConstants.slotDurationInMinutes;
      final requestedEndTime = TimeFormatter.formatMinutesTo12H(
        TimeFormatter.slotIndexToEndMinutes(startIndex, slotSpan: duration.slotCount),
      );

      return Left(
        OutOfBoundsFailure(
          message:
              'الحجز يتجاوز نهاية يوم العمل (6:00 م). المدة المطلوبة (${duration.labelArabic}) تحتاج حتى $requestedEndTime، بينما المتبقي حتى الإغلاق $availableRemainingMinutes دقيقة فقط.',
        ),
      );
    }

    // 3. فحص التتابع وعدم التداخل (Overlap Check)
    for (int i = startIndex; i <= endIndex; i++) {
      final slot = currentSlots[i];
      if (slot.status != BookingStatus.available) {
        return Left(
          OverlapFailure(
            message:
                'يتعارض الحجز المطلوب مع خانة ${slot.status.labelArabic} في الفترة (${slot.rangeFormatted}). يجب أن تكون جميع فترات الحجز متتالية ومتاحة تماماً.',
            conflictingIndex: i,
          ),
        );
      }
    }

    // 4. فحص الفجوة المعزولة عبر المحاكاة الشاملة (Isolated Gap Simulation - X O X)
    final gapIndex = _findIsolatedGapAfterBooking(
      startIndex: startIndex,
      endIndex: endIndex,
      slots: currentSlots,
    );

    if (gapIndex != null) {
      final isolatedSlot = currentSlots[gapIndex];
      return Left(
        IsolatedGapFailure(
          message:
              'ممنوع تنفيذ الحجز لأنه يترك فترة 30 دقيقة فقط معزولة وغير قابلة للاستخدام في (${isolatedSlot.rangeFormatted}) بين حجزين أو في أطراف اليوم (حالة X O X).',
          gapIndex: gapIndex,
        ),
      );
    }

    // نجاح التحقق بالكامل
    final selectedIndices = List<int>.generate(duration.slotCount, (i) => startIndex + i);
    return Right(selectedIndices);
  }

  /// محاكاة الحجز واكتشاف أي خانة وحيدة 30 دقيقة محاصرة ومحجوبة من الجهتين
  int? _findIsolatedGapAfterBooking({
    required int startIndex,
    required int endIndex,
    required List<SlotEntity> slots,
  }) {
    final simulatedStatuses = List<BookingStatus>.generate(
      AppConstants.totalDaySlots,
      (i) => (i >= startIndex && i <= endIndex) ? BookingStatus.booked : slots[i].status,
    );

    for (int i = 0; i < AppConstants.totalDaySlots; i++) {
      if (simulatedStatuses[i] == BookingStatus.available) {
        final bool leftBlocked = (i == 0) || simulatedStatuses[i - 1].isBlocked;
        final bool rightBlocked = (i == AppConstants.totalDaySlots - 1) || simulatedStatuses[i + 1].isBlocked;

        if (leftBlocked && rightBlocked) {
          return i;
        }
      }
    }

    return null;
  }
}
