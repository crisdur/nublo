import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:auto_route/auto_route.dart';
import 'package:nublo/core/router/app_router.gr.dart';
import 'package:nublo/features/auth/presentation/cubit/auth/auth_cubit.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            try {
              final authCubit = GetIt.I<AuthCubit>();
              await authCubit.logout();
              
              if (context.mounted) {
                Navigator.pop(context);
                context.router.replace(const SplashRoute());
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error during logout'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}