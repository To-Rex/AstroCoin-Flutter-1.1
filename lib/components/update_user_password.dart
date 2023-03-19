import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class changePassPage extends StatefulWidget {
  changePassPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<changePassPage> {
  late final TextEditingController _password = TextEditingController();
  late final TextEditingController _password1 = TextEditingController();
  late final TextEditingController _password2 = TextEditingController();

  var token = '';
  var password = '';

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    password = prefs.getString('password') ?? '';
    print(token);
    print(password);
  }

  Future<void> changePass() async {
    final response = await http.post(
      Uri.parse("https://api.astrocoin.uz/api/user/password"),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'old_password': _password.text.trim().toString(),
        'password': _password1.text.trim().toString(),
        'password_confirmation': _password2.text.trim().toString(),
      },
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password changed successfully'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          duration: Duration(milliseconds: 1700),
          backgroundColor: Colors.deepPurpleAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password not changed'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          duration: Duration(milliseconds: 1700),
          backgroundColor: Colors.deepPurpleAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void initState() {
    getToken();
  }

  @override
  void dispose() {
    _password.dispose();
    _password1.dispose();
    _password2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText2!,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return Wrap(
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.008,
                        width: MediaQuery.of(context).size.width * 0.3,
                        //radius: 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.09,
                      ),
                      SvgPicture.asset(
                        'assets/svgs/splash.svg',
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text(
                        'Enter new password for your account',
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(0, 0, 0, 0.6),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.81,
                        child: Text(
                          'Current Password',
                          style: GoogleFonts.fredoka(
                            color: const Color.fromRGBO(0, 0, 0, 0.6),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      Container(
                        height: MediaQuery.of(context).size.height * 0.065,
                        width: MediaQuery.of(context).size.width * 0.83,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          maxLength: 15,
                          minLines: 1,
                          maxLines: 1,
                          controller: _password,
                          style: GoogleFonts.fredoka(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          toolbarOptions: const ToolbarOptions(
                            cut: false,
                            copy: false,
                            selectAll: false,
                            paste: false,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter your password',
                            counter: Offstage(),
                            contentPadding:
                            EdgeInsets.only(left: 15, right: 15),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.81,
                        child: Text(
                          'New Password',
                          style: GoogleFonts.fredoka(
                            color: const Color.fromRGBO(0, 0, 0, 0.6),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.065,
                        width: MediaQuery.of(context).size.width * 0.83,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          maxLength: 15,
                          minLines: 1,
                          maxLines: 1,
                          controller: _password1,
                          style: GoogleFonts.fredoka(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          toolbarOptions: const ToolbarOptions(
                            cut: false,
                            copy: false,
                            selectAll: false,
                            paste: false,
                          ),
                          decoration: const InputDecoration(
                            counter: Offstage(),
                            hintText: 'Enter new password',
                            contentPadding:
                            EdgeInsets.only(left: 15, right: 15),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.81,
                        child: Text(
                          'Re-enter new password',
                          style: GoogleFonts.fredoka(
                            color: const Color.fromRGBO(0, 0, 0, 0.6),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.065,
                        width: MediaQuery.of(context).size.width * 0.83,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          maxLength: 15,
                          minLines: 1,
                          maxLines: 1,
                          controller: _password2,
                          style: GoogleFonts.fredoka(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          toolbarOptions: const ToolbarOptions(
                            cut: false,
                            copy: false,
                            selectAll: false,
                            paste: false,
                          ),
                          decoration: const InputDecoration(
                            counter: Offstage(),
                            hintText: 'Re-enter new password',
                            contentPadding:
                            EdgeInsets.only(left: 15, right: 15),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.83,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (_password1.text == _password2.text&&_password1.text.isNotEmpty&&_password2.text.isNotEmpty) {
                              Navigator.pop(context);
                              changePass();
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Error',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w400)),
                                      content: const Text(
                                          'Error in password or password not match',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400)),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Ok',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w400))),
                                      ],
                                    );
                                  });
                            }
                          },
                          child: Text(
                            'Submit',
                            style: GoogleFonts.fredoka(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    }else{
      return DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText2!,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return Wrap(
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.015,
                        width: MediaQuery.of(context).size.width * 0.15,
                        //radius: 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.09,
                      ),
                      SvgPicture.asset(
                        'assets/svgs/splash.svg',
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text(
                        'Enter new password for your account',
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(0, 0, 0, 0.6),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),

                      /*ListView(
                        children: [

                        ],
                      ),*/

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.81,
                        child: Text(
                          'Current Password',
                          style: GoogleFonts.fredoka(
                            color: const Color.fromRGBO(0, 0, 0, 0.6),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.width * 0.83,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          maxLength: 15,
                          minLines: 1,
                          maxLines: 1,
                          controller: _password,
                          style: GoogleFonts.fredoka(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          toolbarOptions: const ToolbarOptions(
                            cut: false,
                            copy: false,
                            selectAll: false,
                            paste: false,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter your password',
                            counter: Offstage(),
                            contentPadding:
                            EdgeInsets.only(left: 15, right: 15),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.37,
                                child: Text(
                                  'New Password',
                                  style: GoogleFonts.fredoka(
                                    color: const Color.fromRGBO(0, 0, 0, 0.6),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: TextField(
                                  maxLength: 15,
                                  minLines: 1,
                                  maxLines: 1,
                                  controller: _password1,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  obscureText: true,
                                  toolbarOptions: const ToolbarOptions(
                                    cut: false,
                                    copy: false,
                                    selectAll: false,
                                    paste: false,
                                  ),
                                  decoration: const InputDecoration(
                                    counter: Offstage(),
                                    hintText: 'Enter new password',
                                    contentPadding:
                                    EdgeInsets.only(left: 15, right: 15),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.37,
                                child: Text(
                                  'Re-enter new password',
                                  style: GoogleFonts.fredoka(
                                    color: const Color.fromRGBO(0, 0, 0, 0.6),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: TextField(
                                  maxLength: 15,
                                  minLines: 1,
                                  maxLines: 1,
                                  controller: _password2,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  obscureText: true,
                                  toolbarOptions: const ToolbarOptions(
                                    cut: false,
                                    copy: false,
                                    selectAll: false,
                                    paste: false,
                                  ),
                                  decoration: const InputDecoration(
                                    counter: Offstage(),
                                    hintText: 'Re-enter new password',
                                    contentPadding:
                                    EdgeInsets.only(left: 15, right: 15),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(child: SizedBox()),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.83,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (_password1.text == _password2.text&&_password1.text.isNotEmpty&&_password2.text.isNotEmpty) {
                              Navigator.pop(context);
                              changePass();
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Error',
                                          style: GoogleFonts.fredoka(
                                            fontSize: 17,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      content: Text('Error in password or password not match',
                                          style: GoogleFonts.fredoka(
                                            fontSize: 17,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Ok',
                                                style: GoogleFonts.fredoka(
                                                  fontSize: 17,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ))),
                                      ],
                                    );
                                  });
                            }
                          },
                          child: Text(
                            'Submit',
                            style: GoogleFonts.fredoka(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

  }
}
