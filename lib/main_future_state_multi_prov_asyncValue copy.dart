import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:hooks_riverpod/hooks_riverpod.dart';

/* How this works:
First a list of cities displayed in UI from City enum.
When a city is selected,  onTap currentCityProvider provider is called and  currentCityProvider.notifier.state = city,
Then weatherProvider which listens to currentCityProvider changes in final city = ref.watch(currentCityProvider);, 
triggers and gets the weather of that city and the weather Text UI will be rebuild

 */
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

enum City {
  stockholm,
  paris,
  tokyo,
}

typedef WeatherEmoji = String;

Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
    const Duration(seconds: 1),
    () => {
      City.stockholm: '❄️',
      City.paris: '🌧️',
      City.tokyo: '🍃',
    }[city]!,
  );
}

//UI writes to and reads from this(when UI wants to put some checkmark)
final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

const unknownWeatherEmoji = '🤷‍♂️';

//This provider listens to currentCityProvider and provides the current value to this UI which UI listens to this
final weatherProvider = FutureProvider<WeatherEmoji>(
  (ref) {
    final city = ref.watch(currentCityProvider);
    if (city != null) {
      return getWeather(city);
    } else {
      return unknownWeatherEmoji;
    }
  },
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: Column(
        children: [
          currentWeather.when(
            data: (data) => Text(
              data,
              style: const TextStyle(
                fontSize: 40,
              ),
            ),
            error: (_, __) => const Text('Error 😒'),
            loading: () => const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: City.values.length,
              itemBuilder: (context, index) {
                final city = City.values[index];
                final isSelected = city == ref.watch(currentCityProvider);
                return ListTile(
                  title: Text(city.toString()),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  onTap: () => ref
                      .read(
                        currentCityProvider.notifier,
                      )
                      .state = city,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
