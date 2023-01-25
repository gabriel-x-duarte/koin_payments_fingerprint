part of '../koin_payments_fingerprint.dart';

class Fingerprint extends DataEquality {
  final String organizationId;
  final String sessionId;
  final MobileApplication mobileApplication;

  const Fingerprint({
    required this.organizationId,
    required this.sessionId,
    required this.mobileApplication,
  });

  factory Fingerprint.from(Fingerprint fingerprint) {
    return Fingerprint(
      organizationId: fingerprint.organizationId,
      sessionId: fingerprint.sessionId,
      mobileApplication: MobileApplication.from(fingerprint.mobileApplication),
    );
  }

  factory Fingerprint.fromMap(Map<String, dynamic> data) {
    final String organizationId = data['organizationId'] ?? "";
    final String sessionId = data['sessionId'] ?? "";
    final Map<String, dynamic> mobileApplicationData =
        Map<String, dynamic>.from(
      data['mobileApplication'] ?? {},
    );

    return Fingerprint(
      organizationId: organizationId,
      sessionId: sessionId,
      mobileApplication: MobileApplication.fromMap(mobileApplicationData),
    );
  }

  @override
  Fingerprint copyWith({
    String? organizationId,
    String? sessionId,
    MobileApplication? mobileApplication,
  }) {
    return Fingerprint(
      organizationId: organizationId ?? this.organizationId,
      sessionId: sessionId ?? this.sessionId,
      mobileApplication: mobileApplication ?? this.mobileApplication,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['organizationId'] = organizationId;
    data['sessionId'] = sessionId;
    data['mobileApplication'] = mobileApplication.toMap();

    return data;
  }
}

class MobileApplication extends DataEquality {
  final String crossApplicationUniqueId;
  final Application application;
  final OperativeSystem operativeSystem;
  final Device device;
  final Screen screen;
  final Hardware hardware;
  final Connectivity connectivity;
  final String networkType;
  final String isp;

  const MobileApplication._({
    required this.crossApplicationUniqueId,
    required this.application,
    required this.operativeSystem,
    required this.device,
    required this.screen,
    required this.hardware,
    required this.connectivity,
    required this.networkType,
    required this.isp,
  });

  MobileApplication({
    required Application application,
    required OperativeSystem operativeSystem,
    required Device device,
    required Screen screen,
    required Hardware hardware,
    required Connectivity connectivity,
    required String networkType,
    required String isp,
  }) : this._(
          crossApplicationUniqueId:
              "${"${application.hashCode}${operativeSystem.hashCode}".hashCode}.${"${application.hashCode}${device.hashCode}".hashCode}.${"${application.hashCode}${screen.hashCode}".hashCode}.${"${application.hashCode}${hardware.hashCode}".hashCode}.${"${application.hashCode}${connectivity.hashCode}".hashCode}",
          application: application,
          operativeSystem: operativeSystem,
          device: device,
          screen: screen,
          hardware: hardware,
          connectivity: connectivity,
          networkType: networkType,
          isp: isp,
        );

  factory MobileApplication.from(MobileApplication mobileApplication) {
    return MobileApplication(
      application: Application.from(mobileApplication.application),
      operativeSystem: OperativeSystem.from(mobileApplication.operativeSystem),
      device: Device.from(mobileApplication.device),
      screen: Screen.from(mobileApplication.screen),
      hardware: Hardware.from(mobileApplication.hardware),
      connectivity: Connectivity.from(mobileApplication.connectivity),
      networkType: mobileApplication.networkType,
      isp: mobileApplication.isp,
    );
  }

