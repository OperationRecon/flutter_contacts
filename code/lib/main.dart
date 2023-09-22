import 'package:code/widgets/contact_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'search_page.dart';

List<Contact> contacts = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Contacts',
      theme: ThemeData(
        // This is the theme of your application.

        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 1, 13, 65),
            brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Contacts'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool boot = true;

  void loadContacts() async {
    // Request contact permission
    if (await FlutterContacts.requestPermission()) {
      // Get all contacts
      contacts = await FlutterContacts.getContacts(
        withThumbnail: true,
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done

    // load contact list
    if (boot) {
      loadContacts();
      boot = !boot;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

          child: ListView.builder(
            // listView to Show the list of Contacts
            itemCount: contacts.length,
            itemBuilder: (context, index) =>
                ContactListEntry(contactData: contacts[index]),
          ),
        ),
      
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SecondRoute()),
      ),
      tooltip: 'search',
      child: const Icon(Icons.search_outlined),
      ),
    );
  }

  void loadContacts() async {
    // Request contact permission
    if (await FlutterContacts.requestPermission()) {
      // Get all contacts
      contacts = await FlutterContacts.getContacts(
        withThumbnail: true,
      );
      setState(() {});
    }
  }
}


