// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:timezones/l10n/l10n.dart';
import 'package:timezones/time_zones/time_zones.dart';

class MockTimeZoneRepository extends Mock implements TimeZoneRepository {}

class MockTimeZonesBloc extends MockBloc<TimeZonesEvent, TimeZonesState>
    implements TimeZonesBloc {}

class FakeTimeZonesEvent extends Fake implements TimeZonesEvent {}

class FakeTimeZonesState extends Fake implements TimeZonesState {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget,
      {TimeZoneRepository? timeZoneRepository}) {
    registerFallbackValues();
    return pumpWidget(MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: timeZoneRepository ?? MockTimeZoneRepository(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    ));
  }
}

void registerFallbackValues() {
  registerFallbackValue<TimeZonesEvent>(FakeTimeZonesEvent());
  registerFallbackValue<TimeZonesState>(FakeTimeZonesState());
}
