import "package:flutter/material.dart";
import "package:walletplan_flutter/widgets/accounts/account_list_tile.dart";
import "package:walletplan_flutter/widgets/accounts/models/account_item.dart";

class AccountSectionBlock extends StatelessWidget {
  const AccountSectionBlock({
    required this.title,
    required this.items,
    required this.onTapItem,
    super.key,
  });

  final String title;
  final List<AccountItem> items;
  final ValueChanged<AccountItem> onTapItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
          child: Text(
            title,
            style: tt.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: cs.surfaceContainerLow,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.45),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var index = 0; index < items.length; index++) ...[
                  AccountListTile(
                    item: items[index],
                    onTap: () => onTapItem(items[index]),
                  ),
                  if (index < items.length - 1)
                    Divider(
                      height: 1,
                      indent: 72,
                      endIndent: 16,
                      color: cs.outlineVariant,
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
