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
    final isMobile = width < 700;
    final padding = isDesktop
        ? AppSpacing.xxxl
        : isTablet
            ? AppSpacing.xl
            : AppSpacing.lg;

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Schedule',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment_rounded),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
          if (index != 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This faculty tab will be built in a later phase.'),
              ),
            );
          }
        },
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: LandingBackground()),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(padding, AppSpacing.lg, padding, 120),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FacultyHeader(isDesktop: isDesktop),
                      const SizedBox(height: AppSpacing.xl),
                      if (isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(flex: 11, child: _FacultyHeroCard()),
                            const SizedBox(width: AppSpacing.xl),
                            Expanded(
                              flex: 8,
                              child: Column(
                                children: const [
                                  _FacultyNotificationsCard(),
                                  SizedBox(height: AppSpacing.lg),
                                  _RequestsOverviewCard(),
                                ],
                              ),
                            ),
                          ],
                        )
                      else ...[
                        const _FacultyHeroCard(),
                        const SizedBox(height: AppSpacing.lg),
                        const _FacultyNotificationsCard(),
                        const SizedBox(height: AppSpacing.lg),
                        const _RequestsOverviewCard(),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      if (isDesktop || isTablet)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Expanded(flex: 6, child: _TodaysFacultyClassesCard()),
                            SizedBox(width: AppSpacing.lg),
                            Expanded(flex: 5, child: _UpcomingLecturesCard()),
                          ],
                        )
                      else
                        const Column(
                          children: [
                            _TodaysFacultyClassesCard(),
                            SizedBox(height: AppSpacing.lg),
                            _UpcomingLecturesCard(),
                          ],
                        ),
                      if (isMobile) const SizedBox(height: AppSpacing.sm),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FacultyHeader extends StatelessWidget {
  const _FacultyHeader({required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Faculty Workspace',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Manage lectures, teaching load, and academic requests from one place.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (isDesktop) ...[
          const SizedBox(width: AppSpacing.lg),
          SizedBox(
            width: 280,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search course or batch',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: theme.colorScheme.surface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
        FilledButton.tonalIcon(
          onPressed: () => context.go(AppStrings.landingRoute),
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Logout'),
        ),
        const SizedBox(width: AppSpacing.md),
        CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.14),
          child: Text(
            'RM',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
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
              letterSpacing: -1.4,
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
                  color: Color(0xFF0F766E),
                ),
                SizedBox(height: AppSpacing.md),
                StudentStatPill(
                  label: 'Weekly Hours',
                  value: '12 hrs',
                  color: Color(0xFF0284C7),
                ),
                SizedBox(height: AppSpacing.md),
                StudentStatPill(
                  label: 'Next Lecture',
                  value: '10:30 AM',
                  color: Color(0xFFF59E0B),
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
                    color: Color(0xFF0F766E),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StudentStatPill(
                    label: 'Weekly Hours',
                    value: '12 hrs',
                    color: Color(0xFF0284C7),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StudentStatPill(
                    label: 'Next Lecture',
                    value: '10:30 AM',
                    color: Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: const [
              Chip(
                avatar: Icon(Icons.circle, size: 12, color: Color(0xFF16A34A)),
                label: Text('No faculty overlaps'),
              ),
              Chip(
                avatar: Icon(Icons.groups_rounded, size: 16),
                label: Text('Batch: CSE Semester 5'),
              ),
              Chip(
                avatar: Icon(Icons.meeting_room_rounded, size: 16),
                label: Text('Next room: Block B-301'),
              ),
            ],
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
              color: Color(0xFF0284C7),
            ),
            SizedBox(height: AppSpacing.md),
            _FacultyNoticeTile(
              title: 'Department meeting at 4:30 PM',
              subtitle: 'Conference Hall',
              color: Color(0xFF7C3AED),
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
              accent: Color(0xFFF59E0B),
            ),
            SizedBox(height: AppSpacing.md),
            _RequestStatusTile(
              label: 'Availability update',
              status: 'Submitted',
              accent: Color(0xFF0F766E),
            ),
            SizedBox(height: AppSpacing.md),
            _RequestStatusTile(
              label: 'Substitution request',
              status: 'Needs confirmation',
              accent: Color(0xFFF97316),
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
              accent: Color(0xFF0F766E),
            ),
            SizedBox(height: AppSpacing.md),
            _FacultyClassTile(
              course: 'Operating Systems',
              batch: 'IT Sem 5',
              room: 'Lab 204',
              time: '01:00 - 03:00',
              accent: Color(0xFF0284C7),
            ),
            SizedBox(height: AppSpacing.md),
            _FacultyClassTile(
              course: 'Project Mentoring',
              batch: 'Final Year',
              room: 'Seminar Hall',
              time: '03:30 - 04:30',
              accent: Color(0xFFF59E0B),
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
              subtitle: '09:00 AM • Room A-204',
            ),
            SizedBox(height: AppSpacing.md),
            _FacultyAgendaTile(
              day: 'Thursday',
              title: 'Curriculum Review Session',
              subtitle: '11:30 AM • Meeting Room 2',
            ),
            SizedBox(height: AppSpacing.md),
            _FacultyAgendaTile(
              day: 'Friday',
              title: 'Internal Viva',
              subtitle: '02:00 PM • Innovation Lab',
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
        borderRadius: BorderRadius.circular(18),
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
        borderRadius: BorderRadius.circular(18),
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
          Text(
            status,
            style: theme.textTheme.labelLarge?.copyWith(
              color: accent,
              fontWeight: FontWeight.w800,
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
                  course,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$batch • $room',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            time,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
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
        borderRadius: BorderRadius.circular(20),
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
