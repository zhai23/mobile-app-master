import 'dart:async';
import 'dart:io';

import 'package:cobble/domain/api/boot/boot_config.dart';
import 'package:cobble/infrastructure/datasources/web_services/service.dart';

const _confLifetime = Duration(hours: 1);

class BootService extends Service {
  BootConfig? _conf;
  DateTime? _confAge;
  String? token;

  Future? _mutex;

  BootService(String baseUrl) : super(baseUrl);

  Future<BootConfig> get config async {
    if (_mutex != null) await _mutex;
    _mutex = Future(
        () async {
          if (_conf == null || _confAge == null ||
              DateTime.now().difference(_confAge!) >= _confLifetime) {
            _confAge = DateTime.now();
            BootConfig bootConfig = await reqBootConfig();
            _conf = bootConfig;
            return bootConfig;
          } else {
            return _conf!;
          }
        }
    );
    return await _mutex;
  }

  Future<BootConfig> reqBootConfig() async {
    return client.getSerialized(BootConfig.fromJson, "cobble", params: {"locale": Platform.localeName});
  }
}