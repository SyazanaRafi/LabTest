import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Staff_form.dart';
import 'edit_page.dart'; // Optional, if you use edit
import 'staff_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void deleteStaff(String docId) {
    FirebaseFirestore.instance.collection('staffs').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Management"),
        centerTitle: true,
        backgroundColor: Colors.pink.shade300,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StaffFormPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text("Add Staff"),
          ),
          const SizedBox(height: 20),
          const Text(
            "Staff List",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection('staffs')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final staffDocs = snapshot.data!.docs;

                if (staffDocs.isEmpty) {
                  return const Center(child: Text("No staff found."));
                }

                return ListView.builder(
                  itemCount: staffDocs.length,
                  itemBuilder: (context, index) {
                    final staff = staffDocs[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(staff['name']),
                        subtitle: Text(
                          "ID: ${staff['id']} | Age: ${staff['age']}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => EditStaffPage(
                                          docID: staff.id,
                                          currentName: staff['name'],
                                          currentId: staff['id'],
                                          currentAge: staff['age'].toString(),
                                        ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteStaff(staff.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
