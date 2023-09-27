import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

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
