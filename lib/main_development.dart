import 'package:location_api/location_api.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_zone_api/time_zone_api.dart';
import 'package:time_zone_repository/time_zone_repository.dart';
import 'package:timezones/app/app.dart';
import 'package:timezones/bootstrap.dart';
import 'package:timezones/select_time/select_time.dart';

void main() {
  bootstrap(() async {
    final timeZoneApi = TimeZoneApi();
    final locationApi = LocationApi();
    final sharedPreferences = await SharedPreferences.getInstance();
    final persistentStorage = PersistentStorage(
      sharedPreferences: sharedPreferences,
    );
    final timeZoneRepository = TimeZoneRepository(
      locationApi: locationApi,
      timeZoneApi: timeZoneApi,
      storage: persistentStorage,
    );
    return App(
      timeZoneRepository: timeZoneRepository,
      selectTimeBloc: SelectTimeBloc(DateTime.now()),
    );
  });
}
