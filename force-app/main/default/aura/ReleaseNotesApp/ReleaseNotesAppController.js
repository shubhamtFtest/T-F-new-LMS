({    
    init : function(component, event, helper) {
        //Set the default values.
        var dateToday = new Date();
        var dayToday = dateToday.getDate();
        var monthToday = dateToday.getMonth()+1; //January is 0
        var nextMonth = dateToday.getMonth()+2; //January is 0
        var yearToday = dateToday.getFullYear();
        var formattedDate = yearToday +'-'+ monthToday +'-'+ dayToday;
        var startOfMonth = yearToday +'-'+ monthToday +'-'+ 1;
        
        var endOfMonth = new Date(yearToday, monthToday, 0)
        var endOfMonthDay = endOfMonth.getDate();
        var endOfMonthMonth = endOfMonth.getMonth()+1; //January is 0
        var endOfMonthYear = endOfMonth.getFullYear();
        var endOfMonthFormatted = endOfMonthYear +'-'+ endOfMonthMonth +'-'+ endOfMonthDay;
        
        component.set("v.startDate", startOfMonth);
        component.set("v.endDate", endOfMonthFormatted);
        
        helper.getCaseDataFunctionHelper(component, event);     
    },
    
    getCaseDataFunction : function(component, event, helper) {
        helper.getCaseDataFunctionHelper(component, event);
        
    },
    
    generatePDF: function (component, event, helper) {
        
        var startDateValue = component.get("{!v.startDate}");
        var endDateValue = component.get("{!v.endDate}");     
        var url = '/apex/ReleaseNotesPDF?startdate=' +  startDateValue + '&enddate=' + endDateValue;
        
        window.location = url  
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    }
})