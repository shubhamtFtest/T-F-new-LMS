public class EntitlementDataWrapper{
	//public paginatedSearchDetails paginatedSearchDetails;
	//public counts counts;
	public data[] data;
	public Integer count;	//145
	//public drmProductsCount drmProductsCount;
	
	public class data {
		public Integer id;	//437615646
		public String createdOn;	//2022-02-09T06:17:51.947+0000
		public String customerId;	//98422
		public String licenseId;	//118415
		public String status;	//ACTIVE
		public product product;
		public String packageId;	//38149258
		public String accessScope;	//GLOBAL
		public Integer policyXrefId;	//33669007
	}
	public class product {
		public String id;	//0023303d-524f-49a0-93a5-00db3ccb9a39
		public String updatedOn;	//2022-02-17T13:41:22.025+0000
		public String isbn;	//9781003099277
		public String name;	//Practical Handbook of Microbiology
		public String doi;	//10.1201/9781003099277
		public String type;	//BOOK
		public boolean openAccess;
		public String publicationDate;	//2021-05-05T00:00:00.000+0000
		public String status;	//VALID
		public Integer firstPublishedYear;	//2021
		public String dacKey;	//C2020-0-16421-5
		public String hashCode;	//67651df25ae337547e52d35d224375fa1f2efddf
		public boolean drm;
	}
	
	public static EntitlementDataWrapper parse(String json){
		return (EntitlementDataWrapper) System.JSON.deserialize(json, EntitlementDataWrapper.class);
	}
}