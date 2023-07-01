import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tools_markdown/pages/home_list_page.dart';
import 'pages/home_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'state/root_state.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

void main() => runApp(MyApp());

var dataList = [];
final JPush jpush = JPush();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  void initState() {
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<RootState>(
      store: rootStore,
      child: StoreConnector<RootState, ThemeState>(
        converter: ThemeState.storeConverter,
        builder: (ctx, state) {
          final brightness = state.brightness;
          // return CupertinoApp()
          return MaterialApp(
            title: 'Markdown',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue, brightness: brightness),
            // home: HomePage(),
            home: HomeListPage(),
          );
        },
      ),
    );
  }

  Future<void> initPlatformState() async {
    String? platformVersion;

    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
            print("flutter onReceiveNotification: $message");
            // setState(() {
            //   debugLable = "flutter onReceiveNotification: $message";
            // });
          }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
        // setState(() {
        //   debugLable = "flutter onOpenNotification: $message";
        // });
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
        // setState(() {
        //   debugLable = "flutter onReceiveMessage: $message";
        // });
      }, onReceiveNotificationAuthorization:
          (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
        // setState(() {
        //   debugLable = "flutter onReceiveNotificationAuthorization: $message";
        // });
      },onNotifyMessageUnShow:
          (Map<String, dynamic> message) async {
        print("flutter onNotifyMessageUnShow: $message");
        // setState(() {
        //   debugLable = "flutter onNotifyMessageUnShow: $message";
        // });
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    jpush.setAuth(enable: true);
    jpush.setup(
      appKey: "xxxxx", //你自己应用的 AppKey
      channel: "theChannel",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      print("flutter get registration id : $rid");
      // setState(() {
      //   debugLable = "flutter getRegistrationID: $rid";
      // });
    });


  }
}
