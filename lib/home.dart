import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _lines = [];
  String _currentLine = '';
  Timer? _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadMotivationLines().then((_) {
      _pickRandomLine();
      _timer = Timer.periodic(const Duration(seconds: 5), (_) {
        _pickRandomLine();
      });
    });
  }

  Future<void> _loadMotivationLines() async {
    final raw = await rootBundle.loadString('assets/motivation.txt');
    setState(() {
      _lines = raw.split('\n').where((line) => line.trim().isNotEmpty).toList();
    });
  }

  void _pickRandomLine() {
    if (_lines.isEmpty) return;
    final newLine = _lines[_random.nextInt(_lines.length)];
    setState(() {
      _currentLine = newLine;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          _currentLine.isEmpty ? 'Loading...' : _currentLine,
          style: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}