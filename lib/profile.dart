import 'power_data.dart';


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  String? _lifterStatus;

  DateTime? _birthDate;

  Future<void> _updateLifterId() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _birthDate == null) {
      setState(() {
        _lifterStatus = 'To get your lifter rank, please fill in all fields (beside nickname)';
      });
      return;
    }
    final lifterId = await fetchLifterId(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      birthDate: _birthDate!,
    );

    setState(() {
      if (lifterId != null) {
        _lifterStatus = 'Lifter: ${_firstNameController.text} ${_lastNameController.text} (ID: $lifterId)';
      } else {
        _lifterStatus = 'Error: No lifter found';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstNameController.text = prefs.getString('firstName') ?? '';
      _lastNameController.text = prefs.getString('lastName') ?? '';
      _nicknameController.text = prefs.getString('nickname') ?? '';

      final birthDateString = prefs.getString('birthDate');
      if (birthDateString != null) {
        _birthDate = DateTime.tryParse(birthDateString);
      }

    });
    if (_firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty && _birthDate != null) {
      await _updateLifterId();
    }
  }

  Future<void> _saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> _saveBirthDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('birthDate', date.toIso8601String());
  }

  void _onFieldChanged(String key, String value) {
    _saveString(key, value.trim());
    if (key == 'firstName' || key == 'lastName') {
      if (_firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty && _birthDate != null) {
        _updateLifterId();
      }
    } else if (key == 'birthDate') {
      if (_birthDate != null) {
        _updateLifterId();
      }
    }
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(1900);
    final initialDate = _birthDate ?? DateTime(2000);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(now) ? now : initialDate,
      firstDate: firstDate,
      lastDate: now,
    );

    if (picked != null && picked != _birthDate) {
      setState(() => _birthDate = picked);
      await _saveBirthDate(picked);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Birthdate saved!')),
      );
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return '${date.month.toString().padLeft(2, '0')}/'
           '${date.day.toString().padLeft(2, '0')}/'
           '${date.year}';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required String storageKey,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(labelText: label),
            onChanged: (v) => _onFieldChanged(storageKey, v),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // Focus the text field when edit is clicked
            FocusScope.of(context).requestFocus(FocusNode());
            FocusScope.of(context).requestFocus(FocusNode());
            FocusScope.of(context).requestFocus(FocusNode());
            FocusScope.of(context).requestFocus(FocusNode());
            FocusScope.of(context).requestFocus(FocusNode());
            FocusScope.of(context).requestFocus(FocusNode());
            FocusScope.of(context).requestFocus(FocusNode());
            FocusScope.of(context).requestFocus(FocusNode());
            FocusScope.of(context).requestFocus(FocusNode());
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    onChanged: (v) => _onFieldChanged('firstName', v),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    FocusScope.of(context).requestFocus(FocusNode());
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    onChanged: (v) => _onFieldChanged('lastName', v),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nicknameController,
                    decoration: const InputDecoration(labelText: 'Nickname'),
                    onChanged: (v) => _onFieldChanged('nickname', v),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Birthdate',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _formatDate(_birthDate),
                      style: TextStyle(
                        fontSize: 16,
                        color: _birthDate == null
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _pickBirthDate,
                ),
              ],
            ),
            if (_lifterStatus != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _lifterStatus!,
                  style: TextStyle(
                    fontSize: 16,
                    color: _lifterStatus!.contains('No lifter') ? Colors.red : Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
