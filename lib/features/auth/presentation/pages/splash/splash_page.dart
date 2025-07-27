import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nublo/core/constants/app_colors.dart';
import '../../../../../core/constants/auth_status.dart';
import '../../../../../core/router/app_router.gr.dart';
import '../../cubit/auth/auth_cubit.dart';
import '../../cubit/auth/auth_state.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: GetIt.I<AuthCubit>()..checkAuthStatus(),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthStatus.authenticated:
                if (state.user != null) {
                  context.router.replace(const HomeRoute());
                } else {
                  context.router.replace(const LoginRoute());
                }
                break;
              case AuthStatus.error:
              case AuthStatus.unauthenticated:
                context.router.replace(const LoginRoute());
                break;
              case AuthStatus.loading:
              case AuthStatus.initial:
                break;
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud, color: Colors.white, size: 200),
                const SizedBox(height: 48),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
