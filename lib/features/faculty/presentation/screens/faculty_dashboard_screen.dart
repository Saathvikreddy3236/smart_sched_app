import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../landing/presentation/widgets/landing_background.dart';
import '../../../student/presentation/widgets/student_section_card.dart';
import '../../../student/presentation/widgets/student_stat_pill.dart';

class FacultyDashboardScreen extends StatefulWidget {
  const FacultyDashboardScreen({super.key});

  @override
  State<FacultyDashboardScreen> createState() => _FacultyDashboardScreenState();
}

class _FacultyDashboardScreenState extends State<FacultyDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1100;
    final isTablet = width >= 700 && width < 1100;
    final padding = isDesktop
        ? AppSpacing.xl
        : isTablet
        ? AppSpacing.xl
        : AppSpacing.lg;

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: isDesktop
          ? null
          : _FacultyBottomNav(
              selectedIndex: _selectedIndex,
              onSelected: _handleNavigation,
            ),
      body: Stack(
        children: [
          const Positioned.fill(child: LandingBackground()),
          SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDesktop)
                  _FacultySideNav(
                    selectedIndex: _selectedIndex,
                    onSelected: _handleNavigation,
                  ),
                Expanded(
                  child: Stack(
                    children: [
                      NotificationListener<ScrollNotification>(
                        onNotification: _handleScrollNotification,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            padding,
                            AppSpacing.lg + 96,
                            padding,
                            isDesktop ? AppSpacing.xl : 120,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1180),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const _FacultyHeroCard(),
                                  const SizedBox(height: AppSpacing.lg),
                                  _FacultyDashboardSection(
                                    title: 'Faculty Operations',
                                    actionLabel: 'Review queue',
                                    children: [
                                      if (isDesktop || isTablet) ...[
                                        const Expanded(
                                          child: _FacultyNotificationsCard(),
                                        ),
                                        const SizedBox(width: AppSpacing.lg),
                                        const Expanded(
                                          child: _RequestsOverviewCard(),
                                        ),
                                      ] else ...[
                                        const _FacultyNotificationsCard(),
                                        const SizedBox(height: AppSpacing.lg),
                                        const _RequestsOverviewCard(),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  _FacultyDashboardSection(
                                    title: 'Teaching Schedule',
                                    actionLabel: 'Open schedule',
                                    children: [
                                      if (isDesktop || isTablet) ...[
                                        const Expanded(
                                          flex: 6,
                                          child: _TodaysFacultyClassesCard(),
                                        ),
                                        const SizedBox(width: AppSpacing.lg),
                                        const Expanded(
                                          flex: 5,
                                          child: _UpcomingLecturesCard(),
                                        ),
                                      ] else ...[
                                        const _TodaysFacultyClassesCard(),
                                        const SizedBox(height: AppSpacing.lg),
                                        const _UpcomingLecturesCard(),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: AppSpacing.lg,
                        left: padding,
                        right: padding,
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1180),
                            child: _FacultyHeader(
                              title: 'Teaching Timetable',
                              dateText: 'Monday, 10:30 AM',
                              avatarText: 'RM',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(int index) {
    setState(() => _selectedIndex = index);
    if (index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This faculty section will be built in a later phase.'),
        ),
      );
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    return false;
  }
}

class _FacultySideNav extends StatelessWidget {
  const _FacultySideNav({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 248,
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Faculty Menu',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _FacultyMenuButton(
            icon: Icons.dashboard_customize_rounded,
            label: 'Dashboard',
            selected: selectedIndex == 0,
            onTap: () => onSelected(0),
          ),
          _FacultyMenuButton(
            icon: Icons.view_timeline_rounded,
            label: 'Schedule',
            selected: selectedIndex == 1,
            onTap: () => onSelected(1),
          ),
          _FacultyMenuButton(
            icon: Icons.approval_rounded,
            label: 'Requests',
            selected: selectedIndex == 2,
            onTap: () => onSelected(2),
          ),
          _FacultyMenuButton(
            icon: Icons.account_circle_rounded,
            label: 'Profile',
            selected: selectedIndex == 3,
            onTap: () => onSelected(3),
          ),
          const Spacer(),
          Text(
            'Smart Sched',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _FacultyBottomNav extends StatelessWidget {
  const _FacultyBottomNav({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_customize_outlined),
          selectedIcon: Icon(Icons.dashboard_customize_rounded),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.view_timeline_outlined),
          selectedIcon: Icon(Icons.view_timeline_rounded),
          label: 'Schedule',
        ),
        NavigationDestination(
          icon: Icon(Icons.approval_outlined),
          selectedIcon: Icon(Icons.approval_rounded),
          label: 'Requests',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_circle_outlined),
          selectedIcon: Icon(Icons.account_circle_rounded),
          label: 'Profile',
        ),
      ],
      onDestinationSelected: onSelected,
    );
  }
}

class _FacultyMenuButton extends StatelessWidget {
  const _FacultyMenuButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primary.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FacultyDashboardSection extends StatelessWidget {
  const _FacultyDashboardSection({
    required this.title,
    required this.actionLabel,
    required this.children,
  });

  final String title;
  final String actionLabel;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.sizeOf(context).width >= 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            TextButton(onPressed: () {}, child: Text(actionLabel)),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (isWide)
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: children)
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
      ],
    );
  }
}

class _FacultyHeader extends StatelessWidget {
  const _FacultyHeader({
    required this.title,
    required this.dateText,
    required this.avatarText,
  });

  final String title;
  final String dateText;
  final String avatarText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.42),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wb_sunny_rounded,
                        color: theme.colorScheme.primary,
                        size: 15,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        dateText,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              tooltip: 'Logout',
              onPressed: () => context.go(AppStrings.landingRoute),
              icon: const Icon(Icons.logout_rounded),
            ),
            const SizedBox(width: AppSpacing.sm),
            CircleAvatar(
              radius: 20,
              backgroundColor: theme.colorScheme.primary.withValues(
                alpha: 0.14,
              ),
              child: Text(
                avatarText,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FacultyHeroCard extends StatelessWidget {
  const _FacultyHeroCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return StudentSectionCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Teaching snapshot',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Welcome back, Dr. Mehta.',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'You have 3 lectures scheduled today, 12 total teaching hours this week, and 2 requests awaiting action.',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (isMobile)
            const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StudentStatPill(
                  label: 'Classes Today',
                  value: '03',
                  color: Color(0xFF3657FF),
                ),
                SizedBox(height: AppSpacing.md),
                StudentStatPill(
                  label: 'Weekly Hours',
                  value: '12 hrs',
                  color: Color(0xFF00A88F),
                ),
                SizedBox(height: AppSpacing.md),
                StudentStatPill(
                  label: 'Next Lecture',
                  value: '10:30 AM',
                  color: Color(0xFFFF6B4A),
                ),
              ],
            )
          else
            const Row(
              children: [
                Expanded(
                  child: StudentStatPill(
                    label: 'Classes Today',
                    value: '03',
                    color: Color(0xFF3657FF),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StudentStatPill(
                    label: 'Weekly Hours',
                    value: '12 hrs',
                    color: Color(0xFF00A88F),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StudentStatPill(
                    label: 'Next Lecture',
                    value: '10:30 AM',
                    color: Color(0xFFFF6B4A),
                  ),
                ),
              ],
            ),
          const SizedBox(height: AppSpacing.xl),
          const _FacultyInfoStrip(
            items: [
              _FacultyInfoStripItem(
                icon: Icons.verified_rounded,
                label: 'Status',
                value: 'No faculty overlaps',
              ),
              _FacultyInfoStripItem(
                icon: Icons.diversity_3_rounded,
                label: 'Current batch',
                value: 'CSE Semester 5',
              ),
              _FacultyInfoStripItem(
                icon: Icons.door_sliding_rounded,
                label: 'Next room',
                value: 'Block B-301',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FacultyInfoStripItem {
  const _FacultyInfoStripItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class _FacultyInfoStrip extends StatelessWidget {
  const _FacultyInfoStrip({required this.items});

  final List<_FacultyInfoStripItem> items;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 700;

    if (!isWide) {
      return Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _FacultyInfoTile(item: item),
              ),
            )
            .toList(),
      );
    }

    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: item == items.last ? 0 : AppSpacing.md,
                ),
                child: _FacultyInfoTile(item: item),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _FacultyInfoTile extends StatelessWidget {
  const _FacultyInfoTile({required this.item});

  final _FacultyInfoStripItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(item.icon, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FacultyNotificationsCard extends StatelessWidget {
  const _FacultyNotificationsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StudentSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifications',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...const [
            _FacultyNoticeTile(
              title: 'Room changed for Compiler Design lecture',
              subtitle: 'Now in Block B-301',
              color: Color(0xFF00A88F),
            ),
            SizedBox(height: AppSpacing.md),
            _FacultyNoticeTile(
              title: 'Department meeting at 4:30 PM',
              subtitle: 'Conference Hall',
              color: Color(0xFF8B5CF6),
            ),
          ],
        ],
      ),
    );
  }
}

class _RequestsOverviewCard extends StatelessWidget {
  const _RequestsOverviewCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StudentSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Requests Overview',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...const [
            _RequestStatusTile(
              label: 'Leave request',
              status: 'Pending approval',
              accent: Color(0xFFFF6B4A),
            ),
            SizedBox(height: AppSpacing.md),
            _RequestStatusTile(
              label: 'Availability update',
              status: 'Submitted',
              accent: Color(0xFF3657FF),
            ),
            SizedBox(height: AppSpacing.md),
            _RequestStatusTile(
              label: 'Substitution request',
              status: 'Needs confirmation',
              accent: Color(0xFFE8A700),
            ),
          ],
        ],
      ),
    );
  }
}

