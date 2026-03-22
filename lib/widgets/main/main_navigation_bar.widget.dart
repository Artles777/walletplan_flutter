import "package:flutter/material.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/router/base_delegate.dart";

class MainNavigationBarWidget extends StatelessWidget {
  const MainNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: baseDelegate,
      builder: (context, _) {
        final uri = baseDelegate.configuration.uri;
        final currentIndex = indexFromUri(uri);

        Widget item({
          required int index,
          required IconData icon,
          required IconData activeIcon,
          required String label,
        }) {
          final selected = currentIndex == index;

          return Expanded(
            child: InkResponse(
              onTap: () => baseDelegate.beamToNamed(pathForIndex(index)),
              radius: 28,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    selected ? activeIcon : icon,
                    size: 22,
                    color: selected ? cs.primary : cs.onSurfaceVariant,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: (tt.labelSmall ?? const TextStyle()).copyWith(
                      fontSize: 11,
                      height: 1.0,
                      color: selected ? cs.primary : cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return BottomAppBar(
          color: cs.surfaceContainer,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          clipBehavior: Clip.antiAlias,
          height: kBottomNavigationBarHeight,
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              item(
                index: 0,
                icon: Icons.exposure_outlined,
                activeIcon: Icons.exposure,
                label: t.main.navigationBar.transactions,
              ),
              item(
                index: 1,
                icon: Icons.account_balance_wallet_outlined,
                activeIcon: Icons.account_balance_wallet,
                label: t.main.navigationBar.accounts,
              ),
              const SizedBox(width: 34),
              item(
                index: 2,
                icon: Icons.event_note_outlined,
                activeIcon: Icons.event_note,
                label: t.main.navigationBar.plans,
              ),
              item(
                index: 3,
                icon: Icons.analytics_outlined,
                activeIcon: Icons.analytics,
                label: t.main.navigationBar.analytic,
              ),
            ],
          ),
        );
      },
    );
  }
}
