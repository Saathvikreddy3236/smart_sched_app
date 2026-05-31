import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../landing/presentation/widgets/landing_background.dart';
import '../widgets/student_section_card.dart';
import '../widgets/student_stat_pill.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
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
          : _StudentBottomNav(
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
                  _StudentSideNav(
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
                                  const _StudentHeroCard(),
                                  const SizedBox(height: AppSpacing.lg),
                                  _DashboardSection(
                                    title: 'Academic Overview',
                                    actionLabel: 'View all',
                                    children: [
                                      if (isDesktop || isTablet) ...[
                                        const Expanded(
                                          child: _AttendanceCard(),
                                        ),
                                        const SizedBox(width: AppSpacing.lg),
                                        const Expanded(
                                          child: _AnnouncementsCard(),
                                        ),
                                      ] else ...[
                                        const _AttendanceCard(),
                                        const SizedBox(height: AppSpacing.lg),
                                        const _AnnouncementsCard(),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  _DashboardSection(
                                    title: 'Schedule',
                                    actionLabel: 'Open timetable',
                                    children: [
                                      if (isDesktop || isTablet) ...[
                                        const Expanded(
                                          flex: 6,
                                          child: _TodaysClassesCard(),
                                        ),
                                        const SizedBox(width: AppSpacing.lg),
                                        const Expanded(
                                          flex: 5,
                                          child: _UpcomingClassesCard(),
                                        ),
                                      ] else ...[
                                        const _TodaysClassesCard(),
                                        const SizedBox(height: AppSpacing.lg),
                                        const _UpcomingClassesCard(),
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
                            child: _DashboardHeader(
                              title: 'My Timetable',
                              dateText: 'Monday, 09:00 AM',
                              avatarText: 'AS',
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
          content: Text('This student section will be built in a later phase.'),
        ),
      );
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    return false;
  }
}

class _StudentSideNav extends StatelessWidget {
  const _StudentSideNav({
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
            'Student Menu',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _MenuButton(
            icon: Icons.dashboard_customize_rounded,
            label: 'Home',
            selected: selectedIndex == 0,
            onTap: () => onSelected(0),
          ),
          _MenuButton(
            icon: Icons.view_timeline_rounded,
            label: 'Timetable',
            selected: selectedIndex == 1,
            onTap: () => onSelected(1),
          ),
          _MenuButton(
            icon: Icons.campaign_rounded,
            label: 'Notifications',
            selected: selectedIndex == 2,
            onTap: () => onSelected(2),
          ),
          _MenuButton(
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

class _StudentBottomNav extends StatelessWidget {
  const _StudentBottomNav({
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
          label: 'Timetable',
        ),
        NavigationDestination(
          icon: Icon(Icons.campaign_outlined),
          selectedIcon: Icon(Icons.campaign_rounded),
          label: 'Alerts',
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

class _MenuButton extends StatelessWidget {
  const _MenuButton({
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

class _DashboardSection extends StatelessWidget {
  const _DashboardSection({
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

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
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

class _StudentHeroCard extends StatelessWidget {
  const _StudentHeroCard();

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
              'Today at a glance',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Good morning, Aarya.',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'You have 4 classes today, 1 lab coming up, and no schedule conflicts.',
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
                  value: '04',
                  color: Color(0xFF3657FF),
                ),
                SizedBox(height: AppSpacing.md),
                StudentStatPill(
                  label: 'Upcoming Lab',
                  value: '1:30 PM',
                  color: Color(0xFF00A88F),
                ),
                SizedBox(height: AppSpacing.md),
                StudentStatPill(
                  label: 'Free Time',
                  value: '2 hrs',
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
                    value: '04',
                    color: Color(0xFF3657FF),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StudentStatPill(
                    label: 'Upcoming Lab',
                    value: '1:30 PM',
                    color: Color(0xFF00A88F),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StudentStatPill(
                    label: 'Free Time',
                    value: '2 hrs',
                    color: Color(0xFFFF6B4A),
                  ),
                ),
              ],
            ),
          const SizedBox(height: AppSpacing.xl),
          const _StudentInfoStrip(
            items: [
              _InfoStripItem(
                icon: Icons.verified_rounded,
                label: 'Status',
                value: 'No class clashes',
              ),
              _InfoStripItem(
                icon: Icons.explore_rounded,
                label: 'Next room',
                value: 'Lab 204',
              ),
              _InfoStripItem(
                icon: Icons.support_agent_rounded,
                label: 'Advisor',
                value: 'Dr. Mehta',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoStripItem {
  const _InfoStripItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class _StudentInfoStrip extends StatelessWidget {
  const _StudentInfoStrip({required this.items});

  final List<_InfoStripItem> items;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 700;

    if (!isWide) {
      return Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _StudentInfoTile(item: item),
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
                child: _StudentInfoTile(item: item),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _StudentInfoTile extends StatelessWidget {
  const _StudentInfoTile({required this.item});

  final _InfoStripItem item;

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

class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StudentSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '86%',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Above department minimum. Keep this pace to stay exam-eligible.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const LinearProgressIndicator(
            value: 0.86,
            minHeight: 12,
            borderRadius: BorderRadius.all(Radius.circular(999)),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementsCard extends StatelessWidget {
  const _AnnouncementsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StudentSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Announcements',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...const [
            _AnnouncementTile(
              title: 'Algorithms class moved to Room A-302',
              subtitle: 'Updated 15 mins ago',
              color: Color(0xFF00A88F),
            ),
            SizedBox(height: AppSpacing.md),
            _AnnouncementTile(
              title: 'Data Structures quiz on Friday at 10:00 AM',
              subtitle: 'Exam cell notice',
              color: Color(0xFFFF6B4A),
            ),
          ],
        ],
      ),
    );
  }
}

class _AnnouncementTile extends StatelessWidget {
  const _AnnouncementTile({
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
        borderRadius: BorderRadius.circular(22),
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

class _TodaysClassesCard extends StatelessWidget {
  const _TodaysClassesCard();

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
            _ClassTile(
              subject: 'Database Systems',
              faculty: 'Prof. Sharma',
              room: 'Room B-201',
              time: '09:00 - 10:00',
              accent: Color(0xFF3657FF),
            ),
            SizedBox(height: AppSpacing.md),
            _ClassTile(
              subject: 'Operating Systems Lab',
              faculty: 'Dr. Iyer',
              room: 'Lab 204',
              time: '01:30 - 03:30',
              accent: Color(0xFF00A88F),
            ),
            SizedBox(height: AppSpacing.md),
            _ClassTile(
              subject: 'Software Engineering',
              faculty: 'Prof. Nair',
              room: 'Room C-103',
              time: '04:00 - 05:00',
              accent: Color(0xFFFF6B4A),
            ),
          ],
        ],
      ),
    );
  }
}

class _UpcomingClassesCard extends StatelessWidget {
  const _UpcomingClassesCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StudentSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...const [
            _MiniAgendaTile(
              day: 'Tomorrow',
              title: 'Computer Networks',
              subtitle: '08:30 AM - Room D-105',
            ),
            SizedBox(height: AppSpacing.md),
            _MiniAgendaTile(
              day: 'Tomorrow',
              title: 'Project Review',
              subtitle: '02:00 PM - Seminar Hall',
            ),
            SizedBox(height: AppSpacing.md),
            _MiniAgendaTile(
              day: 'Friday',
              title: 'Data Structures Quiz',
              subtitle: '10:00 AM - Block A',
            ),
          ],
        ],
      ),
    );
  }
}

class _ClassTile extends StatelessWidget {
  const _ClassTile({
    required this.subject,
    required this.faculty,
    required this.room,
    required this.time,
    required this.accent,
  });

  final String subject;
  final String faculty;
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
        borderRadius: BorderRadius.circular(22),
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
                  subject,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$faculty - $room',
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

class _MiniAgendaTile extends StatelessWidget {
  const _MiniAgendaTile({
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
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
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
