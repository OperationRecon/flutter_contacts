import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

OverlayEntry? contactOverlay;

void createContactOverlay(BuildContext context, Future<Contact?> contactData) async{

  // remove older overlay if existent
  removeHighlightOverlay();

  // load data of desired contact
  Contact? data = await contactData;

  // build new overlay
  contactOverlay = OverlayEntry(builder: (context) {
    return OverlayExample(contactData: data);
  }
  );

  assert (contactOverlay != null);

  // ignore: use_build_context_synchronously
  Overlay.of(context).insert(contactOverlay!);
  
}

// Remove the OverlayEntry
void removeHighlightOverlay() {
  if (contactOverlay != null)
  {
    contactOverlay?.remove();
    contactOverlay = null;
  }

  
  }

class OverlayExample extends StatefulWidget {
  const OverlayExample({super.key,
    required this.contactData,
    });

  final Contact? contactData;

  @override
  State<OverlayExample> createState() => _OverlayExampleState();
}

class _OverlayExampleState extends State<OverlayExample> {

  @override
  void dispose() {
  // Make sure to remove OverlayEntry when the widget is disposed.
    if (contactOverlay != null) {
      removeHighlightOverlay();
    }

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // create the overlay containing the contactEntry
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("contact's name"),
      ),
      body: Center(
        child: 
        Column(mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(widget.contactData!.displayName,
          style: Theme.of(context).textTheme.headlineLarge,),
          IconButton(onPressed: () => removeHighlightOverlay(),
           icon: Icon(Icons.delete_forever))
        ],
        ),
      ),
    );
  }
}

