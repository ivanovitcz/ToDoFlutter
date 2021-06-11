import 'package:dicodingflutter/colorPalette.dart';
import 'package:flutter/material.dart';

class StringData {
  static const apiUrl = "https://masak-apa.tomorisakura.vercel.app/api/";
  static const categories = {
    0 : [
      "Pekerjaan",
      ColorPalette.primaryColor,
      Icons.business_center
    ],
    1 : [
      "Keuangan",
      ColorPalette.successColor,
      Icons.monetization_on,
    ],
    2 : [
      "Belajar",
      ColorPalette.secondaryColor,
      Icons.library_books
    ],
    3 : [
      "Belanja",
      ColorPalette.warningColor,
      Icons.add_shopping_cart
    ],
    4 : [
      "Kesehatan",
      ColorPalette.dangerColor,
      Icons.accessibility
    ],
    5 : [
      "Lain-lain",
      Colors.purple,
      Icons.layers
    ],
  };

}