import 'package:get/get.dart';

class HomePageController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void selectTab(int index) {
    selectedIndex.value = index;
  }
}
