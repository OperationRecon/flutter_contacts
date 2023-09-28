import 'package:code/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';

bool starting = true;

class ContactOverlay extends StatefulWidget {
  final Contact? contact;
  final String contactName;

  const ContactOverlay({
    super.key,
    required this.contact,
    required this.contactName,
  });

  @override
  State<ContactOverlay> createState() => _ContactOverlayState();
}

class _ContactOverlayState extends State<ContactOverlay> {
  bool editing = false;
  Contact? contactData = Contact(
    id: "Loading",
    name: Name(first: 'Loading...'),
  );

  @override
  Widget build(BuildContext context) {
    if (starting) {
      _loadData();
      starting = false;
    }
    bool noPhones = contactData!.phones.isEmpty;
    if (noPhones) {
      editing = true;
    }
    // fetch data of contact
    // create the overlay containing the contactEntry
    if (contactData!.id != "Loading") {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Hero(
            tag: contactData!.id,
            child: Text(widget.contactName),
          ),
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
              starting = true;
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                editing = !editing;
                setState(() {});
              },
              //icon: const Icon(Icons.edit),
              icon: editing && !noPhones
                  ? const Icon(Icons.check)
                  : const Icon(Icons.edit),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // add circular avatr containing the Thumbnail image of the contact if it has any
                SizedBox(
                  width: 120,
                  height: 120,
                  child: contactData!.photo != null
                      ? CircleAvatar(
                          foregroundImage: MemoryImage(contactData!.photo!),
                        )
                      : CircleAvatar(
                          backgroundColor:
                              Color(contactData.hashCode).withAlpha(80),
                          child: Text(
                            contactData!.displayName[0],
                            textScaleFactor: 3.5,
                          ),
                        ),
                ),
                Text(
                  contactData!.displayName,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                if (editing)
                  IconButton(
                    onPressed: () {
                      Contact? toDelete = contactData;
                      contactData = Contact(id: 'dleted');
                      toDelete!.delete();
                      Navigator.pop(context);
                      starting = true;
                    },
                    icon: const Icon(Icons.delete_forever),
                  ),
                if (editing)
                  ListTile(
                    leading: const Icon(Icons.numbers_sharp),
                    title: TextField(
                      keyboardType: TextInputType.phone,
                      maxLines: 1,
                      onSubmitted: (String value) {
                        contactData!.phones.add(Phone(value));
                        FlutterContacts.updateContact(contactData!);
                        editing = false;
                        setState(() {});
                      },
                    ),
                  ),
                for (var numberEntries in contactData!.phones)
                  ListTile(
                    title: Text(numberEntries.number),
                    leading: IconButton(
                      onPressed: () => launchUrl(
                        Uri(
                          scheme: 'tel',
                          path: numberEntries.number,
                        ),
                      ),
                      icon: const Icon(Icons.call),
                    ),
                    trailing: IconButton(
                        onPressed: () => {
                              contactData!.phones.remove(numberEntries),
                              FlutterContacts.updateContact(contactData!),
                              setState(() {}),
                            },
                        icon: const Icon(Icons.delete)),
                  ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const Scaffold(
        appBar: MainAppBar(widgetName: 'Flutter Contacts'),
      );
    }
  }

  void _loadData() async {
    contactData = await FlutterContacts.getContact(widget.contact!.id,
        withAccounts: true);
    editing = false;
    if (mounted) {
      setState(() {});
    }
  }
}
