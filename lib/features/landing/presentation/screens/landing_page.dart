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
        : 500.0;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: Stack(
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
                        SizedBox(
                          height: isMobile ? AppSpacing.lg : AppSpacing.xl,
                        ),
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
                        const SizedBox(height: AppSpacing.xxl),
                        Container(
                          key: _featuresKey,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Everything needed to follow the day',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                              ),
                              if (!isMobile)
                                Text(
                                  'Focused for students and faculty',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                            ],
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

    if (!isDesktop) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          children: [
            BrandMark(size: isMobile ? 42 : 46, compact: true),
            const Spacer(),
            IconButton.filledTonal(
              tooltip: 'What you get',
              onPressed: onFeaturesTap,
              icon: const Icon(Icons.grid_view_rounded),
            ),
            const SizedBox(width: AppSpacing.xs),
            FilledButton(
              onPressed: () => context.go(AppStrings.loginRoute),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          const BrandMark(size: 46, compact: false),
          const Spacer(),
          TextButton.icon(
            onPressed: onFeaturesTap,
            icon: const Icon(Icons.grid_view_rounded),
            label: const Text('What you get'),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.view_timeline_rounded),
            label: const Text('Timetable app'),
          ),
          const SizedBox(width: AppSpacing.sm),
          FilledButton.tonal(
            onPressed: () => context.go(AppStrings.loginRoute),
            child: const Text('Login'),
          ),
        ],
      ),
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
            letterSpacing: 0,
            height: 0.98,
          )
        : theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
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
              'Precision scheduling for academic days',
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
            child: Text(AppStrings.appTitle, style: titleStyle),
          ),
        ),
        SizedBox(height: isMobile ? AppSpacing.md : AppSpacing.lg),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            AppStrings.appSubtitle,
            style:
                (isMobile
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
                icon: const Icon(Icons.rocket_launch_rounded),
                label: const Text('Get Started'),
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
                icon: const Icon(Icons.rocket_launch_rounded),
                label: const Text('Get Started'),
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
                    child: HeroMetricChip(label: 'Today View', value: 'Live'),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: HeroMetricChip(label: 'Role Access', value: 'Role'),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              HeroMetricChip(label: 'Academic Alerts', value: 'On'),
            ],
          )
        else
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: const [
              HeroMetricChip(label: 'Today View', value: 'Live'),
              HeroMetricChip(label: 'Role Access', value: '2'),
              HeroMetricChip(label: 'Alerts', value: 'Instant'),
            ],
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

const _features = [
  _FeatureData(
    title: 'Personal Timetable',
    description:
        'Students and faculty can quickly see today classes, rooms, and upcoming sessions.',
    icon: Icons.event_available_rounded,
    color: Color(0xFF3657FF),
  ),
  _FeatureData(
    title: 'Room and Time Updates',
    description:
        'Important changes are surfaced clearly so users do not miss relocated or rescheduled classes.',
    icon: Icons.door_sliding_rounded,
    color: Color(0xFFFF6B4A),
  ),
  _FeatureData(
    title: 'Academic Alerts',
    description:
        'Notices, quizzes, substitutions, and department updates stay visible in one place.',
    icon: Icons.campaign_rounded,
    color: Color(0xFF00A88F),
  ),
  _FeatureData(
    title: 'Attendance Snapshot',
    description:
        'Students can track attendance status without digging through multiple screens.',
    icon: Icons.verified_rounded,
    color: Color(0xFF8B5CF6),
  ),
  _FeatureData(
    title: 'Faculty Teaching View',
    description:
        'Faculty can see lectures, batches, room details, and pending schedule-related updates.',
    icon: Icons.workspace_premium_rounded,
    color: Color(0xFFE8A700),
  ),
];
