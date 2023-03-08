// ignore_for_file: non_constant_identifier_names
// spec: https://itnext.io/flutter-1-17-no-more-flavors-no-more-ios-schemas-command-argument-that-solves-everything-8b145ed4285d

// Project imports:
import 'package:get_it/get_it.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

import 'galleria_assets.dart';

final _getIt = GetIt.instance;
final clientAssets = _getIt<GalleriaAssets>();

enum _ApiMode { dev, stage, prod }

final _ApiMode apiMode = _getApiMode();

_ApiMode _getApiMode() {
  switch (clientAssets.env) {
    case Env.dev:
      return _ApiMode.dev;
    case Env.stage:
      return _ApiMode.stage;
    default:
      return _ApiMode.prod;
  }
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

String cuestionarioUrl() {
  switch (_getApiMode()) {
    case _ApiMode.dev:
      return clientAssets.cuestionarioUrls.dev;
    case _ApiMode.stage:
      return clientAssets.cuestionarioUrls.stage;
    case _ApiMode.prod:
      return clientAssets.cuestionarioUrls.prod;
  }
}

final accountCredentials = _getAccountCredentials(_getApiMode());

final emailAccountCredentials = _getAccountCredentials(_getApiMode(), true);

ServiceAccountCredentials _getAccountCredentials(_ApiMode mode,
    [bool email = false]) {
  switch (mode) {
    case _ApiMode.dev:
      return ServiceAccountCredentials.fromJson(
        clientAssets.devCredentials,
        impersonatedUser: email ? 'service.account@mayjuun.com' : null,
      );
    case _ApiMode.stage:
      return ServiceAccountCredentials.fromJson(
        clientAssets.stageCredentials,
        impersonatedUser: email ? 'service.account@mayjuun.com' : null,
      );
    case _ApiMode.prod:
      return ServiceAccountCredentials.fromJson(
        clientAssets.prodCredentials,
        impersonatedUser: email ? 'service.account@mayjuun.com' : null,
      );
  }
}

String? organizationId() {
  switch (_getApiMode()) {
    case _ApiMode.dev:
      return clientAssets.organizationIds.dev;
    case _ApiMode.stage:
      return clientAssets.organizationIds.stage;
    case _ApiMode.prod:
      return clientAssets.organizationIds.prod;
  }
}
