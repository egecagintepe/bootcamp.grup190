import 'package:flutter/material.dart';
import 'ai_assistant_screen.dart';
import 'home_screen.dart'; // Medication modelini ve reminders'ı almak için
import 'welcome.dart';    // WelcomeScreen'e yönlendirme için import ETTİM

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String email;
  final List<Medication> reminders;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.email,
    required this.reminders,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Ayarlar için state
  bool pushNotifications = true;
  bool aiInsights = true;
  bool healthDataSync = false;

  // Reminder switchleri için state (her bir ilacın açılıp kapanması)
  late List<bool> reminderEnabled;

  @override
  void initState() {
    super.initState();
    reminderEnabled = List.filled(widget.reminders.length, true);
  }

  @override
  Widget build(BuildContext context) {
    int activeReminders = widget.reminders.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile & Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: BackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7F8FA),
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
          // Kullanıcı Kartı
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue[50],
                    child: Icon(Icons.person, color: Colors.blue[700], size: 36),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 2),
                        Text(widget.email, style: const TextStyle(color: Colors.grey, fontSize: 15)),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                "$activeReminders Active Reminders",
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                            const SizedBox(width: 12),
                            InkWell(
                              child: const Text("Ask AI", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => AIAssistantScreen(
                                    initialQuestion: "Reminders hakkında özet bilgi verir misin?",
                                  ),
                                ));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.grey[700]),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Health Information Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.favorite_border, color: Colors.red, size: 22),
                      const SizedBox(width: 7),
                      const Text("Health Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      const Spacer(),
                      InkWell(
                        child: const Text("Ask AI", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) => AIAssistantScreen(
                              initialQuestion: "Sağlık bilgilerim için kişiselleştirilmiş öneriler verir misin?",
                            ),
                          ));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _InfoBox(label: "Age", value: "26–35"),
                      _InfoBox(label: "Weight", value: "72 kg"),
                    ],
                  ),
                  Row(
                    children: [
                      _InfoBox(label: "Height", value: "178 cm"),
                      _InfoBox(label: "Chronic Illness", value: "No"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: StadiumBorder(),
                    ),
                    child: const Text("Update Health Information"),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // AI Health Advisor
          Card(
            color: Colors.red[50],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              leading: Icon(Icons.medical_services_outlined, color: Colors.red, size: 30),
              title: const Text("AI Health Advisor", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Get personalized health insights"),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: StadiumBorder()),
                child: const Text("Ask AI"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => AIAssistantScreen(
                      initialQuestion: "Kişisel sağlık durumum hakkında öneriler sunar mısın?",
                    ),
                  ));
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Medication Reminders Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.notifications_active_outlined, color: Colors.blue, size: 22),
                      const SizedBox(width: 7),
                      const Text("Medication Reminders", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ...widget.reminders.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final med = entry.value;
                    return _ReminderProfileTile(
                      medication: med,
                      isEnabled: reminderEnabled[idx],
                      onChanged: (value) {
                        setState(() {
                          reminderEnabled[idx] = value;
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
          ),

          // Settings
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 14),
                  _SwitchSetting(
                    title: "Push Notifications",
                    subtitle: "Receive reminder alerts",
                    value: pushNotifications,
                    onChanged: (value) {
                      setState(() {
                        pushNotifications = value;
                      });
                    },
                  ),
                  _SwitchSetting(
                    title: "AI Insights",
                    subtitle: "Get personalized medication insights",
                    value: aiInsights,
                    onChanged: (value) {
                      setState(() {
                        aiInsights = value;
                      });
                    },
                  ),
                  _SwitchSetting(
                    title: "Health Data Sync",
                    subtitle: "Sync with health apps",
                    value: healthDataSync,
                    onChanged: (value) {
                      setState(() {
                        healthDataSync = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Help & Policies
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.help_outline, color: Colors.grey[800]),
                    title: const Text("Help & Support"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.privacy_tip_outlined, color: Colors.grey[800]),
                    title: const Text("Privacy Policy"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.gavel_outlined, color: Colors.green),
                    title: const Text("Terms of Service", style: TextStyle(color: Colors.green)),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          // App Info
          const SizedBox(height: 16),
          Card(
            color: Colors.blue[50],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: const [
                  Text("Medecai", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 4),
                  Text("Your AI-powered medication companion"),
                  SizedBox(height: 3),
                  Text("Version 1.0.0", style: TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
          ),

          // Sign Out Button
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              // Çıkış fonksiyonu — en başa yönlendir
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.red),
            label: const Text("Sign Out", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 17)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red.withOpacity(0.4)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// Profile'ta gösterilecek ilaç kutusu
class _ReminderProfileTile extends StatelessWidget {
  final Medication medication;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const _ReminderProfileTile({
    required this.medication,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[50],
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(Icons.local_pharmacy, color: Colors.green, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(medication.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 2),
                  Text("${medication.dosage} • ${medication.nextTime}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.medical_services_rounded, color: Colors.red[300], size: 20),
            const SizedBox(width: 10),
            Switch(
              value: isEnabled,
              onChanged: onChanged,
              activeColor: Colors.green,
            )
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  const _InfoBox({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 3),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _SwitchSetting extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchSetting({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: EdgeInsets.only(left: 6, right: 4),
    );
  }
}