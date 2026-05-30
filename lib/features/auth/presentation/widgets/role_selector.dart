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
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: roles
          .map(
            (role) => ChoiceChip(
              label: Text(role),
              selected: selectedRole == role,
              onSelected: (_) => onSelected(role),
            ),
          )
          .toList(),
    );
  }
}
