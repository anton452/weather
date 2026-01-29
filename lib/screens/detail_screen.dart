import 'package:flutter/material.dart';

import '../models/weather.dart';

class DetailScreen extends StatelessWidget {
  final Weather weather;

  const DetailScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${weather.cityName} — детали')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${weather.temp.toStringAsFixed(1)}°C',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Описание: ${weather.description}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Влажность: ${weather.humidity}%', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Ветер: ${weather.windSpeed.toStringAsFixed(1)} м/с', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
