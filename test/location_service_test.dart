import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:nature_explorer/location_service.dart';

class MockGeolocatorPlatform extends Mock implements GeolocatorPlatform {}

void main() {
  group('LocationService', () {
    late LocationService locationService;
    late MockGeolocatorPlatform mockGeolocatorPlatform;

    setUp(() {
      locationService = LocationService();
      mockGeolocatorPlatform = MockGeolocatorPlatform();
      GeolocatorPlatform.instance = mockGeolocatorPlatform;
    });

    test('should get current location', () async {
      final position = Position(
          latitude: 35.6895,
          longitude: 139.6917,
          timestamp: DateTime.now(),
          accuracy: 1.0,
          altitude: 1.0,
          heading: 1.0,
          speed: 1.0,
          speedAccuracy: 1.0);

      when(mockGeolocatorPlatform.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high))
          .thenAnswer((_) async => position);

      final result = await locationService.getCurrentLocation();

      expect(result, position);
    });
  });
}
