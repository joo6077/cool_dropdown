import 'package:flutter/material.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

List dropdownItemList = [];

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
  List<Map> pokemonsMap = [];
  @override
  void initState() {
    for (var i = 0; i < pokemons.length; i++) {
      pokemonsMap.add({
        'label': '${pokemons[i]}',
        'value': '${pokemons[i]}',
        'icon': Container(
          height: 25,
          width: 25,
          child: SvgPicture.asset(
            'assets/${pokemons[i]}.svg',
          ),
        ),
      });
    }
    for (var i = 0; i < fruits.length; i++) {
      dropdownItemList.add(
        {
          'label': fruits[i] == 'melon' ? 'melon sugar high' : '${fruits[i]}',
          // 'label': '${fruits[i]}',
          'value': '${fruits[i]}',
          'icon': Container(
            key: UniqueKey(),
            height: 20,
            width: 20,
            child: SvgPicture.asset(
              'assets/${fruits[i]}.svg',
            ),
          ),
          'selectedIcon': Container(
            key: UniqueKey(),
            width: 20,
            height: 20,
            child: SvgPicture.asset(
              'assets/${fruits[i]}.svg',
              color: Color(0xFF6FCC76),
            ),
          ),
        },
      );
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
              child: CoolDropdown(
                dropdownList: dropdownItemList,
                onChange: (selectedItem) {
                  print(selectedItem);
                },
                // dropdownBoxBD: BoxDecoration(
                //     color: Colors.white, border: Border.all(width: 20)),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            Center(
              child: CoolDropdown(
                dropdownWidth: 70,
                // dropdownIcon: Container(), // if you don't want to use Icon you can set empty Container
                dropdownList: dropdownItemList,
                isDropdownLabel: false,
                onChange: (a) {},
                dropdownItemReverse: true,
                dropdownItemMainAxis: MainAxisAlignment.start,
                dropdownMainAxis: MainAxisAlignment.start,
                labelIconGap: 20,
              ),
            ),
            SizedBox(
              height: 200,
            ),
            Center(
              child: CoolDropdown(
                dropdownList: pokemonsMap,
                dropdownItemPadding: EdgeInsets.zero,
                onChange: (dropdownItem) {},
                dropdownHeight: 50,
                dropdownWidth: 50,
                dropdownBoxWidth: 50,
                dropdownBoxHeight: 200,
                dropdownItemHeight: 30,
                dropdownItemGap: 10,
                dropdownIcon: Container(
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
                dropdownIconLeftGap: 0,
                dropdownPadding: EdgeInsets.zero,
                dropdownIconRotation: true,
                dropdownIconRotationValue: 1,
                isDropdownBoxLabel: false,
                isDropdownLabel: false,
                isDropdownIconLabel: false,
                dropdownBoxPadding: EdgeInsets.zero,
                dropdownAlign: Alignment.center,
                dropdownMainAxis: MainAxisAlignment.center,
                dropdownItemMainAxis: MainAxisAlignment.center,
                selectedItemBD: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: Colors.black.withOpacity(0.7), width: 3))),
                triangleWidth: 10,
                triangleHeight: 10,
                triangleAlign: 'center',
                dropdownBoxAlign: 'center',
                gap: 20,
              ),
            ),
            SizedBox(
              height: 400,
            )
          ],
        ),
      ),
    );
  }
}
