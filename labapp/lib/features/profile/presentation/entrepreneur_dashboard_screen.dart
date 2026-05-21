import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EntrepreneurDashboardScreen extends StatelessWidget {
  const EntrepreneurDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/services/new'),
        icon: const Icon(Icons.add_business),
        label: const Text('Nuevo servicio'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Resumen', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(child: _DashboardCard(icon: Icons.visibility_outlined, label: 'Vistas', value: '0')),
              SizedBox(width: 12),
              Expanded(child: _DashboardCard(icon: Icons.star_outline, label: 'Rating', value: '0.0')),
            ],
          ),
          const SizedBox(height: 12),
          const _DashboardCard(icon: Icons.inventory_2_outlined, label: 'Servicios activos', value: '0'),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(height: 16),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(label),
          ],
        ),
      ),
    );
  }
}
