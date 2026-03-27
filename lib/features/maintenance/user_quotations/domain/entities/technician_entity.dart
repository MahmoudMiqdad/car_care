class TechnicianEntity {
  final int id;
  final String name;
  final String phone;
  final TechnicianProfileEntity technicianProfile;

  TechnicianEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.technicianProfile,
  });
}

class TechnicianProfileEntity {
  final String specialization;
  final int experienceYears;

  TechnicianProfileEntity({
    required this.specialization,
    required this.experienceYears,
  });
}