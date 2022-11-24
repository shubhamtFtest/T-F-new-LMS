public interface DiscountCalculator {
    List<DiscountRequest> getDiscountBulk(List<DiscountRequest> requestList);
}