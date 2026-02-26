import 'package:flutter/material.dart';
import 'package:screen_security/screen_security.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen Security Example',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _screenSecurity = ScreenSecurity();
  bool _isEnabled = false;
  String _status = 'Screen security is OFF';
  final _textController = TextEditingController();

  Future<void> _toggleSecurity() async {
    try {
      if (_isEnabled) {
        await _screenSecurity.disable();
        setState(() {
          _isEnabled = false;
          _status = 'Screen security is OFF';
        });
      } else {
        await _screenSecurity.enable();
        setState(() {
          _isEnabled = true;
          _status = 'Screen security is ON';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen Security Example')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: _isEnabled ? Colors.green.shade50 : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(_isEnabled ? Icons.lock : Icons.lock_open, size: 48, color: _isEnabled ? Colors.green : Colors.red),
                      const SizedBox(height: 12),
                      Text(
                        _status,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _isEnabled ? Colors.green.shade800 : Colors.red.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _toggleSecurity,
                icon: Icon(_isEnabled ? Icons.lock_open : Icons.lock),
                label: Text(_isEnabled ? 'Disable Security' : 'Enable Security'),
                style: FilledButton.styleFrom(
                  backgroundColor: _isEnabled ? Colors.red : Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 32),
              Text('Keyboard & SafeArea Test', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Type here to test keyboard insets',
                  hintText: 'Keyboard should work normally...',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Another text field', hintText: 'Test multiple inputs...'),
              ),
              const Spacer(),
              Text(
                'Try taking a screenshot or screen recording\n'
                'while security is enabled.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
