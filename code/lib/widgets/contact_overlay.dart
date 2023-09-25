// import 'dart:html';

import 'package:code/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:code/main.dart';

OverlayEntry? contactOverlay;

void createContactOverlay(
    BuildContext context, Contact contact) {
  // remove older overlay if existent
  removeHighlightOverlay();

  // build new overlay
  contactOverlay = OverlayEntry(builder: (context) {
    return ContactOverlay(contact: contact);
  });

  assert(contactOverlay != null);

  // ignore: use_build_context_synchronously
  Overlay.of(context).insert(contactOverlay!);
}

// Remove the OverlayEntry
void removeHighlightOverlay() {
  if (contactOverlay != null) {
    contactOverlay?.remove();
    contactOverlay = null;
  }
}

class ContactOverlay extends StatefulWidget {
  final Contact? contact;

  const ContactOverlay({
    super.key,
    required this.contact,
  });
  
  @override
  
  State<ContactOverlay> createState() => _ContactOverlayState();
}

class _ContactOverlayState extends State<ContactOverlay> {

  bool editing = false;
  Contact? contactData;

  void _loadData() async {
  contactData = await FlutterContacts.getContact(widget.contact!.id, withAccounts: true);
  }

  @override
  
  Widget build(BuildContext context) {

    // fetch data of contact
    _loadData();

    // create the overlay containing the contactEntry
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Details"),
        leading: BackButton(
          onPressed: () => removeHighlightOverlay(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              editing = !editing;
              print(editing);
              setState(() {});
            },
            icon: const Icon(Icons.edit),
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
                        foregroundImage:
                            MemoryImage(contactData!.photo!),
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
              Text(contactData!.displayName,
              style: Theme.of(context).textTheme.headlineLarge,
              ),
              if (editing)
                ListTile(
                  leading: const Icon(Icons.numbers_sharp),
                  title: TextField(
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    onSubmitted: (String value) {
                      contactData!.phones.add(Phone(value));
                      setState(() {
                        contacts.firstWhere((element) => element.id == contactData!.id).phones.add(Phone(value));
                        FlutterContacts.updateContact(contactData!);
                      });
                    },
                  ),
                ),
              for (var numberEntries in contactData!.phones)
                ListTile(
                  title: Text(numberEntries.number.toString()),
                  leading: IconButton(
                    onPressed: () => launchUrl(
                      Uri(
                        scheme: 'tel',
                        path: numberEntries.number.toString(),
                      ),
                    ),
                    icon: const Icon(Icons.call),
                  ),
                  trailing: IconButton(
                      onPressed: () => {}, icon: const Icon(Icons.edit)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Make sure to remove OverlayEntry when the widget is disposed.
    if (contactOverlay != null) {
      removeHighlightOverlay();
    }

    super.dispose();
  }
}
