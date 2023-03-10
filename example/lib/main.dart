import 'package:flutter/material.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

List<CoolDropdownItem<String>> dropdownItemList = [];

List<String> pokemons = [
  'pikachu',
  'charmander',
  'squirtle',
  'bullbasaur',
  'snorlax',
  'mankey',
  'psyduck',
  'meowth'
];
List<String> fruits = [
  'apple',
  'banana',
  'grapes',
  'lemon',
  'melon',
  'orange',
  'pineapple',
  'strawberry',
  'watermelon',
];

class _MyAppState extends State<MyApp> {
  List<CoolDropdownItem> pokemonMap = [];
  @override
  void initState() {
    for (var i = 0; i < pokemons.length; i++) {
      pokemonMap.add(
        CoolDropdownItem<String>(
            label: '${pokemons[i]}',
            icon: Container(
              height: 25,
              width: 25,
              child: SvgPicture.asset(
                'assets/${pokemons[i]}.svg',
              ),
            ),
            value: '${pokemons[i]}'),
      );
    }
    for (var i = 0; i < fruits.length; i++) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6FCC76),
          title: Text('Cool Drop Down'),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 100,
            ),
            Center(
              child: CoolDropdown(
                dropdownList: dropdownItemList,
                onChange: (selectedItem) {
                  print(selectedItem);
                },
                onOpen: (isOpen) {
                  print('$isOpen');
                },
                resultIcon: Container(
                  width: 10,
                  height: 10,
                  child: SvgPicture.asset(
                    'assets/dropdown-arrow.svg',
                    semanticsLabel: 'Acme Logo',
                    color: Colors.grey.withOpacity(0.7),
                  ),
                ),
                // dropdownBD: BoxDecoration(
                //     color: Colors.white, border: Border.all(width: 20)),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            Center(
              child: CoolDropdown<String>(
                resultWidth: 70,
                // resultIcon: Container(), // if you don't want to use Icon you can set empty Container
                dropdownList: dropdownItemList,
                isResultLabel: false,
                onChange: (a) {},
                dropdownItemReverse: true,
                dropdownItemMainAxis: MainAxisAlignment.start,
                resultMainAxis: MainAxisAlignment.start,
                dropdownWidth: 200,
                labelIconGap: 20,
                resultIcon: Container(
                  width: 10,
                  height: 10,
                  child: SvgPicture.asset(
                    'assets/dropdown-arrow.svg',
                    semanticsLabel: 'Acme Logo',
                    color: Colors.grey.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            Center(
              child: CoolDropdown(
                dropdownList: pokemonMap,
                dropdownItemPadding: EdgeInsets.zero,
                onChange: (dropdownItem) {},
                resultHeight: 50,
                resultWidth: 50,
                dropdownWidth: 50,
                dropdownHeight: 200,
                dropdownItemHeight: 30,
                dropdownItemGap: 10,
                resultIcon: Container(
                  width: 25,
                  height: 25,
                  child: Container(
                    width: 25,
                    height: 25,
                    child: SvgPicture.asset(
                      'assets/pokeball.svg',
                    ),
                  ),
                ),
                resultIconLeftGap: 0,
                resultPadding: EdgeInsets.zero,
                resultIconRotation: true,
                resultIconRotationValue: 1,
                isDropdownLabel: false,
                isResultLabel: false,
                isResultIconLabel: false,
                dropdownPadding: EdgeInsets.zero,
                resultAlign: Alignment.center,
                resultMainAxis: MainAxisAlignment.center,
                dropdownItemMainAxis: MainAxisAlignment.center,
                selectedItemBD: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: Colors.black.withOpacity(0.7), width: 3))),
                triangleWidth: 10,
                triangleHeight: 10,
                triangleAlign: 'center',
                dropdownAlign: 'center',
                gap: 20,
              ),
            ),
            SizedBox(
              height: 400,
            ),
          ],
        ),
      ),
    );
  }
}

// Android back button check

// import 'package:flutter/material.dart';
// import 'package:cool_dropdown/cool_dropdown.dart';
// import 'package:example/other_screen.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: NewWidget(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class NewWidget extends StatelessWidget {
//   const NewWidget({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             child: CoolDropdown(dropdownList: [
//               {'label': 'apple', 'value': 'apple'}
//             ], onChange: (_) {}),
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => OtherScreen()));
//               },
//               child: Text('click'))
//         ],
//       ),
//     );
//   }
// }