  factory MobileApplication.fromMap(Map<String, dynamic> data) {
    final Map<String, dynamic> applicationData = Map<String, dynamic>.from(
      data['application'] ?? {},
    );
    final Map<String, dynamic> operativeSystemData = Map<String, dynamic>.from(
      data['operativeSystem'] ?? {},
    );
    final Map<String, dynamic> deviceData = Map<String, dynamic>.from(
      data['device'] ?? {},
    );
    final Map<String, dynamic> screenData = Map<String, dynamic>.from(
      data['screen'] ?? {},
    );
    final Map<String, dynamic> hardwareData = Map<String, dynamic>.from(
      data['hardware'] ?? {},
    );
    final Map<String, dynamic> connectivityData = Map<String, dynamic>.from(
      data['connectivity'] ?? {},
    );
    final String networkType = data['networkType'] ?? "";
    final String isp = data['isp'] ?? "";

    return MobileApplication(
      application: Application.fromMap(applicationData),
      operativeSystem: OperativeSystem.fromMap(operativeSystemData),
      device: Device.fromMap(deviceData),
      screen: Screen.fromMap(screenData),
      hardware: Hardware.fromMap(hardwareData),
      connectivity: Connectivity.fromMap(connectivityData),
      networkType: networkType,
      isp: isp,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['crossApplicationUniqueId'] = crossApplicationUniqueId;
    data['application'] = application.toMap();
    data['operativeSystem'] = operativeSystem.toMap();
    data['device'] = device.toMap();
    data['screen'] = screen.toMap();
    data['hardware'] = hardware.toMap();
    data['connectivity'] = connectivity.toMap();
    data['networkType'] = networkType;
    data['isp'] = isp;

    return data;
  }

  @override
  MobileApplication copyWith({
    String? crossApplicationUniqueId,
    Application? application,
    OperativeSystem? operativeSystem,
    Device? device,
    Screen? screen,
    Hardware? hardware,
    Connectivity? connectivity,
    String? networkType,
    String? isp,
  }) {
    return MobileApplication(
      application: application ?? this.application,
      operativeSystem: operativeSystem ?? this.operativeSystem,
      device: device ?? this.device,
      screen: screen ?? this.screen,
      hardware: hardware ?? this.hardware,
      connectivity: connectivity ?? this.connectivity,
      networkType: networkType ?? this.networkType,
      isp: isp ?? this.isp,
    );
  }
}

class Application extends DataEquality {
  final DateTime installationDate;
  final String namespace;
  final String version;
  final String name;
  final String androidId;
  final String advertisingId;

  const Application({
    required this.installationDate,
    required this.namespace,
    required this.version,
    required this.name,
    required this.androidId,
    required this.advertisingId,
  });

  factory Application.from(Application application) {
    return Application(
      installationDate: application.installationDate,
      namespace: application.namespace,
      version: application.version,
      name: application.name,
      androidId: application.androidId,
      advertisingId: application.advertisingId,
    );
  }

  factory Application.fromMap(Map<String, dynamic> data) {
    final DateTime installationDate =
        DateTime.tryParse(data['installationDate'] ?? "") ?? DateTime.now();
    final String namespace = data['namespace'] ?? "";
    final String version = data['version'] ?? "";
    final String name = data['name'] ?? "";
    final String androidId = data['androidId'] ?? "";
    final String advertisingId = data['advertisingId'] ?? "";

    return Application(
      installationDate: installationDate,
      namespace: namespace,
      version: version,
      name: name,
      androidId: androidId,
      advertisingId: advertisingId,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['installationDate'] = installationDate.toIso8601String();
    data['namespace'] = namespace;
    data['version'] = version;
    data['name'] = name;
    data['androidId'] = androidId;
    data['advertisingId'] = advertisingId;

    return data;
  }

  @override
  Application copyWith({
    DateTime? installationDate,
    String? namespace,
    String? version,
    String? name,
    String? androidId,
    String? advertisingId,
  }) {
    return Application(
      installationDate: installationDate ?? this.installationDate,
      namespace: namespace ?? this.namespace,
      version: version ?? this.version,
      name: name ?? this.name,
      androidId: androidId ?? this.androidId,
      advertisingId: advertisingId ?? this.advertisingId,
    );
  }
}

class OperativeSystem extends DataEquality {
  final String version;
  final int apiLevel;
  final String id;
  final String name;

  const OperativeSystem({
    required this.version,
    required this.apiLevel,
    required this.id,
    required this.name,
  });

