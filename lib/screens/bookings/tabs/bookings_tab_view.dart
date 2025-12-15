import 'package:arena_kita/models/booking_model.dart';
import 'package:arena_kita/services/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingsTabView extends StatefulWidget {
  const BookingsTabView({super.key});

  @override
  State<BookingsTabView> createState() => _BookingsTabViewState();
}

class _BookingsTabViewState extends State<BookingsTabView> {
  final BookingService _bookingService = BookingService();
  bool _isLoading = true;
  String? _error;
  List<Booking> _allBookings = [];
  List<Booking> _filteredBookings = [];

  String _selectedStatus = 'All';
  String _sortOrder = 'desc';
  final List<String> _statusOptions = ['All', 'PENDING', 'CONFIRMED', 'REJECTED', 'COMPLETED'];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final bookings = await _bookingService.getBookings();
      if (mounted) {
        setState(() {
          _allBookings = bookings;
          _applyFiltersAndSort();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
      }
    } finally {
      if(mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _applyFiltersAndSort() {
    List<Booking> tempBookings = List.from(_allBookings);
    if (_selectedStatus != 'All') {
      tempBookings = tempBookings.where((b) => b.status == _selectedStatus).toList();
    }
    tempBookings.sort((a, b) => _sortOrder == 'asc'
        ? a.bookingDate.compareTo(b.bookingDate)
        : b.bookingDate.compareTo(a.bookingDate));
    setState(() {
      _filteredBookings = tempBookings;
    });
  }

  Future<void> _updateBookingStatus(int bookingId, Future<bool> Function(int) action, String successMessage) async {
    final success = await action(bookingId);
    if(mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? successMessage : 'Action failed')),
      );
      if(success) {
        _fetchBookings(); // Refresh the list
      }
    }
  }

  void _showActionDialog(BuildContext context, Booking booking, String action) {
    final actionTexts = {
      'approve': {'title': 'Setujui Booking', 'message': 'Apakah kamu yakin ingin menyetujui booking ini?', 'button': 'Setujui', 'success': 'Booking Disetujui'},
      'reject': {'title': 'Tolak Booking', 'message': 'Apakah kamu yakin ingin menolak booking ini?', 'button': 'Tolak', 'success': 'Booking Ditolak'},
    };
    
    final texts = actionTexts[action]!;
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(texts['title']!),
          content: Text(texts['message']!),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(
                texts['button']!,
                style: TextStyle(
                  color: action == 'approve' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                final serviceAction = action == 'approve' 
                    ? _bookingService.approveBooking 
                    : _bookingService.rejectBooking;
                _updateBookingStatus(booking.id, serviceAction, texts['success']!);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          // Sort Toggle - Fixed on the left
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSortButton(
                  icon: Icons.arrow_downward,
                  isSelected: _sortOrder == 'desc',
                  onTap: () {
                    setState(() {
                      _sortOrder = 'desc';
                      _applyFiltersAndSort();
                    });
                  },
                ),
                _buildSortButton(
                  icon: Icons.arrow_upward,
                  isSelected: _sortOrder == 'asc',
                  onTap: () {
                    setState(() {
                      _sortOrder = 'asc';
                      _applyFiltersAndSort();
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Status Filter Pills - Scrollable
          Expanded(
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _statusOptions.map((status) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      showCheckmark: false,
                      label: Text(status),
                      selectedColor: Theme.of(context).primaryColor,
                      labelStyle: TextStyle(color: _selectedStatus == status ? Colors.white : Colors.black),
                      selected: _selectedStatus == status,
                      onSelected: (isSelected) {
                        if (isSelected) {
                          setState(() {
                            _selectedStatus = status;
                            _applyFiltersAndSort();
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }
    if (_filteredBookings.isEmpty) {
      return const Center(child: Text('Tidak ada booking yang ditemukan.'));
    }
    return RefreshIndicator(
      onRefresh: _fetchBookings,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _filteredBookings.length,
        itemBuilder: (context, index) {
          final booking = _filteredBookings[index];
          return _buildBookingItem(booking);
        },
      ),
    );
  }

  Widget _buildBookingItem(Booking booking) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text('${booking.fieldInfo.venueName} - ${booking.fieldInfo.fieldName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              Text(booking.totalPrice, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const Divider(height: 20),
          _buildInfoRow(Icons.person_outline, booking.user.name),
          _buildInfoRow(Icons.calendar_today_outlined, DateFormat('EEEE, d MMM yyyy', Intl.getCurrentLocale()).format(booking.bookingDate)),
          _buildInfoRow(Icons.access_time_outlined, '${booking.startTime} - ${booking.endTime}'),
          const SizedBox(height: 12),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(booking.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  booking.status,
                  style: TextStyle(
                    color: _getStatusColor(booking.status),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              if (booking.status == 'PENDING')
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                      onPressed: () => _showActionDialog(context, booking, 'approve'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                      onPressed: () => _showActionDialog(context, booking, 'reject'),
                    ),
                  ],
                )
              else if (booking.status == 'CONFIRMED')
                IconButton(
                  icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                  tooltip: 'Reject Booking',
                  onPressed: () => _showActionDialog(context, booking, 'reject'),
                ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(color: Colors.grey[800]))),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'CONFIRMED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'PENDING':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
