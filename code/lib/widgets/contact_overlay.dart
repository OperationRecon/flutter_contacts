import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

OverlayEntry? contactOverlay;

void createContactOverlay(
    BuildContext context, Future<Contact?> contactData) async {
  // remove older overlay if existent
  removeHighlightOverlay();

  // load data of desired contact
  Contact? data = await contactData;

  // build new overlay
  contactOverlay = OverlayEntry(builder: (context) {
    return OverlayExample(contactData: data);
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

class OverlayExample extends StatefulWidget {
  final Contact? contactData;

  const OverlayExample({
    super.key,
    required this.contactData,
  });

  @override
  State<OverlayExample> createState() => _OverlayExampleState();
}

class _OverlayExampleState extends State<OverlayExample> {
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
                    onPressed: () => {},
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
