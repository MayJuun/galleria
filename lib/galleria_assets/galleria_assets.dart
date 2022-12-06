class GalleriaAssets {
  GalleriaAssets({
    required this.env,
    required this.fhirDevUrl,
    required this.fhirStageUrl,
    required this.fhirProdUrl,
    required this.devCredentials,
    required this.stageCredentials,
    required this.prodCredentials,
    required this.cuestionarioUrls,
    required this.mayJuunIds,
    required this.twilio,
  });

  factory GalleriaAssets.fromJson(
          Map<String, dynamic> clientApis, Map<String, dynamic> galleria) =>
      GalleriaAssets(
        env: stringToEnv(galleria['env']),
        fhirDevUrl: clientApis['fhirDevUrl'],
        fhirStageUrl: clientApis['fhirStageUrl'],
        fhirProdUrl: clientApis['fhirProdUrl'],
        devCredentials: galleria['devCredentials'],
        stageCredentials: galleria['stageCredentials'],
        prodCredentials: galleria['prodCredentials'],
        cuestionarioUrls:
            CuestionarioUrls.fromJson(clientApis['cuestionarioUrls']),
        mayJuunIds: MayJuunIds.fromJson(clientApis['mayJuunIds']),
        twilio: Twilio.fromJson(galleria['twilio']),
      );

  Map<String, dynamic> toJson() => {
        'clientApis': {
          'fhirDevUrl': this.fhirDevUrl,
          'fhirStageUrl': this.fhirStageUrl,
          'fhirProdUrl': this.fhirProdUrl,
          'cuestionarioUrls': cuestionarioUrls.toJson(),
        },
        'galleria': {
          'env': envToString(this.env),
          'devCredentials': this.devCredentials,
          'stageCredentials': this.stageCredentials,
          'prodCredentials': this.prodCredentials,
          'twilio': this.twilio.toJson(),
        }
      };
  final Env env;
  final String fhirDevUrl;
  final String fhirStageUrl;
  final String fhirProdUrl;
  final Map<String, dynamic> devCredentials;
  final Map<String, dynamic> stageCredentials;
  final Map<String, dynamic> prodCredentials;
  final CuestionarioUrls cuestionarioUrls;
  final MayJuunIds mayJuunIds;
  final Twilio twilio;
}

enum Env { dev, stage, prod }

Env stringToEnv(String string) => string == 'prod'
    ? Env.prod
    : string == 'stage'
        ? Env.stage
        : Env.dev;

String envToString(Env env) {
  switch (env) {
    case Env.dev:
      return 'dev';
    case Env.stage:
      return 'stage';
    case Env.prod:
      return 'prod';
  }
}

class MayJuunIds {
  MayJuunIds({required this.dev, required this.stage, required this.prod});

  factory MayJuunIds.fromJson(Map<String, dynamic> json) => MayJuunIds(
        dev: json['dev'],
        stage: json['stage'],
        prod: json['prod'],
      );

  Map<String, dynamic> toJson() => {
        'dev': this.dev,
        'stage': this.stage,
        'prod': this.prod,
      };

  final String dev;
  final String stage;
  final String prod;
}

class CuestionarioUrls {
  CuestionarioUrls(
      {required this.dev, required this.stage, required this.prod});

  factory CuestionarioUrls.fromJson(Map<String, dynamic> json) =>
      CuestionarioUrls(
        dev: json['dev'],
        stage: json['stage'],
        prod: json['prod'],
      );

  Map<String, dynamic> toJson() => {
        'dev': this.dev,
        'stage': this.stage,
        'prod': this.prod,
      };

  final String dev;
  final String stage;
  final String prod;
}

class Twilio {
  Twilio({
    required this.accountSid,
    required this.authToken,
    required this.twilioNumber,
    required this.minute,
    required this.hour,
    required this.day,
    required this.month,
    required this.dayOfWeek,
  });

  factory Twilio.fromJson(Map<String, dynamic> json) => Twilio(
        accountSid: json['accountSid'],
        authToken: json['authToken'],
        twilioNumber: json['twilioNumber'],
        minute: json['minute'],
        hour: json['hour'],
        day: json['day'],
        month: json['month'],
        dayOfWeek: json['dayOfWeek'],
      );

  Map<String, dynamic> toJson() => {
        'accountSid': this.accountSid,
        'authToken': this.authToken,
        'twilioNumber': this.twilioNumber,
        'minute': this.minute,
        'hour': this.hour,
        'day': this.day,
        'month': this.month,
        'dayOfWeek': this.dayOfWeek,
      };

  /// Account Sid of your Twilio Account
  final String accountSid;

  /// AuthToken from your Twilio Account
  final String authToken;

  /// Twilio Phone Number
  final String twilioNumber;

  /// The following values can be integers or "*"
  /// It uses this package: https://pub.dev/packages/cron
  /// Here is a nice tutorial: https://medium.com/flutterworld/flutter-run-function-repeatedly-using-cron-4aa030eda332
  /// The 5 together make up a cron string "0 * * * * *" this default value runs every hour
  final String minute;
  final String hour;
  final String day;
  final String month;
  final String dayOfWeek;
}
