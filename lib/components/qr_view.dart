import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrSheet extends StatefulWidget {
  var wallet;
  QrSheet({Key? key, this.wallet}) : super(key: key);

  @override
  _SendSheetState createState() => _SendSheetState();
}

class _SendSheetState extends State<QrSheet> {
  var vallets = '';
  Future<void> customToast(String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text(message),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        duration: const Duration(milliseconds: 1700),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  Future<void> getToken() async {
    vallets = widget.wallet.toString();
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).orientation == Orientation.portrait) {
      return Column(
        children: <Widget>[
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
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          Text('Recieve',
              style: GoogleFonts.fredoka(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black)),
          const Expanded(child: SizedBox()),
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
              ),
              //qr image centered
              Positioned(
                top: MediaQuery.of(context).size.height * 0.05,
                left: MediaQuery.of(context).size.width * 0.17,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: QrImage(
                    data: vallets,
                    version: QrVersions.auto,
                    size: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: const Color.fromRGBO(241, 241, 241, 100), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(vallets, style: GoogleFonts.fredoka(
                      fontSize: MediaQuery.of(context).size.width / 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.black26)),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/svgs/copy_icon.svg',
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Clipboard.setData(ClipboardData(text: vallets));
                      customToast('Wallet id copied to clipboard');
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          //button
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.07,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'Close',
                style: GoogleFonts.fredoka(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      );
    }else{
      return Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
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
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Text('Recieve',
              style: GoogleFonts.fredoka(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black)),
          const Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.22,
                    height: MediaQuery.of(context).size.height * 0.39,
                    child: QrImage(
                      data: vallets,
                      version: QrVersions.auto,
                      size: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.white, width: 0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(vallets, style: GoogleFonts.fredoka(
                              fontSize: MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.w400,
                              color: Colors.black26)),
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/svgs/copy_icon.svg',
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              Clipboard.setData(ClipboardData(text: vallets));
                              customToast('Wallet id copied to clipboard');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.58,
                    height: MediaQuery.of(context).size.height * 0.13,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'Close',
                        style: GoogleFonts.fredoka(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
        ],
      );
    }

  }
}
