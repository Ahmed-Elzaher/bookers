import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookers/core/localization/app_translations.dart';
import 'package:bookers/core/theme/app_colors.dart';
import 'package:bookers/core/theme/app_text_styles.dart';
import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_state.dart';
import 'package:bookers/features/booking/presentation/views/widgets/booking_header.dart';
import 'package:bookers/features/booking/presentation/views/widgets/diagnostic_dialog.dart';
import 'package:bookers/features/booking/presentation/views/widgets/duration_selector.dart';
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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSlot(int slotIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final targetKey = SlotsGrid.slotKeys[slotIndex];
      final targetContext = targetKey?.currentContext;
      if (targetContext != null) {
        Scrollable.ensureVisible(
          targetContext,
          alignment: 0.35,
          duration: AppConstants.scrollDuration,
          curve: Curves.easeInOutCubic,
        );
      }
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
          final messenger = ScaffoldMessenger.of(context);
          messenger.hideCurrentSnackBar();

          final rangeText = '${latestBooking.startTimeFormatted} - ${latestBooking.endTimeFormatted}';
          final message = '${AppTranslations.tr('bookingConfirmedSuccess', isArabic: state.isArabic)} ($rangeText)';

          messenger.showSnackBar(
            SnackBar(
              backgroundColor: AppColors.surface,
              behavior: SnackBarBehavior.floating,
              duration: AppConstants.toastDuration,
              margin: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                bottom: 85.h,
              ),
              dismissDirection: DismissDirection.horizontal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                side: const BorderSide(color: AppColors.available, width: 1.5),
              ),
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppColors.available),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      message,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
              action: SnackBarAction(
                label: AppTranslations.tr('undo', isArabic: state.isArabic),
                textColor: AppColors.error,
                onPressed: () {
                  messenger.hideCurrentSnackBar();
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
