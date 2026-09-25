import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookers/core/localization/app_translations.dart';
import 'package:bookers/core/theme/app_colors.dart';
import 'package:bookers/core/theme/app_text_styles.dart';
import 'package:bookers/core/utils/app_constants.dart';

//! =========================================================
//! Widget: FeatureTourDialog
//! =========================================================

class FeatureTourDialog extends StatefulWidget {
  const FeatureTourDialog({super.key, required this.isArabic});

  final bool isArabic;

  static void show(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      builder: (ctx) => FeatureTourDialog(isArabic: isArabic),
    );
  }

  @override
  State<FeatureTourDialog> createState() => _FeatureTourDialogState();
}

class _FeatureTourDialogState extends State<FeatureTourDialog> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final bool isAr = widget.isArabic;

    final steps = [
      {
        'title': AppTranslations.tr('tourStep1Title', isArabic: isAr),
        'desc': AppTranslations.tr('tourStep1Desc', isArabic: isAr),
        'icon': Icons.timelapse_rounded,
        'color': AppColors.primaryLight,
      },
      {
        'title': AppTranslations.tr('tourStep2Title', isArabic: isAr),
        'desc': AppTranslations.tr('tourStep2Desc', isArabic: isAr),
        'icon': Icons.calendar_month_rounded,
        'color': AppColors.available,
      },
      {
        'title': AppTranslations.tr('tourStep3Title', isArabic: isAr),
        'desc': AppTranslations.tr('tourStep3Desc', isArabic: isAr),
        'icon': Icons.lightbulb_rounded,
        'color': AppColors.warning,
      },
      {
        'title': AppTranslations.tr('tourStep4Title', isArabic: isAr),
        'desc': AppTranslations.tr('tourStep4Desc', isArabic: isAr),
        'icon': Icons.confirmation_num_rounded,
        'color': AppColors.primaryLight,
      },
    ];

    final current = steps[_currentStep];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusModal),
          side: const BorderSide(color: AppColors.surfaceSubtle, width: 1.2),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 0.85.sh),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppTranslations.tr('tourTitle', isArabic: isAr),
                      style: AppTextStyles.sectionTitle,
                    ),
                    Text(
                      '${_currentStep + 1} / ${steps.length}',
                      style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  width: 56.r,
                  height: 56.r,
                  decoration: BoxDecoration(
                    color: (current['color'] as Color).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: (current['color'] as Color).withValues(alpha: 0.4)),
                  ),
                  child: Icon(
                    current['icon'] as IconData,
                    color: current['color'] as Color,
                    size: 28.sp,
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  current['title'] as String,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.dialogTitle,
                ),
                SizedBox(height: 8.h),
                Text(
                  current['desc'] as String,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        AppTranslations.tr('skip', isArabic: isAr),
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_currentStep < steps.length - 1) {
                          setState(() {
                            _currentStep++;
                          });
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
                        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                      ),
                      child: Text(
                        _currentStep == steps.length - 1
                            ? AppTranslations.tr('gotIt', isArabic: isAr)
                            : AppTranslations.tr('next', isArabic: isAr),
                        style: AppTextStyles.buttonLabel,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
