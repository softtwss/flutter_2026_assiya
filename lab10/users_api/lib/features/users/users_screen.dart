import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';
import 'new_user_screen.dart';
import 'user.dart';
import 'user_detail_screen.dart';
import 'users_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.watch<UsersModel>();

    Widget body;

    if (m.loading) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = switch (m.error) {
        null => UserList(items: m.items),
        NoConnectionException() => ErrorView(
          message: 'No internet connection',
          onRetry: m.load,
        ),
        NotFoundException() || UnauthorizedException() => ErrorView(
          message: 'Request not allowed or not found',
          onRetry: m.load,
        ),
        ServerException(:final status) => ErrorView(
          message: 'Server error: $status',
          onRetry: m.load,
        ),
        BadResponseException() => const Center(
          child: Text('Invalid server response'),
        ),
      };
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Real Server — Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: m.loading ? null : m.load,
          ),
        ],
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewUserScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  const UserList({super.key, required this.items});

  final List<User> items;

  @override
  Widget build(BuildContext context) {
    final model = context.read<UsersModel>();

    return RefreshIndicator(
      onRefresh: model.load,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final user = items[index];

          return ListTile(
            leading: CircleAvatar(child: Text(user.name[0])),
            title: Text(user.name),
            subtitle: Text('${user.email}\n${user.address.city}'),
            isThreeLine: true,
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
              );
            },
          );
        },
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 60),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
