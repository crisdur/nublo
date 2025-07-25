import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../domain/entities/auth/auth.dart';
import '../../cubit/auth/auth_cubit.dart';
import '../../cubit/auth/auth_state.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => GetIt.I<AuthCubit>(),
      child: const _AuthView(),
    );
  }
}

class _AuthView extends StatelessWidget {
  const _AuthView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auths'),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
       return Container();
        },
      ),
    );
  }
}

class _AuthList extends StatelessWidget {
  const _AuthList({required this.items});

  final List<Auth> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.list, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No Auths',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'No items available',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item.displayName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.description != null)
                Text(item.description!),
              if (item.address != null)
                Text(item.address!),
              if (item.phoneNumber != null)
                Text(item.phoneNumber!),
            ],
          ),
          trailing: item.localizedCategory != null 
            ? Chip(label: Text(item.localizedCategory!))
            : null,
          onTap: () {
          },
        );
      },
    );
  }
} 