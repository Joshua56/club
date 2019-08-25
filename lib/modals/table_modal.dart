class TableModal{
  final String id;
  final int maxNoChairs;
  final int minNoChairs;
  final double reserveCostPerChair;

  // TODO:
  // shedule

  TableModal({
    this.id,
    this.maxNoChairs = 1,
    this.minNoChairs = 1,
    this.reserveCostPerChair = 0.0,
  });
}