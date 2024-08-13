import '../models/cool_dropdown_item.dart';

typedef GetSelectedItem = void Function(int index);
typedef ItemSelectionCallback<T> = void Function(CoolDropdownItem<T>? item);
