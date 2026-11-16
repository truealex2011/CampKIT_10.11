import 'package:flutter/material.dart';

import 'participant_onboarding.dart';

void main() {
  runApp(const CampusLifePreview());
}

class CampusLifePreview extends StatelessWidget {
  const CampusLifePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusLife',
      home: Scaffold(
        backgroundColor: const Color(0xFFF6F6F3),
        body: ParticipantOnboarding(
          onFinished: (ParticipantOnboardingResult result) {},
        ),
      ),
    );
  }
}
