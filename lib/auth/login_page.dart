import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:astro_coin_uz/auth/passcode_page.dart';
import 'package:astro_coin_uz/components/sign_up_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../components/recover_detail.dart';
import '../samples/sample_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _SampesPageState createState() => _SampesPageState();
}

class _SampesPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _email = TextEditingController();
  final _password = TextEditingController();
  var error = Colors.black;

  Future<void> login() async {
    if (_email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          duration: Duration(milliseconds: 1700),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your password'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          duration: Duration(milliseconds: 1700),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _password.clear();
      return;
    }

    final response = await http.post(
      Uri.parse("https://api.astrocoin.uz/api/login"),
      body: {
        'email': _email.text,
        'password': _password.text,
      },
    );
    if (response.statusCode == 200) {
      var token = json.decode(response.body)['token'] ?? '';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      print("buuuuuu ======= $token");

      if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const SamplePage();
        }));
      }
      if (Platform.isAndroid || Platform.isIOS) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const PasscodePage();
        }));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check your email or password'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          duration: Duration(milliseconds: 1700),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      error = Colors.red;
      setState(() {});
      Timer(const Duration(seconds: 1), () {
        error = Colors.black;
        _password.clear();
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
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
      body: Center(
        child: Column(
          children: [
            Expanded(child: Container()),
            SvgPicture.asset(
              'assets/svgs/signInLoge.svg',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 51,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(241, 241, 241, 100),
                      border: Border.all(
                          color: const Color.fromRGBO(241, 241, 241, 100),
                          width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      cursorColor: Colors.deepPurpleAccent,
                      controller: _email,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.fredoka(
                        fontSize: 20,
                        color: error,
                        fontWeight: FontWeight.w400,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(left: 10, right: 10),
                        border: InputBorder.none,
                        hintText: 'Email',
                        hintStyle: GoogleFonts.fredoka(
                            fontSize: 17,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: 51,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(241, 241, 241, 100),
                      border: Border.all(
                          color: const Color.fromRGBO(241, 241, 241, 100),
                          width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    /*child: TextField(
                      cursorColor: Colors.deepPurpleAccent,
                      controller: _password,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.fredoka(
                        fontSize: 20,
                        color: error,
                        fontWeight: FontWeight.w400,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(left: 10, right: 10),
                        border: InputBorder.none,
                        hintText: 'Password',
                        hintStyle: GoogleFonts.fredoka(
                            fontSize: 17,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400),
                      ),
                    ),*/
                    //text fild password
                    child: TextField(
                      cursorColor: Colors.deepPurpleAccent,
                      controller: _password,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.fredoka(
                        fontSize: 20,
                        color: error,
                        fontWeight: FontWeight.w400,
                      ),
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10, right: 10),
                        border: InputBorder.none,
                        hintText: 'Password',
                        hintStyle: GoogleFonts.fredoka(
                            fontSize: 17,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          isDismissible: true,
                          enableDrag: false,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                            height: MediaQuery.of(context)
                                .size
                                .height *
                                0.9,
                            width: MediaQuery.of(context)
                                .size
                                .width,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight:
                                Radius.circular(10),
                              ),
                            ),
                            child: ReceiverPage(),
                          ));
                    },
                    child: Text(
                      'Recover',
                      style: GoogleFonts.fredoka(
                          fontSize: 17,
                          color: const Color.fromRGBO(33, 158, 188, 10),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(87, 51, 209, 180),
                      border: Border.all(
                          color: const Color.fromRGBO(87, 51, 209, 180),
                          width: 0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            isDismissible: true,
                            enableDrag: false,
                            backgroundColor: Colors.transparent,
                            builder: (context) => Container(
                              height: MediaQuery.of(context)
                                  .size
                                  .height *
                                  0.9,
                              width: MediaQuery.of(context)
                                  .size
                                  .width,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight:
                                  Radius.circular(10),
                                ),
                              ),
                              child: SiginUpPage(),
                            ));
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.fredoka(
                            fontSize: 17,
                            color: const Color.fromRGBO(87, 51, 209, 10),
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(87, 51, 209, 10),
                      border: Border.all(
                          color: const Color.fromRGBO(87, 51, 209, 10),
                          width: 0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        login();
                      },
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.fredoka(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
