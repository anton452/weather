import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String initialCity;

  const HomeScreen({super.key, required this.initialCity});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final _api = ApiService();

  Weather? _weather;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialCity;
    _loadWeather();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadWeather() async {
    setState(() => _loading = true);
    try {
      final data = await _api.fetchWeather(_controller.text);
      if (!mounted) return;
      setState(() => _weather = data);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _setCity(String city) {
    _controller.text = city;
    _loadWeather();
  }

  void _openDetails() {
    if (_weather == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(weather: _weather!)),
    );
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
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      _weather?.cityName.isNotEmpty == true ? _weather!.cityName : 'City',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _loading ? null : _loadWeather,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                const Text(
                  'Weather',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),

                // Search
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.18)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.white70),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Search city...',
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => _loadWeather(),
                        ),
                      ),
                      TextButton(
                        onPressed: _loading ? null : _loadWeather,
                        child: const Text('GO', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Weather Card
                GestureDetector(
                  onTap: _openDetails,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: Colors.white.withOpacity(0.18)),
                      boxShadow: const [
                        BoxShadow(blurRadius: 24, offset: Offset(0, 10), color: Color(0x22000000)),
                      ],
                    ),
                    child: _loading
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 26),
                            child: Center(child: CircularProgressIndicator(color: Colors.white)),
                          )
                        : (_weather == null)
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 26),
                                child: Text('Введите город и нажмите GO', style: TextStyle(color: Colors.white70)),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 54,
                                        width: 54,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.16),
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                        child: const Icon(Icons.wb_sunny, color: Colors.white, size: 30),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _weather!.cityName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              _weather!.description,
                                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right, color: Colors.white),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    '${_weather!.temp.round()}°',
                                    style: const TextStyle(color: Colors.white, fontSize: 54, fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Feels like ${_weather!.feelsLike.round()}°',
                                    style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 14),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      _MiniPill(icon: Icons.water_drop_outlined, text: 'Humidity ${_weather!.humidity}%'),
                                      const SizedBox(width: 10),
                                      _MiniPill(icon: Icons.air, text: 'Wind ${_weather!.windSpeed.toStringAsFixed(1)} m/s'),
                                    ],
                                  ),
                                ],
                              ),
                  ),
                ),

                const SizedBox(height: 14),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _CityChip(label: 'Almaty', onTap: () => _setCity('Almaty')),
                    _CityChip(label: 'Astana', onTap: () => _setCity('Astana')),
                    _CityChip(label: 'Shymkent', onTap: () => _setCity('Shymkent')),
                    _CityChip(label: 'Karaganda', onTap: () => _setCity('Karaganda')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MiniPill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _CityChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _CityChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withOpacity(0.18)),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
