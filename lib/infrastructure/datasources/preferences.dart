import 'dart:async';

import 'package:cobble/domain/preferences.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_transform/stream_transform.dart';

// Packages that are muted by default for the crime of spam
const defaultMutedPackages = [
  "com.google.android.googlequicksearchbox",
  "de.itgecko.sharedownloader",
  "com.android.vending",
  "com.android.settings",
  "com.google.android.gms",
  "com.google.android.music",
  "com.android.chrome",
  "com.htc.vowifi",
  "com.android.providers.downloads",
  "org.mozilla.firefox",
  "com.htc.album",
  "com.dropbox.android",
  "com.lookout",
  "com.lastpass.lpandroid"
];

const defaultMutedPackagesVersion = 1;

class Preferences {
  final SharedPreferences _sharedPrefs;

  late StreamController<Preferences> _preferencesUpdateStream;
  late Stream<Preferences> preferencesUpdateStream;

  Preferences(this._sharedPrefs) {
    _preferencesUpdateStream = StreamController<Preferences>.broadcast();

    preferencesUpdateStream = _preferencesUpdateStream.stream;
  }

  Future<void> reload() async {
    await _sharedPrefs.reload();
  }

  String? getBoot() {
    if (shouldOverrideBoot() == true) {
      return getOverrideBootValue();
    }
    return _sharedPrefs.getString("boot");
  }

  Future<void> setBoot(String value) async {
    await _sharedPrefs.setString("boot", value);
    _preferencesUpdateStream.add(this);
  }

  bool? shouldOverrideBoot() {
    return _sharedPrefs.getBool("shouldOverrideBoot");
  }

  Future<void> setShouldOverrideBoot(bool value) async {
    await _sharedPrefs.setBool("shouldOverrideBoot", value);
    _preferencesUpdateStream.add(this);
  }

  String? getOverrideBootValue() {
    return _sharedPrefs.getString("bootOverrideUrl");
  }

  Future<void> setOverrideBootValue(String value) async {
    await _sharedPrefs.setString("bootOverrideUrl", value);
    _preferencesUpdateStream.add(this);
  }

  String? getLastConnectedWatchAddress() {
    return _sharedPrefs.getString("LAST_CONNECTED_WATCH");
  }

  Future<void> setLastConnectedWatchAddress(String value) async {
    await _sharedPrefs.setString("LAST_CONNECTED_WATCH", value);
    _preferencesUpdateStream.add(this);
  }

  bool? isPhoneNotificationMuteEnabled() {
    return _sharedPrefs.getBool("MUTE_PHONE_NOTIFICATIONS");
  }

  bool isWorkaroundDisabled(String workaround) {
    return _sharedPrefs.getBool("DISABLE_WORKAROUND_" + workaround) ?? false;
  }

  Future<void> setPhoneNotificationMute(bool value) async {
    await _sharedPrefs.setBool("MUTE_PHONE_NOTIFICATIONS", value);
    _preferencesUpdateStream.add(this);
  }

  bool? isPhoneCallMuteEnabled() {
    return _sharedPrefs.getBool("MUTE_PHONE_CALLS");
  }

  Future<void> setPhoneCallsMute(bool value) async {
    await _sharedPrefs.setBool("MUTE_PHONE_CALLS", value);
    _preferencesUpdateStream.add(this);
  }

  Future<void> setWorkaroundDisabled(String workaround, bool disabled) async {
    await _sharedPrefs.setBool("DISABLE_WORKAROUND_" + workaround, disabled);
    _preferencesUpdateStream.add(this);
  }

  bool? areNotificationsEnabled() {
    return _sharedPrefs.getBool("MASTER_NOTIFICATION_TOGGLE");
  }

  Future<void> setNotificationsEnabled(bool value) async {
    await _sharedPrefs.setBool("MASTER_NOTIFICATION_TOGGLE", value);
    _preferencesUpdateStream.add(this);
  }

  List<String?> getNotificationsMutedPackages() {
    return _sharedPrefs.getStringList("MUTED_NOTIF_PACKAGES") ?? defaultMutedPackages;
  }

  Future<void> setNotificationsMutedPackages(List<String?> packages) async {
    await _sharedPrefs.setStringList(
        "MUTED_NOTIF_PACKAGES", packages as List<String>);
    _preferencesUpdateStream.add(this);
  }

