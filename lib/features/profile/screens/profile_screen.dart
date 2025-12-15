import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (_) => false);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is! AuthAuthenticated) {
          return _buildLoggedOut(context);
        }

        final user = state.user;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: const Text('Profile'),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ProfileHeader(user: user),
              const SizedBox(height: 24),

              _SectionTitle('Account'),
              _ProfileTile(
                icon: Icons.person_outline,
                title: 'Full Name',
                subtitle: _fullName(user.firstName, user.lastName),
              ),
              _ProfileTile(
                icon: Icons.email_outlined,
                title: 'Email',
                subtitle: user.email,
              ),
              if (user.phoneNumber != null)
                _ProfileTile(
                  icon: Icons.phone_outlined,
                  title: 'Phone',
                  subtitle: user.phoneNumber!,
                ),
              if (user.address != null)
                _ProfileTile(
                  icon: Icons.location_on_outlined,
                  title: 'Address',
                  subtitle: user.address!,
                ),

              const SizedBox(height: 32),

              _SectionTitle('Actions'),
              _ProfileTile(
                icon: Icons.logout,
                title: 'Logout',
                titleColor: Colors.red,
                onTap: () => _confirmLogout(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoggedOut(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_circle_outlined,
                size: 100, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'You are not logged in',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  static String _fullName(String? first, String? last) {
    final name = '${first ?? ''} ${last ?? ''}'.trim();
    return name.isEmpty ? 'Not provided' : name;
  }
}

class _ProfileHeader extends StatelessWidget {
  final dynamic user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                user.username.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _ProfileTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(icon, color: titleColor),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing:
          onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
}
