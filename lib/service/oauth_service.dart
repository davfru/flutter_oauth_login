import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:login/bloc/auth/auth_model.dart';

abstract class OAuthService {
  final String clientId;
  final String cognitoDomain;
  final String redirectUri;

  OAuthService({
    required this.clientId,
    required this.cognitoDomain,
    required this.redirectUri,
  });

  String getProviderName();

  Future<AuthModel?> login() async {
    String state = generateState();
    String codeVerifier = generateCodeVerifier();
    String codeChallenge = generateCodeChallenge(codeVerifier);

    final url =
        Uri.parse('https://$cognitoDomain/oauth2/authorize?response_type=code'
            '&client_id=$clientId'
            '&identity_provider=${getProviderName()}'
            '&state=$state'
            '&redirect_uri=$redirectUri'
            '&code_challenge=$codeChallenge'
            '&code_challenge_method=S256');

    if (Platform.isAndroid) {
      try {
        final result = await FlutterWebAuth2.authenticate(
            url: url.toString(), callbackUrlScheme: "myapp");

        // Extract token from resulting url
        final authorizationCode = Uri.parse(result).queryParameters['code'];
        final receivedState = Uri.parse(result).queryParameters['state'];

        if (state != receivedState) {
          // The state parameter is used to protect against XSRF.
          // If state parameters are different, someone else has initiated the request.

          throw Exception('State does not match');
        }

        final tokenUrl = Uri.parse(
            'https://$cognitoDomain/oauth2/token?grant_type=authorization_code'
            '&client_id=$clientId'
            '&code=$authorizationCode'
            '&redirect_uri=$redirectUri'
            '&code_verifier=$codeVerifier'
            '&code_challenge_method=S256');

        final response = await http.post(
          tokenUrl,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> responseData =
              json.decode(response.body) as Map<String, dynamic>;
          return AuthModel.fromJson(responseData);
        } else {
          throw Exception('Failed to obtain token');
        }
      } catch (e) {
        throw Exception('Failed to launch URL: $e');
      }
    } else if (Platform.isIOS) {
      throw Exception('OAuth Flow must be must be implemented for iOS');
    } else {
      throw Exception('Unsupported platform');
    }
  }

  Future<void> revokeToken(String refreshToken) async {
    try {
      final url = Uri.parse('https://$cognitoDomain/oauth2/revoke'
          '&client_id=$clientId'
          '&token=$refreshToken');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );
    } catch (e) {
      throw Exception('Failed to launch URL: $e');
    }
  }

  // code verifier must be 43-128 characters long
  String generateCodeVerifier({int length = 43}) {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final Random random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  String generateState() {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final Random random = Random.secure();
    return List.generate(10, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  // generate code challenge from code verifier
  String generateCodeChallenge(String codeVerifier) {
    final bytes = utf8.encode(codeVerifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }
}
