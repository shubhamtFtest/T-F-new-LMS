public class TFCollectionPartsDocument {

	public String id;
	public List<Parts> parts;
    public String partsCount;

	public class Parts {
		public String id; // in json: @id
		public String type; // in json: @type
        public String doi;
        public String curationSource;
		public Boolean isAccessibleForFree;
		public List<IsPartOf> isPartOf;
		public Boolean openAccess;
		public Integer position;
        public String publicationDate;
		public String publisherImprint;
		public String title;
		public List<Contributors> contributors;
	}

	public class IsPartOf {
		public String title;
		public String format;
		public String doi;
		public String publishedDate;
		public List<Contributors> contributors;
		public String id; // in json: @id
		public String type; // in json: @type
	}

	public class Contributors {
		public List<String> roles;
		public String givenName;
		public String familyName;
		public String fullName;
		public Integer position;
	}

	public static TFCollectionPartsDocument parse(String json) {
		return (TFCollectionPartsDocument) System.JSON.deserialize(json, TFCollectionPartsDocument.class);
	}
}