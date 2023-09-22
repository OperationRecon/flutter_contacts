import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';

OverlayEntry? contactOverlay;

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
  const ContactOverlay({
    super.key,
    required this.contactData,
  });

  final Contact? contactData;
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
              // Image(image: MemoryImage(widget.contactData!.photo!)),
              //Text(
              //  widget.contactData!.displayName,
              //  style: Theme.of(context).textTheme.headlineLarge,
              //),
              //Text(
              //  widget.contactData!.phones.toString(),
              //),
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
