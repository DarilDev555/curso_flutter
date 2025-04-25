import '../../../domain/entities/institution.dart';
import '../../providers/institutions/institutions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class InstitutionDetailScreen extends ConsumerWidget {
  static const name = 'institution-detail-screen';
  final String idInstitution;

  const InstitutionDetailScreen({super.key, required this.idInstitution});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Institution institution = ref
        .watch(getInstitutionsProvider)
        .firstWhere((element) => element.id == idInstitution);

    return Scaffold(
      backgroundColor: Color.lerp(institution.background, Colors.white, 0.8),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                institution.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 4,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              background: Image.network(
                'https://uni.illinois.edu/sites/default/files/styles/hero_image/public/paragraphs/hero/2023-03/pink-front.jpg?h=5e5c215f&itok=_mhU6Xw_',
                fit: BoxFit.cover,
                color: Colors.black.withValues(alpha: 0.3),
                colorBlendMode: BlendMode.darken,
              ),
            ),
            backgroundColor: colorScheme.primary,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Información General',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _DetailItem(
                            icon: Icons.code,
                            label: 'Código:',
                            value: institution.code,
                            color: colorScheme.primary,
                          ),
                          _DetailItem(
                            icon: Icons.location_city,
                            label: 'Ciudad:',
                            value: institution.location.city,
                            color: colorScheme.secondary,
                          ),
                          _DetailItem(
                            icon: Icons.flag,
                            label: 'Estado:',
                            value: institution.location.state,
                            color: Colors.orange,
                          ),
                          _DetailItem(
                            icon: Icons.home_work,
                            label: 'Dirección:',
                            value: institution.location.street,
                            color: Colors.green,
                          ),
                          _DetailItem(
                            icon: Icons.local_post_office,
                            label: 'Código Postal:',
                            value: institution.location.postalCode,
                            color: Colors.purple,
                          ),
                          if (institution.location.description.isNotEmpty)
                            Column(
                              children: [
                                const Divider(),
                                _DetailItem(
                                  icon: Icons.description,
                                  label: 'Descripción:',
                                  value: institution.location.description,
                                  color: Colors.blueGrey,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.map_outlined,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Ubicación',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(
                                double.parse(institution.location.latitude),
                                double.parse(institution.location.longitude),
                              ),
                              initialZoom: 17.0,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.app',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: LatLng(
                                      double.parse(
                                        institution.location.latitude,
                                      ),
                                      double.parse(
                                        institution.location.longitude,
                                      ),
                                    ),
                                    width: 80,
                                    height: 80,
                                    // ignore: prefer_const_constructors
                                    child: Icon(
                                      Icons.location_pin,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
