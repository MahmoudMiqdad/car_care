class TechnicianStatisticsEntity {
  final bool success;
  final TechnicianStatisticsDataEntity data;

  const TechnicianStatisticsEntity({
    required this.success,
    required this.data,
  });
}

class TechnicianStatisticsDataEntity {
  final int totalJobs;
  final int assignedJobs;
  final int inProgressJobs;
  final int completedJobs;
  final int totalQuotations;
  final int pendingQuotations;
  final int acceptedQuotations;
  final int totalEarnings;
  final String averageRating;
  final int totalRatings;

  const TechnicianStatisticsDataEntity({
    required this.totalJobs,
    required this.assignedJobs,
    required this.inProgressJobs,
    required this.completedJobs,
    required this.totalQuotations,
    required this.pendingQuotations,
    required this.acceptedQuotations,
    required this.totalEarnings,
    required this.averageRating,
    required this.totalRatings,
  });
}