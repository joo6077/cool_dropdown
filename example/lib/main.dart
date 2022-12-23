import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/drop_down_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class FruitQuantity {
  final String name;
  final int quantity;

  FruitQuantity({this.name, this.quantity});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

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

List<DropDownParams<FruitQuantity>> dropdownItemList = [];

List<FruitQuantity> fruits = [
  FruitQuantity(name: 'apple', quantity: 12),
  FruitQuantity(name: 'banana', quantity: 4),
  FruitQuantity(name: 'grapes', quantity: 2),
  FruitQuantity(name: 'lemon', quantity: 8),
  FruitQuantity(name: 'melon', quantity: 2),
  FruitQuantity(name: 'orange', quantity: 7),
  FruitQuantity(name: 'pineapple', quantity: 1),
  FruitQuantity(name: 'strawberry', quantity: 4),
  FruitQuantity(name: 'watermelon', quantity: 2),
];

class _MyAppState extends State<MyApp> {
  List<DropDownParams<String>> pokemonsDropdownList = [];
  @override
  void initState() {
    pokemonsDropdownList = pokemons.map((pokemon) => DropDownParams(
          label: pokemon,
          value: pokemon,
          icon: Container(
            height: 25,
            width: 25,
            child: SvgPicture.asset(
              'assets/$pokemon.svg',
            ),
          ),
        ));

    for (var i = 0; i < fruits.length; i++) {
      dropdownItemList.add(DropDownParams<FruitQuantity>(
        label: fruits[i].name == 'melon' ? 'melon sugar high' : fruits[i].name,
        // 'label': '${fruits[i]}',
        value: fruits[i],
        icon: Container(
          key: UniqueKey(),
          height: 20,
          width: 20,
          child: SvgPicture.asset(
            'assets/${fruits[i]}.svg',
          ),
        ),
        selectedIcon: Container(
          key: UniqueKey(),
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            'assets/${fruits[i]}.svg',
            color: Color(0xFF6FCC76),
          ),
        ),
      ));
    }
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
              child: CoolDropdown<FruitQuantity>(
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
              child: CoolDropdown(
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
              child: CoolDropdown<String>(
                dropdownList: pokemonsDropdownList,
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
