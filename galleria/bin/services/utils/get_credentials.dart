import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import '../../_internal/constants/scopes.dart';
import '../../assets/assets.dart';

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
    print(e);
    print(stack);
    throw e;
  }
}
