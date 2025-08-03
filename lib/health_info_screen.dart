import 'package:flutter/material.dart';

// Sağlık Bilgisi Modeli
class HealthInfo {
  String age;
  String weight;
  String height;
  bool hasChronicIllness;
  String chronicIllnessDetails;

  HealthInfo({
    this.age = '',
    this.weight = '',
    this.height = '',
    this.hasChronicIllness = false,
    this.chronicIllnessDetails = '',
  });
}

class HealthInfoScreen extends StatefulWidget {
  final void Function(HealthInfo healthInfo)? onComplete; // Form tamamlanınca tetiklenir

  const HealthInfoScreen({super.key, this.onComplete});

  @override
  State<HealthInfoScreen> createState() => _HealthInfoScreenState();
}

class _HealthInfoScreenState extends State<HealthInfoScreen> {
  final HealthInfo _formData = HealthInfo();
  final _formKey = GlobalKey<FormState>();

  String _weightUnit = 'kg';
  String _heightUnit = 'cm';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Information"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe0f2fe), Color(0xffd1fae5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Column(
                children: [
                  const SizedBox(height: 8),
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    radius: 32,
                    child: const Icon(Icons.favorite, color: Colors.blue, size: 36),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Personal Health Profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "This information helps our AI provide more personalized medication advice and insights.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
              // Age
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Age *",
                  border: OutlineInputBorder(),
                ),
                value: _formData.age.isEmpty ? null : _formData.age,
                items: [
                  "18-25",
                  "26-35",
                  "36-45",
                  "46-55",
                  "56-65",
                  "66-75",
                  "75+"
                ]
                    .map((age) => DropdownMenuItem(
                          value: age,
                          child: Text(age),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _formData.age = value ?? "");
                },
                validator: (v) => v == null || v.isEmpty ? "Please select your age" : null,
              ),
              const SizedBox(height: 18),
              // Weight
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Weight (optional)",
                        border: OutlineInputBorder(),
                        hintText: "Enter weight",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _formData.weight = v,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _weightUnit,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "",
                      ),
                      items: [
                        DropdownMenuItem(value: "kg", child: Text("kg")),
                        DropdownMenuItem(value: "lbs", child: Text("lbs")),
                      ],
                      onChanged: (v) => setState(() => _weightUnit = v ?? "kg"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Height
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Height (optional)",
                        border: OutlineInputBorder(),
                        hintText: "Enter height",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _formData.height = v,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _heightUnit,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "",
                      ),
                      items: [
                        DropdownMenuItem(value: "cm", child: Text("cm")),
                        DropdownMenuItem(value: "ft", child: Text("ft")),
                      ],
                      onChanged: (v) => setState(() => _heightUnit = v ?? "cm"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Chronic Illness Switch
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Do you have any chronic illnesses?"),
                          SizedBox(height: 4),
                          Text(
                            "This helps us provide better medication guidance",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _formData.hasChronicIllness,
                      onChanged: (v) => setState(() => _formData.hasChronicIllness = v),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 14),
              if (_formData.hasChronicIllness)
                TextFormField(
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: "Please specify (optional)",
                    border: OutlineInputBorder(),
                    hintText: "e.g., Diabetes, Hypertension, Heart disease...",
                  ),
                  onChanged: (v) => _formData.chronicIllnessDetails = v,
                ),
              const SizedBox(height: 18),
              // Privacy Note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.person, color: Colors.blue, size: 28),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Your health information is encrypted and never shared with third parties. You can update or delete this information at any time.",
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Buttons
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Gerekirse buradan ana ekrana veya başka bir yere yönlendir
                    if (widget.onComplete != null) {
                      widget.onComplete!(_formData);
                    }
                    Navigator.pop(context); // Veya ana sayfa: Navigator.pushReplacementNamed(context, '/');
                  }
                },
                child: const Text("Complete Setup", style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: BorderSide(color: Colors.blue.shade200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/home'); // veya istediğin ekrana atla
                },
                child: const Text("Skip for now", style: TextStyle(color: Colors.blue, fontSize: 15)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}