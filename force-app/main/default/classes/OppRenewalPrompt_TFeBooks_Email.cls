//Class: OppRenewalPrompt_TFeBooks_Email.cls
//Tested by: zTEST_OppRenewalTFeBooks.cls
//Created by Jeff Lup - 2014.11.17 - T&F ERN Project
//Modified by Bharat - 2017.12.21 - CHG0039924
//Modified by Jeff Lup - 2018.03.08 - CHG0042222 - updated the email body
//Modified by Matthew Smith - 2020.05.04 - 01476512 - Updating the emails which are sent to Samantha, as she's going on maternity leave. So sending customer responses to shared CSD inbox. Plus, updating the email sent to the customer, so the signature is no longer Samantha

public class OppRenewalPrompt_TFeBooks_Email {
    
    public Static String getEmail(Opportunity opp, List<OpportunityLineItem> olis, OpportunityContactRole ocr) {
        
        TF_ERN_Settings__c setting = TF_ERN_Settings__c.getOrgDefaults();
        String linkEmailAddress = setting.Inbound_Email_Service_Address__c; 
        String linkCCAddress = setting.Inbound_Email_CC_Address__c; 
        String emailHeaderImage = setting.Email_Header_Image__c;
        String emailFooterImage = setting.Email_Footer_Image__c;
          //Updated By Chetan
        String strBaseUrl=System.URL.getSalesforceBaseUrl().toExternalForm();
        
        Date expirationDate = opp.Previous_Renewal__r.End_Date__c;
        if (expirationDate == null && opp.Start_Date__c != null)
            expirationDate = opp.Start_Date__c.addDays(-1);
        
        //String accName = ocr.Contact.Account.Name !=null ? ocr.Contact.Account.Name : ''; // @@ CHG0031935
        //String accName = opp.AccountID !=null ? opp.Account.name :ocr.Contact.Account.Name; // @@ CHG0031935
        
        //CHG0042222
        String accName = '';
        if (opp.AccountID != null && opp.Account.Name != null)
            accName = opp.Account.name;
        else if (opp.AccountID != null)
            accName = [SELECT Name FROM Account WHERE Id = :opp.AccountID].Name; //the trigger has no knowledge of opp.Account.name
        else
            accName = ocr.Contact.Account.Name;
        
        String emailBody = ''
            + '<style>'
            + '    p{'
            + '        margin-top:0px;'
            + '        margin-bottom:0px;'
            + '    }'
            + '</style>'
            + '<body class="setupTab"  onload="init()"  style=" background-color:#CCCCCC; bLabel:body; bEditID:b1st1;">'
            + '    <center >'
            + '        <table id="topTable" height="450" width="500" cellpadding="0" cellspacing="0" >'
            + '            <tr valign="top" >'
            + '                <td  style=" vertical-align:top; height:100; text-align:center; background-color:#FFFFFF; bLabel:header; bEditID:r1st1;">'
            + '                    <img id="r1sp1" bLabel="headerImage" border="0" bEditID="r1sp1" src="' + emailHeaderImage + '" />'
            + '                </td>'
            + '            </tr>'
            + '            <tr valign="top" >'
            + '                <td  style=" height:5; background-color:#AAAAFF; bLabel:accent1; bEditID:r2st1;">'
            + '                </td>'
            + '            </tr>'
            + '            <tr valign="top" >'
            + '                <td styleInsert="1" height="300"  style=" color:#000000; font-size:10pt; background-color:#FFFFFF; font-family: Arial, Helvetica, sans-serif; bLabel:main; bEditID:r3st1;">'
            + '                    <table height="400" width="550" cellpadding="5" border="0" cellspacing="5" >'
            + '                        <tr height="400" valign="top" >'
            + '                            <td style=" color:#000000; font-size:10pt; background-color:#FFFFFF; font-family: Arial, Helvetica, sans-serif; bLabel:main; bEditID:r3st1;" tEditID="c1r1" aEditID="c1r1" locked="0" >';
        
        emailBody += 'Dear '+accName+',';
        emailBody += '<br/><br/>';
        
        //One product
        if (olis.size() == 1) {
            emailBody += 'This message serves as a reminder that your subscription of ' + olis[0].Product2.Name + ' is due to expire on ' + MiscFunctions.convertDateToString_MMM_d_yyyy(expirationDate) + '.' + ' The renewal rate for an annual subscription is $'+MiscFunctions.formattedAmount(olis[0].TotalPrice) + ' (plus applicable tax).' ;
        
        //Multiple products
        } else {
            emailBody += 'This message serves as a reminder that your subscriptions are due to expire on ' + MiscFunctions.convertDateToString_MMM_d_yyyy(expirationDate) + '.' + ' They can be renewed for another year at the annual subscription rates (pretax) shown below:';
            emailBody += '<br/><br/>';
            emailBody += '<table border="0" style="width:90%; font-size: 10pt; color:#000000; font-family: Arial, Helvetica, sans-serif;">';
            emailBody += '    <tr>';
            emailBody += '        <th width="10px"></th>';
            emailBody += '        <th style="text-align: left;">Product</th>';
            emailBody += '        <th style="text-align: right;">Quote</th>';
            
            emailBody += '    </tr>';
            for (OpportunityLineItem oli : olis) {
                emailBody += '    <tr>';
                emailBody += '        <td width="10px"></td>';
                emailBody += '        <td style="text-align: left;">' + oli.Product2.Name + '</td>';
                string currencySyntax='';
                if(opp.CurrencyIsoCode == 'USD' )
                    currencySyntax='$';
                else
                    currencySyntax=opp.CurrencyIsoCode;
                emailBody += '        <td style="text-align: right;">'+ currencySyntax + MiscFunctions.formattedAmount(oli.TotalPrice) +'</td>';
                emailBody += '    </tr>';
            }
            emailBody += '</table>';
        }
        
        //Common
        emailBody += '<br/><br/>';
        emailBody += 'Would you like to renew this subscription?';
        emailBody += '<table border="0" style="width: 90%; font-size: 10pt; color:#000000; font-family: Arial, Helvetica, sans-serif;">';
        String subjectText = ''; String replyText = '';
        String bodyText = 'Please provide any feedback in the body of this email, but do not change the email subject.'.replace(' ','%20');
      
        
        //One product
        if (olis.size() == 1) {
            subjectText = 'Renew'; replyText = 'Renew';
            emailBody += '    <tr>';
            emailBody += '        <td width="10px"></td>';
            emailBody += '        <td><a href="mailto:' + linkEmailAddress + '?cc=' + linkCCAddress + '&subject=' + subjectText + '%20%5Bref%3A%20' + opp.Id + '%5D&body=' + bodyText + '">' + replyText + '</a></td>';
            emailBody += '    </tr>';

        //Multiple products
        } else {
            subjectText = 'Renew'; replyText = 'Renew All Products';
            emailBody += '    <tr>';
            emailBody += '        <td width="10px"></td>';
            emailBody += '        <td><a href="mailto:' + linkEmailAddress + '?cc=' + linkCCAddress + '&subject=' + subjectText + '%20%5Bref%3A%20' + opp.Id + '%5D&body=' + bodyText + '">' + replyText + '</a></td>';
            emailBody += '    </tr>';
            subjectText = 'PartiallyRenew'; replyText = 'Renew Some Products';
            emailBody += '    <tr>';
            emailBody += '        <td width="10px"></td>';
            emailBody += '        <td><a href="mailto:' + linkEmailAddress + '?cc=' + linkCCAddress + '&subject=' + subjectText + '%20%5Bref%3A%20' + opp.Id + '%5D&body=' + bodyText + '">' + replyText + '</a></td>';
            emailBody += '    </tr>';
        }
        
        //Common
        subjectText = 'Decline'; replyText = 'Decline';
        emailBody += '    <tr>';
        emailBody += '        <td width="10px"></td>';
        emailBody += '        <td><a href="mailto:' + linkEmailAddress + '?cc=' + linkCCAddress + '&subject=' + subjectText + '%20%5Bref%3A%20' + opp.Id + '%5D&body=' + bodyText + '">' + replyText + '</a></td>';
        emailBody += '    </tr>';
        subjectText = 'Undecided'; replyText = 'Undecided';
        emailBody += '    <tr>';
        emailBody += '        <td width="10px"></td>';
        emailBody += '        <td><a href="mailto:' + linkEmailAddress + '?cc=' + linkCCAddress + '&subject=' + subjectText + '%20%5Bref%3A%20' + opp.Id + '%5D&body=' + bodyText + '">' + replyText + '</a></td>';
        emailBody += '    </tr>';
        subjectText = 'Speak'; replyText = 'I Want to Speak to my Sales Rep';
        emailBody += '    <tr>';
        emailBody += '        <td width="10px"></td>';
        emailBody += '        <td><a href="mailto:' + linkEmailAddress + '?cc=' + linkCCAddress + '&subject=' + subjectText + '%20%5Bref%3A%20' + opp.Id + '%5D&body=' + bodyText + '">' + replyText + '</a></td>';
        emailBody += '    </tr>';
        emailBody += '</table>';
        emailBody += '<br/><br/>';  
 
        emailBody += 'Once we receive confirmation, we will send along a new invoice. If you are issuing a purchase order, please do include the PO # with your renewal acceptance as well as any changes to your billing or contact information, as we certainly want to maintain the most up to date and accurate records.';
        emailBody += '<br/><br/>';
        emailBody += 'Please do not hesitate to contact us for any reason regarding your subscription and continued access. We look forward to hearing back from you and thank you in advance for your support of our online resources.';
        
        emailBody += '<br/><br/>';  
        emailBody += 'Kind Regards,<br/>';
        //emailBody += 'Samantha Given';
        emailBody += 'Subscription Renewals, EBooks – Americas<br/>';
        emailBody += 'Taylor & Francis<br/>';
        emailBody += 'am_renewals@taylorandfrancis.com';
        
        //emailBody += '<br/><br/>';  
        //emailBody += 'Renewals Manager - eBooks and Digital Content<br/>';
        //emailBody += 'Tel (toll free): 800.797.3803 x17119<br/>';
        //emailBody += 'Direct: 917.351.7119<br/>';
        
        //emailBody += 'samantha.given@taylorandfrancis.com<br/>';
                
        emailBody += ''
            + '                            </td>'
            + '                        </tr>'
            + '                    </table>'
            + '                </td>'
            + '            </tr>'
            + '            <tr valign="top" >'
            + '                <td  style=" height:5; background-color:#AAAAFF; bLabel:accent2; bEditID:r4st1;">'
            + '                </td>'
            + '            </tr>'
            + '            <tr valign="top" >'
            + '                <td  style=" vertical-align:middle; height:50; text-align:center; background-color:#FFFFFF; bLabel:footer; bEditID:r5st1;">'
            + '                    <img id="r5sp1" bLabel="footerImage" border="0" bEditID="r5sp1" src="' + emailFooterImage + '" />'
            + '                </td>'
            + '            </tr>'
            + '            <tr valign="top" >'
            + '                <td  style=" height:5; background-color:#AAAAFF; bLabel:accent3; bEditID:r6st1;">'
            + '                </td>'
            + '            </tr>'
            + '        </table>'
            + '    </center>'
            + ''
            + '<form action="#" method="GET" name="resizeData">'
           // + '    <input type="hidden"  id="baseUrl" name="baseUrl" value="https://cs17.salesforce.com" />'
             + '    <input type="hidden"  id="baseUrl" name="baseUrl" value="' + strBaseUrl + '" />'
            + '    <input type="hidden"  id="path" name="path" value="/email/templaterenderer" />'
            + '    <input type="hidden"  id="previewFrameName" name="previewFrameName" value="preview_frame" />'
            + '    <input type="hidden"  id="previewFrame" name="previewFrame" value="previewFrame" />'
            + '    <input type="hidden"  id="render_type_name" name="render_type_name" value="render_type" />'
            + '    <input type="hidden"  id="render_type" name="render_type" value="RESIZE_FRAME" />'
            + '    <input type="hidden"  id="previewWidthName" name="previewWidthName" value="preview_width" />'
            + '    <input type="hidden"  id="previewHeightName" name="previewHeightName" value="preview_height" />'
            + '</form>'
            + '<script src="/email/wysiwyg/resize.js"></script>'
            + '</body>';
        
        return emailBody;
    }
 