  bool isAppReorderPending() {
    return _sharedPrefs.getBool("APP_REORDER_PENDING") ?? false;
  }

  Future<void> setAppReorderPending(bool value) async {
    await _sharedPrefs.setBool("APP_REORDER_PENDING", value);
    _preferencesUpdateStream.add(this);
  }

  /// Is set to bool after user has connected to their first watch.
  bool hasBeenConnected() {
    return _sharedPrefs.containsKey("firstRun");
  }

  Future<void> setHasBeenConnected() async {
    await _sharedPrefs.setBool("firstRun", true);
    _preferencesUpdateStream.add(this);
  }

  bool wasSetupSuccessful() {
    return _sharedPrefs.getBool("bootSetup") ?? false;
  }

  Future<void> setWasSetupSuccessful(bool value) async {
    await _sharedPrefs.setBool("bootSetup", value);
    _preferencesUpdateStream.add(this);
  }

  DateTime? getOAuthTokenCreationDate() {
    final timestamp = _sharedPrefs.getInt("oauthTokenCreationDate");
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  Future<void> setOAuthTokenCreationDate(DateTime? value) async {
    if (value == null) {
      await _sharedPrefs.remove("oauthTokenCreationDate");
    } else {
      await _sharedPrefs.setInt(
          "oauthTokenCreationDate", value.millisecondsSinceEpoch);
    }
    _preferencesUpdateStream.add(this);
  }

  int? getDefaultMutedPackagesVersion() {
    return _sharedPrefs.getInt("DEFAULT_MUTED_PACKAGES_VERSION");
  }

  Future<void> setDefaultMutedPackagesVersion(int value) async {
    await _sharedPrefs.setInt("DEFAULT_MUTED_PACKAGES_VERSION", value);
    _preferencesUpdateStream.add(this);
  }
}

final preferencesProvider = FutureProvider<Preferences>((ref) async {
  final sharedPreferences = await ref.watch(sharedPreferencesProvider);
  return Preferences(sharedPreferences);
});

final phoneNotificationsMuteProvider = _createPreferenceProvider<bool?>(
  (preferences) => preferences.isPhoneNotificationMuteEnabled(),
);

final phoneCallsMuteProvider = _createPreferenceProvider<bool?>(
  (preferences) => preferences.isPhoneCallMuteEnabled(),
);

final notificationToggleProvider = _createPreferenceProvider<bool?>(
  (preferences) => preferences.areNotificationsEnabled(),
);

final notificationsMutedPackagesProvider = _createPreferenceProvider<List<String?>>(
  (preferences) => preferences.getNotificationsMutedPackages(),
);

/// ```dart
/// final hasBeenConnected =
///   useProvider(hasBeenConnectedProvider).data?.value ?? false;
/// ```
/// OR
/// ```dart
/// final hasBeenConnected = useProvider(hasBeenConnectedProvider.last);
/// useEffect(() {
///   hasBeenConnected.then((value) => /*...*/);
/// }, []);
/// ```
final hasBeenConnectedProvider = _createPreferenceProvider<bool>(
  (preferences) => preferences.hasBeenConnected(),
);

final wasSetupSuccessfulProvider = _createPreferenceProvider<bool>(
  (preferences) => preferences.wasSetupSuccessful(),
);

final bootUrlProvider = _createPreferenceProvider<String?>(
  (preferences) {
    return preferences.getBoot();
  },
);

final overrideBootValueProvider = _createPreferenceProvider<String?>(
  (preferences) => preferences.getOverrideBootValue(),
);

final shouldOverrideBootProvider = _createPreferenceProvider<bool?>(
  (preferences) => preferences.shouldOverrideBoot(),
);

final oauthTokenCreationDateProvider = _createPreferenceProvider<DateTime?>(
  (preferences) => preferences.getOAuthTokenCreationDate(),
);

StreamProvider<T> _createPreferenceProvider<T>(
  T Function(Preferences preferences) mapper,
) {
  return StreamProvider<T>((ref) {
    final preferences = ref.watch(preferencesProvider);

    return preferences.map(
        data: (preferences) => preferences.value.preferencesUpdateStream
            .startWith(preferences.value)
            .map(mapper)
            .distinct(),
        loading: (loading) => const Stream.empty(),
        error: (error) => const Stream.empty());
  });
}
