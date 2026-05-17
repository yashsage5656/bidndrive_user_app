import 'package:bid_driving/features/pdi/pdi_provider.dart';
import 'package:get/get.dart';

class PdiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PdiController>(() => PdiController());
  }
}