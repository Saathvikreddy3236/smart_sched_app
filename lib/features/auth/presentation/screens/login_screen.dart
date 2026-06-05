import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_providers.dart';
import '../widgets/auth_shell.dart';
import '../widgets/role_selector.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Student';
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorText;

  static const _roles = ['Student', 'Faculty'];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'Access your timetable',
      subtitle:
          'Choose your role and sign in to view classes, rooms, attendance, and schedule alerts.',
      sidePanel: const _LoginBenefitsPanel(),
      formCard: _LoginFormCard(
        emailController: _emailController,
        passwordController: _passwordController,
        selectedRole: _selectedRole,
        obscurePassword: _obscurePassword,
        isLoading: _isLoading,
        errorText: _errorText,
        onRoleSelected: (role) => setState(() => _selectedRole = role),
        onTogglePassword: () {
          setState(() => _obscurePassword = !_obscurePassword);
        },
        onLogin: _login,
      ),
    );
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorText = 'Enter your email and password.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final api = ref.read(apiClientProvider);
      final data = await api.login(
        email: email,
        password: password,
        role: _selectedRole,
      );
      final userRole = (data['user']?['role'] ?? _selectedRole).toString();
      if (!mounted) return;

      final role = userRole.toLowerCase();
      if (role.contains('faculty') || _selectedRole == 'Faculty') {
        context.go(AppStrings.facultyDashboardRoute);
      } else {
        context.go(AppStrings.studentDashboardRoute);
      }
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _errorText = error.message);
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _errorText = 'Could not reach the backend. Please try again.',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class _LoginFormCard extends StatelessWidget {
  const _LoginFormCard({
    required this.emailController,
    required this.passwordController,
    required this.selectedRole,
    required this.obscurePassword,
    required this.isLoading,
    required this.errorText,
    required this.onRoleSelected,
    required this.onTogglePassword,
    required this.onLogin,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String selectedRole;
  final bool obscurePassword;
  final bool isLoading;
  final String? errorText;
  final ValueChanged<String> onRoleSelected;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 760),
      curve: Curves.easeOutExpo,
      tween: Tween(begin: 0.96, end: 1),
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        padding: EdgeInsets.all(
          MediaQuery.sizeOf(context).width < 420
              ? AppSpacing.lg
              : AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 44,
              offset: const Offset(0, 26),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Login',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Continue to your student or faculty timetable workspace.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Role',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            RoleSelector(
              roles: _LoginScreenState._roles,
              selectedRole: selectedRole,
              onSelected: onRoleSelected,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'name@university.edu',
                prefixIcon: Icon(Icons.alternate_email_rounded),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.enhanced_encryption_rounded),
                suffixIcon: IconButton(
                  onPressed: onTogglePassword,
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Forgot Password?'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (errorText != null) ...[
              _AuthErrorBanner(message: errorText!),
              const SizedBox(height: AppSpacing.md),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isLoading ? null : onLogin,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.arrow_forward_rounded),
                label: Text(isLoading ? 'Signing in...' : 'Login'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: isLoading
                    ? null
                    : () => context.go(AppStrings.registerRoute),
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: const Text('Create Student or Faculty Account'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: isLoading
                    ? null
                    : () => context.go(AppStrings.landingRoute),
                icon: const Icon(Icons.keyboard_backspace_rounded),
                label: const Text('Back to Landing Page'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthErrorBanner extends StatelessWidget {
  const _AuthErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onErrorContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LoginBenefitsPanel extends StatelessWidget {
  const _LoginBenefitsPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 1100;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final stackStats = constraints.maxWidth < 360;

                  if (stackStats) {
                    return const Column(
                      children: [
                        _StatTile(
                          title: 'Active sessions',
                          value: '2 roles',
                          accent: Color(0xFF3657FF),
                        ),
                        SizedBox(height: AppSpacing.md),
                        _StatTile(
                          title: 'Timetable access',
                          value: 'Live',
                          accent: Color(0xFF00A88F),
                        ),
                      ],
                    );
                  }

                  return const Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          title: 'Active sessions',
                          value: '2 roles',
                          accent: Color(0xFF0F766E),
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _StatTile(
                          title: 'Timetable access',
                          value: 'Live',
                          accent: Color(0xFF0284C7),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              ...const [
                _BenefitRow(
                  icon: Icons.view_timeline_rounded,
                  title: 'Personal schedules',
                  subtitle:
                      'Students and faculty see the timetable that belongs to their role.',
                ),
                SizedBox(height: AppSpacing.md),
                _BenefitRow(
                  icon: Icons.door_sliding_rounded,
                  title: 'Room clarity',
                  subtitle:
                      'Classroom changes and lecture locations stay easy to find.',
                ),
                SizedBox(height: AppSpacing.md),
                _BenefitRow(
                  icon: Icons.campaign_rounded,
                  title: 'Live communication',
                  subtitle:
                      'Timetable changes, exam alerts, and cancellations stay in sync.',
                ),
              ],
            ],
          ),
        ),
        if (isCompact) const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.title,
    required this.value,
    required this.accent,
  });

  final String title;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
