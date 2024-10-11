import 'package:get/get.dart';

class ZoneDropDownController extends GetxController {
  RxString selectedItem = ''.obs;

  void setSelectedItem(String item) {
    selectedItem.value = item;
  }
}
