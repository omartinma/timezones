import 'package:flutter_test/flutter_test.dart';
import 'package:time_zones_ui/time_zones_ui.dart';

void main() {
  group('TimeConverter', () {
    test('returns correct hour', () {
      final time = DateTime(2021);
      expect(time.toHours(), '00:00');
    });
  });
}
