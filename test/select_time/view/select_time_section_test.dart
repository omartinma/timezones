// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_zones_ui/time_zones_ui.dart';
import 'package:timezones/select_time/select_time.dart';

import '../../helpers/helpers.dart';

class MockSelectTimeBloc extends MockBloc<SelectTimeEvent, SelectTimeState>
    implements SelectTimeBloc {}

class FakeSelectTimeEvent extends Fake implements SelectTimeEvent {}

class FakeSelectTimeState extends Fake implements SelectTimeState {}

extension TimeZonesTester on WidgetTester {
  Future<void> pumpSelectTimeSection(
    Widget child, {
    required SelectTimeBloc selectTimeBloc,
  }) async {
    await pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: selectTimeBloc),
        ],
        child: child,
      ),
    );
  }
}

void main() {
  group('SelectTimeSection', () {
    late SelectTimeBloc selectTimeBloc;
    final currentTime = DateTime.now();

    setUp(() {
      selectTimeBloc = MockSelectTimeBloc();
      when(() => selectTimeBloc.state).thenReturn(SelectTimeState(currentTime));
    });

    setUpAll(() {
      registerFallbackValue<SelectTimeEvent>(FakeSelectTimeEvent());
      registerFallbackValue<SelectTimeState>(FakeSelectTimeState());
    });

    testWidgets('displays the time selected', (tester) async {
      await tester.pumpSelectTimeSection(
        Scaffold(
            body: SelectTimeSection(
          height: 100,
        )),
        selectTimeBloc: selectTimeBloc,
      );
      expect(find.text(currentTime.toHours()), findsOneWidget);
    });

    testWidgets('calls to update time', (tester) async {
      await tester.pumpSelectTimeSection(
        Scaffold(
            body: SelectTimeSection(
          height: 100,
        )),
        selectTimeBloc: selectTimeBloc,
      );
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      verify(() => selectTimeBloc.add(any(that: isA<SelectTimeSelected>())))
          .called(1);
    });
  });
}
