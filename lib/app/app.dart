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
import 'package:timezones/home/home.dart';
import 'package:timezones/l10n/l10n.dart';
import 'package:timezones/select_time/select_time.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required TimeZoneRepository timeZoneRepository,
    required SelectTimeBloc selectTimeBloc,
  })  : _timeZoneRepository = timeZoneRepository,
        _selectTimeBloc = selectTimeBloc,
        super(key: key);

  final TimeZoneRepository _timeZoneRepository;
  final SelectTimeBloc _selectTimeBloc;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _timeZoneRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _selectTimeBloc),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.blue.shade900,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blue.shade900,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Colors.blue.shade900,
          )),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
