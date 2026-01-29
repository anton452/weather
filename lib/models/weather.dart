class Weather {
  final String cityName;
  final double temp;
  final String description;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final double feelsLike;
  final double tempMin;
  final double tempMax;

  Weather({
    required this.cityName,
    required this.temp,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;
    final weatherArr = json['weather'] as List<dynamic>;

    return Weather(
      cityName: json['name'] ?? '',
      temp: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),
      description: weatherArr.isNotEmpty ? (weatherArr[0]['description'] ?? '') : '',
      humidity: (main['humidity'] as num).toInt(),
      pressure: (main['pressure'] as num).toInt(),
      windSpeed: (wind['speed'] as num).toDouble(),
    );
  }
}
