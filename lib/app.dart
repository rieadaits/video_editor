import 'package:flutter/material.dart';
import 'package:video_editor/core/utils/app_theme.dart';
import 'package:video_editor/landing/pages/landing_page.dart';

import 'landing/cubit/file_picker/file_picker_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilePickerCubit(),
      child: MaterialApp(
        title: 'Video editor',
        debugShowCheckedModeBanner: false,
        theme: AppThemes.kThemeData,
        home: const LandingPage(),
      ),
    );
  }
}
