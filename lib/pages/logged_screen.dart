import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/theme/app_colors.dart';
import 'package:login/bloc/auth/auth_bloc.dart';
import 'package:login/theme/gaps.dart';

class LoggedScreen extends StatelessWidget {
  const LoggedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              'Hi ${context.read<AuthBloc>().state.idTokenPayload!.name}',
              style: TextStyle(fontSize: 24),
            ),
          ),
          gapH16,
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(SignOut());
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              minimumSize: const Size(100, 45),
              elevation: 0,
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.blue,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
