import 'package:code/main.dart';
import 'package:code/search_page.dart';
import 'package:code/widgets/contact_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:focus_detector/focus_detector.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool boot = true;
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done

    //load contact list
    if (boot) {
      loadContacts();
      boot = !boot;
    }

    return FocusDetector(
      onFocusGained: () {
        boot = !boot;
        setState(() {});
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: () => showAddContact(context),
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: ListView.builder(
            // listView to Show the list of Contacts
            itemCount: contacts.length,
            itemBuilder: (context, index) => ContactListEntry(
              contactData: contacts[index],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchPage(),
            ),
          ),
          tooltip: 'search',
          child: const Icon(Icons.search_outlined),
        ),
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

  showAddContact(parentContext) {
    Contact newContact = Contact();
    return showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add contact'),
        actions: [
          TextButton(
            onPressed: () {
              // Only allow the user to add a contact if they entered one of the following
              if (newContact.name.first != '' ||
                  newContact.name.last != '' ||
                  newContact.name.nickname != '') {
                FlutterContacts.insertContact(newContact);
                boot = !boot;
                setState(
                  () {},
                );
              }
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Add'),
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: TextField(
                decoration: const InputDecoration(hintText: 'First Name'),
                keyboardType: TextInputType.name,
                onChanged: (String firstName) {
                  newContact.name.first = firstName;
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: TextField(
                decoration: const InputDecoration(hintText: 'Last Name'),
                keyboardType: TextInputType.name,
                onChanged: (String lastName) {
                  newContact.name.last = lastName;
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.phone_sharp),
              title: TextField(
                decoration: const InputDecoration(hintText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                onChanged: (String phoneNumber) {
                  newContact.phones[0] = Phone(phoneNumber);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
