import 'package:flutter/material.dart';

// import 'package:flutter_contacts/flutter_contacts.dart';
import 'main.dart';
import 'widgets/contact_list_entry.dart';

List<String> ids = contacts.map((e) => e.id).toList();
List<String> names = contacts.map((e) => e.displayName).toList();
List<String> searchResults = [];

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 10.0),
            child: TextField(
              onChanged: (value) {
                searchResults.clear();
                setState(
                  () {
                    searchResults.addAll(
                      names.where(
                        (element) => element.toLowerCase().contains(
                              value.toLowerCase(),
                            ),
                      ),
                    );
                  },
                );
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.search_outlined),
                hintText: "Search Contacts",
              ),
            ),
          ),
        ),
        title: const Text("Search"),
      ),
      body: Center(
        child: ListView.builder(
          // listView to Show the list of Contacts
          itemCount: searchResults.length,
          itemBuilder: (context, index) => ContactListEntry(
              contactData: contacts.firstWhere(
                  (element) => element.displayName == searchResults[index])),
        ),
      ),
    );
  }
}
