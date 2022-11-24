//Ztest_TFGetProductsFromPCMById
public class TFGetProductsFromPCMById {

	public class Copyright {
		public String holder {get;set;} 
		public Integer year {get;set;} 
		public String statement {get;set;} 		
	}
	
	public class Prices {
		public Decimal price {get;set;} 
		public String currency_Z {get;set;} //In JSON currency
		public String validFrom {get;set;} 
		public String validTo {get;set;} 
		public String priceType {get;set;} 
		public String priceTypeCode {get;set;} 
	}
	
	public class Counts {
		public String type_Z {get;set;} // in json: type
		public Integer count {get;set;} 
		public List<FormatsCount> formatsCount {get;set;} 
	}
	
	public class FormatsCount_Z {
		public String format {get;set;} 
		public Integer count {get;set;}
	}
	
	public class Keywords {
		public String type_Z {get;set;} // in json: type
		public String name {get;set;} 
		public Integer position {get;set;} 
		public String weightage {get;set;} 
	}
	
	public Product product {get;set;} 
	public List<FormatsCount> availability {get;set;} 	
	
	public class Categories {
		public String code {get;set;} 
		public String name {get;set;} 
		public String type_Z {get;set;} // in json: type		
	}
	
	public class FormatsCount {
		
	}
	
	public class Collection {
		public List<Counts> counts {get;set;} 
		public String subtitle {get;set;} 
		public String description {get;set;} 
		public String publisherImprint {get;set;} 
		public String publicationDate {get;set;} 
		public Copyright copyright {get;set;} 
		public String edition {get;set;} 
		public Boolean doiRegistrationStatus {get;set;} 
		public String firstPublishedYear {get;set;} 
		public String plannedPublicationDate {get;set;} 
		public String inLanguage {get;set;} 
		public List<FormatsCount> abstracts {get;set;} 
		public String citation {get;set;} 		
	}
	
	public class Product {
		public String x_id {get;set;} // in json: _id
		public Identifiers identifiers {get;set;} 
		public Collection collection {get;set;} 
		public List<Prices> prices {get;set;} 
		public String type_Z {get;set;} // in json: type
		public String version {get;set;} 
		public String title {get;set;} 
		public List<Categories> categories {get;set;} 
		public List<FormatsCount> classifications {get;set;} 
		public List<Keywords> keywords {get;set;} 
		public List<FormatsCount> contributors {get;set;} 
		public List<FormatsCount> isPartOf {get;set;} 
		public List<FormatsCount> permissions {get;set;} 
		public List<FormatsCount> rights {get;set;} 
		public List<FormatsCount> audience {get;set;} 
		public List<FormatsCount> associatedMedia {get;set;}		
	}
	
	public class Identifiers {
		public String doi {get;set;} 
		public String sku {get;set;} 
	}
	
	
	public static TFGetProductsFromPCMById parse(String json) {
		return (TFGetProductsFromPCMById) System.JSON.deserialize(json, TFGetProductsFromPCMById.class);
	}
	   
}