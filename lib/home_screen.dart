import 'package:flutter/material.dart';
import 'add_medication_screen.dart';
import 'ai_assistant_screen.dart';
import 'medication_search_screen.dart';
import 'reminders_screen.dart';
import 'profile_screen.dart'; // <-- Bunu ekle!

// Geçici veri modelin:
class Medication {
  final String name;
  final String dosage;
  final String schedule;
  final String status;
  final String nextTime;
  final String category;

  Medication({
    required this.name,
    required this.dosage,
    required this.schedule,
    required this.status,
    required this.nextTime,
    required this.category,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userName = "fergrewgrew";
  int _selectedIndex = 0;

  List<Medication> reminders = [
    Medication(
      name: "Lisinopril",
      dosage: "10mg",
      schedule: "Once daily",
      status: "Active",
      nextTime: "08:00",
      category: "Blood Pressure",
    ),
    Medication(
      name: "Metformin",
      dosage: "500mg",
      schedule: "Twice daily",
      status: "Active",
      nextTime: "20:00",
      category: "Diabetes",
    ),
  ];

  List<Medication> popularMedications = [
    Medication(
      name: "Lisinopril",
      dosage: "10mg",
      schedule: "Take once daily",
      status: "Active: Lisinopril",
      nextTime: "",
      category: "Blood Pressure",
    ),
    Medication(
      name: "Metformin",
      dosage: "500mg",
      schedule: "Take twice daily with meals",
      status: "Active: Metformin Hydrochloride",
      nextTime: "",
      category: "Diabetes",
    ),
    Medication(
      name: "Atorvastatin",
      dosage: "20mg",
      schedule: "Take once daily in the evening",
      status: "Active: Atorvastatin Calcium",
      nextTime: "",
      category: "Cholesterol",
    ),
  ];

  void _removeReminder(int index) {
    setState(() {
      reminders.removeAt(index);
    });
  }

  void _removePopularMedication(int index) {
    setState(() {
      popularMedications.removeAt(index);
    });
  }

  Future<void> _addMedication() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMedicationScreen()),
    );

    if (result != null && result is Medication) {
      setState(() {
        reminders.add(result);
      });
    }
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MedicationSearchScreen()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AIAssistantScreen()),
      );
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RemindersScreen(
            reminders: reminders,
            onAddReminder: (med) {
              setState(() {
                reminders.add(med);
              });
            },
            onDeleteReminder: (idx) {
              setState(() {
                reminders.removeAt(idx);
              });
            },
          ),
        ),
      );
    }
    // ---- PROFILE SCREEN EKLEME BURADA ----
    if (index == 4) { // Profile sekmesi
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            userName: userName,
            email: "qewrewq@gmail.com", // örnek mail, istersen değiştir
            reminders: reminders,
          ),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Good morning, $userName!",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            "How are you feeling today?",
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          // Arama Kutusu
          TextField(
            decoration: InputDecoration(
              hintText: "Search medications...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // AI Assistant Card
          Card(
            color: Colors.red[50],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: ListTile(
              leading: const Icon(Icons.chat_bubble_outline, color: Colors.red, size: 38),
              title: const Text("AI Assistant", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Ask about medications, side effects & more"),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: const StadiumBorder(),
                ),
                child: const Text("Ask AI", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AIAssistantScreen()),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Bugünün Hatırlatıcıları
          Row(
            children: [
              const Text(
                "Today's Reminders",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: _addMedication,
                child: const Text("+ Add"),
              ),
            ],
          ),
          ...reminders.asMap().entries.map((entry) {
            final index = entry.key;
            final med = entry.value;
            return ReminderCard(
              medication: med,
              onDelete: () => _removeReminder(index),
              onAskAI: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AIAssistantScreen(
                      initialQuestion: "${med.name} hakkında bilgi verir misin?",
                    ),
                  ),
                );
              },
            );
          }),
          const SizedBox(height: 24),
          // Popüler ilaçlar
          const Text(
            "Popular Medications",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ...popularMedications.asMap().entries.map((entry) {
            final index = entry.key;
            final med = entry.value;
            return MedicationCard(
              medication: med,
              onDelete: () => _removePopularMedication(index),
              onAskAI: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AIAssistantScreen(
                      initialQuestion: "${med.name} hakkında bilgi verir misin?",
                    ),
                  ),
                );
              },
            );
          }),
          const SizedBox(height: 70),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.android), label: "AI Assistant"),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: "Reminders"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// KARTLAR AYNI KALSIN
class ReminderCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback? onDelete;
  final VoidCallback? onAskAI;

  const ReminderCard({super.key, required this.medication, this.onDelete, this.onAskAI});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[50],
          child: const Icon(Icons.medication, color: Colors.green),
        ),
        title: Text(medication.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${medication.dosage} • ${medication.schedule}"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Next: ${medication.nextTime}", style: const TextStyle(color: Colors.blue)),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 3),
                Text(medication.status, style: const TextStyle(color: Colors.green, fontSize: 12)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onAskAI,
                  child: const Text("Ask AI", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback? onDelete;
  final VoidCallback? onAskAI;

  const MedicationCard({super.key, required this.medication, this.onDelete, this.onAskAI});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        title: Row(
          children: [
            Text(
              medication.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            if (medication.category.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  medication.category,
                  style: const TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${medication.dosage} • ${medication.schedule}"),
            Text(medication.status, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit, color: Colors.blue[300]),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDelete,
              child: const Icon(Icons.delete_outline, color: Colors.red),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onAskAI,
              child: const Text("Ask AI", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}