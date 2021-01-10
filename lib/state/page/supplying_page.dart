import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungohday/models/supplying_model.dart';
import 'package:ungohday/state/supplyingdetail.dart';

import '../../utility/my_style.dart';
import '../../utility/my_style.dart';
import '../supplying.dart';

class SupplyingPage extends StatefulWidget {
  @override
  _SupplyingPageState createState() => _SupplyingPageState();
}

class _SupplyingPageState extends State<SupplyingPage> {
  String DOCID = '', PDAID = '02:00:00:44:55:66';
  String status;
  bool checkStatus = true;
  List<SupplyingModel> supplyingModels = List();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('On Top ScrollControler');
      }
    });

    readData();
  }

  Future<Null> readData() async {
    if (supplyingModels.length != 0) {
      supplyingModels.clear();
    }
    String path =
        'http://183.88.213.12/wsvvpack/wsvvpack.asmx/GETSUPPLYHEADER?DOCID=$DOCID&PDAID=$PDAID';

    print('path = $path');

    await Dio().get(path).then((value) {
      print('value = $value');

      int index = 0;
      for (var item in jsonDecode(value.data)) {
        if (index == 0) {
          setState(() {
            status = item['Status'];
          });
          print('status = $status');
          if (status == 'Successful...') {
            //Show listview
            setState(() {
              checkStatus = false;
            });
          }
        } else {
          SupplyingModel model = SupplyingModel.fromJson(item);
          setState(() {
            supplyingModels.add(model);
          });
        }
        index++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNewDoc(),
          buildTransfer(),
        ],
      ),
      backgroundColor: MyStyle().darkBackgroud,
      body: status == null
          ? MyStyle().showProgress()
          : checkStatus
              ? buildShowNoData()
              : buildListView(),
    );
  }

  OutlineButton buildNewDoc() {
    return OutlineButton(
      child: Text(
        'New doc.',
        style: TextStyle(color: Colors.white),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      borderSide: BorderSide(color: Colors.white),
      onPressed: () {},
    );
  }

  OutlineButton buildTransfer() {
    return OutlineButton(
      child: Text(
        'Transfer',
        style: TextStyle(color: Colors.white),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      borderSide: BorderSide(color: Colors.white),
      onPressed: () {},
    );
  }

  Widget buildListView() {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.only(left: 8, right: 8),
        itemCount: supplyingModels.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            print('You Click index = $index');
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SupplyingDetail(model:supplyingModels[index],),
            ));
          },
          child: Card(
            color: supplyingModels[index].statusCode == 'Complete'
                ? Colors.green.shade200
                : Colors.orange.shade200,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Doc.'),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(supplyingModels[index].dOCID),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Location'),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          supplyingModels[index].fromLocation,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          supplyingModels[index].toLocation,
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('BIN'),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          supplyingModels[index].fromBin,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          supplyingModels[index].toBin,
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('ITEM'),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(supplyingModels[index].dOCID),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('DATE'),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(supplyingModels[index].dOCID),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('STATUS'),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(supplyingModels[index].dOCID),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Center buildShowNoData() => Center(child: Text(status == null ? '' : status));
}
