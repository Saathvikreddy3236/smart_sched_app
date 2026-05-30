import 'package:flutter/material.dart';

class PlatformPreviewCard extends StatelessWidget {
  const PlatformPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 700;

    return TweenAnimationBuilder<Offset>(
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: const Offset(0, 0.08), end: Offset.zero),
      builder: (context, offset, child) {
        return Transform.translate(
          offset: Offset(0, offset.dy * 120),
          child: child,
        );
      },
      child: Container(
        padding: EdgeInsets.all(isMobile ? 18 : 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: theme.cardColor,
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 40,
              offset: const Offset(0, 24),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                _WindowDot(color: Colors.red.shade300),
                const SizedBox(width: 8),
                _WindowDot(color: Colors.amber.shade400),
                const SizedBox(width: 8),
                _WindowDot(color: Colors.green.shade400),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Live Campus Grid',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 18 : 24),
            Expanded(
              child: isMobile
                  ? const _MobilePreviewLayout()
                  : const _DesktopPreviewLayout(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopPreviewLayout extends StatelessWidget {
  const _DesktopPreviewLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              const Expanded(
                child: _PreviewTile(
                  title: 'Conflict Detection',
                  value: '03 alerts',
                  accent: Color(0xFFF97316),
                ),
              ),
              const SizedBox(height: 16),
              const Expanded(
                child: _PreviewTile(
                  title: 'Room Utilization',
                  value: '84%',
                  accent: Color(0xFF0F766E),
                ),
              ),
              const Spacer(),
              const LinearProgressIndicator(
                value: 0.84,
                minHeight: 10,
                borderRadius: BorderRadius.all(Radius.circular(99)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: List.generate(
                    5,
                    (index) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index == 4 ? 0 : 10),
                        child: _CalendarColumn(index: index),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(
                    child: _MiniLegend(
                      color: Color(0xFF0F766E),
                      label: 'Lectures',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _MiniLegend(
                      color: Color(0xFF38BDF8),
                      label: 'Labs',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _MiniLegend(
                      color: Color(0xFFF59E0B),
                      label: 'Exams',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MobilePreviewLayout extends StatelessWidget {
  const _MobilePreviewLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 92,
                child: _PreviewTile(
                  title: 'Conflict Alerts',
                  value: '03',
                  accent: Color(0xFFF97316),
                  compact: true,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 92,
                child: _PreviewTile(
                  title: 'Room Usage',
                  value: '84%',
                  accent: Color(0xFF0F766E),
                  compact: true,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 138,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) => SizedBox(
              width: 76,
              child: _CalendarColumn(index: index, compact: true),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const LinearProgressIndicator(
          value: 0.84,
          minHeight: 10,
          borderRadius: BorderRadius.all(Radius.circular(99)),
        ),
        const SizedBox(height: 16),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _MiniLegend(color: Color(0xFF0F766E), label: 'Lectures'),
            _MiniLegend(color: Color(0xFF38BDF8), label: 'Labs'),
            _MiniLegend(color: Color(0xFFF59E0B), label: 'Exams'),
          ],
        ),
      ],
    );
  }
}

class _WindowDot extends StatelessWidget {
  const _WindowDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _PreviewTile extends StatelessWidget {
  const _PreviewTile({
    required this.title,
    required this.value,
    required this.accent,
    this.compact = false,
  });

  final String title;
  final String value;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(compact ? 14 : 16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: compact ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: (compact
                    ? theme.textTheme.labelMedium
                    : theme.textTheme.labelLarge)
                ?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: (compact
                    ? theme.textTheme.headlineMedium
                    : theme.textTheme.headlineSmall)
                ?.copyWith(
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarColumn extends StatelessWidget {
  const _CalendarColumn({
    required this.index,
    this.compact = false,
  });

  final int index;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = [
      const Color(0xFF0F766E),
      const Color(0xFF38BDF8),
      const Color(0xFFF59E0B),
      const Color(0xFF10B981),
      const Color(0xFF6366F1),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: palette[index].withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'][index],
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 12 : null,
                ),
          ),
          SizedBox(height: compact ? 8 : 12),
          Expanded(
            child: Column(
              children: List.generate(
                3,
                (slot) => Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: slot == 2 ? 0 : (compact ? 8 : 10),
                    ),
                    decoration: BoxDecoration(
                      color: palette[(index + slot) % palette.length]
                          .withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(14),
                    ),
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

class _MiniLegend extends StatelessWidget {
  const _MiniLegend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(child: Text(label)),
        ],
      ),
    );
  }
}
