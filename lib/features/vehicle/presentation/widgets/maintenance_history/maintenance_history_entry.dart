class MaintenanceHistoryEntry {
  const MaintenanceHistoryEntry({
    required this.description,
    required this.part,
    required this.technicianName,
    required this.date,
  });

  final String description;
  final String part;
  final String technicianName;
  final DateTime date;
}
