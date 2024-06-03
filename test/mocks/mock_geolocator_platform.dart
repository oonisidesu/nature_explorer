import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:mockito/mockito.dart';

class MockGeolocatorPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements GeolocatorPlatform {
  @override
  Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
    Duration? timeLimit,
  }) {
    return super.noSuchMethod(
      Invocation.method(
        #getCurrentPosition,
        [],
        {
          #desiredAccuracy: desiredAccuracy,
          #forceAndroidLocationManager: forceAndroidLocationManager,
          #timeLimit: timeLimit,
        },
      ),
      returnValue: Future.value(Position(
        latitude: 0.0,
        longitude: 0.0,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      )),
      returnValueForMissingStub: Future.value(Position(
        latitude: 0.0,
        longitude: 0.0,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      )),
    );
  }

  @override
  Future<bool> isLocationServiceEnabled() {
    return super.noSuchMethod(
      Invocation.method(#isLocationServiceEnabled, []),
      returnValue: Future.value(true),
      returnValueForMissingStub: Future.value(true),
    );
  }

  @override
  Future<LocationPermission> checkPermission() {
    return super.noSuchMethod(
      Invocation.method(#checkPermission, []),
      returnValue: Future.value(LocationPermission.always),
      returnValueForMissingStub: Future.value(LocationPermission.always),
    );
  }
}
