import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_providers.dart';
import '../widgets/auth_shell.dart';
import '../widgets/role_selector.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _departmentController = TextEditingController();
  final _identifierController = TextEditingController();
  String _selectedRole = 'Student';
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorText;

  static const _roles = ['Student', 'Faculty'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _departmentController.dispose();
    _identifierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'Create academic access',
      subtitle:
          'Register as a student or faculty member, then sign in to your role-based timetable workspace.',
      sidePanel: const _RegisterInfoPanel(),
      formCard: _RegisterFormCard(
        nameController: _nameController,
        emailController: _emailController,
        passwordController: _passwordController,
        departmentController: _departmentController,
        identifierController: _identifierController,
        selectedRole: _selectedRole,
        obscurePassword: _obscurePassword,
        isLoading: _isLoading,
        errorText: _errorText,
        onRoleSelected: (role) {
          setState(() {
            _selectedRole = role;
            _identifierController.clear();
          });
        },
        onTogglePassword: () {
          setState(() => _obscurePassword = !_obscurePassword);
        },
        onRegister: _register,
      ),
    );
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final departmentId = _departmentController.text.trim();
    final identifier = _identifierController.text.trim();

    if ([
      name,
      email,
      password,
      departmentId,
      identifier,
    ].any((value) => value.isEmpty)) {
      setState(() => _errorText = 'Fill all registration fields.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final api = ref.read(apiClientProvider);
      await api.register(email: email, password: password, role: _selectedRole);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created. Please sign in.')),
      );
      context.go(AppStrings.loginRoute);
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

class _RegisterFormCard extends StatelessWidget {
  const _RegisterFormCard({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.departmentController,
    required this.identifierController,
    required this.selectedRole,
    required this.obscurePassword,
    required this.isLoading,
    required this.errorText,
    required this.onRoleSelected,
    required this.onTogglePassword,
    required this.onRegister,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController departmentController;
  final TextEditingController identifierController;
  final String selectedRole;
  final bool obscurePassword;
  final bool isLoading;
  final String? errorText;
  final ValueChanged<String> onRoleSelected;
  final VoidCallback onTogglePassword;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isStudent = selectedRole == 'Student';

    return Container(
      padding: EdgeInsets.all(
        MediaQuery.sizeOf(context).width < 420 ? AppSpacing.lg : AppSpacing.xl,
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
            'Register',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Create a student or faculty account using the deployed scheduler API.',
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
            roles: _RegisterScreenState._roles,
            selectedRole: selectedRole,
            onSelected: isLoading ? (_) {} : onRoleSelected,
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: nameController,
            enabled: !isLoading,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: isStudent ? 'Student Name' : 'Faculty Name',
              prefixIcon: const Icon(Icons.badge_rounded),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: emailController,
            enabled: !isLoading,
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
            enabled: !isLoading,
            obscureText: obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.enhanced_encryption_rounded),
              suffixIcon: IconButton(
                onPressed: isLoading ? null : onTogglePassword,
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: departmentController,
            enabled: !isLoading,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Department ID',
              prefixIcon: Icon(Icons.account_tree_rounded),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: identifierController,
            enabled: !isLoading,
            decoration: InputDecoration(
              labelText: isStudent ? 'Roll Number' : 'Faculty ID',
              prefixIcon: Icon(
                isStudent
                    ? Icons.confirmation_number_rounded
                    : Icons.work_rounded,
              ),
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: AppSpacing.md),
            _RegisterErrorBanner(message: errorText!),
          ],
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isLoading ? null : onRegister,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.person_add_alt_1_rounded),
              label: Text(isLoading ? 'Creating account...' : 'Create Account'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isLoading
                  ? null
                  : () => context.go(AppStrings.loginRoute),
              icon: const Icon(Icons.login_rounded),
              label: const Text('Back to Login'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterErrorBanner extends StatelessWidget {
  const _RegisterErrorBanner({required this.message});

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

class _RegisterInfoPanel extends StatelessWidget {
  const _RegisterInfoPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        children: const [
          _RegisterInfoRow(
            icon: Icons.school_rounded,
            title: 'Student profile',
            subtitle: 'Creates a user with roll number, name, and department.',
          ),
          SizedBox(height: AppSpacing.md),
          _RegisterInfoRow(
            icon: Icons.workspace_premium_rounded,
            title: 'Faculty profile',
            subtitle: 'Creates a user with faculty id, name, and department.',
          ),
          SizedBox(height: AppSpacing.md),
          _RegisterInfoRow(
            icon: Icons.lock_rounded,
            title: 'Backend auth',
            subtitle:
                'Accounts are submitted to the Render API register endpoint.',
          ),
        ],
      ),
    );
  }
}

class _RegisterInfoRow extends StatelessWidget {
  const _RegisterInfoRow({
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
