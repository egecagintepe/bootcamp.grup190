// lib/add_medication_screen.dart
import 'package:flutter/material.dart';
import 'home_screen.dart'; // Medication sınıfını kullanmak için ekle

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String dosage = '';
  String schedule = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Medication Name"),
                onSaved: (value) => name = value ?? '',
                validator: (value) => value == null || value.isEmpty ? "Required" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: "Dosage (e.g. 10mg)"),
                onSaved: (value) => dosage = value ?? '',
                validator: (value) => value == null || value.isEmpty ? "Required" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: "Schedule (e.g. Once daily)"),
                onSaved: (value) => schedule = value ?? '',
                validator: (value) => value == null || value.isEmpty ? "Required" : null,
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // Medication nesnesi oluştur!
                      final newMedication = Medication(
                        name: name,
                        dosage: dosage,
                        schedule: schedule,
                        status: "Active",
                        nextTime: "09:00",   // İstersen burada time picker ekleyebilirsin
                        category: "",
                      );

                      // Medication nesnesini geri döndür
                      Navigator.pop(context, newMedication);
                    }
                  },
                  child: Text("Add Medication"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}