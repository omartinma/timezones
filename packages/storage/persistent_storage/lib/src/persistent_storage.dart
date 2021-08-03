import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/storage.dart';

/// {@template persistent_storage}
/// A storage that saves the data in a device's persistent memory.
/// {@endtemplate}
class PersistentStorage implements Storage {
  /// {@macro persistent_storage}
  const PersistentStorage({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  /// An instance of shared preferences.
  final SharedPreferences _sharedPreferences;

  /// Returns value for the provided [key].
  /// Read returns `null` if no value is found for the given [key].
  /// * Throws a [StorageException] if the read fails.
  @override
  Future<String?> read({required String key}) async {
    try {
      return _sharedPreferences.getString(key);
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace);
    }
  }

  /// Writes the provided [key], [value] pair asynchronously.
  /// * Throws a [StorageException] if the write fails.
  @override
  Future<void> write({required String key, required String value}) async {
    try {
      await _sharedPreferences.setString(key, value);
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace);
    }
  }

  /// Removes the value for the provided [key] asynchronously.
  /// * Throws a [StorageException] if the delete fails.
  @override
  Future<void> delete({required String key}) async {
    try {
      await _sharedPreferences.remove(key);
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace);
    }
  }

  /// Removes all key, value pairs asynchronously.
  /// * Throws a [StorageException] if the clear fails.
  @override
  Future<void> clear() async {
    try {
      await _sharedPreferences.clear();
    } catch (error, stackTrace) {
      throw StorageException(error, stackTrace);
    }
  }
}
