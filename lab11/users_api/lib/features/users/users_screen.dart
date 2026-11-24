import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';

import '../settings/settings_model.dart';
import '../settings/settings_screen.dart';

import 'new_user_screen.dart';
import 'user_detail_screen.dart';
import 'users_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UsersModel>();
    final settings = context.watch<SettingsModel>();

    final users = model.items.where((user) {
      return settings.city == null || user.address.city == settings.city;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: model.loading
                ? null
                : () async {
                    await model.load();
                  },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (model.fromCache)
            MaterialBanner(
              content: const Text('Saved data · no connection'),
              leading: const Icon(Icons.cloud_off),
              actions: [
                TextButton(
                  onPressed: model.loading
                      ? null
                      : () async {
                          await model.load();
                        },
                  child: const Text('Retry'),
                ),
              ],
            ),
          if (model.loading && model.items.isNotEmpty)
            const LinearProgressIndicator(),
          Expanded(
            child: model.loading && model.items.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : model.error != null
                ? _ErrorView(error: model.error, onRetry: model.load)
                : RefreshIndicator(
                    onRefresh: model.load,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: users.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final user = users[index];

                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(user.name.isEmpty ? '?' : user.name[0]),
                          ),
                          title: Text(user.name),
                          subtitle: Text(
                            '${user.email}\n'
                            '${user.address.city}',
                          ),
                          isThreeLine: true,
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => UserDetailScreen(user: user),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const NewUserScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final ApiException? error;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final message = switch (error) {
      NoConnectionException() => 'Offline — no saved data available',
      NotFoundException() => 'Not found',
      UnauthorizedException() => 'Unauthorized',
      ServerException(:final status) => 'Server error: $status',
      BadResponseException() => 'Invalid response',
      null => 'Unknown error',
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 64),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              await onRetry();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
