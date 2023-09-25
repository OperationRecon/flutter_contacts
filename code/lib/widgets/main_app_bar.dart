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
    showAddContactPopup() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: TextField(
              decoration: InputDecoration(hintText: 'Name'),
            ),
            actions: [
              TextButton(
                onPressed: () {},
                child: Text('Submit'),
              ),
            ],
          ),
        );

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widgetName),
      actions: [
        IconButton(
          onPressed: () => showAddContactPopup(),
          icon: const Icon(Icons.add),
        )
      ],
    );
  }
}
