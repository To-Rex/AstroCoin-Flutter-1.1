import 'dart:async';
import 'dart:io';

import 'package:astro_coin_uz/auth/login_page.dart';
import 'package:astro_coin_uz/samples/sample_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/passcode_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SampesPageState createState() => _SampesPageState();
}

class _SampesPageState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  var password = '';
  var token = '';

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    password = prefs.getString('password') ?? '';
    print(token);
    print(password);
    Timer(const Duration(milliseconds: 2000), () {
      if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return const LoginPage();
        }));
      }
      if(Platform.isAndroid|| Platform.isIOS){
        if (password != '') {
          print('token and password are not empty');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return const PasscodePage();
          }));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return const LoginPage();
          }));
        }
      }
    });
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: SvgPicture.asset(
          'assets/svgs/splash.svg',
          height: 60,
          width: 60,
        ),
      ),
    );
  }
}