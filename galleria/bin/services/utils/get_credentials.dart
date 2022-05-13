import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import '../../_internal/constants/scopes.dart';
import '../api.dart';

/// Get credentials for service account, must pass account credentials,
/// proper scopes (which is really just google cloud) and then the http client
Future<AccessCredentials> getCredentials() async =>
    await obtainAccessCredentialsViaServiceAccount(
        accountCredentials, scopes, http.Client());
