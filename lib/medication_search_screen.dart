import 'package:flutter/material.dart';

class Medication {
  final String name;
  final String dosage;
  final String schedule;
  final String status;
  final String category;
  final String activeIngredient;

  Medication({
    required this.name,
    required this.dosage,
    required this.schedule,
    required this.status,
    required this.category,
    required this.activeIngredient,
  });
}

class MedicationSearchScreen extends StatefulWidget {
  const MedicationSearchScreen({super.key});

  @override
  State<MedicationSearchScreen> createState() => _MedicationSearchScreenState();
}

class _MedicationSearchScreenState extends State<MedicationSearchScreen> {
  String searchText = "";
  String selectedCategory = "All";

  // Aynı popüler ilaçlar listesini buraya ekle!
  List<Medication> medications = [
    Medication(
      name: "Lisinopril",
      dosage: "10mg",
      schedule: "Take once daily",
      status: "Active: Lisinopril",
      category: "Blood Pressure",
      activeIngredient: "Lisinopril",
    ),
    Medication(
      name: "Metformin",
      dosage: "500mg",
      schedule: "Take twice daily with meals",
      status: "Active: Metformin Hydrochloride",
      category: "Diabetes",
      activeIngredient: "Metformin Hydrochloride",
    ),
    Medication(
      name: "Atorvastatin",
      dosage: "20mg",
      schedule: "Take once daily in the evening",
      status: "Active: Atorvastatin Calcium",
      category: "Cholesterol",
      activeIngredient: "Atorvastatin Calcium",
    ),
    Medication(
      name: "Amlodipine",
      dosage: "5mg",
      schedule: "Take once daily",
      status: "Active: Amlodipine Besylate",
      category: "Blood Pressure",
      activeIngredient: "Amlodipine Besylate",
    ),
    Medication(
      name: "Omeprazole",
      dosage: "20mg",
      schedule: "Take before meals",
      status: "Active: Omeprazole",
      category: "Acid Reflux",
      activeIngredient: "Omeprazole",
    ),
    Medication(
      name: "Aspirin",
      dosage: "81mg",
      schedule: "Take once daily with food",
      status: "Active: Acetylsalicylic acid",
      category: "Blood Thinner",
      activeIngredient: "Acetylsalicylic acid",
    ),
  ];

  List<String> categories = [
    "All",
    "Blood Pressure",
    "Diabetes",
    "Cholesterol",
    "Acid Reflux",
    "Blood Thinner",
  ];

  List<Medication> get filteredMedications {
    return medications.where((med) {
      final matchesSearch = searchText.isEmpty ||
          med.name.toLowerCase().contains(searchText.toLowerCase()) ||
          med.activeIngredient.toLowerCase().contains(searchText.toLowerCase());
      final matchesCategory =
          selectedCategory == "All" || med.category == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Medications"),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Find information about any medication",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) => setState(() => searchText = value),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search by medication name or condition...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 14),
            // Kategori filtreleri
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  final selected = selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: selected,
                      onSelected: (_) => setState(() => selectedCategory = cat),
                      selectedColor: Colors.blue,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: Colors.white,
                      shape: StadiumBorder(
                        side: BorderSide(color: Colors.blue.shade100),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "${filteredMedications.length} medications found",
              style: TextStyle(fontSize: 16, color: Colors.grey[700], fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: filteredMedications.length,
                itemBuilder: (context, idx) {
                  final med = filteredMedications[idx];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(
                            med.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              med.category,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${med.dosage} • ${med.schedule}"),
                          Text("Active: ${med.activeIngredient}", style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit, color: Colors.blue[300]),
                          SizedBox(width: 8),
                          Icon(Icons.delete_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Ask AI", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}