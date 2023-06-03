import 'package:boba_me/model/boba_customer.dart';
import 'package:flutter/material.dart';

import 'boba_order_model.dart';

class BobaCartModel extends ChangeNotifier {
  Map bobaOrderMap = Map<String, dynamic>();
  double _tax = 0.12;
  double _deliveryFee = 10.0;
  BobaCustomer _bobaCustomer;

  BobaCustomer get bobaCustomerInfo {
    return _bobaCustomer;
  }

  void assignBobaCustomer(BobaCustomer bc) {
    _bobaCustomer = bc;
    notifyListeners();
  }

  void addOrderToMap(BobaOrderModel order) {
    String key = order.bobaProductName + order.milkTypeName.trim() + order.sweetnessLevelName.trim()
        + order.iceLevelName.trim() + order.toppingsName.trim();

    if(bobaOrderMap.containsKey(key)) {
      BobaOrderModel updateOrder = bobaOrderMap[key];
      updateOrder.orderCount = updateOrder.orderCount + 1;
      bobaOrderMap[key] = updateOrder;
    }else{
      bobaOrderMap.putIfAbsent(key, () => order);
    }

    notifyListeners();
  }

  void updateOrder(BobaOrderModel order, String editOrderKey) {

    if(bobaOrderMap.containsKey(editOrderKey)) {
      bobaOrderMap.remove(editOrderKey);
    }
    addOrderToMap(order);
  }

  void removeOrder(String key, dynamic value) {
    if(bobaOrderMap.containsKey(key)) {
      bobaOrderMap.removeWhere((key, val) => val == value);
    }
  }

  void clearOrders() {
    bobaOrderMap.clear();
    notifyListeners();
  }

  Map<String, dynamic> get bobaOrdersMap => bobaOrderMap;
  
  int get orderCount {
    int orderCount = 0;
    bobaOrderMap.forEach((key, value) {
      BobaOrderModel updateOrder = bobaOrderMap[key];
      orderCount = orderCount + updateOrder.orderCount;
    });
    return orderCount;
  }

  void setBobaOrderMap(Map<String, dynamic> bobaOrdMap) {
    bobaOrderMap = bobaOrdMap;
    notifyListeners();
  }

  int get orderCountMap => bobaOrderMap.length;

  double get taxes {
    double ordTotal = 0;
    int orderNumber = 0;
    bobaOrderMap.forEach((key, value) {
      BobaOrderModel updateOrder = bobaOrderMap[key];
      orderNumber = updateOrder.orderCount;
      ordTotal += (updateOrder.price*orderNumber);
    });

    return ordTotal * _tax;
  }

  double get subTotal {
    double ordTotal = 0;
    int orderNumber = 0;
    bobaOrderMap.forEach((key, value) {
      BobaOrderModel updateOrder = bobaOrderMap[key];
      orderNumber = updateOrder.orderCount;
      ordTotal += (updateOrder.price*orderNumber);
    });

    double taxMultiplier = 1.00 - _tax;
    return ordTotal * taxMultiplier;
  }

  double get orderTotal {
    double ordTotal = 0;
    int orderNumber = 0;
    bobaOrderMap.forEach((key, value) {
      BobaOrderModel updateOrder = bobaOrderMap[key];
      orderNumber = updateOrder.orderCount;
      ordTotal += (updateOrder.price*orderNumber);
    });
    ordTotal += _deliveryFee;
    return ordTotal;
  }

  double get deliveryFee {
    return _deliveryFee;
  }
}