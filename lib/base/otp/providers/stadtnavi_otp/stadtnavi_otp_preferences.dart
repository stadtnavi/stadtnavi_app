import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/city_bike_utils.dart';
import 'package:stadtnavi_core/configuration/config_default/config_default/default_settings.dart';
import 'package:trufi_core/base/models/enums/transport_mode.dart';

import 'package:stadtnavi_core/base/otp/enums/enums_plan/enums_plan.dart';

/// Routing preferences for stadtnavi OTP provider.
///
/// Self-persisting via Hive (same format as the legacy SettingFetchCubit
/// for backward compatibility).
///
/// Follows the trufi_core pattern where preferences are encapsulated
/// inside the provider and accessed internally when building queries.
class StadtnaviOtpPreferences extends ChangeNotifier {
  static const String _boxPath = "state_setting_panel";

  late Box _box;
  bool _initialized = false;

  WalkingSpeed _walkSpeed = WalkingSpeed.average;
  bool _avoidWalking = false;
  List<TransportMode> _transportModes = defaultTransportModes;
  List<BikeRentalNetwork> _bikeRentalNetworks = defaultBikeRentalNetworks;
  TriangleFactor _triangleFactor = TriangleFactor.unknown;
  bool _avoidTransfers = false;
  bool _includeBikeSuggestions = true;
  BicycleParkingFilter _bicycleParkingFilter = BicycleParkingFilter.all;
  BikingSpeed _bikeSpeed = BikingSpeed.average;
  bool _showBikeAndParkItineraries = true;
  bool _includeParkAndRideSuggestions = true;
  bool _includeCarSuggestions = false;
  bool _wheelchair = false;
  Set<String> _allowedVehicleRentalFormFactors = <String>{};
  List<String> _allowedVehicleRentalNetworks = <String>[];

  // Getters
  bool get isInitialized => _initialized;
  WalkingSpeed get walkSpeed => _walkSpeed;
  bool get avoidWalking => _avoidWalking;
  List<TransportMode> get transportModes => List.unmodifiable(_transportModes);
  List<BikeRentalNetwork> get bikeRentalNetworks =>
      List.unmodifiable(_bikeRentalNetworks);
  TriangleFactor get triangleFactor => _triangleFactor;
  bool get avoidTransfers => _avoidTransfers;
  bool get includeBikeSuggestions => _includeBikeSuggestions;
  BicycleParkingFilter get bicycleParkingFilter => _bicycleParkingFilter;
  BikingSpeed get bikeSpeed => _bikeSpeed;
  bool get showBikeAndParkItineraries => _showBikeAndParkItineraries;
  bool get includeParkAndRideSuggestions => _includeParkAndRideSuggestions;
  bool get includeCarSuggestions => _includeCarSuggestions;
  bool get wheelchair => _wheelchair;
  Set<String> get allowedVehicleRentalFormFactors =>
      Set.unmodifiable(_allowedVehicleRentalFormFactors);
  List<String> get allowedVehicleRentalNetworks =>
      List.unmodifiable(_allowedVehicleRentalNetworks);

  /// Initialize preferences from Hive storage.
  ///
  /// Uses the same Hive box and JSON format as the legacy SettingFetchCubit
  /// for backward compatibility.
  Future<void> initialize() async {
    if (_initialized) return;
    _box = Hive.box(_boxPath);
    final jsonString = _box.get(_boxPath);
    if (jsonString != null && jsonString.isNotEmpty) {
      _loadFromJson(jsonDecode(jsonString) as Map<String, dynamic>);
    } else {
      _allowedVehicleRentalNetworks =
          CityBikeUtils.getDefaultNetworks(ConfigDefault.value);
    }
    _initialized = true;
    notifyListeners();
  }

  // Setters

  void setWalkingSpeed(WalkingSpeed speed) {
    _walkSpeed = speed;
    _save();
  }

  void setAvoidWalking(bool value) {
    _avoidWalking = value;
    _save();
  }

  void toggleTransportMode(TransportMode mode) {
    final newList = [..._transportModes];
    if (newList.contains(mode)) {
      newList.remove(mode);
    } else {
      newList.add(mode);
    }
    _transportModes = newList;
    _save();
  }

  void toggleBikeRentalNetwork(BikeRentalNetwork network) {
    final newList = [..._bikeRentalNetworks];
    if (newList.contains(network)) {
      newList.remove(network);
    } else {
      newList.add(network);
    }
    _bikeRentalNetworks = newList;
    _save();
  }

  void setTriangleFactor(TriangleFactor factor) {
    _triangleFactor = factor;
    _save();
  }

  void setAvoidTransfers(bool value) {
    _avoidTransfers = value;
    _save();
  }

  void setIncludeBikeSuggestions(bool value) {
    _includeBikeSuggestions = value;
    _save();
  }

  void setBicycleParkingFilter(BicycleParkingFilter filter) {
    _bicycleParkingFilter = filter;
    _save();
  }

  void setBikingSpeed(BikingSpeed speed) {
    _bikeSpeed = speed;
    _save();
  }

  void setShowBikeAndParkItineraries(bool value) {
    _showBikeAndParkItineraries = value;
    _save();
  }

  void setIncludeParkAndRideSuggestions(bool value) {
    _includeParkAndRideSuggestions = value;
    _save();
  }

