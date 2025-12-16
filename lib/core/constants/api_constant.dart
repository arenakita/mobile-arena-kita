class ApiConstants {
  static const String baseUrl = "https://dev.api.arenakita.my.id/api/v1";

  /// AUTH
  static const String login = "$baseUrl/auth/owner/login";
  static const String logout = "$baseUrl/auth/logout";

  /// DASHBOARD OWNER
  static const String dashboardStats = "$baseUrl/owners/dashboard/stats";
  static const String dashboardBookings = "$baseUrl/owners/dashboard/bookings";
  static const String venues = "$baseUrl/owners/venues";
  static const String dashboard = "$baseUrl/owners/dashboard";
  static const String bookings = "$baseUrl/owners/bookings";
  static const String transactions = "$baseUrl/owners/transactions";
}