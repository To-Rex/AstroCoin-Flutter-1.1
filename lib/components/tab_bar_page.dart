import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../tabs/tab_bar_1.dart';
import '../tabs/tab_bar_2.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({Key? key}) : super(key: key);

  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TabBar(
                          unselectedLabelColor: Colors.black54,
                          labelColor: Colors.black,
                          indicatorColor: Colors.black,
                          indicatorWeight: 2,
                          indicator:  BoxDecoration(
                            color: const Color.fromRGBO(238, 238, 238, 100),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          controller: tabController,
                          labelStyle: GoogleFonts.fredoka(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                          tabs:  const [
                            Tab(text: 'Transfer',
                            ),
                            Tab(
                              text: 'Orders',
                            ),
                          ],
                        ),
                      )
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: TabBarView(
                controller: tabController,
                children: const [
                  Tab1(),
                  Tab2(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
