public class SFDCCustomException extends Exception {
    Exception Error; 
    String ErrorString=null;  
    String notificationString=null; 
   /* public void SFDCCustomException(String errStr)
    {
        this.ErrorString=errStr; notificationString= 'There was exception while Processing request.'; System.debug('CUSTOM EXCEPTION: '+notificationString);

    }*/
    /* public void SFDCCustomException(String str, Exception e){
system.debug('Str'+str);
this.Error = e;
this.ErrorString= str;
notificationString= 'There was exception while Processing request<b>';
notificationString = notificationString+ErrorString+'<b>'+Error.getMessage(); 
System.debug('CUSTOM EXCEPTION: '+notificationString);     
}*/
}