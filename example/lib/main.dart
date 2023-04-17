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
  List<CoolDropdownItem<String>> pokemonDropdownItems = [];
  List<CoolDropdownItem<String>> fruitDropdownItems = [];

  final fruitDropdownController = DropdownController();
  final pokemonDropdownController = DropdownController();
  final listDropdownController = DropdownController();

  @override
  void initState() {
    for (var i = 0; i < pokemons.length; i++) {
      pokemonDropdownItems.add(
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
    for (var i = 0; i < fruits.length; i++) {
      fruitDropdownItems.add(CoolDropdownItem<String>(
          label: 'Delicious ${fruits[i]}',
          icon: Container(
            margin: EdgeInsets.only(left: 10),
            height: 25,
            width: 25,
            child: SvgPicture.asset(
              'assets/${fruits[i]}.svg',
            ),
          ),
          selectedIcon: Container(
            margin: EdgeInsets.only(left: 10),
            height: 25,
            width: 25,
            child: SvgPicture.asset(
              'assets/${fruits[i]}.svg',
              color: Color(0xFF6FCC76),
            ),
          ),
          value: '${fruits[i]}'));
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if (fruitDropdownController.isError) {
              fruitDropdownController.resetError();
            } else {
              await fruitDropdownController.error();
            }
            fruitDropdownController.open();
          },
          label: Text('Error'),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 100,
            ),
            Center(
              child: WillPopScope(
                onWillPop: () async {
                  if (fruitDropdownController.isOpen) {
                    fruitDropdownController.close();
                    return Future.value(false);
                  } else {
                    return Future.value(true);
                  }
                },
                child: CoolDropdown<String>(
                  controller: fruitDropdownController,
                  dropdownList: fruitDropdownItems,
                  defaultItem: null,
                  onChange: (value) async {
                    if (fruitDropdownController.isError) {
                      await fruitDropdownController.resetError();
                    }
                    // fruitDropdownController.close();
                  },
                  onOpen: (value) {},
                  resultOptions: ResultOptions(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: 200,
                    icon: const SizedBox(
                      width: 10,
                      height: 10,
                      child: CustomPaint(
                        painter: DropdownArrowPainter(),
                      ),
                    ),
                    render: ResultRender.all,
                    placeholder: 'Select Fruit',
                    isMarquee: true,
                  ),
                  dropdownOptions: DropdownOptions(
                      top: 20,
                      height: 400,
                      gap: DropdownGap.all(5),
                      borderSide: BorderSide(width: 1, color: Colors.black),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      align: DropdownAlign.left,
                      animationType: DropdownAnimationType.size),
                  dropdownTriangleOptions: DropdownTriangleOptions(
                    width: 20,
                    height: 30,
                    align: DropdownTriangleAlign.left,
                    borderRadius: 3,
                    left: 20,
                  ),
                  dropdownItemOptions: DropdownItemOptions(
                    isMarquee: true,
                    mainAxisAlignment: MainAxisAlignment.start,
                    render: DropdownItemRender.all,
                    height: 50,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            Center(
              child: CoolDropdown<String>(
                controller: pokemonDropdownController,
                dropdownList: pokemonDropdownItems,
                defaultItem: pokemonDropdownItems.last,
                onChange: (a) {
                  pokemonDropdownController.close();
                },
                resultOptions: ResultOptions(
                  width: 70,
                  render: ResultRender.icon,
                  icon: SizedBox(
                    width: 10,
                    height: 10,
                    child: CustomPaint(
                      painter: DropdownArrowPainter(color: Colors.green),
                    ),
                  ),
                ),
                dropdownOptions: DropdownOptions(
                  width: 140,
                ),
                dropdownItemOptions: DropdownItemOptions(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  selectedBoxDecoration: BoxDecoration(
                    color: Color(0XFFEFFAF0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            Center(
              child: CoolDropdown(
                controller: listDropdownController,
                dropdownList: pokemonDropdownItems,
                onChange: (dropdownItem) {},
                resultOptions: ResultOptions(
                  width: 50,
                  render: ResultRender.none,
                  icon: Container(
                    width: 25,
                    height: 25,
                    child: SvgPicture.asset(
                      'assets/pokeball.svg',
                    ),
                  ),
                ),
                dropdownItemOptions: DropdownItemOptions(
                  render: DropdownItemRender.icon,
                  selectedPadding: EdgeInsets.zero,
                  mainAxisAlignment: MainAxisAlignment.center,
                  selectedBoxDecoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.black.withOpacity(0.7),
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 500,
            ),
          ],
        ),
      ),
    );
  }
}
