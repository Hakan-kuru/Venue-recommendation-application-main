import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rive_animation/screens/onboding/onboding_screen.dart';
import 'package:rive_animation/constants.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(411.4, 820.6),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Instagram',
              theme: ThemeData(
                scaffoldBackgroundColor: Color(0xFFF0F4F8),
                primaryColor: Color(0xFF48BFE3),

                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.white,
                  errorStyle: TextStyle(height: 0),
                  border: defaultInputBorder,
                  enabledBorder: defaultInputBorder,
                  focusedBorder: defaultInputBorder,
                  errorBorder: defaultInputBorder,
                ),
              ),
              home: const OnboardingScreen(),
            ));
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFF0F4F8),
    width: 1,
  ),
);