    /*
    public Static String getEmail(Opportunity opp, List<OpportunityLineItem> olis, OpportunityContactRole ocr) {

        TF_ERN_Settings__c setting = TF_ERN_Settings__c.getOrgDefaults();
        String linkEmailAddress = setting.Inbound_Email_Service_Address__c; 
        String linkCCAddress = setting.Inbound_Email_CC_Address__c; 
        String emailHeaderImage = setting.Email_Header_Image__c;
        String emailFooterImage = setting.Email_Footer_Image__c;
        // CHG0039924 get the custom setting to get the User Id
        BatchOppRenewal__c batsetting=BatchOppRenewal__c.getValues('UserID');
        string userId='';
        if(batsetting !=null){
            userId=batsetting.UserId__c;
        }
       

        Date expirationDate = opp.Previous_Renewal__r.End_Date__c;
        if (expirationDate == null && opp.Start_Date__c != null)
            expirationDate = opp.Start_Date__c.addDays(-1);
            
        String accName = opp.AccountID !=null ? opp.Account.name :ocr.Contact.Account.Name; // @@ CHG0031935
     // String accName = ocr.Contact.Account.Name !=null ? ocr.Contact.Account.Name : ''; // @@ CHG0031935
        String emailBody = ''
        + '<style>'
        + '    p{'
        + '        margin-top:0px;'
        + '        margin-bottom:0px;'
        + '    }'
        + '</style>'
        + '<body class="setupTab"  onload="init()"  style=" background-color:#CCCCCC; bLabel:body; bEditID:b1st1;">'
        + '    <center >'
        + '        <table id="topTable" height="450" width="500" cellpadding="0" cellspacing="0" >'
        + '            <tr valign="top" >'
        + '                <td  style=" vertical-align:top; height:100; text-align:center; background-color:#FFFFFF; bLabel:header; bEditID:r1st1;">'
        + '                    <img id="r1sp1" bLabel="headerImage" border="0" bEditID="r1sp1" src="' + emailHeaderImage + '" />'
        + '                </td>'
        + '            </tr>'
        + '            <tr valign="top" >'
        + '                <td  style=" height:5; background-color:#AAAAFF; bLabel:accent1; bEditID:r2st1;">'
        + '                </td>'
        + '            </tr>'
        + '            <tr valign="top" >'
        + '                <td styleInsert="1" height="300"  style=" color:#000000; font-size:10pt; background-color:#FFFFFF; font-family: Arial, Helvetica, sans-serif; bLabel:main; bEditID:r3st1;">'
        + '                    <table height="400" width="550" cellpadding="5" border="0" cellspacing="5" >'
        + '                        <tr height="400" valign="top" >'
        + '                            <td style=" color:#000000; font-size:10pt; background-color:#FFFFFF; font-family: Arial, Helvetica, sans-serif; bLabel:main; bEditID:r3st1;" tEditID="c1r1" aEditID="c1r1" locked="0" >';

                emailBody += 'Dear '+accName+',' ; //+getOppAccountName(opp.Id)+ ',';//emailBody += 'Dear Taylor and Francis Online Customer, ';  @@CHG0030462
        emailBody += '<br/><br/>';


        if (opp.Product_Family__c == 'netBase') {
            if (olis.size() == 1) {
                emailBody += 'This message serves as a reminder that your subscription of ' + olis[0].Product2.Name + ' is due to expire on ' + MiscFunctions.convertDateToString_MMM_d_yyyy(expirationDate) + '.';
                emailBody += '<br/><br/>';
                emailBody += 'As a valued CRCnetBASE customer you are eligible to renew your subscriptions at substantial discounts off our current subscription price. Your subscription can be renewed for another year at the annual rate of $'+MiscFunctions.formattedAmount(olis[0].TotalPrice) + ', (plus applicable tax).'+'  '+ 'Your netBASE product will be updated throughout the year as new content is released.';  // @@CHG0030462 
                emailBody += '<br/>';
               // emailBody += 'Your netBASE product will be updated throughout the year as new content is released.';
            //    emailBody += '<br/>';

                if (olis[0].Product2.Current_Year__c != null)
                    emailBody += '<br/>• ' + olis[0].Product2.Name + ' now includes over ' + olis[0].Product2.Current_Year_Number_of_Titles__c + ' titles worth more than ' + MiscFunctions.formattedAmount(olis[0].Product2.Current_Year_Value_of_Titles__c);
                if (olis[0].Product2.Next_Year__c != null)
                    emailBody += '<br/>• In ' + olis[0].Product2.Next_Year__c + ' ' + olis[0].Product2.Name + ' will continue to add over ' + olis[0].Product2.Next_Year_Number_of_Titles__c + ' books worth more than ' + MiscFunctions.formattedAmount(olis[0].Product2.Next_Year_Value_of_Titles__c);
                if (olis[0].Product2.Current_Year__c != null || olis[0].Product2.Next_Year__c != null)
                    emailBody += '<br/><br/>';
            } else {
                emailBody += 'This message serves as a reminder that your subscription is due to expire on ' + MiscFunctions.convertDateToString_MMM_d_yyyy(expirationDate) + '.';
                emailBody += '<br/><br/>';
                emailBody += 'As a valued CRCnetBASE customer you are eligible to renew your subscriptions at substantial discounts off our current subscription price. Your subscription can be renewed for another year at the annual subscription rates (pre tax) shown below:';
                emailBody += '<br/><br/>';
                emailBody += '<table border="0" style="width:90%; font-size: 10pt; color:#000000; font-family: Arial, Helvetica, sans-serif;">';
                emailBody += '    <tr>';
                emailBody += '        <th width="10px"></th>';
                emailBody += '        <th style="text-align: left;">Product</th>';
                
                 if(opp.OwnerId == userId){
                    system.debug('opp.Id'+opp.Id);
                    emailBody += '        <th style="text-align: right;">Quote</th>';
                }else{
                   emailBody += '        <th style="text-align: right;">Price</th>';
                }
                emailBody += '    </tr>';
                for (OpportunityLineItem oli : olis) {
                    emailBody += '    <tr>';
                    emailBody += '        <td width="10px"></td>';
                    emailBody += '        <td style="text-align: left;">' + oli.Product2.Name;
                    if (oli.Product2.Current_Year__c != null)
                        emailBody += '        <br/><em>  • ' + oli.Product2.Current_Year__c + ': ' + oli.Product2.Current_Year_Number_of_Titles__c + ' titles for ' + MiscFunctions.formattedAmount(oli.Product2.Current_Year_Value_of_Titles__c) + '</em>';
                    if (oli.Product2.Next_Year__c != null)
                        emailBody += '        <br/><em>  • ' + oli.Product2.Next_Year__c + ': ' + oli.Product2.Next_Year_Number_of_Titles__c + ' titles for ' + MiscFunctions.formattedAmount(oli.Product2.Next_Year_Value_of_Titles__c) + '</em>';
                    emailBody += '        </td>';
                    if(opp.OwnerId == userId){
                        string currencySyntax='';
                        if(opp.CurrencyIsoCode == 'USD' )
                            currencySyntax='$';
                        else
                            currencySyntax=opp.CurrencyIsoCode;
                        emailBody += '        <td style="text-align: right;">' + currencySyntax + MiscFunctions.formattedAmount(oli.TotalPrice) + '</td>';
                    }else{
                         emailBody += '        <td style="text-align: right;">' + '(' + opp.CurrencyIsoCode + ') ' + MiscFunctions.formattedAmount(oli.TotalPrice) + '</td>';
                    }
                    
                   
                    emailBody += '    </tr>';
                }
                emailBody += '</table>';
                emailBody += '<br/>';
                emailBody += '<div style="color:#000000; font-family: Arial, Helvetica, sans-serif;">';
                emailBody += 'Your netBASE product will be updated throughout the year as new content is released.';
                emailBody += '<br/>';
                emailBody += '</div>';

            }

        } else {
            if (olis.size() == 1) {
                emailBody += 'This message serves as a gentle reminder that your subscription of ' + olis[0].Product2.Name + ' is due to expire on ' + MiscFunctions.convertDateToString_MMM_d_yyyy(expirationDate) + '.' + ' The renewal rate for an annual subscription is $'+MiscFunctions.formattedAmount(olis[0].TotalPrice) + ' (plus applicable tax).' ;
              //  emailBody += '<br/>';
              //  emailBody += 'The renewal rate for an annual subscription is $'+MiscFunctions.formattedAmount(olis[0].TotalPrice) + ' (plus applicable tax).' ;   // @@ CHG0030462 
   
            } else {
                emailBody += 'This message serves as a gentle reminder that your subscription is due to expire on ' + MiscFunctions.convertDateToString_MMM_d_yyyy(expirationDate) + '.' + ' The renewal rate for an annual subscription (pre tax) is shown below.';
             //   emailBody += '<br/>';
             //   emailBody += 'The renewal rate for an annual subscription (pre tax) is shown below.' ;
                emailBody += '<br/><br/>';
                emailBody += '<table border="0" style="width:90%; font-size: 10pt; color:#000000; font-family: Arial, Helvetica, sans-serif;">';
                emailBody += '    <tr>';
                emailBody += '        <th width="10px"></th>';
                emailBody += '        <th style="text-align: left;">Product</th>';
              //  CHG0039924 To check the Owner Id with user Id if match then it change the template.
                if(opp.OwnerId == userId){
                    system.debug('opp.Id'+opp.Id);
                    emailBody += '        <th style="text-align: right;">Quote</th>';
                }else{
                    emailBody += '        <th style="text-align: right;">Previous Price</th>';
                    emailBody += '        <th style="text-align: right;">Current Price</th>';
                }
               
                emailBody += '    </tr>';
                for (OpportunityLineItem oli : olis) {
                    emailBody += '    <tr>';
                    emailBody += '        <td width="10px"></td>';
                    emailBody += '        <td style="text-align: left;">' + oli.Product2.Name + '</td>';
                    if(opp.OwnerId == userId){
                        string currencySyntax='';
                        if(opp.CurrencyIsoCode == 'USD' )
                            currencySyntax='$';
                        else
                            currencySyntax=opp.CurrencyIsoCode;
                     //   emailBody += '        <td style="text-align: right;">' + '(' + opp.CurrencyIsoCode + ') ' + MiscFunctions.formattedAmount(oli.Previous_Sales_Price__c) + '</td>';
                        emailBody += '        <td style="text-align: right;">'+ currencySyntax + MiscFunctions.formattedAmount(oli.TotalPrice) +'</td>';
                        
                    }else{
                        emailBody += '        <td style="text-align: right;">' + '(' + opp.CurrencyIsoCode + ') ' + MiscFunctions.formattedAmount(oli.Previous_Sales_Price__c) + '</td>';
                        emailBody += '        <td style="text-align: right;">' + '(' + opp.CurrencyIsoCode + ') ' + MiscFunctions.formattedAmount(oli.TotalPrice) + '</td>';
                    }
                    emailBody += '    </tr>';
                }
                emailBody += '</table>';
            }
        }
        emailBody += '<br/><br/>';
       
        emailBody += 'Would you like to renew this subscription?';
        emailBody += '<table border="0" style="width: 90%; font-size: 10pt; color:#000000; font-family: Arial, Helvetica, sans-serif;">';
        String subjectText = ''; String replyText = '';
        String bodyText = 'Please provide any feedback in the body of this email, but do not change the email subject.'.replace(' ','%20');
        if (olis.size() == 1) {
            subjectText = 'Renew'; replyText = 'Renew';
            emailBody += '    <tr>';
            emailBody += '        <td width="10px"></td>';
            emailBody += '        <td><a href="mailto:' + linkEmailAddress + '?cc=' + linkCCAddress + '&subject=' + subjectText + '%20%5Bref%3A%20' + opp.Id + '%5D&body=' + bodyText + '">' + replyText + '</a></td>';
            emailBody += '    </tr>';
        } else {
            subjectText = 'Renew'; replyText = 'Renew All Products';
            emailBody += '    <tr>';
            emailBody += '        <td width="10px"></td>';
            emailBody += '        <td><a href="mailto:' + linkEmailAddress + '?cc=' + linkCCAddress + '&subject=' + subjectText + '%20%5Bref%3A%20' + opp.Id + '%5D&body=' + bodyText + '">' + replyText + '</a></td>';
            emailBody += '    </tr>';
            subjectText = 'PartiallyRenew'; replyText = 'Renew Some Products';
            emailBody += '    <tr>';
            emailBody += '        <td width="10px"></td>';
            emailBody += '        <td><a href="mailto:' + linkEmailAddress + '?cc=' + linkCCAddress + '&subject=' + subjectText + '%20%5Bref%3A%20' + opp.Id + '%5D&body=' + bodyText + '">' + replyText + '</a></td>';
            emailBody += '    </tr>';
        }
        subjectText = 'Decline'; replyText = 'Decline';
        emailBody += '    <tr>';
        emailBody += '        <td width="10px"></td>';
        emailBody += '        <td><a href="mailto:' + linkEmailAddress + '?cc=' + linkCCAddress + '&subject=' + subjectText + '%20%5Bref%3A%20' + opp.Id + '%5D&body=' + bodyText + '">' + replyText + '</a></td>';
        emailBody += '    </tr>';
        subjectText = 'Undecided'; replyText = 'Undecided';
        emailBody += '    <tr>';
        emailBody += '        <td width="10px"></td>';
        emailBody += '        <td><a href="mailto:' + linkEmailAddress + '?cc=' + linkCCAddress + '&subject=' + subjectText + '%20%5Bref%3A%20' + opp.Id + '%5D&body=' + bodyText + '">' + replyText + '</a></td>';
        emailBody += '    </tr>';
        subjectText = 'Speak'; replyText = 'I Want to Speak to my Sales Rep';
        emailBody += '    <tr>';
        emailBody += '        <td width="10px"></td>';
        emailBody += '        <td><a href="mailto:' + linkEmailAddress + '?cc=' + linkCCAddress + '&subject=' + subjectText + '%20%5Bref%3A%20' + opp.Id + '%5D&body=' + bodyText + '">' + replyText + '</a></td>';
        emailBody += '    </tr>';
        emailBody += '</table>';
        emailBody += '<br/>';
        emailBody += 'If tax should not be included in your total price, please include a tax exempt certificate when confirming this renewal.  For international customers, please include VAT number.';
        emailBody += '<br/><br/>';
        emailBody += 'Also, please inform us if any of your billing or contact information has changed, as we certainly want to maintain the most up to date and accurate records.';
        emailBody += '<br/><br/>';  
        
        if (opp.Product_Family__c == 'netBase') {
            //emailBody += 'To explore the complete line of netBASE products, visit <a href="www.crcnetbase.com">www.crcnetbase.com</a> or contact our Sales team at <a href="mailto:e-reference@taylorandfrancis.com">e-reference@taylorandfrancis.com</a>.';
            //emailBody += '<br/><br/>';    
            emailBody += 'We are excited to be able to continue to provide you with the most extensive and highest quality scientific information through an award-winning platform.  We look forward to hearing from you and thank you in advance for your continued subscription.';
        } else {
            emailBody += 'Please do not hesitate to contact us for any reason regarding your subscription and continued access. We look forward to hearing back from you and thank you in advance for your support of our online resources.';
        }

        emailBody += '<br/><br/>';  
        emailBody += 'Sincerely,';
        emailBody += '<br/><br/>';  
        emailBody += 'Samantha Given<br/>';
        emailBody += 'Account Manager – Renewals - eBooks and Digital Content<br/>'; //  @@ CHG0030462 emailBody += 'Renewal Sales Coordinator - eBooks and Digital Content<br/>';
        
        //it was decided that the below information was not needed 
        //emailBody += 'Interested in our other Taylor & Francis Online titles?<br/>';
        //emailBody += '<br/>';
        //emailBody += 'TAYLOR & FRANCIS E-BOOKS<br/>';
        //emailBody += '<a href="http://www.tandfebooks.com">http://www.tandfebooks.com</a><br/>';
        //emailBody += '<br/>';
        //emailBody += 'CRCnetBASE';
        //emailBody += '<a href="http://www.crcnetbase.com">http://www.crcnetbase.com</a><br/>';
        //emailBody += '<br/>';
        //emailBody += 'ROUTLEDGE ONLINE RESOURCES<br/>';
        //emailBody += '<a href="http://www.routledge.com/online">http://www.routledge.com/online</a><br/>';
        //emailBody += '<br/>';
        //emailBody += 'TAYLOR & FRANCIS ONLINE<br/>';
        //emailBody += '<a href="http://www.tandfonline.com">http://www.tandfonline.com</a><br/>';
        //emailBody += '<br/>';
        //emailBody += 'The Taylor & Francis online program has grown by leaps and bounds. In addition to humanities and social science favorites such as the rave-reviewed Routledge Encyclopedia of Philosophy, Europa World, and the IISS Armed Conflict Database, the T&F online family includes the renowned CRCnetBASE and Taylor & Francis Online Encyclopedias, both featuring widely praised resources in areas such as chemistry, engineering, information technology, and the social sciences.';

        emailBody += ''
        + '                            </td>'
        + '                        </tr>'
        + '                    </table>'
        + '                </td>'
        + '            </tr>'
        + '            <tr valign="top" >'
        + '                <td  style=" height:5; background-color:#AAAAFF; bLabel:accent2; bEditID:r4st1;">'
        + '                </td>'
        + '            </tr>'
        + '            <tr valign="top" >'
        + '                <td  style=" vertical-align:middle; height:50; text-align:center; background-color:#FFFFFF; bLabel:footer; bEditID:r5st1;">'
        + '                    <img id="r5sp1" bLabel="footerImage" border="0" bEditID="r5sp1" src="' + emailFooterImage + '" />'
        + '                </td>'
        + '            </tr>'
        + '            <tr valign="top" >'
        + '                <td  style=" height:5; background-color:#AAAAFF; bLabel:accent3; bEditID:r6st1;">'
        + '                </td>'
        + '            </tr>'
        + '        </table>'
        + '    </center>'
        + ''
        + '<form action="#" method="GET" name="resizeData">'
        + '    <input type="hidden"  id="baseUrl" name="baseUrl" value="' + strBaseUrl + '" />'
        + '    <input type="hidden"  id="path" name="path" value="/email/templaterenderer" />'
        + '    <input type="hidden"  id="previewFrameName" name="previewFrameName" value="preview_frame" />'
        + '    <input type="hidden"  id="previewFrame" name="previewFrame" value="previewFrame" />'
        + '    <input type="hidden"  id="render_type_name" name="render_type_name" value="render_type" />'
        + '    <input type="hidden"  id="render_type" name="render_type" value="RESIZE_FRAME" />'
        + '    <input type="hidden"  id="previewWidthName" name="previewWidthName" value="preview_width" />'
        + '    <input type="hidden"  id="previewHeightName" name="previewHeightName" value="preview_height" />'
        + '</form>'
        + '<script src="/email/wysiwyg/resize.js"></script>'
        + '</body>';



        return emailBody;
    }
    */

}