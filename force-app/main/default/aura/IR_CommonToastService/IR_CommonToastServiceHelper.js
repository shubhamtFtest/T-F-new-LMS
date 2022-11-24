/**
 - Created by Sidhant on 9/20/19.
 */
({
    error: function(event) {
        const params = event.getParam("arguments");
        let title = params.title;
        let msg = params.msg;
        console.error("Error: " + msg);

        this.toast(title, msg, "error");
    },
    warning: function(event) {
        const params = event.getParam("arguments");
        let title = params.title;
        let msg = params.msg;

        console.warn("Error: " + msg);
        this.toast(title, msg, "warning");
    },
    success: function(event) {
        const params = event.getParam("arguments");
        let title = params.title;
        let msg = params.msg;

        this.toast(title, msg, 'success');
    },
    toast: function(title, msg, type) {
        let toastEvent = $A.get("e.force:showToast");
        if (typeof toastEvent !== "undefined") {

            let title2 = title || ((type == "success") ? "Success" : "Ooops!");
            toastEvent.setParams({
                title: title2,
                message: msg,
                type: type || "error"
            });
            toastEvent.fire();
        }
    }
})