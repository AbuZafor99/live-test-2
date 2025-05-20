import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: ContactListScreen(),
    );
  }
}

class Contact {
  String name;
  String number;

  Contact({required this.name, required this.number});
}

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final List<Contact> contacts = [];

  void addContact() {
    String name = nameController.text.trim();
    String number = numberController.text.trim();

    if (name.isNotEmpty && number.isNotEmpty) {
      setState(() {
        contacts.add(Contact(name: name, number: number));
        nameController.clear();
        numberController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contact added successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void deleteContact(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text("Confirmation"),
        content: Text("Are you sure you want to delete this contact?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Icon(Icons.cancel, color: Colors.grey),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                contacts.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Contact deleted')),
              );
            },
            child: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget contactTile(Contact contact, int index) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[50],
          child: Icon(Icons.person, color: Colors.blue),
        ),
        title: Text(
          contact.name,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(contact.number),
        trailing: IconButton(
          icon: Icon(Icons.phone, color: Colors.green),
          onPressed: () {},
        ),
        onLongPress: () => deleteContact(index),
      ),
    );
  }

  InputDecoration buildInputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact List"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: buildInputDecoration("Name", "Enter contact name"),
            ),
            SizedBox(height: 12),
            TextField(
              controller: numberController,
              decoration: buildInputDecoration("Number", "Enter phone number"),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addContact,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Add Contact"),
            ),
            SizedBox(height: 16),
            Expanded(
              child: contacts.isEmpty
                  ? Center(
                child: Text("No contacts added yet",
                    style: TextStyle(color: Colors.grey)),
              )
                  : ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return contactTile(contacts[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}