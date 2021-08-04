// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:timezones/l10n/l10n.dart';
import 'package:timezones/time_zones/time_zones.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required TimeZoneRepository timeZoneRepository,
  })  : _timeZoneRepository = timeZoneRepository,
        super(key: key);

  final TimeZoneRepository _timeZoneRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _timeZoneRepository),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const TimeZonesPage(),
    );
  }
}
