import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _targetRepsController = TextEditingController();
  final TextEditingController _targetRpeController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();
  final TextEditingController _actualRepsController = TextEditingController();
  final TextEditingController _actualRpeController = TextEditingController();
  final TextEditingController _actualWeightController = TextEditingController();

  List<Map<String, String>> workouts = [];

  static const _storageKey = 'workouts_list';

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final rawData = prefs.getString(_storageKey);
    if (rawData != null) {
      final List decoded = jsonDecode(rawData);
      setState(() {
        workouts = List<Map<String, String>>.from(decoded);
      });
    }
  }

  Future<void> _saveWorkout() async {
    if (_formKey.currentState!.validate()) {
      final newWorkout = {
        'exercise': _exerciseController.text,
        'targetReps': _targetRepsController.text,
        'targetRpe': _targetRpeController.text,
        'targetWeight': _targetWeightController.text,
        'actualReps': _actualRepsController.text,
        'actualRpe': _actualRpeController.text,
        'actualWeight': _actualWeightController.text,
      };

      setState(() {
        workouts.add(newWorkout);
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, jsonEncode(workouts));

      _formKey.currentState!.reset();
      _exerciseController.clear();
      _targetRepsController.clear();
      _targetRpeController.clear();
      _targetWeightController.clear();
      _actualRepsController.clear();
      _actualRpeController.clear();
      _actualWeightController.clear();
    }
  }

  Widget _buildWorkoutCard(Map<String, String> workout) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exercise: ${workout['exercise']}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Target: ${workout['targetReps']} reps @ RPE ${workout['targetRpe']} - ${workout['targetWeight']}kg'),
            Text('Actual: ${workout['actualReps']} reps @ RPE ${workout['actualRpe']} - ${workout['actualWeight']}kg'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Tracker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildInput('Exercise name', _exerciseController),
                  _buildInput('Target reps', _targetRepsController, number: true),
                  _buildInput('Target RPE', _targetRpeController, number: true),
                  _buildInput('Target weight (kg)', _targetWeightController, number: true),
                  const SizedBox(height: 10),
                  _buildInput('Actual reps', _actualRepsController, number: true),
                  _buildInput('Actual RPE', _actualRpeController, number: true),
                  _buildInput('Actual weight (kg)', _actualWeightController, number: true),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _saveWorkout,
                    child: const Text('Save Workout'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Previous Workouts:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            for (final workout in workouts.reversed)
              _buildWorkoutCard(workout),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, {bool number = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: controller,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }
}