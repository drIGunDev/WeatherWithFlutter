import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final streamProvider = StreamProvider<int>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (x) => x);
});

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Scaffold(
          body: Center(
            child: Consumer(
              builder: (context, ref, _) {
                final value = ref.watch(streamProvider);
                return value.when(
                  data: (data) => Center(child: Text(data.toString(), style: TextStyle(fontSize: 20))),
                  error: (error, stackTrace) => Center(child: Text(error.toString(), style: TextStyle(fontSize: 20))),
                  loading: () => CircularProgressIndicator(),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
