//
public class PCMProductResponseWrapper{
    public cls_availability[] availability;
    public cls_product product;
    public class cls_availability {
        public String name;	//SFDC
        //public cls_status[] status;
        //public cls_errors[] errors;
    }
    public class cls_status {
    }
    
    public class cls_product {
        public String uuid;	//0002d4d1-e71b-472d-8689-05e74f740339
        public String type;	//book
        public String version;	//1.0.0
        public String title;	//Basics of Quantum Physics
        public cls_categories[] categories;
        public cls_classifications[] classifications;
        public cls_keywords[] keywords;
        public cls_contributors[] contributors;
        public cls_isPartOf[] isPartOf;
        public cls_prices[] prices;
        public cls_permissions[] permissions;
        public cls_rights[] rights;
        public cls_audience[] audience;
        public cls_discountGroups[] discountGroups;
        public cls_book book;
        public cls_identifiers identifiers;
        public cls_impressionLocations[] impressionLocations;
        public cls_associatedMedia[] associatedMedia;
    }
    public class cls_categories {
        public String code;	//6A
        public String name;	//Physics US
        public String type;	//flexcat
    }
    public class cls_classifications {
        public Integer level;	//4
        public Integer priority;	//5
        public cls_group validgroup;
        public String code;	//SCMA202530
        public String name;	//Quantum Mechanics
        public String type;	//subject
    }
    public class cls_group {
    }
    public class cls_keywords {
        public String type;	//catchword
        public String name;	//Shrodinger Equation
        public Integer position;	//1
        public cls_weightage weightage;
    }
    public class cls_weightage {
    }
    public class cls_contributors {
        //public cls_roles[] roles;
        public String givenName;	//Jaroslaw
        public String familyName;	//Nowak
        public String fullName;	//Jaroslaw Nowak
        public cls_affiliations[] affiliations;
        public Integer position;	//1
    }
    
    
    public class cls_affiliations {
        public String name;	//Lancaster University
        public cls_department department;
        public cls_address address;
    }
    public class cls_department {
    }
    public class cls_address {
    }
    public class cls_isPartOf {
        public String partid;	//619e61a2-2688-4ea4-96c0-dd4ef8c7e4fd
        public String type;	//collection
        public Integer level;	//1
        public Integer position;	//3480
        public cls_title title;
        public cls_identifiers identifiers;
    }
    class cls_title {
    }
    public class cls_identifiers {
        public String isbn;	//9780367433567
        public String dacKey;	//C2019-0-07661-0
        public String editionId;	//800720
        public cls_doi doi;
        public String orderNumber;	//342522
        public String titleId;	//419431
        //public cls_sku sku;
    }
    public class cls_prices {
        public Integer price;	//200
        public String currencyvalue;	//USD
        public String validFrom;	//2019-08-13T00:00:00.000Z
        public cls_validTo validTo;
        public String priceType;	//Retail Price
        public String priceTypeCode;	//LP
    }
    public class cls_validTo {
    }
    public class cls_permissions {
        public String name;	//EBRALL
        public String code;	//EBRALL
        public String text;	//Institutional, retail and Atypon
        public String type;	//access
        public cls_description description;
        public cls_validTo validTo;
        public cls_validFrom validFrom;
    }
    public class cls_description {
    }
    public class cls_validFrom {
    }
    public class cls_rights {
    }
    public class cls_audience {
        public String code;	//RUGA
        public String description;	//Undergraduate Advanced
    }
    public class cls_discountGroups {
        public String code;	//TEXT
        public String description;	//Textbook
    }
    public class cls_book {
        public String subtitle;	//A Journey From Classical to Quantum Physics
        public cls_description description;
        public cls_shortDescription shortDescription;
        public String publisherImprint;	//CRC Press
        public cls_publisherImprintCode publisherImprintCode;
        public cls_publicationDate publicationDate;
        public cls_copyright copyright;
        public Integer edition;	//1
        public boolean doiRegistrationStatus;
        public String firstPublishedYear;	//2021
        public String plannedPublicationDate;	//2021-05-30T00:00:00.000Z
        public String inLanguage;	//eng
        public cls_abstracts[] abstracts;
        public cls_citation citation;
        public String shortTitle;	//Nowak - BASICS OF QUANTUM PHYSICS
        public String bindingStyle;	//Cased (DesPPC)
        public String bindingStyleCode;	//HBK3
        public String publicationLocation;	//Boca Raton
        public cls_legacyDivision legacyDivision;
        public cls_formerImprints[] formerImprints;
        public String legalOwner;	//US
        public cls_bibliographicSpecification bibliographicSpecification;
        public cls_productionSpecification productionSpecification;
        public String formatCode;	//HARD
        public String format;	//Hardback
        public String textType;	//Textbook (Standard) (DRM-Free)
        public String textTypeCode;	//020
        public String publisherArea;	//Science
        public String publisherAreaCode;	//SCIENCE
        public String division;	//Physics
        public String divisionCode;	//PHYS
        public String status;	//Contracted
        public String statusCode;	//EVT
        public String toc;	//<![CDATA[Chapter 1: Intro to quantum physics. Chapter 2. Planck's hypothesis and the birth of quantum physics. Chapter 3: Wave particle duality. Chapter 4: Schrödinger Equation. Chapter 5: Solutions of the Schrödinger Equation. Chapter 6: Relativistic quantum physics. Chapter 7: Interpretations of the Schrödinger Equation and the Wave Function. Chapter 8: Supporting calculations.]]>
        public cls_counts[] counts;
        public cls_fundingGroups fundingGroups;
        public cls_license license;
        public cls_coPublishers coPublishers;
        public cls_groupOfCompany groupOfCompany;
        public boolean podSuitable;
    }
    class cls_shortDescription {
    }
    class cls_publisherImprintCode {
    }
    class cls_publicationDate {
    }
    class cls_copyright {
        public cls_holder holder;
        public Integer year;	//2021
        public cls_statement statement;
    }
    class cls_holder {
    }
    class cls_statement {
    }
    class cls_abstracts {
    }
    class cls_citation {
    }
    class cls_legacyDivision {
    }
    class cls_formerImprints {
        public cls_code code;
        public cls_description description;
    }
    class cls_code {
    }
    class cls_bibliographicSpecification {
        public String format;	//US3
        public cls_height height;
        public cls_width width;
        public cls_weight weight;
    }
    class cls_height {
    }
    class cls_width {
    }
    class cls_weight {
    }
    class cls_productionSpecification {
        public String basicColor;	//1 colour
    }
    class cls_counts {
        public String type;	//pagesArabic
        public Integer count;	//250
    }
    class cls_fundingGroups {
    }
    class cls_license {
    }
    class cls_coPublishers {
    }
    class cls_groupOfCompany {
    }
    class cls_doi {
    }
    class cls_sku {
    }
    class cls_impressionLocations {
        public cls_discountGroups[] discountGroups;
        public cls_distributionCenter distributionCenter;
        public String plannedPublicationDate;	//2021-06-20T00:00:00.000Z
        public cls_publicationDate publicationDate;
        public boolean mainLocation;
    }
    class cls_distributionCenter {
        public String code;	//AUS
        public String location;	//Australia - TLD
        public cls_stockStatus[] stockStatus;
        public cls_status status;
        public cls_statusCode statusCode;
    }
    class cls_stockStatus {
    }
    class cls_statusCode {
    }
    class cls_associatedMedia {
    }
    public static PCMProductResponseWrapper parse(String json){
        return (PCMProductResponseWrapper) System.JSON.deserialize(json, PCMProductResponseWrapper.class);
    }
}