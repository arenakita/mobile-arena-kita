import 'package:arena_kita/models/transaction_model.dart';
import 'package:arena_kita/services/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsTabView extends StatefulWidget {
  const TransactionsTabView({super.key});

  @override
  State<TransactionsTabView> createState() => _TransactionsTabViewState();
}

class _TransactionsTabViewState extends State<TransactionsTabView> {
  final BookingService _bookingService = BookingService();
  bool _isLoading = true;
  String? _error;
  List<Transaction> _allTransactions = [];
  List<Transaction> _filteredTransactions = [];

  String _selectedStatus = 'All';
  String _sortOrder = 'desc';
  final List<String> _statusOptions = ['All', 'PENDING', 'SUCCESS', 'FAILED', 'EXPIRE'];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final transactions = await _bookingService.getTransactions();
      if (mounted) {
        setState(() {
          _allTransactions = transactions;
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
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _applyFiltersAndSort() {
    List<Transaction> tempTransactions = List.from(_allTransactions);
    if (_selectedStatus != 'All') {
      tempTransactions = tempTransactions
          .where((t) => t.paymentStatus == _selectedStatus)
          .toList();
    }
    tempTransactions.sort((a, b) {
      final dateA = DateTime.parse(a.paymentTime.replaceAll(' ', 'T'));
      final dateB = DateTime.parse(b.paymentTime.replaceAll(' ', 'T'));
      return _sortOrder == 'asc' ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });
    setState(() {
      _filteredTransactions = tempTransactions;
    });
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
                      labelStyle: TextStyle(
                          color: _selectedStatus == status
                              ? Colors.white
                              : Colors.black),
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
    if (_filteredTransactions.isEmpty) {
      return const Center(child: Text('Tidak ada transaksi yang ditemukan.'));
    }
    return RefreshIndicator(
      onRefresh: _fetchTransactions,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _filteredTransactions.length,
        itemBuilder: (context, index) {
          final transaction = _filteredTransactions[index];
          return _buildTransactionItem(transaction);
        },
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final booking = transaction.booking;
    final paymentDate = DateTime.parse(transaction.paymentTime.replaceAll(' ', 'T'));
    final bookingDate = DateTime.parse(booking.bookingDate);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '${booking.fieldInfo.venueName} - ${booking.fieldInfo.fieldName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                booking.totalPrice,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          _buildInfoRow(Icons.person_outline, booking.user.name),
          _buildInfoRow(
            Icons.calendar_today_outlined,
            DateFormat('EEEE, d MMM yyyy', Intl.getCurrentLocale()).format(bookingDate),
          ),
          _buildInfoRow(
            Icons.access_time_outlined,
            '${booking.startTime} - ${booking.endTime}',
          ),
          _buildInfoRow(
            Icons.payment,
            transaction.paymentMethod,
          ),
          _buildInfoRow(
            Icons.access_time,
            'Dibayar: ${DateFormat('d MMM yyyy, HH:mm', Intl.getCurrentLocale()).format(paymentDate)}',
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getPaymentStatusColor(transaction.paymentStatus)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.payment,
                      size: 12,
                      color: _getPaymentStatusColor(transaction.paymentStatus),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      transaction.paymentStatus,
                      style: TextStyle(
                        color: _getPaymentStatusColor(transaction.paymentStatus),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getBookingStatusColor(booking.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getBookingStatusIcon(booking.status),
                      size: 12,
                      color: _getBookingStatusColor(booking.status),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      booking.status,
                      style: TextStyle(
                        color: _getBookingStatusColor(booking.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
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
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.grey[800])),
          ),
        ],
      ),
    );
  }

  Color _getPaymentStatusColor(String status) {
    switch (status) {
      case 'SUCCESS':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'FAILED':
      case 'EXPIRE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getBookingStatusColor(String status) {
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

  IconData _getBookingStatusIcon(String status) {
    switch (status) {
      case 'CONFIRMED':
        return Icons.check_circle;
      case 'REJECTED':
        return Icons.cancel;
      case 'PENDING':
        return Icons.pending;
      default:
        return Icons.info;
    }
  }
}
