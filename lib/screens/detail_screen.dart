import 'package:flutter/material.dart';
import '../widgets/info_card.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

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
                // Top bar
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                const Text(
                  'Karaganda',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Clear sky',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),

                const SizedBox(height: 18),

                // Main info
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
                      children: const [
                        Text(
                          '-5°',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 58,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'Feels like -9°',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 18),

                const Text(
                  'Parameters',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),

                // Cards grid
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    InfoCard(icon: Icons.water_drop_outlined, label: 'Humidity', value: '70%'),
                    InfoCard(icon: Icons.air, label: 'Wind', value: '3.5 m/s'),
                    InfoCard(icon: Icons.speed, label: 'Pressure', value: '1016 hPa'),
                    InfoCard(icon: Icons.thermostat, label: 'Min / Max', value: '-9° / -3°'),
                  ],
                ),

                const Spacer(),

                // Bottom block (UI only)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white.withOpacity(0.18)),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, color: Colors.white),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Элементы интерфейса добавлены согласно макету Figma. Функционал не обязателен.',
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
