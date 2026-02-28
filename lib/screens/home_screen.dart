import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../services/earthquake_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final WeatherService weatherService = WeatherService();
  final EarthquakeService earthquakeService = EarthquakeService();

  final TextEditingController cityController = TextEditingController();

  Map<String, dynamic>? weatherData;
  List earthquakes = [];

  bool isLoadingWeather = false;
  bool isLoadingEarthquakes = false;

  @override
  void initState() {
    super.initState();
    loadEarthquakes();
  }

  Future<void> loadWeather() async {
    if (cityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Введите название города")),
      );
      return;
    }

    setState(() {
      isLoadingWeather = true;
    });

    final data = await weatherService.fetchWeather(cityController.text);

    setState(() {
      weatherData = data;
      isLoadingWeather = false;
    });

    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Город не найден или ошибка API")),
      );
    }
  }

  Future<void> loadEarthquakes() async {
    setState(() {
      isLoadingEarthquakes = true;
    });

    final data = await earthquakeService.fetchEarthquakes();

    setState(() {
      earthquakes = data.take(5).toList();
      isLoadingEarthquakes = false;
    });
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Главный экран"),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            /// ================= WEATHER =================

            const Text(
              "Погода",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: "Введите город",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: loadWeather,
              child: const Text("Получить погоду"),
            ),

            const SizedBox(height: 15),

            if (isLoadingWeather)
              const CircularProgressIndicator(),

            if (weatherData != null && !isLoadingWeather) ...[
              const SizedBox(height: 10),
              Text(
                "Температура: ${weatherData!["main"]["temp"]} °C",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 5),
              Text(
                "Состояние: ${weatherData!["weather"][0]["description"]}",
              ),
              const SizedBox(height: 5),
              Image.network(
                "https://openweathermap.org/img/wn/${weatherData!["weather"][0]["icon"]}@2x.png",
              ),
            ],

            const SizedBox(height: 40),

            /// ================= EARTHQUAKE =================

            const Text(
              "Сейсмическая активность (за сутки)",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            if (isLoadingEarthquakes)
              const CircularProgressIndicator(),

            if (!isLoadingEarthquakes)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: earthquakes.length,
                itemBuilder: (context, index) {
                  final quake = earthquakes[index]["properties"];

                  return Card(
                    child: ListTile(
                      title: Text("Магнитуда: ${quake["mag"]}"),
                      subtitle: Text(quake["place"]),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}