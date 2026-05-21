import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/service.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({required this.service, super.key});

  final Service service;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'es_CO', symbol: r'$');
    return InkWell(
      onTap: () => context.push('/services/${service.id}'),
      borderRadius: BorderRadius.circular(20),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: service.imageUrls.isEmpty
                    ? Container(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: const Icon(Icons.image_outlined, size: 42),
                      )
                    : CachedNetworkImage(
                        imageUrl: service.imageUrls.first,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          service.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF59E0B)),
                      Text(service.rating.toStringAsFixed(1)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    service.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Chip(label: Text(service.category)),
                      const Spacer(),
                      Text(
                        currency.format(service.price),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
