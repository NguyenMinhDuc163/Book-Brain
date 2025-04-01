import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  static const String routeName = '/preview_screen';
  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.red)
    );
  }
}
