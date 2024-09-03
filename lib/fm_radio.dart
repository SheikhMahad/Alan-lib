import 'package:flutter/material.dart';
import 'radio_page.dart';

class FmRadio extends StatefulWidget {
  const FmRadio({super.key});

  @override
  State<FmRadio> createState() => _FmRadioState();
}

class _FmRadioState extends State<FmRadio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FM Radio'),
          backgroundColor: Colors.blue,foregroundColor: Colors.white,
        ),
        body: RadioPage()
    );
  }
}