class ApiDynamic {
  static const String baseUrl = "https://dev.api.arenakita.my.id/api/v1";

  static String approveBookings(int id) => "$baseUrl/owners/bookings/$id/approve";
  static String rejectBookings(int id) => "$baseUrl/owners/bookings/$id/reject";
}

