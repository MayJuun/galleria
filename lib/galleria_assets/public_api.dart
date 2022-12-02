// ignore_for_file: non_constant_identifier_names
// spec: https://itnext.io/flutter-1-17-no-more-flavors-no-more-ios-schemas-command-argument-that-solves-everything-8b145ed4285d

// Project imports:
import 'package:get_it/get_it.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

import 'galleria_assets.dart';

final _getIt = GetIt.instance;
final clientAssets = _getIt<GalleriaAssets>();

class EnvConfig {
  static const APP_SUFFIX = String.fromEnvironment('APP_SUFFIX');
}

enum _ApiMode { dev, stage, prod }

final _ApiMode apiMode = _getApiMode();

_ApiMode _getApiMode() {
  _ApiMode response;
  switch (EnvConfig.APP_SUFFIX) {
    case '.dev':
      response = _ApiMode.dev;
      break;
    case '.stage':
      response = _ApiMode.stage;
      break;
    case '.prod':
    default:
      response = _ApiMode.prod;
  }
  return response;
}

String getFhirUrl() {
  switch (_getApiMode()) {
    case _ApiMode.dev:
      return clientAssets.fhirDevUrl;
    case _ApiMode.stage:
      return clientAssets.fhirStageUrl;
    case _ApiMode.prod:
      return clientAssets.fhirProdUrl;
  }
}

final accountCredentials = _getAccountCredentials(_getApiMode());

final emailAccountCredentials = _getAccountCredentials(_getApiMode(), true);

ServiceAccountCredentials _getAccountCredentials(_ApiMode mode,
    [bool email = false]) {
  return ServiceAccountCredentials.fromJson(
    clientAssets.devCredentials,
    impersonatedUser: email ? 'service.account@mayjuun.com' : null,
  );
  // TODO(Dokotela): environment variables with Docker
  // switch (mode) {
  //   case _ApiMode.dev:
  //     return ServiceAccountCredentials.fromJson(
  //       clientAssets.devCredentials,
  //       impersonatedUser: email ? 'service.account@mayjuun.com' : null,
  //     );
  //   case _ApiMode.stage:
  //     return ServiceAccountCredentials.fromJson(
  //       clientAssets.stageCredentials,
  //       impersonatedUser: email ? 'service.account@mayjuun.com' : null,
  //     );
  //   case _ApiMode.prod:
  //     return ServiceAccountCredentials.fromJson(
  //       clientAssets.prodCredentials,
  //       impersonatedUser: email ? 'service.account@mayjuun.com' : null,
  //     );
  // }
}
