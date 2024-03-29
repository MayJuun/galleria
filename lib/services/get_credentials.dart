import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import '../galleria.dart';

/// Get credentials for service account, must pass account credentials,
/// proper scopes (which is really just google cloud) and then the http client
Future<AccessCredentials> getCredentials([bool forEmail = false]) async {
  final client = http.Client();
  try {
    AccessCredentials credentials =
        await obtainAccessCredentialsViaServiceAccount(
            forEmail ? emailAccountCredentials : accountCredentials,
            scopes,
            client);

    client.close();
    return credentials;
  } catch (e, stack) {
    print('Error: $e');
    print('Stack: $stack');
    throw e;
  }
}
