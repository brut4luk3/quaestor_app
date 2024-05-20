import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> nameDetails;
  final int rank;

  const DetailsScreen({Key? key, required this.nameDetails, required this.rank}) : super(key: key);

  String formatPeriod(String period) {
    if (period.startsWith('[') && period.endsWith('[')) {
      return 'Período entre ${period.substring(1, period.length - 1).replaceAll(',', ' e ')}';
    } else if (period.endsWith('[')) {
      return 'Período de ${period.substring(0, period.length - 1)}';
    } else {
      return 'Período de $period';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes de ' + nameDetails['nome']),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ListView(
            children: [
              Text(
                nameDetails['nome'],
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Posição no rank: $rankº',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Detalhes adicionais:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Localidade: ${nameDetails['localidade']}',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Frequência entre períodos:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ...nameDetails['res'].map<Widget>((periodData) {
                String formattedPeriod = formatPeriod(periodData['periodo']);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    children: [
                      Text(
                        formattedPeriod,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${periodData['frequencia']} registrados.',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}