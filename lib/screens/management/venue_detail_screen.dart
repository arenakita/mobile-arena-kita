import 'package:flutter/material.dart';
import '../../models/venue_model.dart';
import '../../services/venue_service.dart';
import 'edit_venue_screen.dart';

class VenueDetailScreen extends StatefulWidget {
  final int venueId;

  const VenueDetailScreen({super.key, required this.venueId});

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  final VenueService _venueService = VenueService();
  Venue? _venue;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadVenueDetail();
  }

  Future<void> _loadVenueDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final venue = await _venueService.getVenueDetail(widget.venueId);
      setState(() {
        _venue = venue;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteVenue() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Venue'),
        content: const Text('Apakah Anda yakin ingin menghapus venue ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await _venueService.deleteVenue(_venue!.id);
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Venue berhasil dihapus')));
        Navigator.pop(context, true); // Return to management screen
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghapus venue: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Venue'),
        actions: [
          if (_venue != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditVenueScreen(venue: _venue!),
                  ),
                );
                if (result == true) {
                  _loadVenueDetail();
                }
              },
            ),
          if (_venue != null)
            IconButton(icon: const Icon(Icons.delete), onPressed: _deleteVenue),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadVenueDetail,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            )
          : _venue == null
          ? const Center(child: Text('Venue tidak ditemukan'))
          : RefreshIndicator(
              onRefresh: _loadVenueDetail,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Venue Name
                  Text(
                    _venue!.venueName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Photos
                  if (_venue!.photos != null && _venue!.photos!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Foto Venue',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _venue!.photos!.length,
                            itemBuilder: (context, index) {
                              final photo = _venue!.photos![index];
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[300],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    'https://dev.api.arenakita.my.id/storage/${photo.url}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.image, size: 60),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),

                  // Description
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(_venue!.description),
                  const SizedBox(height: 16),

                  // Address & City
                  _buildInfoRow(Icons.location_on, 'Alamat', _venue!.address),
                  _buildInfoRow(Icons.location_city, 'Kota', _venue!.city),

                  // GPS Coordinate
                  if (_venue!.gpsCoordinate != null)
                    _buildInfoRow(
                      Icons.gps_fixed,
                      'GPS',
                      _venue!.gpsCoordinate!,
                    ),

                  // Operating Hours
                  _buildInfoRow(
                    Icons.access_time,
                    'Jam Operasional',
                    '${_venue!.openingTime} - ${_venue!.closingTime}',
                  ),

                  const SizedBox(height: 24),

                  // Fields
                  if (_venue!.fields != null && _venue!.fields!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lapangan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...(_venue!.fields!
                            .map(
                              (field) => Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: field.photoUrl != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          child: Image.network(
                                            'https://dev.api.arenakita.my.id/storage/${field.photoUrl}',
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return const Icon(
                                                    Icons.sports_soccer,
                                                  );
                                                },
                                          ),
                                        )
                                      : const Icon(Icons.sports_soccer),
                                  title: Text(field.name),
                                  subtitle: Text(field.type),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: field.status == 'AVAILABLE'
                                          ? Colors.green
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      field.status,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList()),
                      ],
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
