import 'package:login/bloc/auth/auth_model.dart';
import 'package:login/bloc/auth/auth_status.dart';
import 'package:login/cache/auth_cache_manager.dart';
import 'package:login/service/oauth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthCacheManager authCacheManager;
  final OAuthService oauthService;

  AuthBloc(this.authCacheManager, this.oauthService)
      : super(const AuthState.loading()) {
    on<SignIn>(
      (event, emit) async {
        emit(state.copyWith(status: AuthStatus.loading));

        try {

          final AuthModel? response = await oauthService.login();

          if (response == null) {
            emit(const AuthState.error());
            return;
          }

          final idToken = response.idToken!;
          final accessToken = response.accessToken!;
          final refreshToken = response.refreshToken!;

          await authCacheManager.storeTokens(
              idToken, accessToken, refreshToken);

          IdTokenPayload idTokenPayload =
              IdTokenPayload.fromJson(JWT.decode(idToken).payload);

          emit(state.copyWith(
              status: AuthStatus.userIsLogged, idTokenPayload: idTokenPayload));
        } catch (_) {
          emit(const AuthState.error(
              authStatus: AuthStatus.failedAuth,
              error: AuthError.notValidCredentials));
        }
      },
    );

    on<SignOut>((event, emit) async {
      emit(state.copyWith(status: AuthStatus.signingOut));

      try {
        String? refreshToken = await authCacheManager.getRefreshToken();
        await authCacheManager.signOut();

        if (refreshToken != null) {
          await oauthService.revokeToken(refreshToken);
        }

        emit(const AuthState.userLoggedOut());
      } catch (_) {
        emit(const AuthState.error(authStatus: AuthStatus.error));
      }
    });
  }
}
