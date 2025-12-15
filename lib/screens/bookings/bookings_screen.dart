import 'package:flutter/material.dart';
import 'tabs/bookings_tab_view.dart';
import 'tabs/transactions_tab_view.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Booking dan Transaksi'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Booking'),
              Tab(text: 'Transaksi'),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            BookingsTabView(),
            TransactionsTabView(),
          ],
        ),
      ),
    );
  }
}
