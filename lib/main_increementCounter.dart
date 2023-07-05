import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    ),
  );
}

extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    devtools.log('this $this, other $other');
    final shadow = this;
    devtools.log('shadow $shadow');
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

class Counter extends StateNotifier<int?> {
  Counter() : super(null);
  void increment() => state = (state == null) ? 1 : state + 1;
}

final counterProvider = StateNotifierProvider<Counter, int?>(
  (ref) => Counter(),
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Consumer(
            builder: (context, ref, child) {
              final count = ref.watch(counterProvider);
              final text =
                  count == null ? 'Press the button' : count.toString();
              return Text(text);
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: ref.read(counterProvider.notifier).increment,
              child: const Text(
                'Increment counter',
              ),
            )
          ],
        ));
  }
}
