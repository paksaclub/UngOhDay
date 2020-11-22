import 'package:flutter/material.dart';
import 'package:ungohday/state/recieving.dart';
import 'package:ungohday/state/storing.dart';
import 'package:ungohday/state/supplying.dart';

class MyConstant {
  String domain = 'https://862761840d5e.ngrok.io';
  List<String> titleMenus = ['RECIEVING', 'STORING', 'SUPPLYING'];
  List<IconData> iconMenus = [Icons.filter_1, Icons.filter_2, Icons.filter_3];
  List<Widget> currentWidgets = [Recieving(), Storing(), Supplying()];
  List<List<String>> subTitles = [[], ['BOX BY BOX', 'BIN TO BIN'], []];
  

  MyConstant();
}
