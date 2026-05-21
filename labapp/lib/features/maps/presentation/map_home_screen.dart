import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constants/app_constants.dart';
import '../../services/presentation/services_controller.dart';

class MapHomeScreen extends ConsumerStatefulWidget {
  const MapHomeScreen({super.key});

  @override
  ConsumerState<MapHomeScreen> createState() => _MapHomeScreenState();
}

class _MapHomeScreenState extends ConsumerState<MapHomeScreen> {
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    Permission.locationWhenInUse.request();
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(servicesControllerProvider).value?.items ?? [];
    final markers = {
      for (final service in services)
        Marker(
          markerId: MarkerId(service.id),
          position: LatLng(service.latitude, service.longitude),
          infoWindow: InfoWindow(title: service.title),
          onTap: () => showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            builder: (_) => Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(service.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.push('/services/${service.id}');
                    },
                    child: const Text('Ver detalle'),
                  ),
                ],
              ),
            ),
          ),
        ),
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _controller?.animateCamera(
          CameraUpdate.newLatLngZoom(
            const LatLng(AppConstants.defaultLat, AppConstants.defaultLng),
            13,
          ),
        ),
        child: const Icon(Icons.my_location),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(AppConstants.defaultLat, AppConstants.defaultLng),
          zoom: 12,
        ),
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        markers: markers,
        onMapCreated: (controller) => _controller = controller,
      ),
    );
  }
}
