import 'package:flutter/material.dart';

class cabezeraformulario extends StatelessWidget {
  const cabezeraformulario({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/ui/emblema.png',
          height: 110,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.shield, size: 80);
          },
        ),
        const SizedBox(height: 16),
        const Text('Únete a la Arena'),
        const Text('Elige un nick: así te verán en el ranking.'),
      ],
    );
  }
}