import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookers/core/services/services_locator.dart';
import 'package:bookers/core/theme/app_theme.dart';
import 'package:bookers/core/utils/app_constants.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_state.dart';
import 'package:bookers/features/booking/presentation/views/splash_view.dart';
import 'package:bookers/l10n/app_localizations.dart';

//! =========================================================
//! Application Root Widget: BookerApp
//! =========================================================

class BookerApp extends StatelessWidget {
  const BookerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingCubit>(
      create: (context) => getIt<BookingCubit>(),
      child: ScreenUtilInit(
        designSize: const Size(AppConstants.designWidth, AppConstants.designHeight),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<BookingCubit, BookingState>(
            buildWhen: (previous, current) => previous.isArabic != current.isArabic,
            builder: (context, state) {
              return MaterialApp(
                title: AppConstants.appName,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.darkTheme,
                locale: state.isArabic ? const Locale('ar') : const Locale('en'),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: child,
              );
            },
          );
        },
        child: const SplashView(),
      ),
    );
  }
}
