import "package:flutter/material.dart";
import "package:flutter_compositions/flutter_compositions.dart";
import "package:walletplan_flutter/i18n/strings.g.dart";
import "package:walletplan_flutter/stores/transactions/use_income_expense_fab.dart";
import "package:walletplan_flutter/utils/beamer_context_ext.dart";

typedef SetAddType = void Function(AddType type);

class AddAppBarWidget extends CompositionWidget implements PreferredSizeWidget {
  const AddAppBarWidget({required this.setType, required this.type, super.key});

  final SetAddType setType;
  final AddType type;

  @override
  Widget Function(BuildContext context) setup() {
    final props = widget();

    return (context) => AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: context.beamBackRoot,
      ),
      title: Text(
        props.value.type == AddType.income ? t.common.income : t.common.expense,
      ),
      bottom: TabBar(
        onTap: (i) =>
            props.value.setType(i == 1 ? AddType.income : AddType.expense),
        tabs: [
          Tab(text: t.common.expense),
          Tab(text: t.common.income),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}
