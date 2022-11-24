//This class is created for scheduling batch class : TF_LicenseExpirationBatch

global class TF_LicenseExpirationBatch_Schedule implements Schedulable 
{
   global void execute(SchedulableContext ctx) 
   {
       TF_LicenseExpirationBatch b = new TF_LicenseExpirationBatch();
       Database.executebatch(b);
   }   
}