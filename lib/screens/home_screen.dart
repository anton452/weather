import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController(text: 'Karaganda');
  final _api = ApiService();

  Weather? _weather;
  bool _loading = false;

  Future<void> _getWeather() async {
    setState(() => _loading = true);

    try {
      final w = await _api.fetchWeather(_controller.text);
      setState(() => _weather = w);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Погода')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Введите город (можно кириллицей)',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _getWeather(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _getWeather,
                child: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Показать погоду'),
              ),
            ),
            const SizedBox(height: 16),
            if (_weather != null)
              Card(
                child: ListTile(
                  title: Text(_weather!.cityName),
                  subtitle: Text(
                    '${_weather!.description}, ${_weather!.temp.toStringAsFixed(1)}°C',
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(weather: _weather!),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
