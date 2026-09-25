import 'package:flutter_test/flutter_test.dart';
import 'package:bookers/app.dart';
import 'package:bookers/core/services/services_locator.dart';
import 'package:bookers/features/booking/presentation/views/booking_view.dart';
import 'package:bookers/features/booking/presentation/views/splash_view.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    await setupServiceLocator();
  });

  testWidgets('BookerApp loads splash screen then transitions to booking view', (WidgetTester tester) async {
    await tester.pumpWidget(const BookerApp());

    // Initially loads SplashView
    expect(find.byType(SplashView), findsOneWidget);
    expect(find.text('Booker'), findsOneWidget);

    // Pump past the splash animation and transition delay
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Now on BookingView
    expect(find.byType(BookingView), findsOneWidget);
    expect(find.text('اختر مدة الحجز المطلوبة:'), findsOneWidget);
  });
}
