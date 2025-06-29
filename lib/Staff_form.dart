import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'staff_list.dart';

class StaffFormPage extends StatefulWidget {
  const StaffFormPage({super.key});

  @override
  State<StaffFormPage> createState() => _StaffFormPageState();
}

class _StaffFormPageState extends State<StaffFormPage> {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final ageController = TextEditingController();

  void saveStaff() async {
    String name = nameController.text.trim();
    String id = idController.text.trim();
    String age = ageController.text.trim();

    if (name.isNotEmpty && id.isNotEmpty && int.tryParse(age) != null) {
      try {
        await FirebaseFirestore.instance.collection('staffs').add({
          'name': name,
          'id': id,
          'age': int.parse(age),
          'createdAt': Timestamp.now(),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StaffListPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Staff")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: "Staff ID"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: "Age"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: saveStaff,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF007F),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
