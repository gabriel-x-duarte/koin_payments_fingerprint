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

This package helps to assemble the device fingerprint information to integrate with Koin

## Features

This package will give you the json model, sandbox url and data equality comparison

## Usage
It is recomended that you send the device fingerprint at least at these two moments: 
1 - when the application starts or the user lands on first screen.
2 - when the user starts the checkout procedure (before the payment action)

You could implement a third optional method and send the device fingerprint when the user adds an item to the cart. You can also check for data equality and compare if this firgerprint is different from the last one (must provide the same sessionId) and avoid too many unnecessary requests.

It is very important that you keep the last fingerprint you generated in a variable or storage, since you'll need to use some of it's information when you submit the payment request.


```dart

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
        "language": "pt-BR",
        "screen": {"resolution": "1080x2340", "orientation": "portrait"},
      },
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
        },
        "networkType": "Unknown,Unknown",
        "isp": ",TIM"
      },
    }
  };

  void _getFingerprintAndSubmit() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
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

    fingerprint.mobileApplication ==
        newFingerprint
            .mobileApplication; // true, because both mobileApplication have the same data;

    fingerprint ==
        newFingerprint; // false, because the newFingerprint has a different sessionId

    fingerprint ==
        newFingerprint.copyWith(
          sessionId: fingerprint.sessionId,
        ); // true, because now both fingerprints have the same information

    await sendDeviceFingerprintInformation(fingerprint);
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
      screen: screen,
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
      networkType: "",
      isp: "",
    );

    ///

    final MobileApplication mobileApplication = testMobileApplication.copyWith(
      deviceUniqueId: deviceUniqueId,
      application: application,
      operativeSystem: operativeSystem,
      device: device,
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
      screen: screen,
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
      networkType: "",
      isp: "",
    );

    ///

    final MobileApplication mobileApplication = testMobileApplication.copyWith(
      deviceUniqueId: deviceUniqueId,
      application: application,
      operativeSystem: operativeSystem,
      device: device,
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

    final res = await http.post(
      Uri.parse(url),
      body: fingerprint.toJson(),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
    );

    return true;
  }

```

## Additional information

If you like this package and find it usefull, please give it a like.
