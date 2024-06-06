import 'package:flutter/material.dart';

class ContestScreen extends StatelessWidget {
  final String apiKey;

  ContestScreen({required this.apiKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Contest'),
      ),
      body: Center(
        child: Text('Contest feature coming soon...'),
      ),
    );
  }
}
