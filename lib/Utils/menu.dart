import 'dart:convert';

import 'package:flutter/foundation.dart';

class Menu {
  String items;

  Menu(
    this.items,
  );
  static Map<String, dynamic> toMap(Menu items) => {
        'items': items.items,
      };

  Menu.fromJason(Map<String, dynamic> json) : items = json['items'];

  static String encode(List<Menu> musics) => json.encode(
        musics.map<Map<String, dynamic>>((music) => Menu.toMap(music)).toList(),
      );

  static List<Menu> decode(String items) =>
      (json.decode(items) as List<dynamic>)
          .map<Menu>((item) => Menu.fromJason(item))
          .toList();
}
