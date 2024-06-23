import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/single.dart';
import 'package:mobile/main.dart';
import 'package:mobile/presentation/notifier/user_scores_notifer.dart';
import 'package:mobile/widget/CameraPreviewWidget.dart';
import 'package:uuid/uuid.dart';

class QuestionScreen3 extends ConsumerWidget {
  const QuestionScreen3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CameraDescription? camera = ref.watch(cameraProvider);
    final scoresNotifier = ref.read(userScoresNotiferProvider.notifier);
    // 現在のスコアの長さに基づいてフィルターとテーマを取得
    String filter;
    String theme;
    Map<String, String> questionAndFilter = {};
    switch (scoresNotifier.state.length) {
      case 0:
        questionAndFilter = QuestionConstants.getRandomQuestion1();
        theme = questionAndFilter['theme']!;
        filter = questionAndFilter['filter']!;
        break;
      case 1:
        questionAndFilter = QuestionConstants.getRandomQuestion2();
        theme = questionAndFilter['theme']!;
        filter = questionAndFilter['filter']!;
        break;
      case 2:
        questionAndFilter = QuestionConstants.getRandomQuestion3();
        theme = questionAndFilter['theme']!;
        filter = questionAndFilter['filter']!;
        break;
      default:
        questionAndFilter = QuestionConstants.getRandomQuestion4();
        theme = questionAndFilter['theme']!;
        filter = questionAndFilter['filter']!;
        break;
    }

    Future<void> upload(imagePath) async {
      // 画像を取得できた場合一枚目をFirebaseStorageにアップロードする
      FirebaseStorage storage = FirebaseStorage.instance;
      var uuid = Uuid();
      if (imagePath != null) {
        final uid = uuid.v4(); // Generate a unique identifier

        final imageFile = File(imagePath);
        if (!imageFile.existsSync()) {
          print("File does not exist: $imagePath");
          return;
        }
        try {
          // print("フィアルを送ります");
          await storage.ref('$uid.jpeg').putFile(imageFile);
          // 得点のapiを叩く
          final data = {
            'theme': theme,
            'filter': filter,
            'imgUrl': '$uid.jpeg',
          };
          await scoresNotifier.submitString(data);

          // GoRouter.of(context).refresh();
        } catch (e) {
          print(e);
        }
      }
      return;
    }

    // カメラがnullではないことを確認
    if (camera != null) {
      return Scaffold(
        body: CameraPreviewWidget(
            camera: camera,
            filter: filter,
            theme: theme,
            upload: upload,
            questionCount: scoresNotifier.state.length + 1),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: Text('カメラが利用できません。'),
        ),
      );
    }
  }
}
