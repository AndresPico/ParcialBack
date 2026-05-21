import 'package:flutter/material.dart';

import 'service_form.dart';

class EditServiceScreen extends StatelessWidget {
  const EditServiceScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar servicio')),
      body: ServiceForm(serviceId: id),
    );
  }
}
