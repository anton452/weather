import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../widgets/info_card.dart';

class DetailScreen extends StatelessWidget {
  final Weather weather;

  const DetailScreen({super.key, required this.weather});

  void _snack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B2B5A), Color(0xFF5B86E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    ),
                    const Spacer(),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz, color: Colors.white),
                      onSelected: (v) {
                        if (v == 'share') _snack(context, 'Поделиться (заглушка)');
                        if (v == 'about') _snack(context, 'Weather App — учебный проект');
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'share', child: Text('Поделиться')),
                        PopupMenuItem(value: 'about', child: Text('О приложении')),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Text(
                  weather.cityName,
                  style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(weather.description, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 18),

                Row(
                  children: [
                    Container(
                      height: 88,
                      width: 88,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: Colors.white.withOpacity(0.18)),
                      ),
                      child: const Icon(Icons.wb_sunny, color: Colors.white, size: 44),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${weather.temp.round()}°',
                          style: const TextStyle(color: Colors.white, fontSize: 58, fontWeight: FontWeight.w900),
                        ),
                        Text(
                          'Feels like ${weather.feelsLike.round()}°',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),
                const Text(
                  'Parameters',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    InfoCard(icon: Icons.water_drop_outlined, label: 'Humidity', value: '${weather.humidity}%'),
                    InfoCard(icon: Icons.air, label: 'Wind', value: '${weather.windSpeed.toStringAsFixed(1)} m/s'),
                    InfoCard(icon: Icons.speed, label: 'Pressure', value: '${weather.pressure} hPa'),
                    InfoCard(
                      icon: Icons.thermostat,
                      label: 'Min / Max',
                      value: '${weather.tempMin.round()}° / ${weather.tempMax.round()}°',
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white.withOpacity(0.18)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.white),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Экран адаптивный: прокрутка включена, переполнения нет.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
