import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'contact_overlay.dart';

// Contains the widget used to Show the contact in lists, such as the homepage and the search results page.

class ContactListEntry extends StatefulWidget {
  const ContactListEntry({
    super.key,
    required this.contactData,
  });

  final Contact contactData;

  @override
  State<StatefulWidget> createState() => _ContactListEntryState();
}

class _ContactListEntryState extends State<ContactListEntry> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (contactOverlay != null) {
          removeHighlightOverlay();
          return Future(() => false);
        }
        return Future(() => true);
      },
      child: Card(
        shadowColor: Theme.of(context).colorScheme.onBackground,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          color: Theme.of(context).primaryColor,
          child: TextButton.icon(
            icon: widget.contactData.thumbnail != null
                // creates the circular avatar besides the entry's name, if the contact has a thumbnail
                // it uses that. Otherwise it creates an avatar using the firstmost letter in the contact
                // and a color unique to it.
                ? CircleAvatar(
                    foregroundImage: MemoryImage(widget.contactData.thumbnail!))
                : CircleAvatar(
                    backgroundColor:
                        Color(widget.contactData.hashCode).withAlpha(80),
                    child: Text(widget.contactData.displayName[0]),
                  ),
            // creates on overlay that has the contact's detilas within
            onPressed: () => createContactOverlay(context, widget.contactData),
            style: const ButtonStyle(
              alignment: AlignmentDirectional.centerStart,
              shape: MaterialStatePropertyAll(BeveledRectangleBorder()),
            ),
            label: Text(
              widget.contactData.displayName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
      ),
    );
  }
}
