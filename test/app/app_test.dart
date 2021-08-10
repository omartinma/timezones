// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:timezones/app/app.dart';
import 'package:timezones/time_zones/time_zones.dart';
import '../helpers/helpers.dart';

class MockTimeZoneRepository extends Mock implements TimeZoneRepository {}

void main() {
  group('App', () {
    late TimeZoneRepository timeZoneRepository;

    setUp(() {
      timeZoneRepository = MockTimeZoneRepository();
      when(() => timeZoneRepository.getTimeZoneForLocation(any()))
          .thenAnswer((_) async => Future.value());
      when(() => timeZoneRepository.getTimeZones())
          .thenAnswer((_) async => TimeZones());
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpApp(
        App(timeZoneRepository: timeZoneRepository),
      );
      await tester.pump();
      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late TimeZoneRepository timeZoneRepository;

    setUp(() {
      timeZoneRepository = MockTimeZoneRepository();
      when(() => timeZoneRepository.getTimeZoneForLocation(any()))
          .thenAnswer((_) async => Future.value());
      when(() => timeZoneRepository.getTimeZones())
          .thenAnswer((_) async => TimeZones());
    });

    testWidgets('renders TimeZonesPage', (tester) async {
      await tester.pumpApp(AppView(), timeZoneRepository: timeZoneRepository);
      await tester.pump();
      expect(find.byType(TimeZonesPage), findsOneWidget);
    });
  });
}
