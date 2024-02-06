import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:permissions/phonelogs_screen.dart';
import 'package:oktoast/oktoast.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: 'Flutter Permissions',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(title: 'Flutter Permissions'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  openPhoneLogs() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhonelogsScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkPermissionPhoneLogs();
  }

  bool isGranted = false;

  checkPermissionPhoneLogs() async {
    if (await Permission.phone.request().isPermanentlyDenied) {
      isGranted = false;
      showToast(
        "Go to Settings and Provide Phone permission to make a call and view logs.",
        position: ToastPosition.bottom,
      );
    } else if (await Permission.phone.request().isGranted) {
      // openPhoneLogs();
      isGranted = true;
      setState(() {});
    } else {
      isGranted = false;
      showToast("Provide Phone permission to make a call and view logs.",
          position: ToastPosition.bottom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isGranted
        ? PhonelogsScreen()
        : Scaffold(
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextButton(
                      onPressed: checkPermissionPhoneLogs,
                      child: Text("Click to give permissions"),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
