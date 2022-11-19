class GalleriaAssets {
  GalleriaAssets({
    required this.fhirDevUrl,
    required this.fhirStageUrl,
    required this.fhirProdUrl,
    required this.devCredentials,
    required this.stageCredentials,
    required this.prodCredentials,
    required this.twilio,
  });

  factory GalleriaAssets.fromJson(Map<String, dynamic> json) => GalleriaAssets(
        fhirDevUrl: json['clientApis']['fhirDevUrl'],
        fhirStageUrl: json['clientApis']['fhirStageUrl'],
        fhirProdUrl: json['clientApis']['fhirProdUrl'],
        devCredentials: json['galleria']['devCredentials'],
        stageCredentials: json['galleria']['stageCredentials'],
        prodCredentials: json['galleria']['prodCredentials'],
        twilio: Twilio.fromJson(json['galleria']['twilio']),
      );

  Map<String, dynamic> toJson() => {
        'clientApis': {
          'fhirDevUrl': this.fhirDevUrl,
          'fhirStageUrl': this.fhirStageUrl,
          'fhirProdUrl': this.fhirProdUrl,
        },
        'galleria': {
          'devCredentials': this.devCredentials,
          'stageCredentials': this.stageCredentials,
          'prodCredentials': this.prodCredentials,
          'twilio': this.twilio.toJson(),
        }
      };

  final String fhirDevUrl;
  final String fhirStageUrl;
  final String fhirProdUrl;
  final Map<String, dynamic> devCredentials;
  final Map<String, dynamic> stageCredentials;
  final Map<String, dynamic> prodCredentials;
  final Twilio twilio;
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
