<!--/**************************************************
* Created by: Tom Reed: 2018-07-30
* Updated by: Tom Reed: 2018-08-17
*	CHG1: Removed the generated pdf button as it's not longer required.
**************************************************/!-->

<aura:application extends="force:slds" controller="ReleaseNotes_ctr" implements="force:appHostable,force:hasRecordId,flexipage:availableForAllPageTypes" access="global" >
    
    <aura:attribute name='caseData' type= "Object[]" default="[]" /> 
    <aura:attribute name='startDate' type= "Date" default="" /> 
    <aura:attribute name="endDate" type="Date" default="" />
    <aura:handler event="aura:waiting" action="{!c.showSpinner}"/>
    <aura:handler event="aura:doneWaiting" action="{!c.hideSpinner}"/>
    <aura:attribute name="Spinner" type="boolean" default="false"/>
    
    <aura:handler name='init' value='{!this}' action='{!c.init}'/>
    <br/>
    <div style="padding-left: 30px; font-family:lato; font-size: 2rem; color: darkblue;">
        <img style="height: 10%; width: 10%;" src="/servlet/servlet.FileDownload?file=0150Y000002rgaA"> </img>        
        &nbsp;    
        Salesforce Release Notes 
    </div>
    
    <div class="c-container" style="padding-left: 30px; font-family;:lato; font-size: 1rem;">
        <lightning:layout >
            <lightning:layoutItem  padding="around-small">
                <ui:inputDate label="Start Date" class="field" value="{!v.startDate}" displayDatePicker="true" /> 
                <ui:inputDate label="End Date" class="field" value="{!v.endDate}" displayDatePicker="true" />
            </lightning:layoutItem>
            <lightning:layoutItem padding="around-small">
                <lightning:button variant= "Brand" label="Search" title="search" onclick="{!c.getCaseDataFunction}"/>
                <br/>
                <br/>
          <!-- CHG1 !-->  <!-- <lightning:button variant= "Success" label="Generate PDF" title="generatepdf" onclick="{!c.generatePDF}"/> !-->        
            </lightning:layoutItem>
            <lightning:layoutItem padding="around-small">
                <div style="border-radius: 25px;font-family:lato; font-size: 1rem; padding-left: 30px;padding-right: 30px; color:RGB(0, 158, 219);border-width: thin; border-style: solid; border-color:RGB(0, 158, 219);margin-left: 30px;margin-right: 600px;">    
                    <br/>
                    - Please note that not all changes will be released on the planned release date.
                    <br/>
                    - Any changes with a future release date have yet to be released.
                    <br/>
                    &nbsp;
                </div>
            </lightning:layoutItem>    
        </lightning:layout>
    </div> 
    <br/>    
    <aura:if isTrue="{!v.Spinner}">
        <div aura:id="spinnerId" class="slds-spinner_container">
            <div class="slds-spinner--brand  slds-spinner slds-spinner--large slds-is-relative" role="alert">
                <span class="slds-assistive-text">Loading</span>
                <div class="slds-spinner__dot-a"></div>
                <div class="slds-spinner__dot-b"></div>
            </div>
        </div>
    </aura:if>  
    <br/>
    <div style="padding-left: 30px; padding-right: 30px; font-family:lato; font-size: 1rem;" class="listedTableStyle" aura:id="listView">
        
        <aura:iteration items="{!v.caseData}" var="data" >  
            <p>
                <b> Case Number: </b><u> <a href="{!data.caseURLRow}"> {!data.caseNumberRow}</a></u>
            </p>
            <p style="color:green;"><b> Department: {!data.departmentValueRow}</b> </p>
            <b> Release Date:  {!data.releaseDateRow} </b>
            <br/>
            <br/>
            <p> <ui:outputRichText aura:id="outputRT" value="{!data.releaseNotesRow}" /> </p>           
            <br/>
            <br/>
            <br/>
        </aura:iteration>
    </div>   
</aura:application>