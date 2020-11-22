import 'package:flutter/material.dart';
import 'package:ungohday/state/storing.dart';
import 'package:ungohday/utility/my_constant.dart';
import 'package:ungohday/utility/my_style.dart';

class MainMenu extends StatefulWidget {
  final String name, type, storing;
  MainMenu({Key key, this.name, this.type, this.storing}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  String name, type, storing;
  Widget currentWidget;
  List<String> types = List();
  List<String> titleMenus = MyConstant().titleMenus;
  List<IconData> iconMenus = MyConstant().iconMenus;
  List<Widget> currentWidgets = MyConstant().currentWidgets;
  List<List<String>> subTitles = MyConstant().subTitles;
  List<String> showMenus = List();
  List<IconData> showIcons = List();
  List<Widget> showWidgets = List();
  List<List<String>> showSubTitles = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = widget.name;
    type = widget.type;
    storing = widget.storing;
    print('name = $name, type = $type, storing = $storing');
    createArea();
  }

  void createArea() {
    String string = type.substring(1, type.length - 1);
    print('string = $string');
    types = string.split(',');
    int index = 0;
    for (var item in types) {
      types[index] = item.trim();
      if (types[index] == '10') {
        setState(() {
          showMenus.add(titleMenus[index]);
          showIcons.add(iconMenus[index]);
          showWidgets.add(currentWidgets[index]);
          showSubTitles.add(subTitles[index]);
        });
      }
      index++;
    }
    currentWidget = showWidgets[0];
    print('types = $types');
    print('showMenus = $showMenus');
    print('showSubTitles = ${showSubTitles.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().darkBackgroud,
      ),
      drawer: buildDrawer(),
      body: currentWidget == null ? MyStyle().showProgress() : currentWidget,
    );
  }

  Drawer buildDrawer() => Drawer(
        child: Column(
          children: [
            buildUserAccountsDrawerHeader(),
            showMenus.length == 0
                ? MyStyle().showProgress()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: showMenus.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        setState(() {
                          currentWidget = showWidgets[index];
                        });
                        Navigator.pop(context);
                      },
                      leading: Icon(
                        showIcons[index],
                        size: 36,
                      ),
                      title: Text(showMenus[index]),
                    ),
                  ),
          ],
        ),
      );

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 1.2,
          center: Alignment(-0.8, -0.8),
          colors: [Colors.white, MyStyle().darkBackgroud],
        ),
      ),
      currentAccountPicture: Image.asset('images/logo.png'),
      accountName: Text(name == null ? 'Name' : name),
      accountEmail: Text('Logined'),
    );
  }
}
