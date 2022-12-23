import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/drop_down_params.dart';
import 'package:flutter/material.dart';

class OtherScreen extends StatefulWidget {
  const OtherScreen({Key key}) : super(key: key);

  @override
  _OtherScreenState createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: CoolDropdown<String>(dropdownList: [
            DropDownParams(
              label: 'Apple',
              value: 'apple',
            ),
          ], onChange: (_) => print(_.value)),
        ),
      ),
    );
  }
}
