enum AuthStatus {
  loading,
  error,
  userIsLogged,
  userIsNotLogged,
  failedAuth,
  signingOut,
}

enum AuthError { unknown, notValidCredentials }
