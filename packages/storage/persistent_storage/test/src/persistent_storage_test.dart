import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage/storage.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  const mockKey = 'mock-key';
  const mockValue = 'mock-value';
  final mockException = Exception('oops');

  group('PersistentStorage', () {
    late SharedPreferences sharedPreferences;
    late PersistentStorage persistentStorage;

    setUp(() {
      sharedPreferences = MockSharedPreferences();
      persistentStorage = PersistentStorage(
        sharedPreferences: sharedPreferences,
      );
    });

    group('read', () {
      test(
          'returns value '
          'when SharedPreferences returns successfully', () async {
        when(() => sharedPreferences.getString(any()))
            .thenAnswer((_) => mockValue);
        final actual = await persistentStorage.read(key: mockKey);
        expect(actual, mockValue);
      });

      test(
          'returns null '
          'when sharedPreferences.getString returns null', () async {
        when(() => sharedPreferences.getString(any())).thenAnswer((_) => null);
        final actual = await persistentStorage.read(key: mockKey);
        expect(actual, isNull);
      });

      test(
          'throws StorageException '
          'when sharedPreferences.getString fails', () async {
        when(() => sharedPreferences.getString(any())).thenThrow(mockException);

        try {
          await persistentStorage.read(key: mockKey);
        } on StorageException catch (e) {
          expect(e.error, mockException);
          expect(e.stackTrace, isNotNull);
        }
      });
    });

    group('write', () {
      test(
          'completes '
          'when sharedPreferences.setString completes', () async {
        when(() => sharedPreferences.setString(any(), any()))
            .thenAnswer((_) => Future.value(true));
        expect(
          persistentStorage.write(key: mockKey, value: mockValue),
          completes,
        );
      });

      test(
          'throws StorageException '
          'when sharedPreferences.setString fails', () async {
        when(() => sharedPreferences.setString(any(), any()))
            .thenThrow(mockException);
        try {
          await persistentStorage.write(key: mockKey, value: mockValue);
        } on StorageException catch (e) {
          expect(e.error, mockException);
          expect(e.stackTrace, isNotNull);
        }
      });
    });

    group('delete', () {
      test(
          'completes '
          'when sharedPreferences.remove completes', () async {
        when(() => sharedPreferences.remove(any()))
            .thenAnswer((_) => Future.value(true));
        expect(
          persistentStorage.delete(key: mockKey),
          completes,
        );
      });

      test(
          'throws StorageException '
          'when sharedPreferences.remove fails', () async {
        when(() => sharedPreferences.remove(any())).thenThrow(mockException);
        try {
          await persistentStorage.delete(key: mockKey);
        } on StorageException catch (e) {
          expect(e.error, mockException);
          expect(e.stackTrace, isNotNull);
        }
      });
    });

    group('clear', () {
      test(
          'completes '
          'when sharedPreferences.clear completes', () async {
        when(() => sharedPreferences.clear())
            .thenAnswer((_) => Future.value(true));
        expect(persistentStorage.clear(), completes);
      });

      test(
          'throws StorageException '
          'when sharedPreferences.clear fails', () async {
        when(() => sharedPreferences.clear()).thenThrow(mockException);
        try {
          await persistentStorage.clear();
        } on StorageException catch (e) {
          expect(e.error, mockException);
          expect(e.stackTrace, isNotNull);
        }
      });
    });
  });
}
