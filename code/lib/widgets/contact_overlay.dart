import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

OverlayEntry? contactOverlay;
bool overlayPendingRemoval = false;

void changeContactOverlay(BuildContext context, Contact contact,) {
  /// used to add or remove a contact overlay,
  ///  setting remove to true switches the overlay with one that gets removed intantly.

  // remove older overlay if existent
  removeHighlightOverlay();

  // build new overlay
  contactOverlay = OverlayEntry(builder: (context) {
    return ContactOverlay(contact: contact,);
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
    overlayPendingRemoval = false;
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
  Contact? contactData = Contact(
    id: "Loading",
  );
  @override

  Widget build(BuildContext context) {

    if (overlayPendingRemoval){
      setState(() {
      });
    }

    // fetch data of contact and display a loading placeholder
    if (contactData!.id == "Loading"){
      _loadData();
      return Container(
        color: Colors.black12,
        child: Text("loading",
        style: Theme.of(context).textTheme.labelSmall,
        ),
      );
    }

    // create the overlay containing the contactEntry
    else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Details"),
          leading: BackButton(
            onPressed: () {
              setState(() {
                overlayPendingRemoval = true;
              });
              },
          ),
          actions: [
            IconButton(
              onPressed: () {
                editing = !editing;
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
                if (!editing)
                  Text(
                    contactData!.displayName,
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
      )
      .animate(effects: [
        SlideEffect(delay: 0.0.ms, duration: overlayPendingRemoval? 
          0.0.ms : 0.245.seconds,          
          begin: const Offset(0.0, 1.0)
        )
      ],) 
      // adds in the animation for when the overlay first slides in,
      //gets reversed if the widget is marked for removal.
      
      .swap(builder:(context, child) => child!.animate(effects: [
        SlideEffect(delay: 0.0.ms, duration: 0.2.seconds, 
         begin: const Offset(0.0, 0.0), end: const Offset(0.0, 1.0))
      ],
      target: overlayPendingRemoval ? 1.0 : 0.0,
      onComplete: (controller) {
        if (overlayPendingRemoval) {
        removeHighlightOverlay();
        }
      },
      ),);
      // adds in the animation for when the overlay slides out.

    }   
  }

  @override
  void dispose() {
    removeHighlightOverlay();
    super.dispose();
  }

  void _loadData() async {
    contactData = await FlutterContacts.getContact(widget.contact!.id,
        withAccounts: true);
    if (mounted) {
      setState(() {});
    }
  }
}
