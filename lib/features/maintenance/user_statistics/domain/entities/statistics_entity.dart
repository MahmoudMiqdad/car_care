class StatisticsEntity {
  final bool success;
  final StatisticsDataEntity data;

  StatisticsEntity({
    required this.success,
    required this.data,
  });
}

class StatisticsDataEntity {
  final int totalRequests;
  final int pendingRequests;
  final int acceptedRequests;
  final int completedRequests;
  final int cancelledRequests;

  StatisticsDataEntity({
    required this.totalRequests,
    required this.pendingRequests,
    required this.acceptedRequests,
    required this.completedRequests,
    required this.cancelledRequests,
  });
}