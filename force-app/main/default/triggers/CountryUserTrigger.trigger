/**************************************************************
* Created by Shay Spoonmore (shay.spoonmore@informausa.com)
**************************************************************/

trigger CountryUserTrigger on User (before insert, before update) {
    CopyCountryFromPickList.UserCountry(Trigger.new);
}