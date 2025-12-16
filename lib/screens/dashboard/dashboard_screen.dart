import 'package:flutter/material.dart';

import '../../services/dashboard_service.dart';
import '../../models/dashboard_model.dart';
import '../../models/dashboard_booking_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService _service = DashboardService();

  late Future<DashboardStats> _statsFuture;
  late Future<List<Booking>> _bookingFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _statsFuture = _service.getDashboardStats();
    _bookingFuture = _service.getDashboardBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(_loadData);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStats(),
              const SizedBox(height: 28),
              _buildBookings(),
            ],
          ),
        ),
      ),
    );
  }

  /// =============================
  /// STATS SECTION
  /// =============================
  Widget _buildStats() {
    return FutureBuilder<DashboardStats>(
      future: _statsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const Text('Gagal memuat statistik');
        }

        final stats = snapshot.data!;

        return Row(
          children: [
            Expanded(
              child: _statCard(
                title: 'Total Booking',
                value: stats.totalBookings.toString(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                title: 'Pending',
                value: stats.pendingBookings.toString(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                title: 'Income',
                value: stats.totalIncome,
              ),
            ),
          ],
        );
      },
    );
  }

  /// =============================
  /// BOOKINGS SECTION
  /// =============================
  Widget _buildBookings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Booking Terbaru',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<Booking>>(
          future: _bookingFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Belum ada booking');
            }

            final bookings = snapshot.data!;

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bookings.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final booking = bookings[index];

                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 12),

                        /// BOOKING INFO
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.venueName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                booking.fieldName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${booking.bookingDate} • ${booking.startTime} - ${booking.endTime}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Rp ${booking.totalPrice}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// STATUS
                        _statusChip(booking.status),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  /// =============================
  /// STATUS CHIP
  /// =============================
  Widget _statusChip(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'CONFIRMED':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'PENDING':
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      default:
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  /// =============================
  /// STAT CARD
  /// =============================
  Widget _statCard({
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
