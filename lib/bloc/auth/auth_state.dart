part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthError? error;
  final IdTokenPayload? idTokenPayload;

  const AuthState._({required this.status, this.error, this.idTokenPayload});

  AuthState copyWith(
      {AuthStatus? status,
      IdTokenPayload? idTokenPayload,
      AuthError? error}) {
    return AuthState._(
        status: status ?? this.status,
        idTokenPayload: idTokenPayload ?? this.idTokenPayload,
        error: error ?? this.error);
  }

  const AuthState.userIsLogged({required IdTokenPayload idTokenPayload})
      : this._(status: AuthStatus.userIsLogged, idTokenPayload: idTokenPayload);

  const AuthState.userIsNotLogged()
      : this._(status: AuthStatus.userIsNotLogged, idTokenPayload: null);

  const AuthState.userLoggedOut()
      : this._(status: AuthStatus.userIsNotLogged, idTokenPayload: null);

  const AuthState.loading()
      : this._(status: AuthStatus.loading, idTokenPayload: null);

  const AuthState.error({AuthStatus? authStatus, AuthError? error})
      : this._(
            status: authStatus ?? AuthStatus.error,
            error: error ?? AuthError.unknown);

  @override
  List<Object?> get props => [status, idTokenPayload];
}
