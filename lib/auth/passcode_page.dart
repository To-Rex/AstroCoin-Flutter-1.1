import 'dart:async';
import 'package:astro_coin_uz/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import '../samples/sample_page.dart';
import 'package:flutter/services.dart';

class PasscodePage extends StatefulWidget {
  const PasscodePage({super.key});

  @override
  _SampesPageState createState() => _SampesPageState();
}

class _SampesPageState extends State<PasscodePage>
    with SingleTickerProviderStateMixin {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  var one = const Color.fromRGBO(238, 238, 238, 100),
      two = const Color.fromRGBO(238, 238, 238, 100),
      three = const Color.fromRGBO(238, 238, 238, 100),
      four = const Color.fromRGBO(238, 238, 238, 100);

  var token = "";
  var index = 0;
  var index1 = 0;
  var included = '';
  var password = '';
  var pass = '';
  var textism = 'Guest';
  var txtPasswordName = 'Enter Password';

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    password = prefs.getString('password') ?? '';
    if (prefs.getString('name') != null) {
      textism = prefs.getString('name') ?? '';
      _authenticate();
    } else {
      textism = 'Guest';
    }
    if (password.isNotEmpty) {
      txtPasswordName = 'Enter Password';
    } else {
      txtPasswordName = 'Create Password';
    }
    setState(() {});
  }

  Future<void> _authenticate() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to access the app',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error occured while trying to authenticate'),
        ),
      );
    }

    if (isAuthenticated) {
      print('User authenticated successfully');
      one = Colors.deepPurpleAccent;
      two = Colors.deepPurpleAccent;
      three = Colors.deepPurpleAccent;
      four = Colors.deepPurpleAccent;
      setState(() {});
      _soucsess();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const SamplePage();
      }));
    }
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const LoginPage();
    }));
  }

  void _onback() {
    included = included.substring(0, index);
    if (index == -1) {
      index++;
    }
    if (index == 0) {
      one = const Color.fromRGBO(238, 238, 238, 100);
    }
    if (index == 1) {
      two = const Color.fromRGBO(238, 238, 238, 100);
    }
    if (index == 2) {
      three = const Color.fromRGBO(238, 238, 238, 100);
    }
    if (index == 3) {
      four = const Color.fromRGBO(238, 238, 238, 100);
    }
    if (index > 4) {
      index == 4;
    }
  }

  Future<void> _onclick() async {
    if (index > 4) {
      index = 4;
    }
    if (index == 1) {
      one = Colors.black54;
    }
    if (index == 2) {
      two = Colors.black54;
    }
    if (index == 3) {
      three = Colors.black54;
    }
    if (index == 4) {
      four = Colors.black54;
      if (password.isNotEmpty) {
        //enter password
        if (password == included) {
          one = Colors.deepPurpleAccent;
          two = Colors.deepPurpleAccent;
          three = Colors.deepPurpleAccent;
          four = Colors.deepPurpleAccent;
          _soucsess();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const SamplePage();
          }));
        } else {
          included = '';
          index = 0;
          one = Colors.red;
          two = Colors.red;
          three = Colors.red;
          four = Colors.red;
          _foults();
        }
      } else {
        //create password
        if (index1 == 1) {
          if (pass == included) {
            one = Colors.deepPurpleAccent;
            two = Colors.deepPurpleAccent;
            three = Colors.deepPurpleAccent;
            four = Colors.deepPurpleAccent;
            _soucsess();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('password', included);
            included = '';
            index = 0;
            index1 = 0;
            pass = '';
            txtPasswordName = 'Enter Password';
            getData();
          } else {
            included = '';
            index = 0;
            one = Colors.red;
            two = Colors.red;
            three = Colors.red;
            four = Colors.red;
            _foults();
          }
        }
        if (index1 == 0) {
          index1++;
          pass = included;
          included = '';
          index = 0;
          one = Colors.deepPurpleAccent;
          two = Colors.deepPurpleAccent;
          three = Colors.deepPurpleAccent;
          four = Colors.deepPurpleAccent;
          _soucsess();
          txtPasswordName = 'Confirm Password';
        }
      }
    }
  }

  void _foults() {
    Timer(const Duration(milliseconds: 600), () {
      one = const Color.fromRGBO(238, 238, 238, 100);
      two = const Color.fromRGBO(238, 238, 238, 100);
      three = const Color.fromRGBO(238, 238, 238, 100);
      four = const Color.fromRGBO(238, 238, 238, 100);
      included = '';
      index = 0;
      setState(() {});
    });
  }

  void _soucsess() {
    Timer(const Duration(milliseconds: 600), () {
      one = const Color.fromRGBO(238, 238, 238, 100);
      two = const Color.fromRGBO(238, 238, 238, 100);
      three = const Color.fromRGBO(238, 238, 238, 100);
      four = const Color.fromRGBO(238, 238, 238, 100);
      included = '';
      index = 0;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0), // here the desired height
          child: AppBar(
            backgroundColor: const Color.fromRGBO(33, 158, 188, 10),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(child: Text('')),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            SvgPicture.asset(
              'assets/svgs/password_logo.svg',
              width: MediaQuery.of(context).size.width * 0.55,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Text(
              'Hello, $textism',
              style: GoogleFonts.fredoka(
                fontSize: 25,
                //color: error,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              txtPasswordName,
              style: GoogleFonts.fredoka(
                fontSize: 17,
                //color: error,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Row(
              children: [
                const Expanded(child: Text('')),
                Container(
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width * 0.09,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(238, 238, 238, 100),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.025,
                      width: MediaQuery.of(context).size.width * 0.045,
                      decoration: BoxDecoration(
                        color: one,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width * 0.09,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(238, 238, 238, 100),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.025,
                      width: MediaQuery.of(context).size.width * 0.045,
                      decoration: BoxDecoration(
                        color: two,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width * 0.09,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(238, 238, 238, 100),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.025,
                      width: MediaQuery.of(context).size.width * 0.045,
                      decoration: BoxDecoration(
                        color: three,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width * 0.09,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(238, 238, 238, 100),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.025,
                      width: MediaQuery.of(context).size.width * 0.045,
                      decoration: BoxDecoration(
                        color: four,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                const Expanded(child: Text('')),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            // 1 2 3 text button
            Row(
              children: [
                const Expanded(child: Text('')),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    included = '${included}1';
                    index++;
                    _onclick();
                    setState(() {});
                  },
                  child: Text(
                    '1',
                    style: GoogleFonts.fredoka(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    included = '${included}2';
                    index++;
                    _onclick();
                    setState(() {});
                  },
                  child: Text(
                    '2',
                    style: GoogleFonts.fredoka(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    included = '${included}3';
                    index++;
                    _onclick();
                    setState(() {});
                  },
                  child: Text(
                    '3',
                    style: GoogleFonts.fredoka(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Expanded(child: Text('')),
              ],
            ),
            //4 5 6 textButton
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Row(
              children: [
                const Expanded(child: Text('')),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    included = '${included}4';
                    index++;
                    _onclick();
                    setState(() {});
                  },
                  child: Text(
                    '4',
                    style: GoogleFonts.fredoka(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    included = '${included}5';
                    index++;
                    _onclick();
                    setState(() {});
                  },
                  child: Text(
                    '5',
                    style: GoogleFonts.fredoka(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    included = '${included}6';
                    index++;
                    _onclick();
                    setState(() {});
                  },
                  child: Text(
                    '6',
                    style: GoogleFonts.fredoka(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Expanded(child: Text('')),
              ],
            ),
            //7 8 9 text Button
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Row(
              children: [
                const Expanded(child: Text('')),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    included = '${included}7';
                    index++;
                    _onclick();
                    setState(() {});
                  },
                  child: Text(
                    '7',
                    style: GoogleFonts.fredoka(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    included = '${included}8';
                    index++;
                    _onclick();
                    setState(() {});
                  },
                  child: Text(
                    '8',
                    style: GoogleFonts.fredoka(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    included = '${included}9';
                    index++;
                    _onclick();
                    setState(() {});
                  },
                  child: Text(
                    '9',
                    style: GoogleFonts.fredoka(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Expanded(child: Text('')),
              ],
            ),
            //finger print icon 0 and back icon
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Row(
              children: [
                const Expanded(child: Text('')),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _authenticate();
                      },
                      child: SvgPicture.asset(
                        'assets/svgs/fingerprint_icon.svg',
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.09,
                      )),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.095,
                ),
                TextButton(
                  onPressed: () {
                    //Vibration.vibrate(duration: 200);
                    HapticFeedback.lightImpact();
                    included = '${included}0';
                    index++;
                    _onclick();
                    setState(() {});
                  },
                  child: Text(
                    '0',
                    style: GoogleFonts.fredoka(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.095,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      if (index == 0) {
                        index++;
                      }
                      index--;
                      _onback();
                      setState(() {});
                    },
                    child: SvgPicture.asset(
                      'assets/svgs/back_icon.svg',
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.09,
                    ),
                  ),
                ),
                const Expanded(child: Text('')),
              ],
            ),
            const Expanded(child: Text('')),
            TextButton(
              onPressed: () {
                HapticFeedback.vibrate();
                logOut();
              },
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.fredoka(
                  fontSize: 20,
                  color: Colors.indigo,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ));
  }
}
