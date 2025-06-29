import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditStaffPage extends StatefulWidget {
  final String docId;
  final String currentName;
  final String currentId;
  final String currentAge;

  const EditStaffPage({
    super.key,
    required this.docId,
    required this.currentName,
    required this.currentId,
    required this.currentAge,
  });

  @override
  State<EditStaffPage> createState() => _EditStaffPageState();
}

class _EditStaffPageState extends State<EditStaffPage> {
  late TextEditingController nameController;
  late TextEditingController idController;
  late TextEditingController ageController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    idController = TextEditingController(text: widget.currentId);
    ageController = TextEditingController(text: widget.currentAge);
  }

  void updateStaff() async {
    String name = nameController.text.trim();
    String id = idController.text.trim();
    String age = ageController.text.trim();

    if (name.isNotEmpty && id.isNotEmpty && int.tryParse(age) != null) {
      try {
        await FirebaseFirestore.instance
            .collection('staffs')
            .doc(widget.docId)
            .update({'name': name, 'id': id, 'age': int.parse(age)});

        Navigator.pop(context); // go back to list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Staff updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating staff: $e')));
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
      appBar: AppBar(title: const Text("Edit Staff")),
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
                onPressed: updateStaff,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF007F),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Update"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
