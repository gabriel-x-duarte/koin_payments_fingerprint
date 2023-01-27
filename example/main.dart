import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

import 'package:koin_payments_fingerprint/koin_payments_fingerprint.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  //static const String _sessionId = "233c8675-e227-4198-b4ca-15e3590876ff";

  /// To always get the same "crossApplicationUniqueId"
  /// with this example, just pass a fixed instalationDate
  static final instalationDate =
      DateTime.now().subtract(const Duration(days: 90));
  //static final instalationDate = DateTime(2000);

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
          "wireless": "192.168.1.103",
          "wired": "ipWired"
        }
      },
      "networkType": "Unknown,Unknown",
      "isp": ",TIM"
    }
  };

  int _counter = 0;

  Map<String, dynamic>? _fingerprintSent;
  Map<String, dynamic>? _requestResponse;

  @override
  void initState() {
    super.initState();
  }

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

      throw Exception("Platform not surpoted");
    }

    final MobileApplication mobileApplication = Platform.isIOS
        ? await _gatherIosMobileApplicationInformation()
        : await _gatherAndroidMobileApplicationInformation();

    final Fingerprint fingerprint = Fingerprint(
      organizationId: _organizationId,
      //sessionId: _sessionId,
      mobileApplication: mobileApplication,
    );

    checkTestFingerprint(fingerprint); // false

    fingerprint == Fingerprint.from(fingerprint); // true

    final Fingerprint newFingerprint = Fingerprint(
      organizationId: _organizationId,
      mobileApplication: mobileApplication,
    ); // This newFingerprint is generated using the same information

    fingerprint ==
        newFingerprint; // false, because the newFingerprint has a different sessionId

    fingerprint ==
        newFingerprint.copyWith(
          sessionId: fingerprint.sessionId,
        ); // true, because if the information inside mobileApplication did not change, both fingerprints have the same information

    await sendDeviceFingerprintInformation(fingerprint);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  bool checkTestFingerprint(Fingerprint fingerprint) {
    final Fingerprint testFingerprint = Fingerprint.fromMap(_testJson);

    return fingerprint == testFingerprint;
  }

  /// Android only!
  Future<MobileApplication> _gatherAndroidMobileApplicationInformation() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    /// Start gathering data
    ///
    final MobileApplication testMobileApplication =
        MobileApplication.fromMap(const {});

    ///

    /// Device Unique Id
    final deviceUniqueId = androidInfo.id;

    /// Application
    final String applicationPackageName = packageInfo.packageName;
    final String applicationName = packageInfo.appName;
    final String applicationNamespace = applicationPackageName.substring(
      0,
      (applicationPackageName.length - ".$applicationName".length),
    );
    final String applicationVersion = packageInfo.version;
    final DateTime applicationInstallationDate = instalationDate;
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

    /// Connectivity
    final networkInterfaces = await NetworkInterface.list();

    String? ipAddress;

    for (var interface in networkInterfaces) {
      if (ipAddress != null) {
        break;
      }

      for (var addr in interface.addresses) {
        if (addr.address.isNotEmpty) {
          ipAddress = addr.address;

          break;
        }
      }
    }

    final Connectivity connectivity = Connectivity(
      ipAddresses: IpAddresses(
        line: "",
        wireless: ipAddress ?? "",
        wired: "",
      ),
    );

    ///

    final MobileApplication mobileApplication = testMobileApplication.copyWith(
      deviceUniqueId: deviceUniqueId,
      application: application,
      operativeSystem: operativeSystem,
      device: device,
      screen: screen,
      connectivity: connectivity,
    );

    return mobileApplication;
  }

  /// IOS only!
  Future<MobileApplication> _gatherIosMobileApplicationInformation() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

    /// Start gathering data
    ///
    final MobileApplication testMobileApplication =
        MobileApplication.fromMap(const {});

    ///

    /// Device Unique Id
    final deviceUniqueId = iosInfo.identifierForVendor ?? "";

    /// Application
    final String applicationPackageName = packageInfo.packageName;
    final String applicationName = packageInfo.appName;
    final String applicationNamespace = applicationPackageName.substring(
      0,
      (applicationPackageName.length - ".$applicationName".length),
    );
    final String applicationVersion = packageInfo.version;
    final DateTime applicationInstallationDate = instalationDate;

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

    /// Connectivity
    final networkInterfaces = await NetworkInterface.list();

    String? ipAddress;

    for (var interface in networkInterfaces) {
      if (ipAddress != null) {
        break;
      }

      for (var addr in interface.addresses) {
        if (addr.address.isNotEmpty) {
          ipAddress = addr.address;

          break;
        }
      }
    }

    final Connectivity connectivity = Connectivity(
      ipAddresses: IpAddresses(
        line: "",
        wireless: ipAddress ?? "",
        wired: "",
      ),
    );

    ///

    final MobileApplication mobileApplication = testMobileApplication.copyWith(
      deviceUniqueId: deviceUniqueId,
      application: application,
      operativeSystem: operativeSystem,
      device: device,
      screen: screen,
      connectivity: connectivity,
    );

    return mobileApplication;
  }

  /// Sends fingerprint by http request
  Future<bool> sendDeviceFingerprintInformation(
    Fingerprint fingerprint, {
    bool sandbox = true,
  }) async {
    const String sandboxUrl = KoinPaymentsFingerprint.sandboxUrl;
    const String productionUrl = "";

    final String url = sandbox ? sandboxUrl : productionUrl;

    setState(() {
      _fingerprintSent = fingerprint.toMap();
    });

    final res = await http.post(
      Uri.parse(url),
      body: fingerprint.toJson(),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
    );

    if (res.body.isNotEmpty) {
      setState(() {
        _requestResponse = jsonDecode(res.body);
      });
    } else {
      setState(() {
        _requestResponse = <String, String>{
          "Error": "Response body returned empty",
        };
      });
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Fingerprint information:"),
                      const SizedBox(
                        height: 5,
                      ),
                      _fingerprintSent != null
                          ? JsonViewer(_fingerprintSent)
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Response:"),
                      const SizedBox(
                        height: 5,
                      ),
                      _requestResponse != null
                          ? JsonViewer(_requestResponse)
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
