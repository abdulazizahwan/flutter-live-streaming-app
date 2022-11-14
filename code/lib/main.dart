import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

// Load .env file
Future main() async {
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zego Live Streaming',
      home: HomePage(),
    );
  }
}

// Generate userID with 6 digit length
final String userID = Random().nextInt(900000 + 100000).toString();

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Generate Live Streaming ID with 6 digit length
  final liveIDController = TextEditingController(
    text: Random().nextInt(900000 + 100000).toString(),
  );

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff034ada),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/header_illustration.svg',
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Your UserID: $userID'),
            const Text('Please test with two or more devices'),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: liveIDController,
              decoration: const InputDecoration(
                labelText: 'Join or Start a Live by Input an ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: buttonStyle,
              child: const Text('Start a Live'),
              onPressed: () => jumpToLivePage(
                context,
                liveID: liveIDController.text,
                isHost: true,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              style: buttonStyle,
              child: const Text('Join a Live'),
              onPressed: () => jumpToLivePage(
                context,
                liveID: liveIDController.text,
                isHost: false,
              ),
            )
          ],
        ),
      ),
    );
  }

  // Go to Live Page
  jumpToLivePage(BuildContext context,
      {required String liveID, required bool isHost}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePage(
          liveID: liveID,
          isHost: isHost,
        ),
      ),
    );
  }
}

// Live Page Prebuilt UI from ZEGOCLOUD UIKits
class LivePage extends StatelessWidget {
  final String liveID;
  final bool isHost;

  LivePage({
    super.key,
    required this.liveID,
    this.isHost = false,
  });

  // Read AppID and AppSign from .env file
  // Make sure you replace with your own
  final int appID = int.parse(dotenv.get('ZEGO_APP_ID'));
  final String appSign = dotenv.get('ZEGO_APP_SIGN');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: appID,
        appSign: appSign,
        userID: userID,
        userName: 'user_$userID',
        liveID: liveID,
        config: isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience()
          ..audioVideoViewConfig.showAvatarInAudioMode = true
          ..audioVideoViewConfig.showSoundWavesInAudioMode = true,
      ),
    );
  }
}
