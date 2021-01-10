import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungohday/models/supply_detail_model.dart';
import 'package:ungohday/models/supplying_model.dart';
import 'package:ungohday/state/lot_detail.dart';
import '../utility/my_style.dart';

class SupplyingDetail extends StatefulWidget {
  final SupplyingModel model;
  SupplyingDetail({Key key, this.model}) : super(key: key);
  @override
  _SupplyingDetailState createState() => _SupplyingDetailState();
}

class _SupplyingDetailState extends State<SupplyingDetail> {
  SupplyingModel supplyingModel;
  bool checkStatus;
  String status;
  List<SupplyDetailModel> supplyDetailModels = List();
  List<String> lots = List();

  Map<String, int> mapBoxQTYs = Map();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    supplyingModel = widget.model;
    if (supplyingModel != null) {
      readData();
    }
  }

  Future<Null> readData() async {
    String path =
        'http://183.88.213.12/wsvvpack/wsvvpack.asmx/GETSUPPLYDETAIL?DOCID=${supplyingModel.dOCID}&PDAID=${supplyingModel.pDAID}&ITEMID=';
    // print('path ------> $path');

    await Dio().get(path).then((value) {
      print('value ========> $value');
      var result = jsonDecode(value.data);

      int index = 0;
      for (var item in result) {
        if (index == 0) {
          status = item['Status'];
          print('status ===> $status');
          if (status == 'Successful...') {
            setState(() {
              checkStatus = false;
            });
          } else {
            setState(() {
              checkStatus = true;
            });
          }
        } else {
          SupplyDetailModel model = SupplyDetailModel.fromJson(item);
          supplyDetailModels.add(model);


          if (lots.length == 0) {
            setState(() {
              lots.add(model.lOT);
              mapBoxQTYs[model.lOT] = model.bOXQTY;

              List<SupplyDetailModel> models = List();
              models.add(model);



            });
          } else {
            bool addStatus = true;
            for (var item in lots) {
              if (item == model.lOT) {
                // Lot Dupplicate
                addStatus = false;
                mapBoxQTYs[model.lOT] = mapBoxQTYs[model.lOT] + model.bOXQTY;


              }
            }
            if (addStatus) {
              setState(() {
                // Non Lot Dupplicate
                lots.add(model.lOT);
                mapBoxQTYs[model.lOT] = model.bOXQTY;
              });
            }
          }
        }

        index++;
      }
      print('mapBoxQTYs ===> ${mapBoxQTYs.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyStyle().darkBackgroud,
      appBar: AppBar(
        actions: [
          TextButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ),
              label: Text(
                'Save',
                style: MyStyle().titelH3(),
              ))
        ],
        backgroundColor: MyStyle().darkBackgroud,
        title: Text('Supplying'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildRow1(),
            buildRow('From Location', supplyingModel.fromLocation,
                MyStyle().titelH2red()),
            buildRow(
                'From BIN', supplyingModel.fromBin, MyStyle().titelH2red()),
            Divider(
              color: Colors.grey,
            ),
            buildRow('To Location', supplyingModel.fromLocation,
                MyStyle().titelH2green()),
            buildRow('To BIN', supplyingModel.toBin, MyStyle().titelH2green()),
            Divider(
              color: Colors.grey,
            ),
            buildRow('ITEM', supplyingModel.item, MyStyle().titelH2()),
            buildRow('Quanlity', supplyingModel.qty, MyStyle().titelH2()),
            buildRow('Remaining', supplyingModel.qty, MyStyle().titelH2()),
            Divider(
              color: Colors.grey,
            ),
            showListView(),
          ],
        ),
      ),
    );
  }

  Widget showListView() {
    return checkStatus == null
        ? Expanded(child: MyStyle().showProgress())
        : checkStatus
            ? Container(
                margin: EdgeInsets.only(top: 100),
                child: Text(
                  status,
                  style: MyStyle().titelH3(),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: lots.length,
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LotDetail(lot: lots[index],models:supplyDetailModels),
                            ));
                      },
                      child: Card(
                        color: Colors.yellow[700],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text('Lot'),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(lots[index]),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text('Quantity'),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                        mapBoxQTYs[lots[index]].toString()),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ));
  }

  Padding buildRow(String title, String value, TextStyle textStyle) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: textStyle,
            ),
          ),
          Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: textStyle,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Padding buildRow1() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Description :',
              style: MyStyle().titelH3(),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                decoration: MyStyle().boxDecorationTextField(),
                child: TextField(),
              )),
        ],
      ),
    );
  }
}