  factory OperativeSystem.from(OperativeSystem operativeSystem) {
    return OperativeSystem(
      version: operativeSystem.version,
      apiLevel: operativeSystem.apiLevel,
      id: operativeSystem.id,
      name: operativeSystem.name,
    );
  }

  factory OperativeSystem.fromMap(Map<String, dynamic> data) {
    final String version = data['version'] ?? "";
    final int apiLevel = data['apiLevel'] ?? 0;
    final String id = data['id'] ?? "";
    final String name = data['name'] ?? "";

    return OperativeSystem(
      version: version,
      apiLevel: apiLevel,
      id: id,
      name: name,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['version'] = version;
    data['apiLevel'] = apiLevel;
    data['id'] = id;
    data['name'] = name;

    return data;
  }

  @override
  OperativeSystem copyWith({
    String? version,
    int? apiLevel,
    String? id,
    String? name,
  }) {
    return OperativeSystem(
      version: version ?? this.version,
      apiLevel: apiLevel ?? this.apiLevel,
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

class Device extends DataEquality {
  final String name;
  final String model;
  final Battery battery;
  final String language;

  const Device({
    required this.name,
    required this.model,
    required this.battery,
    required this.language,
  });

  factory Device.from(Device device) {
    return Device(
      name: device.name,
      model: device.model,
      battery: device.battery,
      language: device.language,
    );
  }

  factory Device.fromMap(Map<String, dynamic> data) {
    final String name = data['name'] ?? "";
    final String model = data['model'] ?? "";
    final Map<String, dynamic> batteryData = Map<String, dynamic>.from(
      data['battery'] ?? {},
    );
    final String language = data['language'] ?? "";

    return Device(
      name: name,
      model: model,
      battery: Battery.fromMap(batteryData),
      language: language,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['model'] = model;
    data['battery'] = battery.toMap();
    data['language'] = language;

    return data;
  }

  @override
  Device copyWith({
    String? name,
    String? model,
    Battery? battery,
    String? language,
  }) {
    return Device(
      name: name ?? this.name,
      model: model ?? this.model,
      battery: battery ?? this.battery,
      language: language ?? this.language,
    );
  }
}

class Battery extends DataEquality {
  final String status;
  final String type;
  final int level;

  const Battery({
    required this.status,
    required this.type,
    required this.level,
  });

  factory Battery.from(Battery battery) {
    return Battery(
      status: battery.status,
      type: battery.type,
      level: battery.level,
    );
  }

  factory Battery.fromMap(Map<String, dynamic> data) {
    final String status = data['status'] ?? "";
    final String type = data['type'] ?? "";
    final int level = data['level'] ?? 0;

    return Battery(
      status: status,
      type: type,
      level: level,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['status'] = status;
    data['type'] = type;
    data['level'] = level;

    return data;
  }

  @override
  Battery copyWith({
    String? status,
    String? type,
    int? level,
  }) {
    return Battery(
      status: status ?? this.status,
      type: type ?? this.type,
      level: level ?? this.level,
    );
  }
}

class Screen extends DataEquality {
  final String resolution;
  final String orientation;

  const Screen({
    required this.resolution,
    required this.orientation,
  });

  factory Screen.from(Screen screen) {
    return Screen(
      resolution: screen.resolution,
      orientation: screen.orientation,
    );
  }

  factory Screen.fromMap(Map<String, dynamic> data) {
    final String resolution = data['resolution'] ?? "";
    final String orientation = data['orientation'] ?? "";

    return Screen(
      resolution: resolution,
      orientation: orientation,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['resolution'] = resolution;
    data['orientation'] = orientation;

    return data;
  }

  @override
  Screen copyWith({
    String? resolution,
    String? orientation,
  }) {
    return Screen(
      resolution: resolution ?? this.resolution,
      orientation: orientation ?? this.orientation,
    );
  }
}

class Hardware extends DataEquality {
  final String cpuArchitecture;
  final int cpuCores;
  final List<String> sensors;
  final bool wifiAvailable;
  final bool multitouchAvailable;

  const Hardware({
    required this.cpuArchitecture,
    required this.cpuCores,
    required this.sensors,
    required this.wifiAvailable,
    required this.multitouchAvailable,
  });

  factory Hardware.from(Hardware hardware) {
    return Hardware(
      cpuArchitecture: hardware.cpuArchitecture,
      cpuCores: hardware.cpuCores,
      sensors: hardware.sensors,
      wifiAvailable: hardware.wifiAvailable,
      multitouchAvailable: hardware.multitouchAvailable,
    );
  }

  factory Hardware.fromMap(Map<String, dynamic> data) {
    final String cpuArchitecture = data['cpuArchitecture'] ?? "";
    final int cpuCores = data['cpuCores'] ?? 0;
    final List<String> sensors = List<String>.from(
      data['sensors'] ?? [],
    );
    final bool wifiAvailable = data['wifiAvailable'] ?? false;
    final bool multitouchAvailable = data['multitouchAvailable'] ?? false;

    return Hardware(
      cpuArchitecture: cpuArchitecture,
      cpuCores: cpuCores,
      sensors: sensors,
      wifiAvailable: wifiAvailable,
      multitouchAvailable: multitouchAvailable,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['cpuArchitecture'] = cpuArchitecture;
    data['cpuCores'] = cpuCores;
    data['sensors'] = sensors;
    data['wifiAvailable'] = wifiAvailable;
    data['multitouchAvailable'] = multitouchAvailable;

    return data;
  }

  @override
  Hardware copyWith({
    String? cpuArchitecture,
    int? cpuCores,
    List<String>? sensors,
    bool? wifiAvailable,
    bool? multitouchAvailable,
  }) {
    return Hardware(
      cpuArchitecture: cpuArchitecture ?? this.cpuArchitecture,
      cpuCores: cpuCores ?? this.cpuCores,
      sensors: sensors ?? this.sensors,
      wifiAvailable: wifiAvailable ?? this.wifiAvailable,
      multitouchAvailable: multitouchAvailable ?? this.multitouchAvailable,
    );
  }
}

class Connectivity extends DataEquality {
  final IpAddresses ipAddresses;

  const Connectivity({
    required this.ipAddresses,
  });

  factory Connectivity.from(Connectivity connectivity) {
    return Connectivity(
      ipAddresses: IpAddresses.from(connectivity.ipAddresses),
    );
  }

  factory Connectivity.fromMap(Map<String, dynamic> data) {
    final Map<String, dynamic> ipAddressesData = Map<String, dynamic>.from(
      data['ipAddresses'] ?? {},
    );

    return Connectivity(
      ipAddresses: IpAddresses.fromMap(ipAddressesData),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['ipAddresses'] = ipAddresses.toMap();

    return data;
  }

  @override
  Connectivity copyWith({
    IpAddresses? ipAddresses,
  }) {
    return Connectivity(
      ipAddresses: ipAddresses ?? this.ipAddresses,
    );
  }
}

class IpAddresses extends DataEquality {
  final String line;
  final String wireless;
  final String wired;

  const IpAddresses({
    required this.line,
    required this.wireless,
    required this.wired,
  });

  factory IpAddresses.from(IpAddresses ipAddresses) {
    return IpAddresses(
      line: ipAddresses.line,
      wireless: ipAddresses.wireless,
      wired: ipAddresses.wired,
    );
  }

  factory IpAddresses.fromMap(Map<String, dynamic> data) {
    final String line = data['line'] ?? "";
    final String wireless = data['wireless'] ?? "";
    final String wired = data['wired'] ?? "";

    return IpAddresses(
      line: line,
      wireless: wireless,
      wired: wired,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['line'] = line;
    data['wireless'] = wireless;
    data['wired'] = wired;

    return data;
  }

  @override
  IpAddresses copyWith({
    String? line,
    String? wireless,
    String? wired,
  }) {
    return IpAddresses(
      line: line ?? this.line,
      wireless: wireless ?? this.wireless,
      wired: wired ?? this.wired,
    );
  }
}
