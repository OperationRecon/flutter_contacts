import 'package:flutter/material.dart';

OverlayEntry? contactOverlay;

void createContactOverlay(BuildContext context){

  // remove older overlay if existent
  removeHighlightOverlay();

  // build new overlay
  contactOverlay = OverlayEntry(builder: (context) {
    return OverlayExample();
  }
  );

  assert (contactOverlay != null);

  Overlay.of(context).insert(contactOverlay!);
  
}

// Remove the OverlayEntry.
void removeHighlightOverlay() {
  if (contactOverlay != null)
  {
    contactOverlay?.remove();
    contactOverlay = null;
  }

  
  }

class OverlayExample extends StatefulWidget {
  const OverlayExample({super.key,});
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
          Text("Details To Be Added",
          style: Theme.of(context).textTheme.headlineLarge,),
          IconButton(onPressed: () => removeHighlightOverlay(),
           icon: Icon(Icons.delete_forever))
        ],
        ),
      ),
    );
  }
  
  
}

