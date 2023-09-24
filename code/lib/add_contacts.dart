import 'package:code/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddContactPageState();
  }
}

class _AddContactPageState extends State<AddContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(widgetName: 'Add New Contact'),
    );
  }
}
