import 'package:flutter/material.dart';
import 'home_screen.dart';

class RemindersScreen extends StatefulWidget {
  final List<Medication> reminders;
  final Function(Medication) onAddReminder;
  final Function(int) onDeleteReminder;

  const RemindersScreen({super.key, 
    required this.reminders,
    required this.onAddReminder,
    required this.onDeleteReminder,
  });

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  void _showAddReminderDialog() async {
    nameController.clear();
    dosageController.clear();
    timeController.clear();
    TimeOfDay? pickedTime;

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Add New Reminder"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Medication Name"),
                ),
                TextField(
                  controller: dosageController,
                  decoration: InputDecoration(labelText: "Dosage (e.g. 10mg, 1 tablet)"),
                ),
                TextField(
                  controller: timeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Time",
                    hintText: "08:00",
                  ),
                  onTap: () async {
                    pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      timeController.text = pickedTime!.format(context);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    dosageController.text.isNotEmpty &&
                    timeController.text.isNotEmpty) {
                  widget.onAddReminder(
                    Medication(
                      name: nameController.text,
                      dosage: dosageController.text,
                      schedule: "Once daily",
                      nextTime: timeController.text,
                      status: "Active",
                      category: "",
                    ),
                  );
                  Navigator.of(ctx).pop();
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Reminder", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            SizedBox(height: 12),
            Text(
              "Your Medication Reminders",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 20),
            ...widget.reminders.asMap().entries.map((entry) {
              final idx = entry.key;
              final med = entry.value;
              return Card(
                margin: EdgeInsets.symmetric(vertical: 7),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: ListTile(
                  leading: Icon(Icons.medication, color: Colors.blue, size: 32),
                  title: Text(med.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text("${med.dosage} • ${med.schedule}"),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        med.nextTime,
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 3),
                      Text(
                        med.status,
                        style: TextStyle(fontSize: 12, color: Colors.green),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => widget.onDeleteReminder(idx),
                        tooltip: "Delete reminder",
                      ),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size.fromHeight(54),
                shape: StadiumBorder(),
              ),
              onPressed: _showAddReminderDialog,
              child: Text("➕ Add New Reminder", style: TextStyle(fontSize: 17)),
            ),
          ],
        ),
      ),
    );
  }
}