import "package:flutter/material.dart";
import "package:walletplan_flutter/utils/currency_formatter.dart";
import "package:walletplan_flutter/widgets/accounts/models/account_item.dart";

class AccountListTile extends StatelessWidget {
  const AccountListTile({required this.item, required this.onTap, super.key});

  final AccountItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    final amountLabel = formatCurrencyAmount(
      item.amount,
      item.currency,
      decimalDigits: 0,
    );
    final iconBackgroundColor = _iconBackgroundColor(cs, item.sourceType);
    final iconColor = _iconForegroundColor(cs, item.sourceType);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: SizedBox(
                width: 44,
                height: 44,
                child: Icon(item.icon, color: iconColor),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.displayTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  if (item.sourceType != AccountSourceType.connected) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                  if (item.progress != null &&
                      item.sourceType == AccountSourceType.manual) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: item.progress!.clamp(0.0, 1.0),
                        minHeight: 4,
                        backgroundColor: cs.surfaceContainerHighest,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: item.hasSyncState ? 124 : 88,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          amountLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                        if (item.hasSyncState) ...[
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  item.syncLabel!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                  style: tt.labelSmall?.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              _StatusDot(status: item.syncStatus!),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.edit_note_rounded,
                    color: cs.onSurfaceVariant,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _iconBackgroundColor(ColorScheme cs, AccountSourceType sourceType) {
    return switch (sourceType) {
      AccountSourceType.connected => cs.primaryContainer,
      AccountSourceType.manual => cs.secondaryContainer,
      AccountSourceType.investment => cs.tertiaryContainer,
    };
  }

  Color _iconForegroundColor(ColorScheme cs, AccountSourceType sourceType) {
    return switch (sourceType) {
      AccountSourceType.connected => cs.onPrimaryContainer,
      AccountSourceType.manual => cs.onSecondaryContainer,
      AccountSourceType.investment => cs.onTertiaryContainer,
    };
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});

  final AccountSyncStatus status;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _statusColor(Theme.of(context).colorScheme, status),
        shape: BoxShape.circle,
      ),
      child: const SizedBox(width: 8, height: 8),
    );
  }

  Color _statusColor(ColorScheme cs, AccountSyncStatus syncStatus) {
    return switch (syncStatus) {
      AccountSyncStatus.success => const Color(0xFF2E9E4D),
      AccountSyncStatus.warning => cs.outline,
      AccountSyncStatus.error => const Color(0xFFD04E3C),
    };
  }
}
