import 'dart:convert';
import 'package:astro_coin_uz/components/qr_view.dart';
import 'package:astro_coin_uz/components/send_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_list_model.dart';

class ComUserSearch extends StatefulWidget {
  const ComUserSearch({Key? key}) : super(key: key);

  @override
  _ComUserSearchState createState() => _ComUserSearchState();
}

class _ComUserSearchState extends State<ComUserSearch> {
  var token;
  var useerrlist = [];
  var listUser = [];
  late final _usersearch = TextEditingController();

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    getData();
  }

  void customFullScreenDialog(BuildContext context, Widget child) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return Column(
          children: [
            Material(
              color: Colors.black,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: PhotoView(
                  backgroundDecoration:
                      const BoxDecoration(color: Colors.transparent),
                  imageProvider: NetworkImage(
                      'https://api.astrocoin.uz/${useerrlist[0]['image']}'),
                ),
              ),
            ),
          ],
        );
      },
    ));
  }

  Future<void> getData() async {
    useerrlist.clear();
    listUser.clear();
    final response = await http
        .get(Uri.parse("https://api.astrocoin.uz/api/users"), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    Encoding.getByName("utf-8");
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var i = 0; i < data.length; i++) {
        useerrlist.add(UserList(
          id: data[i]['id'] ?? '',
          name: data[i]['name'] ?? '',
          last_name: data[i]['last_name'] ?? '',
          stack: data[i]['stack'] ?? '',
          photo: data[i]['photo'] ?? '',
          qwasar: data[i]['qwasar'] ?? '',
          status: data[i]['status'] ?? '',
          verify: data[i]['verify'] ?? 0,
          balance: data[i]['balance'] ?? 0,
          wallet: data[i]['wallet'] ?? '',
        ));
      }
      setState(() {
        useerrlist = useerrlist;
        listUser = useerrlist;
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
    _usersearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _usersearch,
                        style: GoogleFonts.fredoka(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          hintText: 'Search',
                          hintStyle: GoogleFonts.fredoka(
                            fontSize: 16,
                            decoration: TextDecoration.none,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            useerrlist = listUser.where((element) {
                              return element.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                                  element.last_name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.stack
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.qwasar
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.verify
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase());
                            }).toList();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.786,
            child: ListView.builder(
              itemCount: useerrlist.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    if (useerrlist[index].photo == '')
                      Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.08,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => Container(
                                  height: MediaQuery.of(context).size.height * 0.85,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(241, 241, 241, 8),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.02,
                                      ),
                                      SvgPicture.asset(
                                        'assets/svgs/usericon.svg',
                                        height: MediaQuery.of(context).size.height * 0.2,
                                        width: MediaQuery.of(context).size.width * 0.3,
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.6,
                                        child: ListView(
                                          children: [
                                            Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                      70,
                                                ),
                                                Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        '${useerrlist[index].name} ${useerrlist[index].last_name}',
                                                        style: GoogleFonts.fredoka(
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      if (useerrlist[index].verify == 1)
                                                        const Icon(
                                                          Icons.verified,
                                                          size: 20,
                                                          color: Colors
                                                              .deepPurpleAccent,
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                      110,
                                                ),
                                                Text(
                                                  '${useerrlist[index].stack}',
                                                  style: GoogleFonts.fredoka(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                      20,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    HapticFeedback.lightImpact();
                                                    Navigator.pop(context);
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled:
                                                      true,
                                                      backgroundColor:
                                                      Colors
                                                          .transparent,
                                                      builder: (context) =>
                                                          Container(
                                                            height: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .height *
                                                                0.75,
                                                            decoration:
                                                            const BoxDecoration(
                                                              color: Color
                                                                  .fromRGBO(
                                                                  241,
                                                                  241,
                                                                  241,
                                                                  20),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                    15.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                    15.0),
                                                              ),
                                                            ),
                                                            child: SendSheet(
                                                              wallet:
                                                              useerrlist[
                                                              index]
                                                                  .wallet,
                                                            ),
                                                          ),
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 2),
                                                        borderRadius:
                                                        BorderRadius.circular(10),
                                                      ),
                                                      child: Row(
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height:
                                                            MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                                18,
                                                            child: SvgPicture.asset(
                                                              'assets/svgs/sendcoin.svg',
                                                              height: 44,
                                                              width: 44,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Send Coin',
                                                            style: GoogleFonts.fredoka(
                                                              fontSize: 16,
                                                              color: Colors.black,
                                                              fontWeight:
                                                              FontWeight.w400,),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                      40,
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .height /
                                                                  17,
                                                              child:
                                                              SvgPicture.asset(
                                                                'assets/svgs/userdoll.svg',
                                                                //fit: BoxFit.cover,
                                                                height: 44,
                                                                width: 44,
                                                              ),
                                                            ),
                                                            Text('${useerrlist[index].balance} ASC',
                                                                style:
                                                                GoogleFonts
                                                                    .fredoka(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                )),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .height /
                                                                  40,
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(
                                                          //height: 20,
                                                          thickness: 5,
                                                          //indent: 20,
                                                          //endIndent: 0,
                                                          color: Color.fromRGBO(
                                                              241, 241, 241, 20),
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .height /
                                                                  17,
                                                              child:
                                                              SvgPicture.asset(
                                                                'assets/svgs/usersec.svg',
                                                                height: 44,
                                                                width: 44,
                                                              ),
                                                            ),
                                                            TextButton(
                                                                onPressed: () {},
                                                                child: SizedBox(
                                                                  child: Text(
                                                                    '${useerrlist[index].qwasar}',
                                                                    style:
                                                                    GoogleFonts
                                                                        .fredoka(
                                                                      fontSize: 16,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                    ),
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                        const Divider(
                                                          //height: 20,
                                                          thickness: 5,
                                                          //indent: 20,
                                                          //endIndent: 0,
                                                          color: Color.fromRGBO(
                                                              241, 241, 241, 20),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            HapticFeedback.lightImpact();
                                                            Navigator.pop(
                                                                context);
                                                            showModalBottomSheet(
                                                              context: context,
                                                              isScrollControlled:
                                                              true,
                                                              backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                              builder:
                                                                  (context) =>
                                                                  Container(
                                                                    height: MediaQuery.of(
                                                                        context)
                                                                        .size
                                                                        .height *
                                                                        0.75,
                                                                    decoration:
                                                                    const BoxDecoration(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                          241,
                                                                          241,
                                                                          241,
                                                                          20),
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                        topLeft: Radius
                                                                            .circular(
                                                                            15.0),
                                                                        topRight: Radius
                                                                            .circular(
                                                                            15.0),
                                                                      ),
                                                                    ),
                                                                    child: QrSheet(
                                                                      wallet: useerrlist[
                                                                      index]
                                                                          .wallet,
                                                                    ),
                                                                  ),
                                                            );
                                                          },
                                                          onLongPress: (){
                                                            Clipboard.setData(
                                                                ClipboardData(
                                                                    text: useerrlist[
                                                                    index]
                                                                        .wallet));
                                                            ScaffoldMessenger
                                                                .of(context)
                                                                .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                    'Copied to Clipboard',
                                                                    style:
                                                                    GoogleFonts
                                                                        .fredoka(
                                                                      fontSize: 16,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                    ),
                                                                  ),
                                                                ));
                                                            HapticFeedback.vibrate();
                                                          },
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                    context)
                                                                    .size
                                                                    .height /
                                                                    17,
                                                                child: SvgPicture.asset(
                                                                  'assets/svgs/cashback.svg',
                                                                  height: 44,
                                                                  width: 44,
                                                                ),
                                                              ),
                                                              Flexible(
                                                                child: Text(
                                                                  '${useerrlist[index].wallet}',
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                  style: GoogleFonts
                                                                      .fredoka(
                                                                    fontSize: 13,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            title: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svgs/usericon.svg',
                                  height: MediaQuery.of(context).size.height * 0.055,
                                  width: MediaQuery.of(context).size.width * 0.1,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.05,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          useerrlist[index].name,
                                          style: GoogleFonts.fredoka(
                                            fontSize: 17,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        if (useerrlist[index].verify == 1)
                                          const Icon(
                                            Icons.verified,
                                            size: 20,
                                            color: Colors.deepPurpleAccent,
                                          ),
                                      ],
                                    ),
                                    Text(
                                      '${useerrlist[index].balance} ACK',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                      ),
                    if (useerrlist[index].photo != '')
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: ListTile(
                          onTap: (){
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Container(
                                height: MediaQuery.of(context).size.height * 0.85,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(241, 241, 241, 8),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                      MediaQuery.of(context).size.height / 35,
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 5,
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(PageRouteBuilder(
                                            opaque: false,
                                            pageBuilder:
                                                (BuildContext context, _, __) {
                                              return Material(
                                                color: Colors.black,
                                                child: InkWell(
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                  child: PhotoView(
                                                    backgroundDecoration:
                                                    const BoxDecoration(
                                                        color: Colors
                                                            .transparent),
                                                    imageProvider: //NetworkImage user image
                                                    NetworkImage(
                                                        'https://api.astrocoin.uz/${useerrlist[index].photo}'),
                                                  ),
                                                ),
                                              );
                                            },
                                          ));
                                        },
                                        child: CircleAvatar(
                                          radius:
                                          MediaQuery.of(context).size.height /
                                              10,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(
                                            'https://api.astrocoin.uz/${useerrlist[index].photo}',
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.6,
                                      child: ListView(
                                        children: [
                                          Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    70,
                                              ),
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${useerrlist[index].name} ${useerrlist[index].last_name}',
                                                      style: GoogleFonts.fredoka(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight.w400,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    if (useerrlist[index]
                                                        .verify ==
                                                        1)
                                                      const Icon(
                                                        Icons.verified,
                                                        size: 20,
                                                        color: Colors
                                                            .deepPurpleAccent,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    110,
                                              ),
                                              Text(
                                                '${useerrlist[index].stack}',
                                                style: GoogleFonts.fredoka(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    20,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  HapticFeedback.lightImpact();
                                                  Navigator.pop(context);
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled:
                                                    true,
                                                    backgroundColor:
                                                    Colors
                                                        .transparent,
                                                    builder: (context) =>
                                                        Container(
                                                          height: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .height *
                                                              0.75,
                                                          decoration:
                                                          const BoxDecoration(
                                                            color: Color
                                                                .fromRGBO(
                                                                241,
                                                                241,
                                                                241,
                                                                20),
                                                            borderRadius:
                                                            BorderRadius
                                                                .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                  15.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                  15.0),
                                                            ),
                                                          ),
                                                          child: SendSheet(
                                                            wallet:
                                                            useerrlist[
                                                            index]
                                                                .wallet,
                                                          ),
                                                        ),
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                              18,
                                                          child: SvgPicture.asset(
                                                            'assets/svgs/sendcoin.svg',
                                                            height: 44,
                                                            width: 44,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Send Coin',
                                                          style: GoogleFonts.fredoka(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                            fontWeight:
                                                            FontWeight.w400,),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    40,
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 25.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 2),
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            height: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .height /
                                                                17,
                                                            child:
                                                            SvgPicture.asset(
                                                              'assets/svgs/userdoll.svg',
                                                              //fit: BoxFit.cover,
                                                              height: 44,
                                                              width: 44,
                                                            ),
                                                          ),
                                                          TextButton(
                                                              onPressed: () {},
                                                              child: SizedBox(
                                                                child: Text(
                                                                  '${useerrlist[index].balance} ASC',
                                                                  style:
                                                                  GoogleFonts
                                                                      .fredoka(
                                                                    fontSize: 16,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                  ),
                                                                ),
                                                              )),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .height /
                                                                40,
                                                          ),
                                                        ],
                                                      ),
                                                      const Divider(
                                                        //height: 20,
                                                        thickness: 5,
                                                        //indent: 20,
                                                        //endIndent: 0,
                                                        color: Color.fromRGBO(
                                                            241, 241, 241, 20),
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            height: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .height /
                                                                17,
                                                            child:
                                                            SvgPicture.asset(
                                                              'assets/svgs/usersec.svg',
                                                              height: 44,
                                                              width: 44,
                                                            ),
                                                          ),
                                                          TextButton(
                                                              onPressed: () {},
                                                              child: SizedBox(
                                                                child: Text(
                                                                  '${useerrlist[index].qwasar}',
                                                                  style:
                                                                  GoogleFonts
                                                                      .fredoka(
                                                                    fontSize: 16,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                  ),
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                      const Divider(
                                                        //height: 20,
                                                        thickness: 5,
                                                        //indent: 20,
                                                        //endIndent: 0,
                                                        color: Color.fromRGBO(
                                                            241, 241, 241, 20),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          HapticFeedback.lightImpact();
                                                          Navigator.pop(
                                                              context);
                                                          showModalBottomSheet(
                                                            context: context,
                                                            isScrollControlled:
                                                            true,
                                                            backgroundColor:
                                                            Colors
                                                                .transparent,
                                                            builder:
                                                                (context) =>
                                                                Container(
                                                                  height: MediaQuery.of(
                                                                      context)
                                                                      .size
                                                                      .height *
                                                                      0.75,
                                                                  decoration:
                                                                  const BoxDecoration(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                        241,
                                                                        241,
                                                                        241,
                                                                        20),
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                          15.0),
                                                                      topRight: Radius
                                                                          .circular(
                                                                          15.0),
                                                                    ),
                                                                  ),
                                                                  child: QrSheet(
                                                                    wallet: useerrlist[
                                                                    index]
                                                                        .wallet,
                                                                  ),
                                                                ),
                                                          );
                                                        },
                                                        onLongPress: (){
                                                          Clipboard.setData(
                                                              ClipboardData(
                                                                  text: useerrlist[
                                                                  index]
                                                                      .wallet));
                                                          ScaffoldMessenger
                                                              .of(context)
                                                              .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  'Copied to Clipboard',
                                                                  style:
                                                                  GoogleFonts
                                                                      .fredoka(
                                                                    fontSize: 16,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                  ),
                                                                ),
                                                              ));
                                                          HapticFeedback.vibrate();
                                                        },
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .height /
                                                                  17,
                                                              child: SvgPicture.asset(
                                                                'assets/svgs/cashback.svg',
                                                                height: 44,
                                                                width: 44,
                                                              ),
                                                            ),
                                                            Flexible(
                                                              child: Text(
                                                                '${useerrlist[index].wallet}',
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                                style: GoogleFonts
                                                                    .fredoka(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          title: Row(
                            children: [
                              if (useerrlist[index].photo == null)
                                const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20,
                                  backgroundImage:
                                  AssetImage('assets/pngs/astrocoin.png'),
                                ),
                              if (useerrlist[index].photo != null)
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: MediaQuery.of(context).size.height / 35,
                                  backgroundImage: NetworkImage(
                                      'https://api.astrocoin.uz/${useerrlist[index].photo}'),
                                ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(child: Container()),
                                  Row(
                                    children: [
                                      Text(
                                        useerrlist[index].name,
                                        style: GoogleFonts.fredoka(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      if (useerrlist[index].verify == 1)
                                        const Icon(
                                          Icons.verified,
                                          size: 20,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                    ],
                                  ),
                                  Text(
                                    '${useerrlist[index].balance} ACK',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 15,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    const Divider(
                      color: Color.fromRGBO(241, 241, 241, 20),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      );
    }else{
      return Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.13,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _usersearch,
                        style: GoogleFonts.fredoka(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          hintText: 'Search',
                          hintStyle: GoogleFonts.fredoka(
                            fontSize: 16,
                            decoration: TextDecoration.none,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            useerrlist = listUser.where((element) {
                              return element.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                                  element.last_name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.stack
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.qwasar
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.verify
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase());
                            }).toList();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.62,
            child: ListView.builder(
              itemCount: useerrlist.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    if (useerrlist[index].photo == '')
                      Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.13,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => Container(
                                  height: MediaQuery.of(context).size.height * 0.85,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(241, 241, 241, 8),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.02,
                                      ),
                                      SvgPicture.asset(
                                        'assets/svgs/usericon.svg',
                                        height: MediaQuery.of(context).size.height * 0.2,
                                        width: MediaQuery.of(context).size.width * 0.3,
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.6,
                                        child: ListView(
                                          children: [
                                            Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                      70,
                                                ),
                                                Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        '${useerrlist[index].name} ${useerrlist[index].last_name}',
                                                        style: GoogleFonts.fredoka(
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      if (useerrlist[index].verify == 1)
                                                        const Icon(
                                                          Icons.verified,
                                                          size: 20,
                                                          color: Colors
                                                              .deepPurpleAccent,
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                      110,
                                                ),
                                                Text(
                                                  '${useerrlist[index].stack}',
                                                  style: GoogleFonts.fredoka(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                      20,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    HapticFeedback.lightImpact();
                                                    Navigator.pop(context);
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled:
                                                      true,
                                                      backgroundColor:
                                                      Colors
                                                          .transparent,
                                                      builder: (context) =>
                                                          Container(
                                                            height: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .height *
                                                                0.75,
                                                            decoration:
                                                            const BoxDecoration(
                                                              color: Color
                                                                  .fromRGBO(
                                                                  241,
                                                                  241,
                                                                  241,
                                                                  20),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                    15.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                    15.0),
                                                              ),
                                                            ),
                                                            child: SendSheet(
                                                              wallet:
                                                              useerrlist[
                                                              index]
                                                                  .wallet,
                                                            ),
                                                          ),
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 2),
                                                        borderRadius:
                                                        BorderRadius.circular(10),
                                                      ),
                                                      child: Row(
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height:
                                                            MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                                18,
                                                            child: SvgPicture.asset(
                                                              'assets/svgs/sendcoin.svg',
                                                              height: 44,
                                                              width: 44,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Send Coin',
                                                            style: GoogleFonts.fredoka(
                                                              fontSize: 16,
                                                              color: Colors.black,
                                                              fontWeight:
                                                              FontWeight.w400,),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                      40,
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .height /
                                                                  17,
                                                              child:
                                                              SvgPicture.asset(
                                                                'assets/svgs/userdoll.svg',
                                                                //fit: BoxFit.cover,
                                                                height: 44,
                                                                width: 44,
                                                              ),
                                                            ),
                                                            Text('${useerrlist[index].balance} ASC',
                                                                style:
                                                                GoogleFonts
                                                                    .fredoka(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                )),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .height /
                                                                  40,
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(
                                                          //height: 20,
                                                          thickness: 5,
                                                          //indent: 20,
                                                          //endIndent: 0,
                                                          color: Color.fromRGBO(
                                                              241, 241, 241, 20),
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .height /
                                                                  17,
                                                              child:
                                                              SvgPicture.asset(
                                                                'assets/svgs/usersec.svg',
                                                                height: 44,
                                                                width: 44,
                                                              ),
                                                            ),
                                                            TextButton(
                                                                onPressed: () {},
                                                                child: SizedBox(
                                                                  child: Text(
                                                                    '${useerrlist[index].qwasar}',
                                                                    style:
                                                                    GoogleFonts
                                                                        .fredoka(
                                                                      fontSize: 16,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                    ),
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                        const Divider(
                                                          //height: 20,
                                                          thickness: 5,
                                                          //indent: 20,
                                                          //endIndent: 0,
                                                          color: Color.fromRGBO(
                                                              241, 241, 241, 20),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            HapticFeedback.lightImpact();
                                                            Navigator.pop(
                                                                context);
                                                            showModalBottomSheet(
                                                              context: context,
                                                              isScrollControlled:
                                                              true,
                                                              backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                              builder:
                                                                  (context) =>
                                                                  Container(
                                                                    height: MediaQuery.of(
                                                                        context)
                                                                        .size
                                                                        .height *
                                                                        0.75,
                                                                    decoration:
                                                                    const BoxDecoration(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                          241,
                                                                          241,
                                                                          241,
                                                                          20),
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                        topLeft: Radius
                                                                            .circular(
                                                                            15.0),
                                                                        topRight: Radius
                                                                            .circular(
                                                                            15.0),
                                                                      ),
                                                                    ),
                                                                    child: QrSheet(
                                                                      wallet: useerrlist[
                                                                      index]
                                                                          .wallet,
                                                                    ),
                                                                  ),
                                                            );
                                                          },
                                                          onLongPress: (){
                                                            Clipboard.setData(
                                                                ClipboardData(
                                                                    text: useerrlist[
                                                                    index]
                                                                        .wallet));
                                                            ScaffoldMessenger
                                                                .of(context)
                                                                .showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                    'Copied to Clipboard',
                                                                    style:
                                                                    GoogleFonts
                                                                        .fredoka(
                                                                      fontSize: 16,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                    ),
                                                                  ),
                                                                ));
                                                            HapticFeedback.vibrate();
                                                          },
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                    context)
                                                                    .size
                                                                    .height /
                                                                    17,
                                                                child: SvgPicture.asset(
                                                                  'assets/svgs/cashback.svg',
                                                                  height: 44,
                                                                  width: 44,
                                                                ),
                                                              ),
                                                              Flexible(
                                                                child: Text(
                                                                  '${useerrlist[index].wallet}',
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                                  style: GoogleFonts
                                                                      .fredoka(
                                                                    fontSize: 13,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            title: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svgs/usericon.svg',
                                  height: MediaQuery.of(context).size.height * 0.08,
                                  width: MediaQuery.of(context).size.width * 0.15,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.05,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          useerrlist[index].name,
                                          style: GoogleFonts.fredoka(
                                            fontSize: 17,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        if (useerrlist[index].verify == 1)
                                          const Icon(
                                            Icons.verified,
                                            size: 20,
                                            color: Colors.deepPurpleAccent,
                                          ),
                                      ],
                                    ),
                                    Text(
                                      '${useerrlist[index].balance} ACK',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                      ),
                    if (useerrlist[index].photo != '')
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.13,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: ListTile(
                          onTap: (){
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Container(
                                height: MediaQuery.of(context).size.height * 0.85,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(241, 241, 241, 8),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                      MediaQuery.of(context).size.height / 35,
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 5,
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(PageRouteBuilder(
                                            opaque: false,
                                            pageBuilder:
                                                (BuildContext context, _, __) {
                                              return Material(
                                                color: Colors.black,
                                                child: InkWell(
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                  child: PhotoView(
                                                    backgroundDecoration:
                                                    const BoxDecoration(
                                                        color: Colors
                                                            .transparent),
                                                    imageProvider: //NetworkImage user image
                                                    NetworkImage(
                                                        'https://api.astrocoin.uz/${useerrlist[index].photo}'),
                                                  ),
                                                ),
                                              );
                                            },
                                          ));
                                        },
                                        child: CircleAvatar(
                                          radius:
                                          MediaQuery.of(context).size.height /
                                              10,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(
                                            'https://api.astrocoin.uz/${useerrlist[index].photo}',
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.6,
                                      child: ListView(
                                        children: [
                                          Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    70,
                                              ),
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${useerrlist[index].name} ${useerrlist[index].last_name}',
                                                      style: GoogleFonts.fredoka(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight.w400,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    if (useerrlist[index]
                                                        .verify ==
                                                        1)
                                                      const Icon(
                                                        Icons.verified,
                                                        size: 20,
                                                        color: Colors
                                                            .deepPurpleAccent,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    110,
                                              ),
                                              Text(
                                                '${useerrlist[index].stack}',
                                                style: GoogleFonts.fredoka(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    20,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  HapticFeedback.lightImpact();
                                                  Navigator.pop(context);
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled:
                                                    true,
                                                    backgroundColor:
                                                    Colors
                                                        .transparent,
                                                    builder: (context) =>
                                                        Container(
                                                          height: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .height *
                                                              0.75,
                                                          decoration:
                                                          const BoxDecoration(
                                                            color: Color
                                                                .fromRGBO(
                                                                241,
                                                                241,
                                                                241,
                                                                20),
                                                            borderRadius:
                                                            BorderRadius
                                                                .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                  15.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                  15.0),
                                                            ),
                                                          ),
                                                          child: SendSheet(
                                                            wallet:
                                                            useerrlist[
                                                            index]
                                                                .wallet,
                                                          ),
                                                        ),
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                              18,
                                                          child: SvgPicture.asset(
                                                            'assets/svgs/sendcoin.svg',
                                                            height: 44,
                                                            width: 44,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Send Coin',
                                                          style: GoogleFonts.fredoka(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                            fontWeight:
                                                            FontWeight.w400,),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                    40,
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 25.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 2),
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            height: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .height /
                                                                17,
                                                            child:
                                                            SvgPicture.asset(
                                                              'assets/svgs/userdoll.svg',
                                                              //fit: BoxFit.cover,
                                                              height: 44,
                                                              width: 44,
                                                            ),
                                                          ),
                                                          TextButton(
                                                              onPressed: () {},
                                                              child: SizedBox(
                                                                child: Text(
                                                                  '${useerrlist[index].balance} ASC',
                                                                  style:
                                                                  GoogleFonts
                                                                      .fredoka(
                                                                    fontSize: 16,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                  ),
                                                                ),
                                                              )),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .height /
                                                                40,
                                                          ),
                                                        ],
                                                      ),
                                                      const Divider(
                                                        //height: 20,
                                                        thickness: 5,
                                                        //indent: 20,
                                                        //endIndent: 0,
                                                        color: Color.fromRGBO(
                                                            241, 241, 241, 20),
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            height: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .height /
                                                                17,
                                                            child:
                                                            SvgPicture.asset(
                                                              'assets/svgs/usersec.svg',
                                                              height: 44,
                                                              width: 44,
                                                            ),
                                                          ),
                                                          TextButton(
                                                              onPressed: () {},
                                                              child: SizedBox(
                                                                child: Text(
                                                                  '${useerrlist[index].qwasar}',
                                                                  style:
                                                                  GoogleFonts
                                                                      .fredoka(
                                                                    fontSize: 16,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                  ),
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                      const Divider(
                                                        //height: 20,
                                                        thickness: 5,
                                                        //indent: 20,
                                                        //endIndent: 0,
                                                        color: Color.fromRGBO(
                                                            241, 241, 241, 20),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          HapticFeedback.lightImpact();
                                                          Navigator.pop(
                                                              context);
                                                          showModalBottomSheet(
                                                            context: context,
                                                            isScrollControlled:
                                                            true,
                                                            backgroundColor:
                                                            Colors
                                                                .transparent,
                                                            builder:
                                                                (context) =>
                                                                Container(
                                                                  height: MediaQuery.of(
                                                                      context)
                                                                      .size
                                                                      .height *
                                                                      0.75,
                                                                  decoration:
                                                                  const BoxDecoration(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                        241,
                                                                        241,
                                                                        241,
                                                                        20),
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                          15.0),
                                                                      topRight: Radius
                                                                          .circular(
                                                                          15.0),
                                                                    ),
                                                                  ),
                                                                  child: QrSheet(
                                                                    wallet: useerrlist[
                                                                    index]
                                                                        .wallet,
                                                                  ),
                                                                ),
                                                          );
                                                        },
                                                        onLongPress: (){
                                                          Clipboard.setData(
                                                              ClipboardData(
                                                                  text: useerrlist[
                                                                  index]
                                                                      .wallet));
                                                          ScaffoldMessenger
                                                              .of(context)
                                                              .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  'Copied to Clipboard',
                                                                  style:
                                                                  GoogleFonts
                                                                      .fredoka(
                                                                    fontSize: 16,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                  ),
                                                                ),
                                                              ));
                                                          HapticFeedback.vibrate();
                                                        },
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .height /
                                                                  17,
                                                              child: SvgPicture.asset(
                                                                'assets/svgs/cashback.svg',
                                                                height: 44,
                                                                width: 44,
                                                              ),
                                                            ),
                                                            Flexible(
                                                              child: Text(
                                                                '${useerrlist[index].wallet}',
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                                style: GoogleFonts
                                                                    .fredoka(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          title: Row(
                            children: [
                              if (useerrlist[index].photo == null)
                                const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20,
                                  backgroundImage:
                                  AssetImage('assets/pngs/astrocoin.png'),
                                ),
                              if (useerrlist[index].photo != null)
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: MediaQuery.of(context).size.height * 0.04,
                                  backgroundImage: NetworkImage(
                                      'https://api.astrocoin.uz/${useerrlist[index].photo}'),
                                ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(child: Container()),
                                  Row(
                                    children: [
                                      Text(
                                        useerrlist[index].name,
                                        style: GoogleFonts.fredoka(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      if (useerrlist[index].verify == 1)
                                        const Icon(
                                          Icons.verified,
                                          size: 20,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                    ],
                                  ),
                                  Text(
                                    '${useerrlist[index].balance} ACK',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 15,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    const Divider(
                      color: Color.fromRGBO(241, 241, 241, 20),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      );
    }

  }
}