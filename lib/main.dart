import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/bloc/auth/auth_bloc.dart';
import 'package:login/bloc/auth/auth_status.dart';
import 'package:login/cache/auth_cache_manager.dart';
import 'package:login/env_config.dart';
import 'package:login/routing/app_router.dart';
import 'package:login/routing/navigate_util.dart';
import 'package:login/service/google_oauth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // load flavor
  const String flavor = String.fromEnvironment('FLAVOR', defaultValue: 'prod');
  await EnvConfig.load(flavor);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          // AuthBloc must be global accessible, that's why it has been put here
          create: (_) => AuthBloc(
              AuthCacheManager(),
              GoogleOAuthService(
                  clientId: dotenv.env["COGNITO_CLIENT_ID"]!,
                  cognitoDomain: dotenv.env["COGNITO_DOMAIN"]!,
                  redirectUri: dotenv.env["COGNITO_REDIRECT_URI"]!)),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();
  late final AuthBloc authBloc;
  late StreamSubscription authStream;

  @override
  void initState() {
    super.initState();

    authBloc = context.read<AuthBloc>();
    authStream = authBloc.stream.listen((state) {
      if (state.status == AuthStatus.userIsLogged) {
        NavigateUtil().navigateToView('/customer', clearStack: true);
      } else if (state.status == AuthStatus.userIsNotLogged) {
        NavigateUtil().navigateToView('/guest', clearStack: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Poppins'),
      onGenerateRoute: _appRouter.onGenerateRoute,
      navigatorKey: navigatorKey,
    );
  }

  @override
  void dispose() {
    _appRouter.dispose();
    authStream.cancel();
    super.dispose();
  }
}
