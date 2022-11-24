global with sharing class TF_PPDImageUploadToS3 {
    public string awsKey {get;set;}
    public string awsSecret {get;set;}
    public string bucketName {get;set;}
    public string methodName {get;set;}
    public string hostName {get;set;}
    TF_AwsRestWrapper  tFAwsImageWrapper = new TF_AwsRestWrapper();

    
    public class ImgUploadDetails {  
        @AuraEnabled
        public String imgBundleId { get;set; }  
        @AuraEnabled
        public String imgtitle { get;set; }  
        @AuraEnabled
        public Integer imgSize { get;set; }
        @AuraEnabled
        public String imgFileUrl { get;set; }
        }
    
    public TF_PPDImageUploadToS3() {
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            awsKey = (String) orgSpecificProps.get('AWS_Access_Key_Id__c');
            awsSecret = (String) orgSpecificProps.get('AWS_Secret_Access_key__c');
            bucketName = (String) orgSpecificProps.get('AWS_S3_Approved_Bucket_ImageUpload__c');
            String hostUrl = 'https://'+ bucketName + (String) orgSpecificProps.get('AWS_S3_Host_Url__c');
            methodName='PUT';
            hostName='s3.eu-west-1.amazonaws.com';
    }
    
    public string ContentType(string fileType){
        switch on fileType.toLowerCase()
        {
            when 'docx'
            {
                return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
            }
            when 'csv'
            {
                return 'application/vnd.ms-excel';
            }
            when 'wav'
            {
                return 'audio/wav';
            }
            when 'wmv'
            {
                return 'video/x-ms-wmv';
            }
            when 'mp3'
            {
                return 'audio/mpeg';
            }
            when 'mp4'
            {
                return 'video/mp4';
            }
            when 'png'
            {
                return 'image/png';
                
            }
            when 'pdf'
            {
                return 'application/pdf';
                
            }
            when else {
                return 'image/jpeg';
            }
        }
    }
    
    public string CreateAuthHeader(String contentType,
                                   String filename, String formattedDateString){
                                       string auth;
                                       String stringToSign = this.methodName+'\n\n'+contentType+'\n'+formattedDateString+'\n/'+this.bucketName+'/'+filename.toLowerCase();
                                       Blob mac = Crypto.generateMac('HMACSHA1', blob.valueof(stringToSign),blob.valueof(this.awsSecret));
                                       String sig = EncodingUtil.base64Encode(mac);
                                       auth = 'AWS' + ' ' + this.awsKey + ':' + sig;
                                       return auth;
                                   }
    
    
   /* public void UploadDocuments_temp(List<string> ids, String bundleId){
        system.debug('UploadDocuments Entered');
        list<ImgUploadDetails>imgdetail =new List<ImgUploadDetails>();
        List<ContentVersion> versions=[SELECT VersionData,Title,ContentDocumentId,FileExtension, ContentSize  FROM ContentVersion WHERE ContentDocumentId = :ids AND IsLatest = true];
        Product2 product = new Product2();
        product = [SELECT Id,hub_id__c FROM Product2 WHERE id = :bundleID limit 1];
        String uuid=product.hub_id__c;
        String imgBannertitle;
        STring imgBannerSize;
        String imgBannerFileUrl;
        
        for(ContentVersion attach:versions){
            try 
            {
                ImgUploadDetails imgdet =new ImgUploadDetails();
                String attachmentBody = EncodingUtil.base64Encode(attach.VersionData);
                String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
                String accessType = 'public-read';
                String filename = attach.Title;
                string contentType=ContentType(attach.FileExtension);
                system.debug('contentType:'+contentType);
                
                
                string fileUrl='https://' + this.bucketName + '.' + this.hostName + '/' + 'collection' + '/' + uuid + '/' + filename.toLowerCase();
              
                HttpRequest req = new HttpRequest();
                req.setMethod(this.methodName);
                req.setEndpoint(fileUrl);
                req.setHeader('Host', this.bucketName + '.' + this.hostName);
                req.setHeader('Content-Length', String.valueOf(attachmentBody.length()));
                req.setHeader('Content-Encoding', 'UTF-8');
                req.setHeader('Content-type', contentType);
                req.setHeader('Connection', 'keep-alive');
                req.setHeader('Date', formattedDateString);
                req.setHeader('ACL', accessType);
                
                Blob fBlob = EncodingUtil.base64Decode(attachmentBody);
            	req.setBodyAsBlob(fBlob);
                filename= 'collection' + '/' + uuid + '/'+ filename;
                req.setHeader('Authorization',CreateAuthHeader(contentType, filename, formattedDateString));
                
                Http http = new Http();
                HTTPResponse res = http.send(req);
                system.debug('statusCode'+ res.getStatusCode());
                system.debug('getStatus'+ res.getStatus());
                system.debug('getBodyAsBlob'+ res.getBodyAsBlob());
                system.debug('getBody()'+ res.getBody());
 
                 imgdet.imgFileUrl=fileUrl;
                 imgdet.imgtitle=attach.title;
                system.debug('checkentryofloop##'+imgdet.imgtitle);
                 imgdet.imgsize=attach.ContentSize;
                 imgdet.imgBundleId=bundleId;
                if (res.getStatusCode() == 200 || res.getStatusCode()==201) 
                {
                    system.debug('Success'); 
                    system.debug('fileUrl'+fileUrl);
                  
                }
                else{
                    system.debug('Failed');
                    system.debug('fileUrl'+fileUrl);
                }
               imgdetail.add(imgdet); 
            }
            catch(Exception ex)
            {
              system.debug(ex.getStackTraceString());
              
            }
            
        }
       
        savePrdImageS3Details(imgdetail);
        
    }*/
    //method to access S3 Bucket via named credentials 
    /*public void UploadDocuments_named(List<string> ids, String bundleId){
        system.debug('Entered UploadDocuments by named credentials');
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        list<ImgUploadDetails>imgdetail =new List<ImgUploadDetails>();
        List<ContentVersion> versions=[SELECT VersionData,Title,ContentDocumentId,FileExtension, ContentSize  FROM ContentVersion WHERE ContentDocumentId = :ids AND IsLatest = true];
        Product2 product = new Product2();
        product = [SELECT Id,hub_id__c FROM Product2 WHERE id = :bundleID limit 1];
        String uuid=product.hub_id__c;
        String imgBannertitle;
        STring imgBannerSize;
        String imgBannerFileUrl;
         DateTime now = DateTime.now(); 
        
        for(ContentVersion attach:versions){
            try
            {
                ImgUploadDetails imgdet =new ImgUploadDetails();
                String attachmentBody = EncodingUtil.base64Encode(attach.VersionData);
                String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
                String accessType = 'public-read-write';
                String filename = attach.Title;
                string contentType=ContentType(attach.FileExtension);
                system.debug('contentType:'+contentType);
                
                  string fileUrl='https://' + this.bucketName + '.' + this.hostName + '/' + 'collection' + '/' + uuid + '/' + filename.toLowerCase();
                string fileUrlForNamedCred= '/' + 'collection' + '/' + uuid + '/' + filename.toLowerCase();
              
              HttpRequest req = new HttpRequest();
              req.setEndpoint('callout:AWS_S3' + fileUrlForNamedCred);
		      req.setMethod('PUT');
			  req.setHeader('Content-Encoding', 'UTF-8');
              req.setHeader('Content-type', contentType);
              req.setHeader('Connection', 'keep-alive');
              req.setHeader('Date', formattedDateString);
              req.setHeader('ACL', accessType);
              Blob fBlob = EncodingUtil.base64Decode(attachmentBody);
              req.setBodyAsBlob(fBlob);
                

			  Http http = new Http();
			  HTTPResponse res = http.send(req);
			  System.debug(res.getBody());
			  System.debug(res.getStatusCode());
			  System.debug(res.getStatus());
                
                 imgdet.imgFileUrl=fileUrl;
                 imgdet.imgtitle=attach.title;
                system.debug('checkentryofloop##'+imgdet.imgtitle);
                 imgdet.imgsize=attach.ContentSize;
                 imgdet.imgBundleId=bundleId;
                if (res.getStatusCode() == 200 || res.getStatusCode()==201) 
                {
                    system.debug('Success'); 
                    system.debug('fileUrl'+fileUrl);
                         
                }
                else{
                    system.debug('Failed');
                    system.debug('fileUrl'+fileUrl);
                }
               imgdetail.add(imgdet); 
            }
            catch(Exception ex)
            {
              system.debug(ex.getStackTraceString());
              
            }
            
        }
       
        savePrdImageS3Details(imgdetail);
    }*/
    
    
    //method with custom cannonical request
     public void UploadDocuments(List<string> ids, String bundleId){
        system.debug('Entered UploadDocuments by cannonical request');
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
        list<ImgUploadDetails>imgdetail =new List<ImgUploadDetails>();
        List<ContentVersion> versions=[SELECT VersionData,Title,ContentDocumentId,FileExtension, ContentSize  FROM ContentVersion WHERE ContentDocumentId = :ids AND IsLatest = true];
        Product2 product = new Product2();
        product = [SELECT Id,hub_id__c FROM Product2 WHERE id = :bundleID limit 1];
        String uuid=product.hub_id__c;
        String imgBannertitle;
        STring imgBannerSize;
        String imgBannerFileUrl;
        DateTime now = DateTime.now(); 
         
         String folderPath = '';
            String regionName = (String) orgSpecificProps.get('AWS_Region_Name__c');
            String keyAccessId = (String) orgSpecificProps.get('AWS_Access_Key_Id__c');
            String secretAccessKey = (String) orgSpecificProps.get('AWS_Secret_Access_key__c');
            String hostUrl = 'https://'+ this.bucketName + (String) orgSpecificProps.get('AWS_S3_Host_Url__c');
        
        for(ContentVersion attach:versions){
            try
            {//File Content
                ImgUploadDetails imgdet =new ImgUploadDetails();
                String attachmentBody = EncodingUtil.base64Encode(attach.VersionData);
                String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
                String accessType = 'public-read-write';
                String filename = attach.Title;
                string contentType=ContentType(attach.FileExtension);
                system.debug('contentType:'+contentType);
                
               string fileUrl='https://' + this.bucketName + '.' + this.hostName;
               string saveFileUrl='https://' + this.bucketName + '.' + this.hostName + '/' + 'collection' + '/' + uuid + '/' + filename.toLowerCase();
               string imagefileName= 'collection' + '/' + uuid + '/' + filename.toLowerCase();
  
              Blob fBlob = EncodingUtil.base64Decode(attachmentBody);
              String response = tFAwsImageWrapper.putCollectionImageonS3(fBlob ,contentType, regionName, folderPath, imagefileName, bundleID, keyAccessId, secretAccessKey, fileUrl);
                
                
                 imgdet.imgFileUrl=saveFileUrl;
                 imgdet.imgtitle=attach.title;
                 system.debug('checkentryofloop##'+imgdet.imgtitle);
                 imgdet.imgsize=attach.ContentSize;
                 imgdet.imgBundleId=bundleId;
                 if(response != null){
                    System.debug('Product Placed in S3');
                    
                } else {
                    System.debug('Error Placing the product in S3');
                   
                } 
               imgdetail.add(imgdet); 
            }
            catch(Exception ex)
            {
              system.debug(ex.getStackTraceString());
              
            }
            
        }
        // savePrdImageS3Details(bundleId,fileUrl,attach.title,attach.ContentSize);
        savePrdImageS3Details(imgdetail);
    }
    
    
    public void savePrdImageS3Details(List<ImgUploadDetails>imgDetail){
        system.debug('savePrdImageS3Details entered');
        for(ImgUploadDetails img:imgDetail){
            system.debug('title' +img.imgtitle);
            String imageType;
        Product2 product = new Product2();
        product = [SELECT Id,hub_id__c FROM Product2 WHERE id = :img.imgBundleId limit 1];
        if(img.imgtitle.contains('_banner')){
            imageType='banner';
        }else if(img.imgtitle.contains('_cover')){
            imageType='cover';
        }
            system.debug('imageType###'+imageType);
        if(imageType=='banner'){
            product.Collection_Banner_Image_S3_location__c =img.imgFileUrl;
            product.Collection_Banner_Image_Size__c =String.valueOf(img.imgSize);
            update product;
            system.debug('banner image details updated');
        }else if(imageType=='cover'){
            product.Collection_Cover_Image_S3_location__c =img.imgFileUrl;
            product.Collection_Cover_Image_Size__c =String.valueOf(img.imgSize);
            update product;
            system.debug('cover image details updated');
        }
        }
    }
    
   //method to download images from s3 url
    public List<String> DownloadDocuments(String bundleId){
        
        TF_AwsRestWrapper tFAwsImageWrapper=new TF_AwsRestWrapper();
        Product2 product = new Product2();
        product = [SELECT Id,hub_id__c,Business_Id_Calc__c,Collection_Banner_Image_S3_location__c,Collection_Cover_Image_S3_location__c ,Collection_Banner_Image_Size__c ,Collection_Cover_Image_Size__C FROM Product2 WHERE id = :bundleID limit 1];
       
        String uuid=product.hub_id__c;
        String bannerResponse='';
        String coverResponse='';
        String imgBannertitle='';
        String fileBannerUrl='';
        Integer intIndex=0;
        String imgBannerSize='';
        String imgBannerFileUrl='';
        String bannerContentType='';
        
        String imgCovertitle='';
        String fileCoverUrl='';
        Integer intcoverIndex=0;
        String imgCoverSize='';
        String imgCoverFileUrl='';
        String coverContentType='';
        
 		if(product.Collection_Banner_Image_S3_location__c!=null){
        imgBannertitle=product.Collection_Banner_Image_S3_location__c;
        fileBannerUrl=imgBannertitle;
        intIndex = imgBannertitle.lastindexOf('/');
        imgBannertitle=imgBannertitle.right(imgBannertitle.length()-intIndex-1);
        bannerContentType=imgBannertitle.substringAfter('.');
        //imgBannertitle=product.Business_Id_Calc__c +'_'+ 'bannerimage'+ '.' + bannerContentType;
        imgBannerSize=product.Collection_Banner_Image_Size__c;
        imgBannerFileUrl=product.Collection_Banner_Image_S3_location__c;
       
        }
        if(product.Collection_Cover_Image_S3_location__c!=null){
        imgCovertitle=product.Collection_Cover_Image_S3_location__c;
        fileCoverUrl=imgCovertitle;
        intCoverIndex = imgCovertitle.lastindexOf('/');
        imgCovertitle=imgCovertitle.right(imgCovertitle.length()-intCoverIndex-1);
        coverContentType=imgCovertitle.substringAfter('.');
        //imgCovertitle=product.Business_Id_Calc__c +'_'+ 'coverimage'+ '.' + coverContentType;
        imgCoverSize=product.Collection_Cover_Image_Size__C;
        imgCoverFileUrl=product.Collection_Cover_Image_S3_location__c;
            } 
        DateTime now = DateTime.now();
         
        TF_OrgSpecificProps__c orgSpecificProps = TF_OrgSpecificProps__c.getOrgDefaults();
            String folderpath='collection/'+ uuid;
            String regionName = (String) orgSpecificProps.get('AWS_Region_Name__c');
            String keyAccessId = (String) orgSpecificProps.get('AWS_Access_Key_Id__c');
            String secretAccessKey = (String) orgSpecificProps.get('AWS_Secret_Access_key__c');
            String bucketName = (String) orgSpecificProps.get('AWS_S3_Approved_Bucket_ImageUpload__c');
            String hostUrl = 'https://'+ bucketName + (String) orgSpecificProps.get('AWS_S3_Host_Url__c');
       
        if(imgBannerFileUrl!=null){
            bannerResponse = tFAwsImageWrapper.getImage(regionName, folderPath, imgBannertitle, imgBannertitle, keyAccessId, secretAccessKey, hostUrl);
            system.debug('bannerResponse###'+bannerResponse);     
        } 
        
        if(imgCoverFileUrl!=null){
            coverResponse = tFAwsImageWrapper.getImage(regionName, folderPath, imgCovertitle, imgCovertitle, keyAccessId, secretAccessKey, hostUrl);
            system.debug('coverResponse###'+coverResponse); 
        }
        List<String>imageResponse =new List<String>();
        if(bannerResponse!=null){
            
            imageResponse.add(bannerResponse);
            imgBannertitle=product.Business_Id_Calc__c +'_'+ 'bannerimage' + '.' +bannerContentType;
            TF_PPDProcessController.uploadImageFile(bundleId,imgBannertitle,bannerResponse,bannerContentType);
        }
        
        if(coverResponse!=null){
            imageResponse.add(coverResponse);
            imgCovertitle=product.Business_Id_Calc__c +'_'+ 'coverimage' + '.' +coverContentType;
            TF_PPDProcessController.uploadImageFile(bundleId,imgCovertitle,coverResponse,coverContentType);
        }
        return imageResponse;
    }
 
    
    
}