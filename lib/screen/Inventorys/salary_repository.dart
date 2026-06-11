import 'package:oceanbit_timeclock/models/get_inventory_model.dart';

class InventoryPDFRepository {
  static final InventoryPDFRepository salaryPDFRepository =
      InventoryPDFRepository._();

  InventoryPDFRepository._();

  factory InventoryPDFRepository() {
    return salaryPDFRepository;
  }

  GetInventoryModel inventoryModel =
      GetInventoryModel(status: false, message: '', data: []);
}
