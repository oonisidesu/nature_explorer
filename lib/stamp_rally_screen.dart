import 'package:flutter/material.dart';

class StampRallyScreen extends StatelessWidget {
  final String apiKey;

  StampRallyScreen({required this.apiKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stamp Rally'),
      ),
      body: Center(
        child: Text('Stamp Rally feature coming soon...'),
      ),
    );
  }
}
