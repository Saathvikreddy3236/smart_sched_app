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
  final _identifierController = TextEditingController();
  String _selectedRole = 'Student';
  List<_DepartmentOption> _departments = const [];
  List<_SectionOption> _sections = const [];
  _DepartmentOption? _selectedDepartment;
  _SectionOption? _selectedSection;
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isLoadingDepartments = true;
  bool _isLoadingSections = false;
  String? _errorText;

  static const _roles = ['Student', 'Faculty'];

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
        identifierController: _identifierController,
        selectedRole: _selectedRole,
        departments: _departments,
        sections: _sections,
        selectedDepartment: _selectedDepartment,
        selectedSection: _selectedSection,
        obscurePassword: _obscurePassword,
        isLoading: _isLoading,
        isLoadingDepartments: _isLoadingDepartments,
        isLoadingSections: _isLoadingSections,
        errorText: _errorText,
        onRoleSelected: _selectRole,
        onDepartmentSelected: _selectDepartment,
        onSectionSelected: (section) {
          setState(() => _selectedSection = section);
        },
        onTogglePassword: () {
          setState(() => _obscurePassword = !_obscurePassword);
        },
        onRegister: _register,
      ),
    );
  }

  Future<void> _loadDepartments() async {
    try {
      final api = ref.read(apiClientProvider);
      final items = await api.getDepartments();
      if (!mounted) return;

      setState(() {
        _departments = items.map(_DepartmentOption.fromJson).toList();
        _isLoadingDepartments = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _errorText = error.message;
        _isLoadingDepartments = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorText = 'Could not load departments. Please try again.';
        _isLoadingDepartments = false;
      });
    }
  }

  void _selectRole(String role) {
    setState(() {
      _selectedRole = role;
      _identifierController.clear();
      _selectedSection = null;
      if (role != 'Student') {
        _sections = const [];
      }
    });

    if (role == 'Student' && _selectedDepartment != null) {
      _selectDepartment(_selectedDepartment);
    }
  }

  Future<void> _selectDepartment(_DepartmentOption? department) async {
    setState(() {
      _selectedDepartment = department;
      _selectedSection = null;
      _sections = const [];
      _errorText = null;
    });

    if (department == null || _selectedRole != 'Student') return;

    setState(() => _isLoadingSections = true);
    try {
      final api = ref.read(apiClientProvider);
      final items = await api.getSections(departmentId: department.id);
      if (!mounted) return;

      setState(() {
        _sections = items.map(_SectionOption.fromJson).toList();
        _isLoadingSections = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _errorText = error.message;
        _isLoadingSections = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorText = 'Could not load sections for this department.';
        _isLoadingSections = false;
      });
    }
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final identifier = _identifierController.text.trim();
    final isStudent = _selectedRole == 'Student';

    if ([name, email, password].any((value) => value.isEmpty) ||
        _selectedDepartment == null ||
        (isStudent && (identifier.isEmpty || _selectedSection == null))) {
      setState(() => _errorText = 'Fill all registration fields.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final api = ref.read(apiClientProvider);
      await api.register(
        email: email,
        password: password,
        role: _selectedRole,
        name: name,
        departmentId: _selectedDepartment!.id,
        rollNo: isStudent ? identifier : null,
        sectionId: isStudent ? _selectedSection!.id : null,
      );
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
    required this.identifierController,
    required this.selectedRole,
    required this.departments,
    required this.sections,
    required this.selectedDepartment,
    required this.selectedSection,
    required this.obscurePassword,
    required this.isLoading,
    required this.isLoadingDepartments,
    required this.isLoadingSections,
    required this.errorText,
    required this.onRoleSelected,
    required this.onDepartmentSelected,
    required this.onSectionSelected,
    required this.onTogglePassword,
    required this.onRegister,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController identifierController;
  final String selectedRole;
  final List<_DepartmentOption> departments;
  final List<_SectionOption> sections;
  final _DepartmentOption? selectedDepartment;
  final _SectionOption? selectedSection;
  final bool obscurePassword;
  final bool isLoading;
  final bool isLoadingDepartments;
  final bool isLoadingSections;
  final String? errorText;
  final ValueChanged<String> onRoleSelected;
  final ValueChanged<_DepartmentOption?> onDepartmentSelected;
  final ValueChanged<_SectionOption?> onSectionSelected;
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
          DropdownButtonFormField<_DepartmentOption>(
            isExpanded: true,
            initialValue: selectedDepartment,
            items: departments
                .map(
                  (department) => DropdownMenuItem(
                    value: department,
                    child: Text(
                      department.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            selectedItemBuilder: (context) {
              return departments
                  .map(
                    (department) => Text(
                      department.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                  .toList();
            },
            onChanged: isLoading || isLoadingDepartments
                ? null
                : onDepartmentSelected,
            decoration: InputDecoration(
              labelText: 'Department',
              prefixIcon: const Icon(Icons.account_tree_rounded),
              suffixIcon: isLoadingDepartments
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (isStudent) ...[
            DropdownButtonFormField<_SectionOption>(
              isExpanded: true,
              initialValue: selectedSection,
              items: sections
                  .map(
                    (section) => DropdownMenuItem(
                      value: section,
                      child: Text(
                        section.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              selectedItemBuilder: (context) {
                return sections
                    .map(
                      (section) => Text(
                        section.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                    .toList();
              },
              onChanged:
                  isLoading || isLoadingSections || selectedDepartment == null
                  ? null
                  : onSectionSelected,
              decoration: InputDecoration(
                labelText: 'Year and Section',
                prefixIcon: const Icon(Icons.groups_rounded),
                suffixIcon: isLoadingSections
                    ? const Padding(
                        padding: EdgeInsets.all(14),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          if (isStudent)
            TextField(
              controller: identifierController,
              enabled: !isLoading,
              decoration: const InputDecoration(
                labelText: 'Roll Number',
                prefixIcon: Icon(Icons.confirmation_number_rounded),
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
            subtitle:
                'Creates a user with name, roll number, department, and section.',
          ),
          SizedBox(height: AppSpacing.md),
          _RegisterInfoRow(
            icon: Icons.workspace_premium_rounded,
            title: 'Faculty profile',
            subtitle: 'Creates a user with faculty name and department.',
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

class _DepartmentOption {
  const _DepartmentOption({
    required this.id,
    required this.name,
    required this.code,
  });

  final int id;
  final String name;
  final String code;

  String get label => code.isEmpty ? name : '$name ($code)';

  factory _DepartmentOption.fromJson(Map<String, dynamic> json) {
    return _DepartmentOption(
      id: json['department_id'] as int,
      name: json['department_name']?.toString() ?? 'Department',
      code: json['department_code']?.toString() ?? '',
    );
  }
}

class _SectionOption {
  const _SectionOption({
    required this.id,
    required this.year,
    required this.name,
  });

  final int id;
  final int year;
  final String name;

  String get label => 'Year $year - Section $name';

  factory _SectionOption.fromJson(Map<String, dynamic> json) {
    return _SectionOption(
      id: json['section_id'] as int,
      year: json['year_number'] as int,
      name: json['section_name']?.toString() ?? '',
    );
  }
}
