class DashboardStats {
  final int totalBookings;
  final int pendingBookings;
  final String totalIncome;

  DashboardStats({
    required this.totalBookings,
    required this.pendingBookings,
    required this.totalIncome,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalBookings: json['total_bookings'] ?? 0,
      pendingBookings: json['pending_bookings'] ?? 0,
      totalIncome: json['total_income'] ?? 'Rp 0',
    );
  }
}
