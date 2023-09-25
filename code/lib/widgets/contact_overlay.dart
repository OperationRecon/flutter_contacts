import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:code/main.dart';

OverlayEntry? contactOverlay;

bool editing = false;

void createContactOverlay(
    BuildContext context, Future<Contact?> contactData) async {
  // remove older overlay if existent
  removeHighlightOverlay();

  // load data of desired contact
  Contact? data = await contactData;

  // build new overlay
  contactOverlay = OverlayEntry(builder: (context) {
    return ContactOverlay(contactData: data);
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
  final Contact? contactData;

  const ContactOverlay({
    super.key,
    required this.contactData,
  });
  @override
  State<ContactOverlay> createState() => _ContactOverlayState();
}

class _ContactOverlayState extends State<ContactOverlay> {
  @override
  Widget build(BuildContext context) {
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
                child: widget.contactData!.photo != null
                    ? CircleAvatar(
                        foregroundImage:
                            MemoryImage(widget.contactData!.photo!),
                      )
                    : CircleAvatar(
                        backgroundColor:
                            Color(widget.contactData.hashCode).withAlpha(80),
                        child: Text(
                          widget.contactData!.displayName[0],
                          textScaleFactor: 3.5,
                        ),
                      ),
              ),
              Text(widget.contactData!.displayName,
              style: Theme.of(context).textTheme.headlineLarge,
              ),
              if (editing)
                ListTile(
                  leading: const Icon(Icons.numbers_sharp),
                  title: TextField(
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    onSubmitted: (String value) {
                      setState(() async {
                        //widget.contactData!.update();
                        widget.contactData!.phones.add(Phone(value));
                        widget.contactData!.name.first = 'NAAs';
                        print(widget.contactData!.phones);
                        await contacts[int.parse(widget.contactData!.id)]
                            .update();
                      });
                    },
                  ),
                ),
              for (var numberEntries in widget.contactData!.phones)
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
