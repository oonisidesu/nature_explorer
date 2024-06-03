import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import '../lib/location_service.dart';
import 'mocks/mock_geolocator_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocationService', () {
    final mockGeolocatorPlatform = MockGeolocatorPlatform();
    final locationService = LocationService();

    setUp(() {
      GeolocatorPlatform.instance = mockGeolocatorPlatform;
    });

    test('should get current location', () async {
      final position = Position(
        latitude: 35.6895,
        longitude: 139.6917,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );

      when(mockGeolocatorPlatform.getCurrentPosition())
          .thenAnswer((_) async => position);
      when(mockGeolocatorPlatform.isLocationServiceEnabled())
          .thenAnswer((_) async => true);
      when(mockGeolocatorPlatform.checkPermission())
          .thenAnswer((_) async => LocationPermission.always);

      final result = await locationService.getCurrentLocation();

      expect(result, isNotNull);
      expect(result.latitude, 35.6895);
      expect(result.longitude, 139.6917);
    });
  });
}
