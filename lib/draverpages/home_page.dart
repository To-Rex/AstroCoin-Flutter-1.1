import 'dart:async';
import 'dart:convert';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:astro_coin_uz/components/tab_bar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

import '../components/qr_scanner.dart';
import '../components/qr_view.dart';
import '../components/send_wallet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _SampesPageState createState() => _SampesPageState();
}

class _SampesPageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var token;
  var wallet;
  var _ammaunt = '1000 ASC';
  late TabController tabController;
  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    wallet = prefs.getString('wallet') ?? '';
    getData();
  }

  Future<void> getData() async {
    final response = await http
        .get(Uri.parse("https://api.astrocoin.uz/api/user"), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    Encoding.getByName("utf-8");
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _ammaunt = '${data['balance']} ASC';
        wallet = data['wallet'];
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', data['name']);
      prefs.setString('lastname', data['last_name']);
      prefs.setString('qwasar', data['qwasar']);
      prefs.setString('email', data['email']);
      prefs.setString('number', data['number']);
      prefs.setString('stack', data['stack']);
      prefs.setString('role', data['role']);
      prefs.setString('status', data['status']);
      prefs.setInt('verify', data['verify']);
      prefs.setString('photo', data['photo']);
      prefs.setInt('balance', data['balance']);
      prefs.setString('wallet', data['wallet']);
      _controller.sink.add(SwipeRefreshState.hidden);
    }else{
      _controller.sink.add(SwipeRefreshState.hidden);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please check your internet connection'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          duration: Duration(milliseconds: 1700),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  final _controller = StreamController<SwipeRefreshState>.broadcast();
  Stream<SwipeRefreshState> get _stream => _controller.stream;

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(238, 238, 238, 100),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0), // here the desired height
          child: AppBar(
            backgroundColor: const Color.fromRGBO(33, 158, 188, 10),
          ),
        ),
        body: SwipeRefresh.material(
          stateStream: _stream,
          onRefresh: getData,
          //padding: const EdgeInsets.symmetric(vertical: 10),
          children:  [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.08,
                              ),
                              SvgPicture.asset(
                                'assets/svgs/splash.svg',
                                width: MediaQuery.of(context).size.width * 0.2,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Card(
                              color: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                title: Center(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.014,
                                        ),
                                        Image.asset(
                                          'assets/pngs/astrocoin.png',
                                          height: MediaQuery.of(context).size.height * 0.06,
                                          width: MediaQuery.of(context).size.width * 0.3,
                                          scale: 0.1,
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.01,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            AnimatedFlipCounter(
                                              value: double.parse(_ammaunt.split(' ')[0]),
                                              duration: const Duration(seconds: 2),
                                              curve: Curves.elasticOut,
                                              wholeDigits: _ammaunt.split(' ')[0].length,
                                              textStyle: GoogleFonts.fredoka(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              ' ${_ammaunt.split(' ')[1]}',
                                              style: GoogleFonts.fredoka(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.013,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(child: Container()),
                                            GestureDetector(
                                              onTap: () {
                                                HapticFeedback.lightImpact();
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.transparent,
                                                  builder: (context) => Container(
                                                    height: MediaQuery.of(context).size.height * 0.85,
                                                    decoration: const BoxDecoration(
                                                      color: Color.fromRGBO(241, 241, 241, 20),
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(15.0),
                                                        topRight: Radius.circular(15.0),
                                                      ),
                                                    ),
                                                    child: QrSheet(wallet: wallet),
                                                  ),
                                                );
                                              },
                                              child: SvgPicture.asset(
                                                'assets/svgs/read_qr_icon.svg',
                                                width: MediaQuery.of(context).size.width * 0.11,
                                                height: MediaQuery.of(context).size.width * 0.11,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.025,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                HapticFeedback.lightImpact();
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.transparent,
                                                  builder: (context) => Container(
                                                    height: MediaQuery.of(context).size.height * 0.85,
                                                    decoration: const BoxDecoration(
                                                      color: Color.fromRGBO(241, 241, 241, 20),
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(15.0),
                                                        topRight: Radius.circular(15.0),
                                                      ),
                                                    ),
                                                    child:  SendSheet(wallet: ''),
                                                  ),
                                                );
                                              },
                                              child: SvgPicture.asset(
                                                'assets/svgs/send_icon.svg',
                                                width: MediaQuery.of(context).size.width * 0.11,
                                                height: MediaQuery.of(context).size.width * 0.11,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.025,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                HapticFeedback.lightImpact();
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.transparent,
                                                  builder: (context) => Container(
                                                    height: MediaQuery.of(context).size.height * 0.75,
                                                    decoration: const BoxDecoration(
                                                      color: Color.fromRGBO(241, 241, 241, 20),
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(15.0),
                                                        topRight: Radius.circular(15.0),
                                                      ),
                                                    ),
                                                    child: const QRViewExample(),
                                                  ),
                                                );
                                              },
                                              child: SvgPicture.asset(
                                                'assets/svgs/qr_icon.svg',
                                                width: MediaQuery.of(context).size.width * 0.11,
                                                height: MediaQuery.of(context).size.width * 0.11,
                                              ),
                                            ),
                                            Expanded(child: Container()),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.014,
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.88,
                            child: const TabBarPage(),
                          ),
                        ]
                    ),
                  ),
                ],
              ),
            )
          ],
        ),

        /*body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.08,
                ),
                SvgPicture.asset(
                  'assets/svgs/splash.svg',
                  width: MediaQuery.of(context).size.width * 0.2,
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  title: Center(
                      child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.014,
                      ),
                      Image.asset(
                        'assets/pngs/astrocoin.png',
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.3,
                        scale: 0.1,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                        _ammaunt,
                        style: GoogleFonts.fredoka(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.013,
                      ),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          SvgPicture.asset(
                            'assets/svgs/read_qr_icon.svg',
                            width: MediaQuery.of(context).size.width * 0.11,
                            height: MediaQuery.of(context).size.width * 0.11,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          SvgPicture.asset(
                            'assets/svgs/send_icon.svg',
                            width: MediaQuery.of(context).size.width * 0.11,
                            height: MediaQuery.of(context).size.width * 0.11,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          SvgPicture.asset(
                            'assets/svgs/qr_icon.svg',
                            width: MediaQuery.of(context).size.width * 0.11,
                            height: MediaQuery.of(context).size.width * 0.11,
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.014,
                      ),
                    ],
                  )),
                ),
              ),
            ),
            Container(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.88,
                height: MediaQuery.of(context).size.height * 0.6,
                child:  Column(
                  children: const [TabBarPage()],
                )
              ),
            ),
            */
        /*SizedBox(
              width: MediaQuery.of(context).size.width * 0.88,
              height: MediaQuery.of(context).size.height * 0.6,
              child:  Column(
                children: const [TabBarPage()],
              )
            ),*/
      );
    } else {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(238, 238, 238, 100),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0), // here the desired height
          child: AppBar(
            backgroundColor: const Color.fromRGBO(33, 158, 188, 10),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.01,
                        ),
                        SvgPicture.asset(
                          'assets/svgs/splash.svg',
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Card(
                          color: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.014,
                              ),
                              Image.asset(
                                'assets/pngs/astrocoin.png',
                                height:
                                    MediaQuery.of(context).size.height * 0.13,
                                width: MediaQuery.of(context).size.width * 0.5,
                                scale: 0.2,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Text(
                                _ammaunt,
                                style: GoogleFonts.fredoka(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.013,
                              ),
                              Row(
                                children: [
                                  Expanded(child: Container()),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => Container(
                                          height: MediaQuery.of(context).size.height * 0.85,
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(241, 241, 241, 20),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15.0),
                                              topRight: Radius.circular(15.0),
                                            ),
                                          ),
                                          child: QrSheet(wallet: wallet),
                                        ),
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      'assets/svgs/read_qr_icon.svg',
                                      width: MediaQuery.of(context).size.width *
                                          0.07,
                                      height: MediaQuery.of(context).size.width *
                                          0.07,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => Container(
                                          height: MediaQuery.of(context).size.height * 0.85,
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(241, 241, 241, 20),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15.0),
                                              topRight: Radius.circular(15.0),
                                            ),
                                          ),
                                          child:  SendSheet(wallet: ''),
                                        ),
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      'assets/svgs/send_icon.svg',
                                      width: MediaQuery.of(context).size.width *
                                          0.07,
                                      height: MediaQuery.of(context).size.width *
                                          0.07,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => Container(
                                          height: MediaQuery.of(context).size.height * 0.85,
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(241, 241, 241, 20),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15.0),
                                              topRight: Radius.circular(15.0),
                                            ),
                                          ),
                                          child: const QRViewExample(),
                                        ),
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      'assets/svgs/qr_icon.svg',
                                      width: MediaQuery.of(context).size.width *
                                          0.07,
                                      height: MediaQuery.of(context).size.width *
                                          0.07,
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.014,
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Center(
                          child: Column(
                        children: const [TabBarPage()],
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
