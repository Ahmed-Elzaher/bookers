import 'package:get_it/get_it.dart';
import 'package:bookers/features/booking/data/data_sources/booking_local_data_source.dart';
import 'package:bookers/features/booking/data/data_sources/booking_local_data_source_impl.dart';
import 'package:bookers/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:bookers/features/booking/domain/repositories/booking_repository.dart';
import 'package:bookers/features/booking/domain/use_cases/cancel_booking_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/confirm_booking_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/find_alternative_slot_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/get_all_alternatives_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/get_day_schedule_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/get_user_bookings_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/reset_schedule_use_case.dart';
import 'package:bookers/features/booking/domain/use_cases/validate_booking_use_case.dart';
import 'package:bookers/features/booking/presentation/cubit/booking_cubit.dart';


final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<BookingLocalDataSource>(
    () => BookingLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(
      localDataSource: getIt<BookingLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetDayScheduleUseCase>(
    () => GetDayScheduleUseCase(
      repository: getIt<BookingRepository>(),
    ),
  );

  getIt.registerLazySingleton<ValidateBookingUseCase>(
    () => const ValidateBookingUseCase(),
  );

  getIt.registerLazySingleton<ConfirmBookingUseCase>(
    () => ConfirmBookingUseCase(
      repository: getIt<BookingRepository>(),
    ),
  );

  getIt.registerLazySingleton<ResetScheduleUseCase>(
    () => ResetScheduleUseCase(
      repository: getIt<BookingRepository>(),
    ),
  );

  getIt.registerLazySingleton<FindAlternativeSlotUseCase>(
    () => FindAlternativeSlotUseCase(
      validateBookingUseCase: getIt<ValidateBookingUseCase>(),
    ),
  );

  getIt.registerLazySingleton<GetAllAlternativesUseCase>(
    () => GetAllAlternativesUseCase(
      validateBookingUseCase: getIt<ValidateBookingUseCase>(),
    ),
  );

  getIt.registerLazySingleton<GetUserBookingsUseCase>(
    () => GetUserBookingsUseCase(
      repository: getIt<BookingRepository>(),
    ),
  );

  getIt.registerLazySingleton<CancelBookingUseCase>(
    () => CancelBookingUseCase(
      repository: getIt<BookingRepository>(),
    ),
  );

  getIt.registerFactory<BookingCubit>(
    () => BookingCubit(
      getDayScheduleUseCase: getIt<GetDayScheduleUseCase>(),
      validateBookingUseCase: getIt<ValidateBookingUseCase>(),
      confirmBookingUseCase: getIt<ConfirmBookingUseCase>(),
      resetScheduleUseCase: getIt<ResetScheduleUseCase>(),
      findAlternativeSlotUseCase: getIt<FindAlternativeSlotUseCase>(),
      getAllAlternativesUseCase: getIt<GetAllAlternativesUseCase>(),
      getUserBookingsUseCase: getIt<GetUserBookingsUseCase>(),
      cancelBookingUseCase: getIt<CancelBookingUseCase>(),
      repository: getIt<BookingRepository>(),
    ),
  );
}
