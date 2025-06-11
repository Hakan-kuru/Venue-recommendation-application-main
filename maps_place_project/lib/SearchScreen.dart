import 'dart:ui';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';
import 'package:rive_animation/screens/onboding/onboding_screen.dart';
import 'package:rive_animation/constants.dart';
import 'FavoritePlacesScreen.dart';
import 'ResultsScreen.dart';
import 'api.dart';


class SearchScreen extends StatefulWidget {
  final String eposta;
  final String sifre;

  SearchScreen({required this.eposta, required this.sifre});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController cityController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController keywordController = TextEditingController();
  FocusNode districtFocusNode = FocusNode();
  FocusNode keywordFocusNode = FocusNode();
  bool isLoading = false;

  @override
  void dispose() {
    // Dispose focus nodes when they are no longer needed
    districtFocusNode.dispose();
    keywordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColorLight,
        bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          color: secondaryColor,
          backgroundColor: backgroundColorLight,
          animationDuration: const Duration(milliseconds: 300),
          index: 0,
          items: const [
            Icon(
              Icons.search,
              color: Colors.white,
            ),
            Icon(
              Icons.favorite_border_outlined,
              color: myWhite ,//Colors.white,
              size: 23,
            ),
            Icon(Icons.exit_to_app_outlined, color: myWhite/*Colors.white*/),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                break;

              case 1:
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        FavoritePlacesScreen(widget.eposta, widget.sifre)));
                break;
              case 2:
                _showExitDialog(context);
              /*  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const OnboardingScreen())); */
            }
          },
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Mekan Öneri Uygulaması'),
          backgroundColor: secondaryColor, //const Color(0xFFFF6B6B),
        ),
        body: Stack(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    width: MediaQuery.of(context).size.width * 1.7,
                    bottom: 200,
                    left: 100,
                    child: Image.asset('assets/Backgrounds/Spline.png'),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
                    ),
                  ),
                  const RiveAnimation.asset('assets/RiveAssets/shapes.riv'),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
                      child: const SizedBox(),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Container(
                            height: 240,
                            width: 400,
                            decoration: BoxDecoration(
                              color: backgroundColorLight.withOpacity(0.7),
                              //Color(0xFFF0F4F8).withOpacity(0.7),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Container(
                                child: Column(
                                  children: [
                                    buildTextField(
                                      cityController,
                                      'İl',
                                      context,
                                      onSubmitted: (_) {
                                        _changeFocus(
                                            context, districtFocusNode);
                                      },
                                    ),
                                    buildTextField(
                                      districtController,
                                      'Semt',
                                      context,
                                      focusNode: districtFocusNode,
                                      onSubmitted: (_) {
                                        _changeFocus(context, keywordFocusNode);
                                      },
                                    ),
                                    buildTextField(
                                      keywordController,
                                      'Anahtar Kelime',
                                      context,
                                      focusNode: keywordFocusNode,
                                      onSubmitted: (_) {
                                        _performSearch();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        isLoading
                            ? Container(
                                width: 70,
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: CircularProgressIndicator(
                                    color: myWhite, //Colors.white,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      secondaryColor.withOpacity(0.8),
                                      //const Color(0xFFFF6B6B).withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  _performSearch();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      secondaryColor
                                      //Color(0xFFFF6B6B)
                                          .withOpacity(0.9),
                                  minimumSize: Size(140, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                child: Text(
                                  'Ara',
                                  style: GoogleFonts.varela(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String labelText,
    BuildContext context, {
    FocusNode? focusNode,
    ValueChanged<String>? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: backgroundColor2 /*Color(0xFF2D3142)*/),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: backgroundColor2/*const Color(0xFF2D3142)*/),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: backgroundColor2/*const Color(0xFF2D3142)*/),
        ),
        filled: false,
      ),
      style: TextStyle(
        color: Colors.black,
      ),
      focusNode: focusNode,
      onSubmitted: (value) {
        if (onSubmitted != null) {
          onSubmitted(value);
        }
      },
    );
  }

  void _changeFocus(BuildContext context, FocusNode nextFocus) {
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _performSearch() async {
    if (cityController.text.isEmpty ||
        districtController.text.isEmpty ||
        keywordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Uyarı'),
            content: Text('Lütfen tüm alanları doldurun.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Tamam',
                  style: TextStyle(
                    color: secondaryColor, //const Color(0xFFFF6B6B),
                  ),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    List<Place> places = await ApiService.searchPlaces(
      cityController.text,
      districtController.text,
      keywordController.text,
    );

    setState(() {
      isLoading = false;
    });

    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) =>
            ResultsScreen(places, widget.eposta!, widget.sifre!),
      ),
    )
        .then((value) {
      cityController.clear();
      districtController.clear();
      keywordController.clear();
    });
  }

  Future<void> _showExitDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Çıkış Yapmak İstiyor Musunuz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Kapatma işlemi
              },
              child: Text(
                'Hayır',
                style: TextStyle(
                  color: secondaryColor,
                  //color: Color(0xFFFF6B6B),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Kapatma işlemi
                // Burada çıkış işlemleri gerçekleştirilebilir
                // Örneğin: exit(0);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const OnboardingScreen()));
              },
              child: Text(
                'Evet',
                style: TextStyle(
                  color: secondaryColor,
                  // Color(0xFFFF6B6B),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