class _TodaysFacultyClassesCard extends StatelessWidget {
  const _TodaysFacultyClassesCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StudentSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Classes",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...const [
            _FacultyClassTile(
              course: 'Compiler Design',
              batch: 'CSE Sem 5',
              room: 'Block B-301',
              time: '10:30 - 11:30',
              accent: Color(0xFF3657FF),
            ),
            SizedBox(height: AppSpacing.md),
            _FacultyClassTile(
              course: 'Operating Systems',
              batch: 'IT Sem 5',
              room: 'Lab 204',
              time: '01:00 - 03:00',
              accent: Color(0xFF00A88F),
            ),
            SizedBox(height: AppSpacing.md),
            _FacultyClassTile(
              course: 'Project Mentoring',
              batch: 'Final Year',
              room: 'Seminar Hall',
              time: '03:30 - 04:30',
              accent: Color(0xFFFF6B4A),
            ),
          ],
        ],
      ),
    );
  }
}

class _UpcomingLecturesCard extends StatelessWidget {
  const _UpcomingLecturesCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StudentSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Lectures',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...const [
            _FacultyAgendaTile(
              day: 'Tomorrow',
              title: 'Database Management Systems',
              subtitle: '09:00 AM - Room A-204',
            ),
            SizedBox(height: AppSpacing.md),
            _FacultyAgendaTile(
              day: 'Thursday',
              title: 'Curriculum Review Session',
              subtitle: '11:30 AM - Meeting Room 2',
            ),
            SizedBox(height: AppSpacing.md),
            _FacultyAgendaTile(
              day: 'Friday',
              title: 'Internal Viva',
              subtitle: '02:00 PM - Innovation Lab',
            ),
          ],
        ],
      ),
    );
  }
}

class _FacultyNoticeTile extends StatelessWidget {
  const _FacultyNoticeTile({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestStatusTile extends StatelessWidget {
  const _RequestStatusTile({
    required this.label,
    required this.status,
    required this.accent,
  });

  final String label;
  final String status;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            flex: 0,
            child: Text(
              status,
              textAlign: TextAlign.right,
              style: theme.textTheme.labelLarge?.copyWith(
                color: accent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FacultyClassTile extends StatelessWidget {
  const _FacultyClassTile({
    required this.course,
    required this.batch,
    required this.room,
    required this.time,
    required this.accent,
  });

  final String course;
  final String batch;
  final String room;
  final String time;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 72,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$batch - $room',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            flex: 0,
            child: Text(
              time,
              textAlign: TextAlign.right,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FacultyAgendaTile extends StatelessWidget {
  const _FacultyAgendaTile({
    required this.day,
    required this.title,
    required this.subtitle,
  });

  final String day;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              day,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
