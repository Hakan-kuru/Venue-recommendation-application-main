import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive_animation/mongodb.dart';
import 'package:rive_animation/screens/onboding/onboding_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'SearchScreen.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Bunu dosyanın en üstüne ekle
import 'package:rive_animation/constants.dart';

class FavoritePlacesScreen extends StatefulWidget {
  // receive emaşl and password for user fav places authentication
  final String eposta;
  final String sifre;

  FavoritePlacesScreen(this.eposta, this.sifre);

  @override
  State<FavoritePlacesScreen> createState() => _FavoritePlacesScreenState();
}

class _FavoritePlacesScreenState extends State<FavoritePlacesScreen> {
  late Future<List<dynamic>> favoritePlacesFuture;
  // load fav places from db on unit
  @override
  void initState() {
    super.initState();
    favoritePlacesFuture = _loadFavoritePlaces(); // initialize data loading
  }

  //build list weiv of fav palaces
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit( //reponsive screen setup
      designSize: Size(411.4, 820.6),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => WillPopScope(
        onWillPop: () async {
          // Geri tuşu kullanımını kontrol etmek istediğiniz koşulları burada belirtin.
          // Eğer geri tuşunu devre dışı bırakmak istiyorsanız `false` döndürün.
          return false;
        },
        child: Scaffold(
          backgroundColor: Color(0xFFF0F4F8),
          bottomNavigationBar: CurvedNavigationBar(
            height: 55,
            color: Color(0xFFFF6B6B),
            backgroundColor: Color(0xFFF0F4F8),
            animationDuration: const Duration(milliseconds: 300),
            index: 1,
            items: const [
              Icon(
                Icons.search,
                color: Colors.white,
              ),
              Icon(
                Icons.favorite_border_outlined,
                color: Colors.white,
                size: 23,
              ),
              Icon(Icons.exit_to_app_outlined, color: Colors.white),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchScreen(
                          eposta: widget.eposta, sifre: widget.sifre)));
                  break;
                case 1:
                  // Handle messenger icon tap
                  print('Messenger icon tapped');
                  break;
                case 2:
                  _showExitDialog(context);
              }
            },
          ),
          appBar: AppBar(
            title: Text('Favori Mekanlar'),
            automaticallyImplyLeading: false,
            backgroundColor: secondaryColor, //const Color(0xFFFF6B6B),
          ),
          body: FutureBuilder<List<dynamic>>(
            future: favoritePlacesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(secondaryColor /*const Color(0xFFFF6B6B)*/),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Hata: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('Favori mekan bulunamadı.'),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    int placeNumber = index + 1;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: backgroundColorLight, //Color(0xFFF0F4F8),
                        ),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$placeNumber. ${_truncateString(snapshot.data![index]["name"], 34)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '⭐ ${snapshot.data![index]['rating'].toString()}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            _showDetailsDialog(context, snapshot.data![index]);
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  //Helper method to shorten long text with ellipsis
  String _truncateString(String text, int maxLength) {

    if (text.length <= maxLength) {
      return text;
    }
    return text.substring(0, maxLength) + '...';
  }

  //show dialog info dialog for selected palaces
  void _showDetailsDialog(BuildContext context, Map<String, dynamic> mapListe) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    mapListe['name'].toString(),
                    style: TextStyle(
                      color: secondaryColor, //const Color(0xFFFF6B6B),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: mapListe['address'].toString().length < 70
                                ? 22
                                : mapListe['address'].toString().length < 100
                                    ? 41
                                    : 60),
                        child: Text(
                          'Adres: ',
                          style:
                              GoogleFonts.varela(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          mapListe['address'].toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      Text('Telefon: ',
                          style:
                              GoogleFonts.varela(fontWeight: FontWeight.bold)),
                      Text(
                        mapListe['phone'].toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        'Websitesi: ',
                        style: GoogleFonts.varela(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: GestureDetector(
                          onTap: () async {
                            if (mapListe['website'].toString() !=
                                'Bulunamadı') {
                              await launch(mapListe['website'].toString());
                            }
                          },
                          child: Text(
                            mapListe['website'].toString() != 'Bulunamadı'
                                ? 'Ziyaret et'
                                : 'Bulunamadı',
                            style: TextStyle(
                              color:
                                  mapListe['website'].toString() != 'Bulunamadı'
                                      ? turkuaz//Color(0xFF48BFE3)
                                      : Colors.black,
                              decoration:
                                  mapListe['website'].toString() != 'Bulunamadı'
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      Text(
                        'Çalışma Saatleri',
                        style: GoogleFonts.varela(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        _buildWorkingHours(mapListe['weekday_text'].toString()),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width > 400
                            ? 260.w
                            : 235.w),
                    child: Row(
                      children: [
                        Text(
                          'Kapat',
                          style: TextStyle(
                              color: secondaryColor //const Color(0xFFFF6B6B)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //show exit dialog
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
                  color: Color(0xFFFF6B6B),
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
                  color: Color(0xFFFF6B6B),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  //WHat is that????????????
  List<Widget> _buildWorkingHours(String workingHoursString) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final turkishDays = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar',
    ];

    workingHoursString =
        workingHoursString.replaceAll('[', '').replaceAll(']', '');

    final workingHoursList = workingHoursString.split(', ');

    if (workingHoursList.isEmpty) {
      return [Text('Çalışma saatleri bulunamadı.')];
    }

    return workingHoursList.map((workingHour) {
      final components = workingHour.split(': ');

      if (components.length >= 2) {
        final dayIndex = days.indexOf(components[0]);
        final hours = convertToTurkishStatus(components[1]);
        return Text('${turkishDays[dayIndex]}: $hours');
      } else {
        return Text('Çalışma Saati Bulunamadı');
      }
    }).toList();
  }

  String convertToTurkishStatus(String status) {
    status = status.toLowerCase().replaceAll('hours', 'saat');
    status = status.replaceAll('open', 'Açık:');
    status = status.replaceAll('closed', 'Kapalı');

    return status;
  }

  Future<List<dynamic>> FavoriYerler(
      String url, String tableName, String eposta, String sifre) {
    return MongoDatabase.SelectFavoritePlace(url, tableName, eposta, sifre);
  }

  Future<List<dynamic>> _loadFavoritePlaces() async {
    try {
      final List<dynamic>? favoritePlaces = await FavoriYerler(
        "mongodb+srv://Hakan:Hakanpassword@users.y0io5iq.mongodb.net/Users?retryWrites=true&w=majority&appName=Users",
        "Place",
        widget.eposta,
        widget.sifre,
      );

      if (favoritePlaces != null) {
        Fluttertoast.showToast(
          msg: "olduuu",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xFFFF6B6B),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return favoritePlaces;
      } else {
        Fluttertoast.showToast(
          msg: "Favori mekanlar alınamadı.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Color(0xFFFF6B6B),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return [];
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Hataaa $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xFFFF6B6B),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return [];
    }
  }
}

