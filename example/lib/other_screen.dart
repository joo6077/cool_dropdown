import 'package:flutter/material.dart';
import 'package:cool_dropdown/cool_dropdown.dart';

class OtherScreen extends StatefulWidget {
  const OtherScreen({Key? key}) : super(key: key);

  @override
  _OtherScreenState createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: CoolDropdown(dropdownList: [
            {'label': 'apple', 'value': 'apple'}
          ], onChange: (_) {}),
        ),
      ),
    );
  }
}
