import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_page.dart';
import '../components/astrum_rank.dart';
import '../components/astrum_store.dart';
import '../components/update_password.dart';
import '../components/update_user_password.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  _SampesPageState createState() => _SampesPageState();
}

class _SampesPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  var token = '';
  var name = '';
  var lastname = '';
  var qwasar = '';
  var email = '';
  var number = '';
  var stack = '';
  var role = '';
  var status = '';
  var verify = 0;
  var photo = '';
  var balance = 0;
  var wallet = '';
  var size = 0.0;
  var sizeweight = 0.0;

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? ''.trim();
    name = prefs.getString('name') ?? '';
    lastname = prefs.getString('lastname') ?? '';
    qwasar = prefs.getString('qwasar') ?? '';
    email = prefs.getString('email') ?? '';
    number = prefs.getString('number') ?? '';
    stack = prefs.getString('stack') ?? '';
    role = prefs.getString('role') ?? '';
    status = prefs.getString('status') ?? '';
    verify = prefs.getInt('verify') ?? 0;
    photo = prefs.getString('photo') ?? '';
    balance = prefs.getInt('balance') ?? 0;
    wallet = prefs.getString('wallet') ?? '';
    print(verify);
    setState(() {
      final size1 = MediaQuery.of(context).size;
      size = size1.height;
      sizeweight = size1.width;
    });
  }

  void customFullScreenDialog(BuildContext context, Widget child) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return Material(
          color: Colors.black,
          child: InkWell(
            //needed
            onTap: () => Navigator.pop(context),
            child: PhotoView(
              backgroundDecoration:
                  const BoxDecoration(color: Colors.transparent),
              imageProvider: //NetworkImage user image
                  NetworkImage('https://api.astrocoin.uz/$photo'),
            ),
          ),
        );
      },
    ));
  }

  void showImageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Choose an option',
              style: GoogleFonts.fredoka(
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(
                    'Camera',
                    style: GoogleFonts.fredoka(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    _getFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: Text(
                    'Gallery',
                    style: GoogleFonts.fredoka(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    _getFromGallarey();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  late File _image;

  void _getFromCamera() {
    ImagePicker()
        .getImage(source: ImageSource.camera)
        .then((PickedFile? image) {
      if (image != null) {
        setState(() {
          _image = File(image.path);
          cropImage();
        });
      }
    });
  }

  void _getFromGallarey() {
    if (Platform.isAndroid) {
      ImagePicker()
          .getImage(source: ImageSource.gallery)
          .then((PickedFile? image) {
        if (image != null) {
          setState(() {
            _image = File(image.path);
            cropImage();
          });
        }
      });
    }
    if (Platform.isIOS) {
      ImagePicker()
          .getImage(source: ImageSource.gallery)
          .then((PickedFile? image) {
        if (image != null) {
          setState(() {
            _image = File(image.path);
            cropImage();
          });
        }
      });
    }
    if (Platform.isMacOS) {
      ImagePicker()
          .getImage(source: ImageSource.gallery)
          .then((PickedFile? image) {
        if (image != null) {
          setState(() {
            _image = File(image.path);
            cropImage();
          });
        }
      });
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        _image = File(croppedFile.path);
        uploadImage();
      });
    }
  }

  Future<void> uploadImage() async {
    getToken();
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.astrocoin.uz/api/user/photo'));
    request.headers.addAll({'Authorization': 'Bearer $token'});
    request.files.add(await http.MultipartFile.fromPath('photo', _image.path));
    var res = await request.send();
    if (res.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('photo');
      prefs.setString('photo', 'https://api.astrocoin.uz/${_image.path}');
      setState(() {
        photo = _image.path;
        getToken();
      });
    }
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
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(238, 238, 238, 100),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0), // here the desired height
          child: AppBar(
            backgroundColor: const Color.fromRGBO(33, 158, 188, 10),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: size * 0.28,
                child: Column(
                  children: [
                    SizedBox(
                      height: size * 0.018,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              customFullScreenDialog(
                                  context,
                                  PhotoView(
                                    imageProvider: NetworkImage(
                                        'https://api.astrocoin.uz/$photo'),
                                  ));
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: MediaQuery.of(context).size.width * 0.16,
                              backgroundImage: NetworkImage(
                                  'https://api.astrocoin.uz/$photo'),
                            ),
                          ),
                          Positioned(
                            bottom: -0,
                            right: -0,
                            child: Center(
                              child: Container(
                                height: size * 0.05,
                                width: size * 0.05,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/svgs/camweb.svg',
                                  ),
                                  onPressed: () {
                                    showImageDialog(context);
                                    //uploadImage();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size * 0.005,
                    ),
                    Row(
                      children: [
                        const Expanded(child: Text('')),
                        Text(
                          '$name $lastname',
                          style: GoogleFonts.fredoka(
                            fontSize: size * 0.029,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: size * 0.01,
                        ),
                        if (verify == 1)
                          Icon(
                            Icons.verified,
                            color: Colors.deepPurpleAccent,
                            size: size * 0.030,
                          ),
                        const Expanded(child: Text('')),
                      ],
                    ),
                    SizedBox(
                      height: size * 0.0009,
                    ),
                    Text(
                      email,
                      style: GoogleFonts.fredoka(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: size * 0.005,
                    ),
                  ],
                )),
            SizedBox(
              height: size * 0.6,
              child: ListView(
                children: [
                  Center(
                    child: Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  isDismissible: true,
                                  enableDrag: false,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => Container(
                                        height: size * 0.92,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: rankPage(),
                                      ));
                            },
                            child: Container(
                              width: sizeweight * 0.9,
                              height: size * 0.06,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: sizeweight * 0.04,
                                    ),
                                    SvgPicture.asset(
                                      'assets/svgs/iconrank.svg',
                                    ),
                                    SizedBox(
                                      width: sizeweight * 0.02,
                                    ),
                                    Text(
                                      'Student Ranks',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size * 0.012,
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  isDismissible: true,
                                  enableDrag: false,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => Container(
                                        height: size * 0.92,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: storePage(),
                                      ));
                            },
                            child: Container(
                              width: sizeweight * 0.9,
                              height: size * 0.06,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: sizeweight * 0.04,
                                    ),
                                    SvgPicture.asset(
                                      'assets/svgs/iconstore.svg',
                                    ),
                                    SizedBox(
                                      width: sizeweight * 0.02,
                                    ),
                                    Text(
                                      'Astrum Store',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.012,
                          ),
                          Wrap(children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                    },
                                    child: SizedBox(
                                      child: SizedBox(
                                        width: sizeweight * 0.9,
                                        height: size * 0.06,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              width: sizeweight * 0.04,
                                            ),
                                            SvgPicture.asset(
                                              'assets/svgs/usersec.svg',
                                            ),
                                            SizedBox(
                                              width: sizeweight * 0.02,
                                            ),
                                            Text(
                                              qwasar,
                                              style: GoogleFonts.fredoka(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        1000,
                                    child: const Divider(
                                      thickness: 2,
                                      color: Color.fromRGBO(241, 241, 241, 10),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                    },
                                    child: SizedBox(
                                      width: sizeweight * 0.9,
                                      height: size * 0.06,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            width: sizeweight * 0.04,
                                          ),
                                          SvgPicture.asset(
                                            'assets/svgs/stackicon.svg',
                                          ),
                                          SizedBox(
                                            width: sizeweight * 0.02,
                                          ),
                                          Text(
                                            stack,
                                            style: GoogleFonts.fredoka(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        1000,
                                    child: const Divider(
                                      thickness: 2,
                                      color: Color.fromRGBO(241, 241, 241, 10),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      Clipboard.setData(ClipboardData(text: wallet));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Copied to Clipboard'),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                          duration: Duration(milliseconds: 1700),
                                          backgroundColor: Colors.deepPurpleAccent,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      width: sizeweight * 0.9,
                                      height: size * 0.06,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            width: sizeweight * 0.04,
                                          ),
                                          SvgPicture.asset(
                                            'assets/svgs/cashback.svg',
                                          ),
                                          SizedBox(
                                            width: sizeweight * 0.02,
                                          ),
                                          Text(
                                            wallet,
                                            style: GoogleFonts.fredoka(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.012,
                          ),
                          Wrap(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    GestureDetector(
                                        onTap: () {
                                          HapticFeedback.lightImpact();
                                          showModalBottomSheet<void>(
                                              context: context,
                                              isScrollControlled: true,
                                              isDismissible: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (context) => Container(
                                                    height: size * 0.9,
                                                    width: sizeweight * 0.9,
                                                    decoration: const BoxDecoration(
                                                      color: Color.fromRGBO(241, 241, 241, 10),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: changePassPage(),
                                                  ));
                                        },
                                        child: SizedBox(
                                          width: sizeweight * 0.9,
                                          height: size * 0.06,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: sizeweight * 0.04,
                                              ),
                                              SvgPicture.asset(
                                                'assets/svgs/chpass.svg',
                                              ),
                                              SizedBox(
                                                width: sizeweight * 0.02,
                                              ),
                                              Text(
                                                'Change Password',
                                                style: GoogleFonts.fredoka(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1000,
                                      child: const Divider(
                                        thickness: 2,
                                        color:
                                            Color.fromRGBO(241, 241, 241, 10),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        showModalBottomSheet<void>(
                                          context: context,
                                          isScrollControlled: true,
                                          isDismissible: true,
                                          //enableDrag: false,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) =>
                                              Container(
                                            height: size * 0.9,
                                            width: sizeweight * 0.9,
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  241, 241, 241, 10),
                                              borderRadius:
                                                  BorderRadius.only(
                                                topLeft:
                                                    Radius.circular(10),
                                                topRight:
                                                    Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                              ),
                                            ),
                                            child:  const AppPassCode(),
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        height: size * 0.06,
                                        width: sizeweight * 0.9,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              width: sizeweight * 0.04,
                                            ),
                                            SvgPicture.asset(
                                              'assets/svgs/apass.svg',
                                            ),
                                            SizedBox(
                                              width: sizeweight * 0.02,
                                            ),
                                            Text(
                                              'App Password',
                                              style: GoogleFonts.fredoka(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.012,
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.vibrate();
                              logout();
                            },
                            child: Container(
                              width: sizeweight * 0.9,
                              height: size * 0.06,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: sizeweight * 0.05,
                                    ),
                                    SvgPicture.asset(
                                      'assets/svgs/logout.svg',
                                    ),
                                    SizedBox(
                                      width: sizeweight * 0.02,
                                    ),
                                    Text(
                                      'Log Out',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
        body: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                    width: size * 0.98,
                    height: sizeweight * 0.28,
                    child: Row(
                      children: [
                        SizedBox(
                          width: sizeweight * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$name $lastname',
                              style: GoogleFonts.fredoka(
                                fontSize: size * 0.03,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '$email',
                              style: GoogleFonts.fredoka(
                                fontSize: size * 0.021,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: size * 0.01,
                        ),
                        if (verify == 1)
                          Icon(
                            Icons.verified,
                            color: Colors.deepPurpleAccent,
                            size: size * 0.030,
                          ),
                        const Expanded(child: SizedBox()),
                        SizedBox(
                          height: size * 0.1,
                          width: size * 0.1,
                          child: Center(
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    customFullScreenDialog(
                                        context,
                                        PhotoView(
                                          imageProvider: NetworkImage(
                                              'https://api.astrocoin.uz/$photo'),
                                        ));
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: MediaQuery.of(context).size.width * 0.5,
                                    backgroundImage: NetworkImage(
                                        'https://api.astrocoin.uz/$photo'),
                                  ),
                                ),
                                Positioned(
                                    bottom: -3,
                                    right: -3,
                                    child: SizedBox(
                                      height: size * 0.04,
                                      width: size * 0.04,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        child: IconButton(
                                          icon: SvgPicture.asset(
                                            'assets/svgs/camweb.svg',
                                            height: size * 0.1,
                                            width: size * 0.1,
                                          ),
                                          onPressed: () {
                                            showImageDialog(context);
                                            //uploadImage();
                                          },
                                        ),
                                      ),
                                    ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: sizeweight * 0.05,
                        ),
                      ],
                    ),
                ),
                SizedBox(
                  width: size * 0.98,
                  height: sizeweight * 0.5,
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: size * 0.02,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: sizeweight * 0.05,
                              ),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  showModalBottomSheet<void>(
                                      context: context,
                                      isScrollControlled: true,
                                      isDismissible: true,
                                      enableDrag: false,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => Container(
                                        height: size * 0.8,
                                        width: size * 0.98,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: rankPage(),
                                      ));
                                },
                                child: Container(
                                  width: size * 0.44,
                                  height: size * 0.06,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: sizeweight * 0.04,
                                        ),
                                        SvgPicture.asset(
                                          'assets/svgs/iconrank.svg',
                                        ),
                                        SizedBox(
                                          width: sizeweight * 0.02,
                                        ),
                                        Text(
                                          'Student Ranks',
                                          style: GoogleFonts.fredoka(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  showModalBottomSheet<void>(
                                      context: context,
                                      isScrollControlled: true,
                                      isDismissible: true,
                                      enableDrag: false,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => Container(
                                        height: size * 0.8,
                                        width: size * 0.98,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: storePage(),
                                      ));
                                },
                                child: Container(
                                  width: size * 0.44,
                                  height: size * 0.06,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: sizeweight * 0.04,
                                        ),
                                        SvgPicture.asset(
                                          'assets/svgs/iconstore.svg',
                                        ),
                                        SizedBox(
                                          width: sizeweight * 0.02,
                                        ),
                                        Text(
                                          'Astrum Store',
                                          style: GoogleFonts.fredoka(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: sizeweight * 0.05,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size * 0.01,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: sizeweight * 0.05,
                              ),
                              Wrap(
                                children: [
                                  Container(
                                    width: size * 0.44,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                            onTap: () {
                                              HapticFeedback.lightImpact();
                                              showModalBottomSheet<void>(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  isDismissible: true,
                                                  backgroundColor: Colors.transparent,
                                                  builder: (context) => Container(
                                                    height: size * 0.9,
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    decoration:
                                                    const BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          241, 241, 241, 10),
                                                      borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                        Radius.circular(10),
                                                        topRight:
                                                        Radius.circular(10),
                                                        bottomLeft:
                                                        Radius.circular(10),
                                                        bottomRight:
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: changePassPage(),
                                                  ));
                                            },
                                            child: SizedBox(
                                              width: sizeweight * 0.9,
                                              height: size * 0.06,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: sizeweight * 0.04,
                                                  ),
                                                  SvgPicture.asset(
                                                    'assets/svgs/chpass.svg',
                                                  ),
                                                  SizedBox(
                                                    width: sizeweight * 0.02,
                                                  ),
                                                  Text(
                                                    'Change Password',
                                                    style: GoogleFonts.fredoka(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height /
                                              1000,
                                          child: const Divider(
                                            thickness: 2,
                                            color: Color.fromRGBO(241, 241, 241, 10),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            HapticFeedback.lightImpact();
                                            showModalBottomSheet<void>(
                                              context: context,
                                              isScrollControlled: true,
                                              isDismissible: true,
                                              backgroundColor: Colors.transparent,
                                              builder: (context) =>
                                                  Container(
                                                    height: size * 0.9,
                                                    width: size * 0.98,
                                                    decoration:
                                                    const BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          241, 241, 241, 10),
                                                      borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                        Radius.circular(10),
                                                        topRight:
                                                        Radius.circular(10),
                                                        bottomLeft:
                                                        Radius.circular(10),
                                                        bottomRight:
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: const AppPassCode(),
                                                  ),
                                            );
                                          },
                                          child: SizedBox(
                                            height: size * 0.06,
                                            width: sizeweight * 0.9,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: sizeweight * 0.04,
                                                ),
                                                SvgPicture.asset(
                                                  'assets/svgs/apass.svg',
                                                ),
                                                SizedBox(
                                                  width: sizeweight * 0.02,
                                                ),
                                                Text(
                                                  'App Password',
                                                  style: GoogleFonts.fredoka(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height /
                                              1000,
                                          child: const Divider(
                                            thickness: 2,
                                            color: Color.fromRGBO(241, 241, 241, 10),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            HapticFeedback.vibrate();
                                            logout();
                                          },
                                          child: Container(
                                            width: sizeweight * 0.9,
                                            height: size * 0.06,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                                bottomRight: Radius.circular(10),
                                              ),
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: sizeweight * 0.05,
                                                  ),
                                                  SvgPicture.asset(
                                                    'assets/svgs/logout.svg',
                                                  ),
                                                  SizedBox(
                                                    width: sizeweight * 0.02,
                                                  ),
                                                  Text(
                                                    'Log Out',
                                                    style: GoogleFonts.fredoka(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Expanded(child: SizedBox()),
                              Wrap(children: <Widget>[
                                Container(
                                  width: size * 0.44,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          HapticFeedback.lightImpact();
                                        },
                                        child: SizedBox(
                                          child: SizedBox(
                                            width: sizeweight * 0.9,
                                            height: size * 0.06,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: sizeweight * 0.04,
                                                ),
                                                SvgPicture.asset(
                                                  'assets/svgs/usersec.svg',
                                                ),
                                                SizedBox(
                                                  width: sizeweight * 0.02,
                                                ),
                                                Text(
                                                  qwasar,
                                                  style: GoogleFonts.fredoka(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                        MediaQuery.of(context).size.height / 1000,
                                        child: const Divider(
                                          thickness: 2,
                                          color: Color.fromRGBO(241, 241, 241, 10),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          HapticFeedback.lightImpact();
                                        },
                                        child: SizedBox(
                                          width: sizeweight * 0.9,
                                          height: size * 0.06,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: sizeweight * 0.04,
                                              ),
                                              SvgPicture.asset(
                                                'assets/svgs/stackicon.svg',
                                              ),
                                              SizedBox(
                                                width: sizeweight * 0.02,
                                              ),
                                              Text(
                                                stack,
                                                style: GoogleFonts.fredoka(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                        MediaQuery.of(context).size.height / 1000,
                                        child: const Divider(
                                          thickness: 2,
                                          color: Color.fromRGBO(241, 241, 241, 10),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          HapticFeedback.lightImpact();
                                          Clipboard.setData(
                                              ClipboardData(text: wallet));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            backgroundColor: Colors.deepPurpleAccent,
                                            content: Text('Copied to Clipboard'),
                                          ));
                                        },
                                        child: SizedBox(
                                          width: sizeweight * 0.9,
                                          height: size * 0.06,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: sizeweight * 0.04,
                                              ),
                                              SvgPicture.asset(
                                                'assets/svgs/cashback.svg',
                                              ),
                                              SizedBox(
                                                width: sizeweight * 0.02,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  wallet,
                                                  style: GoogleFonts.fredoka(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                              SizedBox(
                                width: sizeweight * 0.05,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Future<void> logout() async {
    getToken();
    final response = await http
        .post(Uri.parse('https://api.astrocoin.uz/api/logout'), headers: {
      'Authorization': 'Bearer $token',
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Encoding.getByName("utf-8");
    if (response.statusCode == 200) {
      prefs.remove('token');
      prefs.remove('name');
      prefs.remove('lastname');
      prefs.remove('qwasar');
      prefs.remove('email');
      prefs.remove('number');
      prefs.remove('stack');
      prefs.remove('role');
      prefs.remove('status');
      prefs.remove('photo');
      prefs.remove('balance');
      prefs.remove('wallet');
      prefs.setString('password', '');
      prefs.remove('password');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      prefs.setString('token', '');
      prefs.setString('name', '');
      prefs.setString('lastname', '');
      prefs.setString('qwasar', '');
      prefs.setString('email', '');
      prefs.setString('number', '');
      prefs.setString('stack', '');
      prefs.setString('role', '');
      prefs.setString('status', '');
      prefs.setString('photo', '');
      prefs.setString('balance', '');
      prefs.setString('wallet', '');
      prefs.setString('password', '');
      prefs.remove('password');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false);
    }
  }
}
