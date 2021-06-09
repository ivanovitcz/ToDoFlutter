import 'package:dicodingflutter/colorPalette.dart';
import 'package:dicodingflutter/stringData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          child: Icon(Icons.add),
          backgroundColor: ColorPalette.primaryColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 10,
            child: Text(
              "My ToDo List",
              style: TextStyle(
                  fontFamily: 'Niramit',
                  color: ColorPalette.titleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 26),
            ),
          ),
          for (int i = 0; i < StringData.categories.length; i += 2)
            Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: buildCategoryRow(context, i)),
          Container(
            margin: EdgeInsets.only(top: 40),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "To Do",
                  style: TextStyle(
                      fontFamily: 'Niramit',
                      color: ColorPalette.titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  "Lihat Semua",
                  style: TextStyle(
                      fontFamily: 'Niramit',
                      color: ColorPalette.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          ),

          for(int i = 0; i < 5; i++)
            Container(
              margin: EdgeInsets.only(right: 25, left: 25, bottom: 20),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: ColorPalette.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 15),
                          child: Icon(
                            Icons.money_rounded,
                            color: ColorPalette.primaryColor
                          ),
                        ),
                        Container(
                          child: Text(
                            "Testing",
                            style: TextStyle(
                              fontFamily: 'Niramit',
                              color: ColorPalette.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    ),
                  ),

                  InkWell(
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Colors.green[100],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Row buildCategoryRow(BuildContext context, int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildCategoryContainer(context, i),
        buildCategoryContainer(context, i + 1),
      ],
    );
  }

  Container buildCategoryContainer(BuildContext context, int i) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      height: MediaQuery.of(context).size.height / 8,
      width: MediaQuery.of(context).size.width / 2.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: StringData.categories[i][1],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(StringData.categories[i][2], color: Colors.white),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                StringData.categories[i][0],
                style: TextStyle(
                  fontFamily: 'Niramit',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                "0/0",
                style: TextStyle(
                  fontFamily: 'Niramit',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          )
        ],
      ),
    );
  }
}
