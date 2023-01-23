<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

This package helps to get device fingerprint to integrate with Koin

## Features

This package will give you the json model and production and sandbox url`s

## Usage

```dart
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

import 'package:koin_payments_fingerprint/koin_payments_fingerprint.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const String _organizationId = "tZFvfVActG";
  static const String _sessionId = "233c8675-e227-4198-b4ca-15e3590876ff";

  static final instalationDate =
      DateTime.now().subtract(const Duration(days: 90));

  static const _testJson = <String, dynamic>{
    "organizationId": "tZFvfVActG",
    "sessionId": "233c8675-e227-4198-b4ca-15e3590876ff",
    "mobileApplication": {
      "crossApplicationUniqueId": "crossId",
      "application": {
        "installationDate": "2022-01-21T15:37:50.279-0300",
        "namespace": "com.xx",
        "version": "17.5.0",
        "name": "name",
        "androidId": "087455bdcd027faa",
        "advertisingId": "1ffd5f59-4563-9874-bd05-ea39f83e5b09"
      },
      "operativeSystem": {
        "version": "10",
        "apiLevel": 29,
        "id": "QKQ1.9999.002 test-keys",
        "name": "Android"
      },
      "device": {
        "name": "DeviceName",
        "model": "model",
        "battery": {"status": "discharging", "type": "Li-poly", "level": 29},
        "language": "pt-BR"
      },
      "screen": {"resolution": "1080x2340", "orientation": "portrait"},
      "hardware": {
        "cpuArchitecture": "aarch64",
        "cpuCores": 8,
        "sensors": [
          "sns_tilt  Wakeup",
          "pedometer  Wakeup",
          "pedometer  Non-wakeup",
          "pedometer  Wakeup",
          "pedometer  Non-wakeup",
          "stationary_detect_wakeup",
          "stationary_detect",
          "sns_smd  Wakeup",
          "Rotation Vector  Non-wakeup",
          "stk_stk3x3x Proximity Sensor Wakeup",
          "stk_stk3x3x Proximity Sensor Non-wakeup",
          "semtech_sx932x SAR Sensor Wakeup",
          "semtech_sx932x SAR Sensor Non-wakeup",
          "Rotation Vector  Non-wakeup",
          "pickup  Wakeup",
          "pickup  Non-wakeup",
          "motion_detect_wakeup",
          "motion_detect",
          "ak0991x Magnetometer-Uncalibrated Non-wakeup",
          "ak0991x Magnetometer Non-wakeup",
          "linear_acceleration",
          "gravity",
          "Non-wakeup",
          "sns_geomag_rv  Non-wakeup",
          "Device Orientation  Wakeup",
          "Device Orientation  Non-wakeup",
          "icm4x6xx Gyroscope Non-wakeup",
          "Game Rotation Vector  Non-wakeup",
          "icm4x6xx Gyroscope-Uncalibrated Non-wakeup",
          "stk_stk3x3x Ambient Light Sensor Wakeup",
          "stk_stk3x3x Ambient Light Sensor Non-wakeup",
          "icm4x6xx Accelerometer-Uncalibrated Non-wakeup",
          "icm4x6xx Accelerometer Non-wakeup"
        ],
        "wifiAvailable": true,
        "multitouchAvailable": true
      },
      "connectivity": {
        "ipAddresses": {
          "line": "ipLine",
          "wireless": "ipWireless",
          "wired": "ipWired"
        }
      },
      "networkType": "Unknown,Unknown",
      "isp": ",TIM"
    }
  };

  int _counter = 0;

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });

    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          ),
        );
      },
    );

    if (!Platform.isAndroid && !Platform.isIOS) {
      Navigator.of(context).pop();

      print("Platform not surpoted");
    }

    final MobileApplication mobileApplication = Platform.isIOS
        ? await _gatherIosMobileApplicationInformation()
        : await _gatherAndroidMobileApplicationInformation();

    final Fingerprint fingerprint = Fingerprint(
      organizationId: _organizationId,
      sessionId: _sessionId,
      mobileApplication: mobileApplication,
    );

    print(checkTestFingerprint(fingerprint));

    print(fingerprint == Fingerprint.from(fingerprint));

    print("data: \n");
    print(fingerprint.toString());

    final res = await sendDeviceFingerprintInformation(fingerprint);

    print("res: \n");
    print(res);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  bool checkTestFingerprint(Fingerprint fingerprint) {
    final Fingerprint testFingerprint = Fingerprint.fromMap(_testJson);

    print(
        "testFingerprint: \nHashcode: ${testFingerprint.hashCode} \ntoString: ${testFingerprint.toString()}");
    print(
        "fingerprint: \nHashcode: ${fingerprint.hashCode} \ntoString: ${fingerprint.toString()}");

    return fingerprint == testFingerprint;
  }

  /// Android only!
  static Future<MobileApplication>
      _gatherAndroidMobileApplicationInformation() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    /// Start gathering data
    ///
    final MobileApplication testMobileApplication =
        MobileApplication.fromMap(const {});

    ///

    /// Application
    final String applicationPackageName = packageInfo.packageName;
    final String applicationName = packageInfo.appName;
    final String applicationNamespace = applicationPackageName.substring(
      0,
      (applicationPackageName.length - ".$applicationName".length),
    );
    final String applicationVersion = packageInfo.version;
    final String applicationInstallationDate =
        instalationDate.toIso8601String();
    final String applicationAndroidId = androidInfo.id;

    final Application application = Application(
      installationDate: applicationInstallationDate,
      namespace: applicationNamespace,
      version: applicationVersion,
      name: applicationName,
      androidId: applicationAndroidId,
      advertisingId: "",
    );

    /// OperativeSystem
    final String operativeSystemVersion = androidInfo.version.release;
    final String operativeSystemID = androidInfo.id;
    const String operativeSystemName = "Android";
    final int operativeSystemApiLevel = androidInfo.version.sdkInt;

    final OperativeSystem operativeSystem = OperativeSystem(
      version: operativeSystemVersion,
      apiLevel: operativeSystemApiLevel,
      id: operativeSystemID,
      name: operativeSystemName,
    );

    /// Device
    final String deviceName = androidInfo.device;
    final String deviceModel = androidInfo.model;
    final String devicelanguage = Platform.localeName;

    final Device device = Device(
      name: deviceName,
      model: deviceModel,
      language: devicelanguage,
      battery: const Battery(
        status: "",
        type: "",
        level: 0,
      ),
    );

    /// Screen
    final screenWindowSize = WidgetsBinding.instance.window.physicalSize;
    final screenWindowOrientation =
        WidgetsBinding.instance.window.physicalSize.aspectRatio > 1
            ? Orientation.landscape
            : Orientation.portrait;

    final Screen screen = Screen(
      resolution:
          "${screenWindowSize.width.truncate()}x${screenWindowSize.height.truncate()}",
      orientation: screenWindowOrientation == Orientation.portrait
          ? "portrait"
          : "landscape",
    );

    ///

    final MobileApplication mobileApplication = testMobileApplication.copyWith(
      application: application,
      operativeSystem: operativeSystem,
      device: device,
      screen: screen,
    );

    return mobileApplication;
  }

  /// IOS only!
  static Future<MobileApplication>
      _gatherIosMobileApplicationInformation() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

    /// Start gathering data
    ///
    final MobileApplication testMobileApplication =
        MobileApplication.fromMap(const {});

    ///

    /// Application
    final String applicationPackageName = packageInfo.packageName;
    final String applicationName = packageInfo.appName;
    final String applicationNamespace = applicationPackageName.substring(
      0,
      (applicationPackageName.length - ".$applicationName".length),
    );
    final String applicationVersion = packageInfo.version;
    final String applicationInstallationDate =
        instalationDate.toIso8601String();

    final Application application = Application(
      installationDate: applicationInstallationDate,
      namespace: applicationNamespace,
      version: applicationVersion,
      name: applicationName,
      androidId: "",
      advertisingId: "",
    );

    /// OperativeSystem
    final String operativeSystemVersion = iosInfo.systemVersion ?? "";
    final String operativeSystemID = iosInfo.identifierForVendor ?? "";
    const String operativeSystemName = "iOS";

    final OperativeSystem operativeSystem = OperativeSystem(
      version: operativeSystemVersion,
      apiLevel: 0,
      id: operativeSystemID,
      name: operativeSystemName,
    );

    /// Device
    final String deviceName = iosInfo.name ?? "";
    final String deviceModel = iosInfo.model ?? "";
    final String devicelanguage = Platform.localeName;

    final Device device = Device(
      name: deviceName,
      model: deviceModel,
      language: devicelanguage,
      battery: const Battery(
        status: "",
        type: "",
        level: 0,
      ),
    );

    /// Screen
    final screenWindowSize = WidgetsBinding.instance.window.physicalSize;
    final screenWindowOrientation =
        WidgetsBinding.instance.window.physicalSize.aspectRatio > 1
            ? Orientation.landscape
            : Orientation.portrait;

    final Screen screen = Screen(
      resolution:
          "${screenWindowSize.width.truncate()}x${screenWindowSize.height.truncate()}",
      orientation: screenWindowOrientation == Orientation.portrait
          ? "portrait"
          : "landscape",
    );

    ///

    final MobileApplication mobileApplication = testMobileApplication.copyWith(
      application: application,
      operativeSystem: operativeSystem,
      device: device,
      screen: screen,
    );

    return mobileApplication;
  }

  /// Sends fingerprint by http request
  static Future<bool> sendDeviceFingerprintInformation(
    Fingerprint fingerprint, {
    bool sandbox = true,
  }) async {
    const String sandboxUrl = KoinPaymentsFingerprint.sandboxUrl;
    const String productionUrl = KoinPaymentsFingerprint.productionUrl;

    final String url = sandbox ? sandboxUrl : productionUrl;

    print(
      fingerprint.toJson(),
    );

    final res = await http.post(
      Uri.parse(url),
      body: fingerprint.toJson(),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
    );

    print(res.toString());
    print(res.statusCode);
    print(res.body);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

```

## Additional information

If you like this package and find it usefull, please give it a like.
