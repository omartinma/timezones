// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:timezones/app/app.dart';
import 'package:timezones/timezones/timezones.dart';

void main() {
  group('App', () {
    testWidgets('renders TimeZonesPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(TimeZonesPage), findsOneWidget);
    });
  });
}
