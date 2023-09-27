import 'package:code/widgets/add_contact_dialog.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String widgetName;

  const MainAppBar({
    super.key,
    required this.widgetName,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widgetName),
      actions: [
        IconButton(
          onPressed: () => showAddContact(context),
          icon: const Icon(Icons.add),
        )
      ],
    );
  }
}
