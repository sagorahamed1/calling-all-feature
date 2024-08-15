import 'package:flutter/material.dart';
import 'package:video_calling/utils.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  // call the useSystemCallingUI
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    runApp(MyApp(navigatorKey: navigatorKey));
  });
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key, required this.navigatorKey});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: widget.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController roomIdController = TextEditingController();
    final TextEditingController userNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Start a Call'),
      ),
      body: CallInvitation(
        userName: 'sagor',
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: roomIdController,
                decoration: InputDecoration(
                  labelText: 'Room ID',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: userNameController,
                decoration: InputDecoration(
                  labelText: 'User Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    startGroupCall(context, roomIdController.text, userNameController.text);
                  },
                  child: Text('Start Call'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startGroupCall(BuildContext context, String roomId, String userName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ZegoUIKitPrebuiltCall(
          appID: Utils.appId,
          appSign: Utils.appSign,
          userID: userName,
          userName: 'userName',
          plugins: [ZegoUIKitSignalingPlugin()], callID: roomId, config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
        ),
      ),
    );
  }
}


class CallInvitation extends StatelessWidget {
  final Widget child;
  final String userName;

  CallInvitation({super.key, required this.child, required this.userName});

  @override
  Widget build(BuildContext context) {
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: Utils.appId,
      appSign: Utils.appSign,
      userID: userName,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
    );
    return child;
  }
}
