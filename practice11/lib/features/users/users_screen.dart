import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';
import 'user.dart';
import 'users_model.dart';
import 'user_detail_screen.dart';
import 'new_user_screen.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UsersModel model = context.watch<UsersModel>();

    if (model.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final Widget content = switch (model.error) {
      null => UserList(users: model.items, onRefresh: model.load),

      NoConnectionException() => ErrorView(
        message: 'No internet connection',
        onRetry: model.load,
      ),

      NotFoundException() => ErrorView(
        message: 'Users not found',
        onRetry: model.load,
      ),

      UnauthorizedException() => ErrorView(
        message: 'Unauthorized access',
        onRetry: model.load,
      ),

      ServerException(:final status) => ErrorView(
        message: 'Server error: $status',
        onRetry: model.load,
      ),

      BadResponseException() => const ErrorView(
        message: 'Invalid server response',
      ),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh users',
            onPressed: () {
              model.load();
            },
          ),

          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New User',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const NewUserScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: content,
    );
  }
}

class UserList extends StatelessWidget {
  final List<User> users;
  final Future<void> Function() onRefresh;

  const UserList({super.key, required this.users, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: users.length,

        separatorBuilder: (context, index) {
          return const Divider();
        },

        itemBuilder: (context, index) {
          final User user = users[index];

          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),

            title: Text(user.name),

            subtitle: Text('${user.email}\n${user.address.city}'),

            isThreeLine: true,

            trailing: const Icon(Icons.arrow_forward_ios),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return UserDetailScreen(user: user);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function()? onRetry;

  const ErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),

          const SizedBox(height: 16),

          Text(message, textAlign: TextAlign.center),

          const SizedBox(height: 16),

          if (onRetry != null)
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
