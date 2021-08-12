import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezones/time_zones/time_zones.dart';
import '../../helpers/helpers.dart';

class MockTimeZonesBloc extends MockBloc<TimeZonesEvent, TimeZonesState>
    implements TimeZonesBloc {}

class FakeTimeZonesEvent extends Fake implements TimeZonesEvent {}

class FakeTimeZonesState extends Fake implements TimeZonesState {}

void main() {
  group('TimeZonesPopulatedView', () {
    late TimeZonesBloc timeZonesBloc;
    final timeZones = createTimeZonesStub();
    setUp(() {
      timeZonesBloc = MockTimeZonesBloc();
    });
    setUpAll(() {
      registerFallbackValue<TimeZonesEvent>(FakeTimeZonesEvent());
      registerFallbackValue<TimeZonesState>(FakeTimeZonesState());
    });
    testWidgets('renders TimeZoneTile', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: TimeZonesPopulatedView(
            timeZones: timeZones.items,
          ),
        ),
      );

      expect(find.byType(TimeZoneTile), findsNWidgets(1));
    });

    testWidgets('can delete an element', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: timeZonesBloc,
          child: Scaffold(
            body: TimeZonesPopulatedView(
              timeZones: timeZones.items,
            ),
          ),
        ),
      );

      final slidableFinder = find.byType(Slidable).first;
      final iconSlideAction = find.byType(IconSlideAction);
      expect(slidableFinder, findsOneWidget);
      expect(iconSlideAction, findsNothing);
      await tester.drag(slidableFinder, const Offset(-200, 0));

      await tester.pumpAndSettle();
      await tester.tap(iconSlideAction);
      verify(
        () => timeZonesBloc.add(
          TimeZonesDeleteRequested(timeZone: timeZones.items.first),
        ),
      ).called(1);
    });
  });
}
