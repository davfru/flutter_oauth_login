import '../enums/network_enums.dart';
import 'cache_manager.dart';

class AuthCacheManager {
  Future<bool> isLoggedIn() async {
    return (await CacheManager.getBool(NetworkEnums.idToken.name)) ?? false;
  }

  Future<void> signOut() async {
    await CacheManager.clearAll();
  }

  Future<String?> getIdToken() async {
    return await CacheManager.getString(NetworkEnums.idToken.name);
  }

  Future<String?> getRefreshToken() async {
    return await CacheManager.getString(NetworkEnums.refreshToken.name);
  }

  Future<void> storeTokens(
      String idToken, String accessToken, String refreshToken) async {
    await CacheManager.setString(NetworkEnums.idToken.name, idToken);
    await CacheManager.setString(NetworkEnums.accessToken.name, accessToken);
    await CacheManager.setString(NetworkEnums.refreshToken.name, refreshToken);
  }

  Future<void> storeIdToken(String idToken) async {
    await CacheManager.setString(NetworkEnums.idToken.name, idToken);

    // DioManager.instance.dio.options.headers['Authorization'] =
    //     'Bearer $idToken';
  }
}
