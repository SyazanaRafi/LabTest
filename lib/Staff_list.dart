import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Staff_form.dart';
import 'Edit_page.dart';

class StaffListPage extends StatelessWidget {
  const StaffListPage({super.key});

  void deleteStaff(String docId) {
    FirebaseFirestore.instance.collection('staffs').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Staff List")),
      body: StreamBuilder(
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

          return ListView.builder(
            itemCount: staffDocs.length,
            itemBuilder: (context, index) {
              final staff = staffDocs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(staff['name']),
                  subtitle: Text("ID: ${staff['id']} | Age: ${staff['age']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.pinkAccent),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => EditStaffPage(
                                    docId: staff.id,
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const StaffFormPage()),
          );
        },
      ),
    );
  }
}
