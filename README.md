# Cool drop down
## Features
 - All customizable css
 - Auto scroll to selected item position
 - dropdownBox is automatically placed. It's based on the position of the dropdown on the screen.(top/bottom)
 - Support triangle arrow
 - Support overflow ellipsis
 - "COOL"

## Samples
<div style="display: flex;">
<img src="/sample_01.gif" height="600">
<img src="/sample_02.gif" height="600"/>
<img src="/sample_03.gif" height="600"/>
</div>

## Options map
<img src="/dropdown_description.png" height="500"/>


## Important options 

| option          | Type      | Default  | Description                                                                                                                                                                                       |
|---------------|-----------|---------:|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| onChange      | Function  | required | when user selects one of the values, it's triggered. You <span style="color:#333333">must</span> put one parameter in the Function. (ex. onChange: (a) {}).Then, you will get return selectedItem Map. |
| dropdownList | List<Map> | required | You have to declare a key, "label", all elements of the List                                                                                                                                      |
| isAnimation   | bool      | true     | turn on/off animation                 |
```dart
import 'package:flutter_svg/flutter_svg.dart';
          
List dropdownItemList = [
  {
    'label': 'apple',
    'value': 'apple',
    'icon': Container(        // if you want to use icon, you have to declare key as 'icon'
      key: UniqueKey(),       // you have to use UniqueKey()
      width: 20,
      height: 20,
      child: SvgPicture.asset(          // I recommend to use this library
        'assets/apple.svg',
      ),
    ),
    'selectedIcon': Container(          // if you want to use different icon when user select item, you have to declare key as 'selectedIcon'
      key: UniqueKey(),
      width: 20,
      height: 20,
      child: SvgPicture.asset(
        'assets/apple.svg',
        color: Colors.white.withOpacity(0.7),
      ),
    ),
  }
]
```

## Dropdown options
| option                | Type          | Default | Description                          |
|---------------------|---------------|--------:|--------------------------------------|
| dropdownWidth       | double        | 220     |                                      |
| dropdownHeight      | double        | 50      |                                      |
| dropdownBD          | BoxDecoration |below code| BoxDeocoration of the dropdown           |
| dropdownTS          | TextStyle     |below code| TextStyle of the dropdown                |
| dropdownPadding     | EdgeInsets    |below code| Padding of the dropdown                  |
| dropdownAlign       | Alignment     |below code| Alignment of the dropdown in row         |
| dropdownMainAxis       | MainAxisAlignment     | MainAxisAlignment.start| MainAxisAlignment of the dropdown in row         |
| dropdownReverse     | bool          | false   | Reverse order of the dropdown by row |
| labelIconGap        | double        | 10      | Gap between the label and icon           |
| isDropdownLabel        | bool        | true      | Show/hide the label of the dropdown          |
| isDropdownBoxLabel        | bool        | true      | Show/hide the label of the dropdownBox         |
| isDropdownIconLabel        | bool        | true      | Show/hide the label and icon of the dropdown          |
| dropdownIconLeftGap | double        | 10      | Gap left side of the dropdown and icon   |
| dropdownIcon        | Widget        |below code| Icon of the dropdown at right            |
| dropdownIconRotation| bool        |true| Rotation animation of the dropdownIcon             |
| dropdownIconRotationValue| double        |0.5| Rotation value of the dropdownIcon animation |
| placeholder         | String        | null    |                                      |
| placeholderTS       | TextStyle     |below code|                                      |

| defaultValue        | Map           | null    | Default selected value               |
| gap        | double           | 30    | Gap between the dropdown and dropdownBox               |

```dart
dropdownBD = BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 1),
            ),
          ],
        );
```
```dart
dropdownTS = TextStyle(
            fontSize: 20,
            color: Colors.black,
          );
```
```dart
dropdownPadding = const EdgeInsets.only(left: 10, right: 10);
```
```dart
dropdownAlign = Alignment.centerLeft
```
```dart
placeholderTS = TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 20);
```

## DropdownBox & triangle options
| option                  | Type          | Default    | Description                                           |
|-----------------------|---------------|-----------:|-------------------------------------------------------|
| dropdownBoxWidth      | double        | 200        |                                                       |
| dropdownBoxHeight     | double        | 300        |                                                       |
| dropdownBoxBD         | BoxDecoration | below code | BoxDecoration of the dropdownBox                      |
| dropdownBoxPadding    | EdgeInsets    | below code | Padding of the dropdownBox                            |
| dropdownBoxAlign      | String        | 'center'   | Only 'left', 'center', 'right' available              |
| dropdownItemHeight    | double        | 50         | Height of items in the dropdownBox                    |
| dropdownItemGap       | double        | 5          | Gaps between items in the dropdownBox                 |
| dropdownItemTopGap    | double        | 10         | Gap between the first item and the dropdownBox top    |
| dropdownItemBottomGap | double        | 10         | Gap between the last item and the dropdownBox bottom  |
| dropdownItemPadding   | EdgeInsets    | below code | Padding of dropdownBox                                |
| dropdownItemReverse   | bool          | false      | reverse order(label, icon) of the dropdownItem by row |
| dropdownItemMainAxis       | MainAxisAlignment     | MainAxisAlignment.start| MainAxisAlignment of dropdown in row         |
| isTriangle            | bool          | true       | show/hide triangle arrow                              |
| triangleWidth         | double        | 20         |                                                       |
| triangleHeight        | double        | 20         |                                                       |
| triangleLeft          | double        | 10         | Left of the current triangle position                 |
| triangleAlign         | String        | 'center'   | Only 'left', 'center', 'right' available              |
| selectedItemBD        | BoxDecoration | below code | BoxDecoration of selectedItem                         |
| selectedItemTS        | TextStyle     | below code | TextStyle of selectedItem                             |
| selectedItemPadding   | EdgeInsets    | below code | Padding of selectedItem                               |
| unselectedItemTS      | TextStyle     | below code | TextStyle of unselectedItem                           |
          
```dart
dropdownBoxBD = BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 1),
            ),
          ],
        )
```
```dart
dropdownBoxPadding = const EdgeInsets.only(left: 10, right: 10)
```
```dart
dropdownItemPadding = const EdgeInsets.only(left: 10, right: 10)
```
```dart
selectedItemBD = BoxDecoration(
          color: Color(0XFFEFFAF0),
          borderRadius: BorderRadius.circular(10),
        )
```
```dart
selectedItemTS = TextStyle(color: Color(0xFF6FCC76), fontSize: 20);
```
```dart
selectedItemPadding = const EdgeInsets.only(left: 10, right: 10)
```
```dart
unselectedItemTS = TextStyle(
            fontSize: 20,
            color: Colors.black,
          )
```
