import 'package:flutter/material.dart';

import 'service_form.dart';

class CreateServiceScreen extends StatelessWidget {
  const CreateServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear servicio')),
      body: const ServiceForm(),
    );
  }
}
