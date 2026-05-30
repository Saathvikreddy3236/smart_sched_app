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
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Timetable',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none_rounded),
            selectedIcon: Icon(Icons.notifications_rounded),
            label: 'Notifications',
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
                content: Text('This student tab will be built in a later phase.'),
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
                      _DashboardHeader(isDesktop: isDesktop),
                      const SizedBox(height: AppSpacing.xl),
                      if (isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 11,
                              child: _StudentHeroCard(),
                            ),
                            const SizedBox(width: AppSpacing.xl),
                            Expanded(
                              flex: 8,
                              child: Column(
                                children: const [
                                  _AttendanceCard(),
                                  SizedBox(height: AppSpacing.lg),
                                  _AnnouncementsCard(),
                                ],
                              ),
                            ),
                          ],
                        )
                      else ...[
                        const _StudentHeroCard(),
                        const SizedBox(height: AppSpacing.lg),
                        const _AttendanceCard(),
                        const SizedBox(height: AppSpacing.lg),
                        const _AnnouncementsCard(),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      if (isDesktop || isTablet)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Expanded(flex: 6, child: _TodaysClassesCard()),
                            SizedBox(width: AppSpacing.lg),
                            Expanded(flex: 5, child: _UpcomingClassesCard()),
                          ],
                        )
                      else
                        const Column(
                          children: [
                            _TodaysClassesCard(),
                            SizedBox(height: AppSpacing.lg),
                            _UpcomingClassesCard(),
                          ],
                        ),
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

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.isDesktop});

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
                'Student Workspace',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Track classes, attendance, and announcements at a glance.',
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
                hintText: 'Search subjects or rooms',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: theme.colorScheme.surface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
        const SizedBox(width: AppSpacing.md),
        CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.14),
          child: Text(
            'AS',
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
              letterSpacing: -1.4,
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
                  color: Color(0xFF0F766E),
                ),
                SizedBox(height: AppSpacing.md),
                StudentStatPill(
                  label: 'Upcoming Lab',
                  value: '1:30 PM',
                  color: Color(0xFF0284C7),
                ),
                SizedBox(height: AppSpacing.md),
                StudentStatPill(
                  label: 'Free Time',
                  value: '2 hrs',
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
                    value: '04',
                    color: Color(0xFF0F766E),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StudentStatPill(
                    label: 'Upcoming Lab',
                    value: '1:30 PM',
                    color: Color(0xFF0284C7),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StudentStatPill(
                    label: 'Free Time',
                    value: '2 hrs',
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
                label: Text('No class clashes'),
              ),
              Chip(
                avatar: Icon(Icons.location_on_rounded, size: 16),
                label: Text('Next room: Lab 204'),
              ),
              Chip(
                avatar: Icon(Icons.person_rounded, size: 16),
                label: Text('Advisor: Dr. Mehta'),
              ),
            ],
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
              color: Color(0xFF0284C7),
            ),
            SizedBox(height: AppSpacing.md),
            _AnnouncementTile(
              title: 'Data Structures quiz on Friday at 10:00 AM',
              subtitle: 'Exam cell notice',
              color: Color(0xFFF59E0B),
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
              accent: Color(0xFF0F766E),
            ),
            SizedBox(height: AppSpacing.md),
            _ClassTile(
              subject: 'Operating Systems Lab',
              faculty: 'Dr. Iyer',
              room: 'Lab 204',
              time: '01:30 - 03:30',
              accent: Color(0xFF0284C7),
            ),
            SizedBox(height: AppSpacing.md),
            _ClassTile(
              subject: 'Software Engineering',
              faculty: 'Prof. Nair',
              room: 'Room C-103',
              time: '04:00 - 05:00',
              accent: Color(0xFFF59E0B),
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
              subtitle: '08:30 AM • Room D-105',
            ),
            SizedBox(height: AppSpacing.md),
            _MiniAgendaTile(
              day: 'Tomorrow',
              title: 'Project Review',
              subtitle: '02:00 PM • Seminar Hall',
            ),
            SizedBox(height: AppSpacing.md),
            _MiniAgendaTile(
              day: 'Friday',
              title: 'Data Structures Quiz',
              subtitle: '10:00 AM • Block A',
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
                  '$faculty • $room',
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
