import 'package:login/service/oauth_service.dart';

class GoogleOAuthService extends OAuthService {

  GoogleOAuthService(
      {required super.clientId,
      required super.cognitoDomain,
      required super.redirectUri});

  @override
  String getProviderName() {
    return "Google";
  }
}
