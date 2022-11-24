public class TFGetProductFromPCMById {

    public class Identifier {
		public String code {get;set;} 
		
	}
	
	public class Category {
		
	}
	
	public class Keywords {
		public String description {get;set;} 
		public String name {get;set;} 
		public Integer position {get;set;} 
		
	}
	
	public String id {get;set;} //in JSON @id
	public String type {get;set;} //in JSON @type
	public String additionalType {get;set;} //in JSON @additionalType
	public String inLanguage {get;set;} 
	public String version {get;set;} 
	public String doi {get;set;} 
	public String ean {get;set;} 
	public String issn {get;set;} 
	public String sku {get;set;} 
	public String productID {get;set;} 
	public String description {get;set;} 
	public Long x_createdDate {get;set;} // in json: _createdDate
	public Long x_lastDateModified {get;set;} // in json: _lastDateModified
	public String dateCreated {get;set;} 
	public String dateModified {get;set;} 
	public String copyrightYear {get;set;} 
	public CopyrightHolder copyrightHolder {get;set;} 
	public String publisher {get;set;} 
	public List<Identifier> identifier {get;set;} 
	public List<Category> category {get;set;} 
	public List<Keywords> keywords {get;set;} 
	public List<Contributor> contributor {get;set;} 
	public List<Offers> offers {get;set;} 
	public List<PartsCount> partsCount {get;set;} 
	public String title {get;set;} 
	public String subtitle {get;set;} 

	
	public class PartsCount {
		public String type {get;set;}// In JSON @type
		public Integer count {get;set;} 
		public List<MediaTypeCount> mediaTypeCount {get;set;} 
		
	}
	
	public class MediaTypeCount {
		public String mediaType {get;set;} 
		public Integer count {get;set;} 
		
	}
	
	public class Contributor {
		public String familyName {get;set;} 
		public String givenName {get;set;} 
		public String name {get;set;} 
		public Integer position {get;set;} 
		public String role {get;set;} 
		
	}
	
	public class CopyrightHolder {
		public String name {get;set;} 		
	}
	
	public class Offers {
		public String price {get;set;} 
		public String priceCurrency {get;set;} 
		public String validFrom {get;set;} 		
	}
	
	
	public static TFGetProductFromPCMById parse(String json) {
		return (TFGetProductFromPCMById) System.JSON.deserialize(json, TFGetProductFromPCMById.class);
	}
}