import 'package:get/get.dart';

class LocationController extends GetxController {
  var startLocation = ''.obs;
  var endLocation = ''.obs;

  void updateStartLocation(String location) {
    startLocation.value = location;
  }

  void updateEndLocation(String location) {
    endLocation.value = location;
  }

  void clearLocations() {
    startLocation.value = '';
    endLocation.value = '';
  }
}
