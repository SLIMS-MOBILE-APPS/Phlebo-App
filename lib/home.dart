import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'drawer.dart';
import 'package:badges/badges.dart' as badges;
import 'globals.dart' as globals;

import 'completed.dart';
import 'pending.dart';

import 'package:badges/badges.dart';

class PhleboHome extends StatefulWidget {
  int selectedTab = 0;

  PhleboHome(int iTabID) {
    this.selectedTab = iTabID;
  }

  @override
  _PhleboHomeState createState() => _PhleboHomeState(this.selectedTab);
}

class _PhleboHomeState extends State<PhleboHome> {
  var date = "";
  DateTime selectedDate = DateTime.now();
  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2026),
    );

    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        globals.selectDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  int selectedIndex = 0;
  var selecteFromdt = '';
  var selecteTodt = '';
  bool pressAttention = false;
  var tabflag = '';
  int selectedTab = 0;

  _PhleboHomeState(int iTabID) {
    this.selectedTab = iTabID;

    if (this.selectedTab == 0) {
      tabflag = 'Pending';
    } else if (this.selectedTab == 1) {
      tabflag = 'Completed';
    }

    // else if (this.selectedTab == 2) {
    //   tabflag = 'Cancelled';
    // } else if (this.selectedTab == 3) {
    //   tabflag = 'Rejected';
    // }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var date = "";
    DateTime selectedDate = DateTime.now();
    String _formattodate = new DateFormat.yMMMd().format(selectedDate);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff123456),
        flexibleSpace: Container(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Builder(
            builder: (context) => IconButton(
              icon: Image(image: NetworkImage(globals.Logo)),
              onPressed: () {},
            ),
          ),
        )),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/home visit.png'),
                        fit: BoxFit.fitWidth)),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            globals.selectDate == ""
                ? MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Text("${selectedDate.toLocal()}".split(' ')[0],
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  )
                : MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Text(
                      globals.selectDate,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
            IconButton(
                onPressed: () {
                  BookingStatusLatLong = "";
                  _selectDate(context);
                },
                icon: Icon(Icons.calendar_month_outlined),
                color: Colors.white),
          ],
        ),
      ),
      drawer: DrawerForAll(),
      body: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DefaultTabController(
                  initialIndex: this.selectedTab,
                  length: 2, // length of tabs

                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: screenWidth * 1.0,
                          height: screenHeight * 0.08,
                          color: Color(0xff123456),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              height: 35,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: TabBar(
                                    indicator: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(0xff123456)),
                                    isScrollable: true,
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.black,
                                    tabs: [
                                      Tab(
                                          child: Container(
                                        width: width / 4,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            badges.Badge(
                                              position: BadgePosition.topEnd(
                                                  top: -10, end: -16),
                                              toAnimate: true,
                                              badgeColor: Colors.blue,
                                              child: MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                          textScaleFactor: 1.0),
                                                  child: Text("Pending")),
                                              badgeContent: MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        textScaleFactor: 1.0),
                                                child: Text(
                                                    globals.PHLEBO_PENDING_CNT,
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            )
                                          ],
                                        ),
                                      )),

                                      Tab(
                                          child: Container(
                                        width: width / 4,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            badges.Badge(
                                                position: BadgePosition.topEnd(
                                                    top: -10, end: -16),
                                                toAnimate: true,
                                                badgeColor: Colors.blue,
                                                child: MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                            textScaleFactor:
                                                                1.0),
                                                    child: Text("Completed")),
                                                badgeContent: MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .copyWith(
                                                          textScaleFactor: 1.0),
                                                  child: Text(
                                                    globals.COMPLETED_CNT,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      )),
                                      // Tab(
                                      //     child: Container(
                                      //   width: width / 6,
                                      //   child: Row(
                                      //     children: [
                                      //       badges.Badge(
                                      //         position: BadgePosition.topEnd(
                                      //             top: -10, end: -16),
                                      //         toAnimate: true,
                                      //         badgeColor: Colors.blue,
                                      //         child: MediaQuery(
                                      //             data: MediaQuery.of(context)
                                      //                 .copyWith(textScaleFactor: 1.0),
                                      //             child: Text("Cancelled")),
                                      //         badgeContent: MediaQuery(
                                      //           data: MediaQuery.of(context)
                                      //               .copyWith(textScaleFactor: 1.0),
                                      //           child: Text(globals.CANCEL_CNT,
                                      //               style: TextStyle(
                                      //                   color: Colors.white)),
                                      //         ),
                                      //       )
                                      //     ],
                                      //   ),
                                      // )),
                                      // Tab(
                                      //     child: Container(
                                      //   width: width / 7,
                                      //   child: Row(
                                      //     children: [
                                      //       badges.Badge(
                                      //           position: BadgePosition.topEnd(
                                      //               top: -10, end: -16),
                                      //           toAnimate: true,
                                      //           badgeColor: Colors.blue,
                                      //           child: MediaQuery(
                                      //               data: MediaQuery.of(context)
                                      //                   .copyWith(
                                      //                       textScaleFactor: 1.0),
                                      //               child: Text("Rejected")),
                                      //           badgeContent: MediaQuery(
                                      //             data: MediaQuery.of(context)
                                      //                 .copyWith(textScaleFactor: 1.0),
                                      //             child: Text(
                                      //               globals.REJECT_CNT,
                                      //               style: TextStyle(
                                      //                   color: Colors.white),
                                      //             ),
                                      //           ))
                                      //     ],
                                      //   ),
                                      // )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                            height: screenHeight * 0.8,
                            color: Colors.red,
                            child: TabBarView(
                                physics: NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  Phleb_Pending(),
                                  Phlebo_Completed(),
                                  // Phlebo_Cancelled(),
                                  // Phlebo_Rejected(),
                                ]))
                      ])),
            ]),
      ),
    );
  }
}
