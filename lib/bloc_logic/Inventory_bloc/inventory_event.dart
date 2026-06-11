import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();
  get context => null;
  get id => null;
  get inventoryName => null;
  get amount => null;
  get serialNo => null;
  get purchaseDate => null;
  get endWarrantyDate => null;
}

class GetInventory extends InventoryEvent {
  const GetInventory({required this.context});

  @override
  final BuildContext context;

  @override
  List<Object?> get props => [];
}

class GetInventoryById extends InventoryEvent {
  const GetInventoryById({required this.context, required this.id});

  @override
  final BuildContext context;
  @override
  final int id;

  @override
  List<Object?> get props => [];
}

class AddInventoryEvent extends InventoryEvent {
  const AddInventoryEvent({
    required this.context,
    required this.inventoryName,
    required this.amount,
    required this.serialNo,
    required this.purchaseDate,
    required this.endWarrantyDate,
  });

  @override
  final BuildContext context;
  @override
  final String inventoryName;
  @override
  final String amount;
  @override
  final String serialNo;
  @override
  final String purchaseDate;
  @override
  final String endWarrantyDate;

  @override
  List<Object?> get props => [];
}

class UpdateInventory extends InventoryEvent {
  const UpdateInventory(
      {required this.context,
      required this.inventoryName,
      required this.amount,
      required this.serialNo,
      required this.purchaseDate,
      required this.endWarrantyDate,
      required this.id});

  @override
  final BuildContext context;
  @override
  final int id;
  @override
  final String inventoryName;
  @override
  final String amount;
  @override
  final String serialNo;
  @override
  final String purchaseDate;
  @override
  final String endWarrantyDate;

  @override
  List<Object?> get props => [];
}

class DeleteInventory extends InventoryEvent {
  const DeleteInventory({
    required this.context,
    required this.id,
  });

  @override
  final BuildContext context;
  @override
  final int id;

  @override
  List<Object?> get props => [];
}
