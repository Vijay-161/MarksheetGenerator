import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marksstudentmanagement/view/student_view.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Riverpod state management',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const StudentView(),
        },
      ),
    ),
  );
}
