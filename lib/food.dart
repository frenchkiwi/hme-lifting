import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _calorieInputController = TextEditingController();
  static const String _goalKey = 'daily_calorie_goal';

  int _goal = 0;

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final savedGoal = prefs.getInt(_goalKey) ?? 0;
    setState(() {
      _goal = savedGoal;
      _goalController.text = _goal.toString();
    });
  }

  Future<void> _saveGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final input = int.tryParse(_goalController.text);
    if (input != null) {
      await prefs.setInt(_goalKey, input);
      setState(() {
        _goal = input;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal saved!')),
      );
    }
  }

  Future<void> _addCalories() async {
    final input = int.tryParse(_calorieInputController.text);
    if (input != null) {
      setState(() {
        _goal -= input;
        _goalController.text = _goal.toString();
        _calorieInputController.clear();
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_goalKey, _goal);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid calorie amount.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Set your daily calorie goal:',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Calorie Goal',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saveGoal,
              child: const Text('Save Goal'),
            ),
            const Spacer(),
            TextField(
              controller: _calorieInputController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Add Calories',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addCalories,
              child: const Text('Log Calories'),
            ),
          ],
        ),
      ),
    );
  }
}