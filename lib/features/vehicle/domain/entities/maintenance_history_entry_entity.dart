class MaintenanceHistoryEntryEntity {
  const MaintenanceHistoryEntryEntity({
    required this.id,
    required this.description,
    required this.part,
    required this.technicianName,
    required this.date,
  });

  final int id;
  final String description;    
  final String part;            
  final String technicianName;
  final DateTime date;        
}