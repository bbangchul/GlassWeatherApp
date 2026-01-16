import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// 위치 권한 확인 → (필요 시) 요청 → 현재 위치 반환
///
/// 반환값:
/// - 성공: Position
/// - 실패/거부: null
class GetLocation {
  final LocationSettings locationSettings;

  GetLocation({LocationSettings? locationSettings})
    : locationSettings =
          locationSettings ??
          const LocationSettings(
            accuracy: LocationAccuracy.low,
            distanceFilter: 100,
          );

  Future<Position?> getLocation() async {
    try {
      // 0) 위치 서비스(기기 설정) 켜져있는지 확인
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('❌ 위치 서비스가 꺼져 있습니다. 설정에서 Location Services를 켜주세요.');
        await Geolocator.openLocationSettings();
        return null;
      }

      // 1) 권한 상태 확인
      LocationPermission permission = await Geolocator.checkPermission();

      // 2) 거부된 경우 권한 요청
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('❌ 위치 권한이 거부되었습니다.');
          return null;
        }
      }

      // 3) 영구 거부된 경우(설정에서 직접 허용 필요)
      if (permission == LocationPermission.deniedForever) {
        debugPrint('❌ 위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해야 합니다.');
        await Geolocator.openAppSettings();
        return null;
      }

      // 4) 권한 OK → 위치 가져오기
      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      debugPrint('📍 현재 위치: ${position.latitude}, ${position.longitude}');
      return position;
    } on PermissionDefinitionsNotFoundException catch (e) {
      // iOS/macOS Info.plist에 키가 없을 때
      debugPrint('❌ Info.plist 권한 정의가 없습니다: $e');
      return null;
    } on PermissionDeniedException catch (e) {
      // 사용자가 권한 거부
      debugPrint('❌ 위치 권한이 거부되었습니다: $e');
      return null;
    } on LocationServiceDisabledException catch (e) {
      debugPrint('❌ 위치 서비스가 비활성화되어 있습니다: $e');
      return null;
    } catch (e) {
      debugPrint('❌ 위치 가져오기 실패: $e');
      return null;
    }
  }
}
