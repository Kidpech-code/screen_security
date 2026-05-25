import 'package:flutter/material.dart';
import 'package:screen_security/screen_security.dart';

import 'l10n/app_localizations.dart';

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
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
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
  final _textController = TextEditingController();

  Future<void> _toggleSecurity() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      if (_isEnabled) {
        await _screenSecurity.disable();
        setState(() {
          _isEnabled = false;
        });
      } else {
        await _screenSecurity.enable();
        setState(() {
          _isEnabled = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.statusError(e.toString()))));
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
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
                      Icon(
                        _isEnabled ? Icons.lock : Icons.lock_open,
                        size: 48,
                        color: _isEnabled ? Colors.green : Colors.red,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isEnabled ? l10n.statusOn : l10n.statusOff,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: _isEnabled
                                  ? Colors.green.shade800
                                  : Colors.red.shade800,
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
                label: Text(
                  _isEnabled ? l10n.disableSecurity : l10n.enableSecurity,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: _isEnabled ? Colors.red : Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.keyboardTestTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: l10n.typeHereLabel,
                  hintText: l10n.typeHereHint,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: l10n.anotherFieldLabel,
                  hintText: l10n.anotherFieldHint,
                ),
              ),
              const Spacer(),
              Text(
                l10n.screenshotHint,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
