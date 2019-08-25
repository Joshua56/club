import 'package:flutter/material.dart';

class ProductModal{
  final String id;
  final String name;
  final double price;

  ProductModal({
    this.id = '1',
    @required this.name,
    @required this.price
  });
}