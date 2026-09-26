import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookers/core/theme/app_colors.dart';
import 'package:bookers/core/theme/app_text_styles.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_state.dart';
import 'package:bookers/features/booking/presentation/views/widgets/booking_header.dart';
import 'package:bookers/features/booking/presentation/views/widgets/diagnostic_dialog.dart';
import 'package:bookers/features/booking/presentation/views/widgets/duration_selector.dart';
import 'package:bookers/features/booking/presentation/views/widgets/feature_tour_dialog.dart';
import 'package:bookers/features/booking/presentation/views/widgets/slots_grid.dart';
import 'package:bookers/features/booking/presentation/views/widgets/summary_dock.dart';


class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BookingViewBody();
  }
}

class _BookingViewBody extends StatefulWidget {
  const _BookingViewBody();

  @override
  State<_BookingViewBody> createState() => _BookingViewBodyState();
}

class _BookingViewBodyState extends State<_BookingViewBody> {
  late final ScrollController _scrollController;
  bool _hasShownInitialTour = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasShownInitialTour && mounted) {
        _hasShownInitialTour = true;
        FeatureTourDialog.show(context, context.read<BookingCubit>().state.isArabic);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSlot(int slotIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      // Grid has 2 columns. Row index = slotIndex ~/ 2.
      // Approximate height of each row is ~115.h
      final double targetOffset = (slotIndex ~/ 2) * 115.0.h;
      final double clampedOffset = targetOffset.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );

      _scrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listenWhen: (previous, current) =>
          (current.showDiagnosticModal && current.failure != null && !previous.showDiagnosticModal) ||
          (current.focusedSlotIndex != null && current.focusedSlotIndex != previous.focusedSlotIndex) ||
          (current.isBookingConfirmed && !previous.isBookingConfirmed),
      listener: (context, state) {
        if (state.showDiagnosticModal && state.failure != null) {
          DiagnosticDialog.show(context, state.failure!);
        }

        if (state.focusedSlotIndex != null) {
          _scrollToSlot(state.focusedSlotIndex!);
          context.read<BookingCubit>().clearFocus();
        }

        if (state.isBookingConfirmed && state.userBookings.isNotEmpty) {
          final latestBooking = state.userBookings.last;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.surface,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: const BorderSide(color: AppColors.available, width: 1.5),
              ),
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.available),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      state.isArabic
                          ? 'تم تأكيد حجزك بنجاح (${latestBooking.startTimeFormatted} - ${latestBooking.endTimeFormatted})'
                          : 'Booking confirmed (${latestBooking.startTimeFormatted} - ${latestBooking.endTimeFormatted})',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
              action: SnackBarAction(
                label: state.isArabic ? 'تراجع' : 'Undo',
                textColor: AppColors.bookedLight,
                onPressed: () {
                  context.read<BookingCubit>().cancelBooking(latestBooking.id);
                },
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isAr = state.isArabic;

        return Directionality(
          textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  BookingHeader(
                    onResetPressed: () => context.read<BookingCubit>().resetSchedule(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.h),
                          DurationSelector(
                            selectedDuration: state.selectedDuration,
                            isArabic: isAr,
                            onDurationChanged: (duration) {
                              context.read<BookingCubit>().setDuration(duration);
                            },
                          ),
                          const SlotsGrid(),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                  const SummaryDock(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
