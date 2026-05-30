import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/brand_mark.dart';
import '../widgets/feature_highlight_card.dart';
import '../widgets/hero_metric_chip.dart';
import '../widgets/landing_background.dart';
import '../widgets/platform_preview_card.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _scrollController = ScrollController();
  final _featuresKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToFeatures() {
    final context = _featuresKey.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeInOutCubic,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1100;
    final isTablet = width >= 700 && width < 1100;
    final isMobile = width < 700;
    final horizontalPadding = isDesktop
        ? AppSpacing.xxxl
        : isTablet
            ? AppSpacing.xl
            : AppSpacing.lg;
    final previewHeight = isDesktop
        ? 520.0
        : isTablet
            ? 420.0
            : 560.0;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: LandingBackground()),
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: AppSpacing.lg,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LandingAppBar(
                        isDesktop: isDesktop,
                        isMobile: isMobile,
                        onFeaturesTap: _scrollToFeatures,
                      ),
                      SizedBox(height: isMobile ? AppSpacing.lg : AppSpacing.xl),
                      if (isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(flex: 11, child: _HeroContent()),
                            const SizedBox(width: AppSpacing.xl),
                            Expanded(
                              flex: 10,
                              child: SizedBox(
                                height: previewHeight,
                                child: const PlatformPreviewCard(),
                              ),
                            ),
                          ],
                        )
                      else ...[
                        const _HeroContent(),
                        const SizedBox(height: AppSpacing.xl),
                        SizedBox(
                          height: previewHeight,
                          child: const PlatformPreviewCard(),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xxxl),
                      Container(
                        key: _featuresKey,
                        child: Text(
                          'Why teams choose this platform',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final columns = constraints.maxWidth >= 1200
                              ? 5
                              : constraints.maxWidth >= 800
                              ? 2
                              : 1;

                          return Wrap(
                            spacing: AppSpacing.lg,
                            runSpacing: AppSpacing.lg,
                            children: _features
                                .map(
                                  (feature) => SizedBox(
                                    width: columns == 1
                                        ? constraints.maxWidth
                                        : columns == 2
                                        ? (constraints.maxWidth -
                                                  AppSpacing.lg) /
                                              2
                                        : (constraints.maxWidth -
                                                  (AppSpacing.lg * 4)) /
                                              5,
                                    child: FeatureHighlightCard(
                                      title: feature.title,
                                      description: feature.description,
                                      icon: feature.icon,
                                      color: feature.color,
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
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

class _LandingAppBar extends StatelessWidget {
  const _LandingAppBar({
    required this.isDesktop,
    required this.isMobile,
    required this.onFeaturesTap,
  });

  final bool isDesktop;
  final bool isMobile;
  final VoidCallback onFeaturesTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BrandMark(size: 52, compact: true),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TextButton(
                  onPressed: onFeaturesTap,
                  child: const Text('Features'),
                ),
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: () => context.go(AppStrings.loginRoute),
                  child: const Text('Login'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => context.go(AppStrings.loginRoute),
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  child: const Text('Get Started'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        const BrandMark(size: 56, compact: false),
        const Spacer(),
        if (isDesktop) ...[
          TextButton(
            onPressed: onFeaturesTap,
            child: const Text('Features'),
          ),
          const SizedBox(width: 8),
          TextButton(onPressed: () {}, child: const Text('Platform')),
          const SizedBox(width: 12),
        ],
        FilledButton.tonal(
          onPressed: () => context.go(AppStrings.loginRoute),
          child: const Text('Login'),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: () => context.go(AppStrings.loginRoute),
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: const Text('Get Started'),
        ),
      ],
    );
  }
}

class _HeroContent extends StatelessWidget {
  const _HeroContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 700;
    final titleStyle = isMobile
        ? theme.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -1.4,
            height: 0.98,
          )
        : theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -1.8,
            height: 1.05,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          tween: Tween(begin: 0, end: 1),
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, (1 - value) * 24),
              child: child,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
              ),
            ),
            child: Text(
              'Designed for universities, faculties, and campus operations',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Hero(
          tag: 'landing-title',
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              AppStrings.appTitle,
              style: titleStyle,
            ),
          ),
        ),
        SizedBox(height: isMobile ? AppSpacing.md : AppSpacing.lg),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            AppStrings.appSubtitle,
            style: (isMobile
                    ? theme.textTheme.titleLarge
                    : theme.textTheme.titleMedium)
                ?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        if (isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: () => context.go(AppStrings.loginRoute),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Get Started'),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: () => context.go(AppStrings.loginRoute),
                icon: const Icon(Icons.login_rounded),
                label: const Text('Login'),
              ),
            ],
          )
        else
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              FilledButton.icon(
                onPressed: () => context.go(AppStrings.loginRoute),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Get Started'),
              ),
              OutlinedButton.icon(
                onPressed: () => context.go(AppStrings.loginRoute),
                icon: const Icon(Icons.login_rounded),
                label: const Text('Login'),
              ),
            ],
          ),
        const SizedBox(height: AppSpacing.xl),
        if (isMobile)
          Column(
            children: const [
              Row(
                children: [
                  Expanded(
                    child: HeroMetricChip(
                      label: 'Campuses Coordinated',
                      value: '12+',
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: HeroMetricChip(
                      label: 'Scheduling Accuracy',
                      value: '98%',
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              HeroMetricChip(
                label: 'Reschedule Time Saved',
                value: '6 hrs',
              ),
            ],
          )
        else
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: const [
              HeroMetricChip(label: 'Campuses Coordinated', value: '12+'),
              HeroMetricChip(label: 'Scheduling Accuracy', value: '98%'),
              HeroMetricChip(label: 'Reschedule Time Saved', value: '6 hrs'),
            ],
          ),
        const SizedBox(height: AppSpacing.xl),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _featureLabels
              .map(
                (label) => Chip(
                  label: Text(label),
                  avatar: const Icon(Icons.check_circle_rounded, size: 18),
                ),
              )
              .toList(),
        ),
        if (isMobile) const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

class _FeatureData {
  const _FeatureData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
}

const _featureLabels = [
  'Smart Scheduling',
  'Conflict Detection',
  'Real-time Updates',
  'Analytics Dashboard',
  'Adaptive Rescheduling',
];

const _features = [
  _FeatureData(
    title: 'Smart Scheduling',
    description:
        'Create balanced academic timetables with structured automation for classes, labs, and exams.',
    icon: Icons.auto_awesome_rounded,
    color: Color(0xFF0F766E),
  ),
  _FeatureData(
    title: 'Conflict Detection',
    description:
        'Catch faculty overlaps, room collisions, and time-slot clashes before they impact students.',
    icon: Icons.warning_amber_rounded,
    color: Color(0xFFF97316),
  ),
  _FeatureData(
    title: 'Real-time Updates',
    description:
        'Keep students, faculty, and administrators aligned with live timetable and room changes.',
    icon: Icons.notifications_active_rounded,
    color: Color(0xFF0284C7),
  ),
  _FeatureData(
    title: 'Analytics Dashboard',
    description:
        'Track room utilization, teaching load, and scheduling efficiency with executive-ready views.',
    icon: Icons.insights_rounded,
    color: Color(0xFF7C3AED),
  ),
  _FeatureData(
    title: 'Adaptive Rescheduling',
    description:
        'Respond faster to disruptions by previewing downstream impact before confirming changes.',
    icon: Icons.sync_alt_rounded,
    color: Color(0xFF16A34A),
  ),
];
