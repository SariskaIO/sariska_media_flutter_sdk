// import 'package:flutter_test/flutter_test.dart';
// import 'package:sariska_media_flutter_sdk/SariskaMediaTransport.dart';
// import 'package:sariska_media_flutter_sdk/SariskaMediaTransportInterface.dart';
// import 'package:sariska_media_flutter_sdk/SariskaMediaTransportMethodChannel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockSariskaMediaTransportPlatform
//     with MockPlatformInterfaceMixin
//     implements SariskaMediaTransportInterface {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final SariskaMediaTransportInterface initialPlatform = SariskaMediaTransportInterface.instance;
//
//   test('$SariskaMediaTransportMethodChannel is the default instance', () {
//     expect(initialPlatform, isInstanceOf<SariskaMediaTransportMethodChannel>());
//   });
//
//   test('getPlatformVersion', () async {
//     SariskaMediaTransport sariskaMediaFlutterSdkPlugin = SariskaMediaTransport();
//     MockSariskaMediaFlutterSdkPlatform fakePlatform = MockSariskaMediaFlutterSdkPlatform();
//     SariskaMediaTransportInterface.instance = fakePlatform;
//
//     expect(await sariskaMediaFlutterSdkPlugin.getPlatformVersion(), '42');
//   });
// }
