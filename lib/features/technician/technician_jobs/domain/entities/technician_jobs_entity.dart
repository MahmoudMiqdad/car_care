class TechnicianJobsEntity {
  final bool success;
  final List<JobEntity> jobs;

  const TechnicianJobsEntity({
    required this.success,
    required this.jobs,
  });
}

class JobEntity {
  final int id;
  final String status;
  final DateTime scheduledDate;
  final String notes;

  const JobEntity({
    required this.id,
    required this.status,
    required this.scheduledDate,
    required this.notes,
  });
}