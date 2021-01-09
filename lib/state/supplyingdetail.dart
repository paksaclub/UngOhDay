import 'package:flutter/material.dart';

import '../utility/my_style.dart';
import '../utility/my_style.dart';

class SupplyingDetail extends StatefulWidget {
  @override
  _SupplyingDetailState createState() => _SupplyingDetailState();
}

class _SupplyingDetailState extends State<SupplyingDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyStyle().darkBackgroud,
      appBar: AppBar(
        backgroundColor: MyStyle().darkBackgroud,
        title: Text('Supplying'),
      ),
    );
  }
}
