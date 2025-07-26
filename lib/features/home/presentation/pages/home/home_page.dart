import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nublo/core/constants/app_colors.dart';
import 'package:nublo/core/widgets/appbar/custom_app_bar.dart';
import '../../../domain/entities/home/home.dart';
import '../../cubit/home/home_cubit.dart';
import '../../cubit/home/home_state.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => GetIt.I<HomeCubit>()..loadAllHomes(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Homes'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.purple, AppColors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox(),
              loading: () => const Center(child: CircularProgressIndicator()),
              success: (items) => _HomeList(items: items),
              error: (message) => Center(child: Text(message)),
            );
          },
        ),
      ),
    );
  }
}

class _HomeList extends StatelessWidget {
  const _HomeList({required this.items});

  final List<Home> items;

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
              'No Homes',
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