import 'package:flutter/material.dart';

class SplashLoader extends StatelessWidget {
  const SplashLoader({Key? key}) : super(key: key);

  Stream<String> getLoadingMessages() {
    final List<String> messages = [
      'Cargado péliculas',
      'Esto no tardará mucho',
      'Espere...',
      'Un poco más',
      '¡Espere!',
      'Ya está demorando mucho :c',
    ];
    return Stream.periodic(
      const Duration(seconds: 1),
      (step) => messages[step],
    ).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Cargando...'),
        const SizedBox(height: 10),
        const CircularProgressIndicator(),
        const SizedBox(height: 10),
        StreamBuilder(
          stream: getLoadingMessages(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Cargando...');
            return Text(snapshot.data!);
          },
        )
      ],
    ));
  }
}
