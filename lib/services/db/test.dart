import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterStreamProvider = StreamProvider<int>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (count) =>  count +1);
});

class CounterStreamScreen extends ConsumerWidget {
  const CounterStreamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterAsyncValue = ref.watch(counterStreamProvider);
    foo(builder: (count) async => await getCounter(count));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Stream'),
      ),
      body: Center(
        child: counterAsyncValue.when(
          data: (count) => Text('Current Count: $count', style: const TextStyle(fontSize: 24)),
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => Text('Error: $error'),
        ),
      ),
    );
  }
}

Future<int> getCounter(int counter) async {
  return 10;
}

int getCounter1(int counter) {
  return 10;
}

FutureOr<void> foo({required FutureOr<int> Function(int count) builder})  {
  final result =  builder(10);
  print(result);
}

//
/// test last update counter
///
void main() => runApp(
  ProviderScope(
    child: MaterialApp(
      home: Scaffold(
        body: Center(
          child: CounterStreamScreen(),
        ),
      ),
    ),
  ),
);