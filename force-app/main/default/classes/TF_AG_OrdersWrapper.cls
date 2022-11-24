public class TF_AG_OrdersWrapper {

@AuraEnabled	public List<Data> data;
@AuraEnabled	public Integer page;
@AuraEnabled	public Integer totalPages;
@AuraEnabled	public Integer pageSize;

	public class Data {
	@AuraEnabled	public String accountId;
	@AuraEnabled	public String orderId;
	@AuraEnabled	public String orderValue;
	@AuraEnabled	public String isbn;
	@AuraEnabled	public String titleFull;
	@AuraEnabled	public String quantity;
	@AuraEnabled	public String titleStatus;
	@AuraEnabled	public String publishPrice;
	@AuraEnabled	public String discountPercentage;
	}
}