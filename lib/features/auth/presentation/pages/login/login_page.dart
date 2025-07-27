import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nublo/core/constants/app_colors.dart';
import 'package:nublo/core/constants/auth_status.dart';
import '../../../../../core/router/app_router.gr.dart';
import '../../cubit/auth/auth_cubit.dart';
import '../../cubit/auth/auth_state.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: GetIt.I<AuthCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthStatus.authenticated:
            if (state.user != null) {
              context.router.replaceAll([const HomeRoute()]);
            }
            break;
          case AuthStatus.error:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error?.message.toString() ?? 'Error logging in',
                ),
                backgroundColor: Colors.red,
              ),
            );
            break;
          case AuthStatus.loading:
          case AuthStatus.initial:
            break;
          case AuthStatus.unauthenticated:
            break;
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud, color: Colors.white, size: 200),
                    const SizedBox(height: 48),
                    _TitleText(),
                    const SizedBox(height: 16),
                    _SubtitleText1(),
                    const SizedBox(height: 16),
                    _SubtitleText2(),
                    const SizedBox(height: 48),
                    _SignInButtoon(isLoading: isLoading),
                    const SizedBox(height: 24),
                    CreateAccountButton(isLoading: isLoading),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({
    super.key,
    required this.isLoading,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: isLoading
            ? null
            : () => context.read<AuthCubit>().signup(),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SignInButtoon extends StatelessWidget {
  const _SignInButtoon({
    required this.isLoading,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () => context.read<AuthCubit>().login(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF6366F1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              )
            : const Text(
                'Sign In with Auth0',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

class _SubtitleText2 extends StatelessWidget {
  const _SubtitleText2();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Track weather in your favorite locations',
      style: TextStyle(fontSize: 16, color: Colors.white70),
    );
  }
}

class _SubtitleText1 extends StatelessWidget {
  const _SubtitleText1();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Sign in to continue to your account',
      style: TextStyle(fontSize: 16, color: Colors.white70),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Welcome Back',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
