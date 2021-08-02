// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:bloc/bloc.dart';
import 'package:location_api/location_api.dart';
import 'package:time_zone_api/time_zone_api.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:timezones/app/app.dart';
import 'package:timezones/app/app_bloc_observer.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  final timeZoneApi = TimeZoneApi();
  final locationApi = LocationApi();
  final timeZoneRepository = TimeZoneRepository(
    locationApi: locationApi,
    timeZoneApi: timeZoneApi,
  );

  runZonedGuarded(
    () => runApp(App(
      timeZoneRepository: timeZoneRepository,
    )),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
