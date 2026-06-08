import 'package:flutter/material.dart';

class RoleSelector extends StatelessWidget {
  const RoleSelector({
    super.key,
    required this.roles,
    required this.selectedRole,
    required this.onSelected,
  });

  final List<String> roles;
  final String selectedRole;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 420;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: roles
              .map(
                (role) => SizedBox(
                  width: isNarrow ? constraints.maxWidth : null,
                  child: ChoiceChip(
                    avatar: Icon(
                      role == 'Student'
                          ? Icons.school_rounded
                          : Icons.workspace_premium_rounded,
                      size: 18,
                    ),
                    label: Center(child: Text(role)),
                    selected: selectedRole == role,
                    onSelected: (_) => onSelected(role),
                    showCheckmark: false,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
