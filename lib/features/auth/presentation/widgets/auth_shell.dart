import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/brand_mark.dart';
import '../../../landing/presentation/widgets/landing_background.dart';

class AuthShell extends StatelessWidget {
  const AuthShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.formCard,
    required this.sidePanel,
  });

  final String title;
  final String subtitle;
  final Widget formCard;
  final Widget sidePanel;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1100;
    final isTablet = width >= 720;
    final horizontalPadding = isDesktop
        ? AppSpacing.xxxl
        : isTablet
            ? AppSpacing.xl
            : AppSpacing.lg;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: LandingBackground()),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: AppSpacing.lg,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1380),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BrandMark(size: 56),
                      const SizedBox(height: AppSpacing.xl),
                      if (isDesktop)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 11,
                              child: _AuthIntro(
                                title: title,
                                subtitle: subtitle,
                                child: sidePanel,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xl),
                            Expanded(flex: 9, child: formCard),
                          ],
                        )
                      else ...[
                        _AuthIntro(
                          title: title,
                          subtitle: subtitle,
                          child: sidePanel,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        formCard,
                      ],
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

class _AuthIntro extends StatelessWidget {
  const _AuthIntro({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
            ),
          ),
          child: Text(
            'Secure role-based access for every academic stakeholder',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Hero(
          tag: 'landing-title',
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              title,
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -1.6,
                height: 1.05,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            subtitle,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        child,
      ],
    );
  }
}
