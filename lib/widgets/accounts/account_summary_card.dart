import "package:flutter/material.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";

class AccountSummaryCard extends StatelessWidget {
  const AccountSummaryCard({
    required this.title,
    required this.totalAmountLabel,
    required this.activeAccountsLabel,
    required this.breakdownLabel,
    this.collapseProgress = 0,
    this.onAddAccount,
    super.key,
  });

  final String title;
  final String totalAmountLabel;
  final String activeAccountsLabel;
  final String breakdownLabel;
  final double collapseProgress;
  final VoidCallback? onAddAccount;

  double _collapseFactor(double progress, double start, double end) {
    if (progress <= start) {
      return 1.0;
    }
    if (progress >= end) {
      return 0.0;
    }

    return 1 - ((progress - start) / (end - start));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    final progress = collapseProgress.clamp(0.0, 1.0);
    final activeFactor = _collapseFactor(progress, 0.0, 0.42);
    final breakdownFactor = _collapseFactor(progress, 0.22, 0.82);
    final detailsFactor = activeFactor > breakdownFactor
        ? activeFactor
        : breakdownFactor;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: cs.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.45)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      key: const ValueKey("accounts-summary-title"),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tt.titleSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        totalAmountLabel,
                        key: const ValueKey("accounts-summary-total"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                          height: 1.0,
                        ),
                      ),
                      if (onAddAccount != null) ...[
                        const SizedBox(width: 6),
                        SizedBox.square(
                          dimension: 30,
                          child: IconButton(
                            key: const ValueKey("accounts-summary-add-account"),
                            onPressed: onAddAccount,
                            tooltip: context.t.accountsPage.addAccount,
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            style: IconButton.styleFrom(
                              backgroundColor: cs.primaryContainer,
                              foregroundColor: cs.onPrimaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.add_rounded, size: 16),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              _CollapsingSummaryPart(
                factor: detailsFactor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Divider(
                      key: const ValueKey("accounts-summary-divider"),
                      color: cs.outlineVariant,
                      height: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10 * detailsFactor),
              _CollapsingSummaryPart(
                factor: activeFactor,
                child: Text(
                  activeAccountsLabel,
                  key: const ValueKey("accounts-summary-active"),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
                ),
              ),
              SizedBox(height: 1 * breakdownFactor),
              _CollapsingSummaryPart(
                factor: breakdownFactor,
                child: Text(
                  breakdownLabel,
                  key: const ValueKey("accounts-summary-breakdown"),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollapsingSummaryPart extends StatelessWidget {
  const _CollapsingSummaryPart({required this.factor, required this.child});

  final double factor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (factor <= 0.001) {
      return const SizedBox.shrink();
    }

    return ClipRect(
      child: Align(
        alignment: Alignment.topLeft,
        heightFactor: factor,
        child: Opacity(opacity: factor, child: child),
      ),
    );
  }
}
