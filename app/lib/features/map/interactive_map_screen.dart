import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import '../../core/config/constants.dart';
import '../../shared/providers/providers.dart';

class InteractiveMapScreen extends ConsumerWidget {
  const InteractiveMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularAsync = ref.watch(popularTemplesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Braj Shrines Map')),
      body: popularAsync.when(
        data: (temples) {
          final markers = temples.map((t) {
            return Marker(
              point: LatLng(t.latitude, t.longitude),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          Text(t.shortDescription, maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              context.push('/temple/${t.id}');
                            },
                            child: const Text('View Temple Details'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const CircleAvatar(
                  backgroundColor: Color(0xFF18181B),
                  child: Icon(Icons.temple_hindu_outlined, color: Colors.white, size: 20),
                ),
              ),
            );
          }).toList();

          return FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(AppConstants.defaultLat, AppConstants.defaultLng),
              initialZoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.brajdarshan.app',
              ),
              MarkerLayer(markers: markers),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to load map data')),
      ),
    );
  }
}
