import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:developer' as devtools show log;

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

const names = [
  'Alice',
  'Bob',
  'Charlie',
  'David',
  'Eve',
  'Fred',
  'Ginny',
  'Harrier',
  'Ileana',
  'Joseph',
  'Kate',
  'Larry',
];

final tickerProvider = StreamProvider(
  (ref) => Stream.periodic(
      const Duration(
        seconds: 1,
      ),
      (i) => i + 1),
);

final namesProvider = StreamProvider<List<String>>(
  (ref) {
    final count = ref.watch(tickerProvider);
    final range = names.getRange(0, count.value!);
    return Stream.value(range.toList());
  },
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);
    devtools.log('names $names');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Stream Provider'),
        ),
        body: names.when(
          data: (names) {
            return ListView.builder(
              itemCount: names.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    names[index],
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) => const Text('Reached end of the list!'),
          loading: () => const Center(child: CircularProgressIndicator()),
        ));
  }
}