  void setIncludeCarSuggestions(bool value) {
    _includeCarSuggestions = value;
    _save();
  }

  void setWheelchair(bool value) {
    _wheelchair = value;
    _save();
  }

  void setAllowedVehicleRentalFormFactors(Set<String> factors) {
    _allowedVehicleRentalFormFactors = {...factors};
    _save();
  }

  void addVehicleRentalFormFactor(String factor) {
    _allowedVehicleRentalFormFactors = {
      ..._allowedVehicleRentalFormFactors,
      factor,
    };
    _save();
  }

  void removeVehicleRentalFormFactor(String factor) {
    _allowedVehicleRentalFormFactors = {
      ..._allowedVehicleRentalFormFactors,
    }..remove(factor);
    _save();
  }

  void setAllowedVehicleRentalNetworks(List<String> networks) {
    _allowedVehicleRentalNetworks = [...networks];
    _save();
  }

  void addVehicleRentalNetworks(List<String> networkIds) {
    final temp = [..._allowedVehicleRentalNetworks];
    temp.addAll(networkIds.where((e) => !temp.contains(e)));
    _allowedVehicleRentalNetworks = temp;
    _save();
  }

  void removeVehicleRentalNetworks(List<String> networkIds) {
    final temp = [..._allowedVehicleRentalNetworks];
    temp.removeWhere((e) => networkIds.contains(e));
    _allowedVehicleRentalNetworks = temp;
    _save();
  }

  /// Reset all preferences to their defaults.
  void reset() {
    _walkSpeed = WalkingSpeed.average;
    _avoidWalking = false;
    _transportModes = defaultTransportModes;
    _bikeRentalNetworks = defaultBikeRentalNetworks;
    _triangleFactor = TriangleFactor.unknown;
    _avoidTransfers = false;
    _includeBikeSuggestions = true;
    _bicycleParkingFilter = BicycleParkingFilter.all;
    _bikeSpeed = BikingSpeed.average;
    _showBikeAndParkItineraries = true;
    _includeParkAndRideSuggestions = true;
    _includeCarSuggestions = false;
    _wheelchair = false;
    _allowedVehicleRentalFormFactors = <String>{};
    _allowedVehicleRentalNetworks =
        CityBikeUtils.getDefaultNetworks(ConfigDefault.value);
    _save();
  }

  // Persistence (same JSON format as legacy SettingFetchState)

  void _save() {
    _box.put(_boxPath, jsonEncode(_toJson()));
    notifyListeners();
  }

  void _loadFromJson(Map<String, dynamic> json) {
    _walkSpeed = getWalkingSpeed(json['typeWalkingSpeed'] as String);
    _avoidWalking = json['avoidWalking'] as bool;
    _transportModes = (json['transportModes'] as List)
        .map<TransportMode>((key) => getTransportMode(mode: key as String))
        .toList();
    _bikeRentalNetworks = (json['bikeRentalNetworks'] as List)
        .map<BikeRentalNetwork>((key) => getBikeRentalNetwork(key as String))
        .toList();
    _triangleFactor =
        getTriangleFactorByString(json['triangleFactor'] as String);
    _avoidTransfers = json['avoidTransfers'] as bool;
    _includeBikeSuggestions = json['includeBikeSuggestions'] as bool;
    _bicycleParkingFilter =
        getBicycleParkingFilter(json['bicycleParkingFilter'] as String);
    _bikeSpeed = getBikingSpeed(json['typeBikingSpeed'] as String);
    _showBikeAndParkItineraries = json['showBikeAndParkItineraries'] as bool;
    _includeParkAndRideSuggestions =
        json['includeParkAndRideSuggestions'] as bool;
    _includeCarSuggestions = json['includeCarSuggestions'] as bool;
    _wheelchair = json['wheelchair'] as bool;
    _allowedVehicleRentalFormFactors =
        (json['allowedVehicleRentalFormFactors'] as List<dynamic>?)
                ?.map((item) => item as String)
                .toSet() ??
            <String>{};
    _allowedVehicleRentalNetworks =
        (json['allowedVehicleRentalNetworks'] as List<dynamic>?)
                ?.map((item) => item as String)
                .toList() ??
            <String>[];
  }

  Map<String, dynamic> _toJson() {
    return {
      'typeWalkingSpeed': _walkSpeed.name,
      'avoidWalking': _avoidWalking,
      'transportModes':
          _transportModes.map((mode) => mode.name).toList(),
      'bikeRentalNetworks':
          _bikeRentalNetworks.map((network) => network.name).toList(),
      'triangleFactor': _triangleFactor.name,
      'avoidTransfers': _avoidTransfers,
      'includeBikeSuggestions': _includeBikeSuggestions,
      'bicycleParkingFilter': _bicycleParkingFilter.name,
      'typeBikingSpeed': _bikeSpeed.name,
      'showBikeAndParkItineraries': _showBikeAndParkItineraries,
      'includeParkAndRideSuggestions': _includeParkAndRideSuggestions,
      'includeCarSuggestions': _includeCarSuggestions,
      'wheelchair': _wheelchair,
      'arriveBy': false,
      'date': null,
      'allowedVehicleRentalFormFactors':
          _allowedVehicleRentalFormFactors.toList(),
      'allowedVehicleRentalNetworks': _allowedVehicleRentalNetworks,
    };
  }
}
