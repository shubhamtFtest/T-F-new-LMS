window,window._walkmeWebpackJP&&(window._walkmeWebpackJP=window._walkmeWebpackJP||[]).push([[8],{1201:function(e,s,d){"use strict";d.r(s),function(e){d.d(s,"services",function(){return i}),d.d(s,"init",function(){return a});var t=d(10),n=d(1255),r=d(1),i=["TrackedElements2Manager","TrackedElements2VisibilityTrackerFactory"];d(2506),d(2507),d(2508),d(2509),d(2510),d(2511),d(2777),d(2512),d(2513),d(2514),Object(t.registerApi)({services:i},n.a);var a=function(){e.get("DataFileDataLoader").registerDataAppender({append:o}),e.get("WmInternals").one(r.EVENTS.WalkmeReady,c)},c=function(){return e.get("TrackedElements2Manager").start()},o=function(){return e.get("TrackedElements2Manager").setDeployables(e.get("TrackedElements2Container").get())}}.call(this,d(2))},1255:function(e,t,n){"use strict";n.d(t,"a",function(){return r});var n=n(10),r=Object(n.create)()},2506:function(e,t,n){"use strict";n.r(t),n.d(t,"TrackedElements2Manager",function(){return c});var i,r=n(0),a=n(7),t=n(39),n=n(1255),c=(i=t.DeployablesManager,Object(r.__extends)(o,i),o.prototype.getAllByPageId=function(t){return this.arrayUtils.filter(this.getAll(),function(e){return e.TrackedPageId==t})},o.prototype.start=function(){this.trackedElementsVisibilityTracker=this.trackedElementsVisibilityTrackerFactory.create({}),this.trackedElementsVisibilityTracker.startTrack()},o.prototype.releaseAll=function(){this.trackedElementsVisibilityTracker&&this.trackedElementsVisibilityTracker.stopTrack()},Object(r.__decorate)([Object(a.c)("TrackedElements2Manager",{ctx:n.a,dependencies:"Lib, Consts, ArrayUtils, TrackedElements2VisibilityTrackerFactory"})],o));function o(e,t,n,r){return(t=i.call(this,{lib:e,type:t.DEPLOYABLE_TYPE.TrackedElement})||this).arrayUtils=n,t.trackedElementsVisibilityTrackerFactory=r,t._name="TrackedElement2",t.setDeployables([]),t}},2507:function(e,t,n){"use strict";n.r(t),n.d(t,"TrackedElement2EventBinder",function(){return i});var r=n(0),t=n(7),n=n(1255),c={1:"click",2:"mouseenter",3:"change"},i=(a.prototype.bind=function(t,n,r){var i=this,e=this.trackedElementEventHandlerFactory.get(n),a=c[n.Event];this.analyticsTrackerLogger.customerLog("TrackedElement2EventBinder - binding events to element with id "+n.Id),e.bind(t,a,this.analyticsTrackerConsts.EVENT_NAMESPACE,function(){return i.pageVisitGuidProvider.get(i.changesTrackerFactory.get().getCurrentIndex()).then(function(e){return i.trackedElementEventDataSender.send("engagedElementsEvent",e,n,r,t)})})},a.prototype.unbind=function(e,t){var n=this.trackedElementEventHandlerFactory.get(t),r=c[t.Event];this.analyticsTrackerLogger.customerLog("TrackedElement2EventBinder - unbinding events from element with id "+t.Id),n.unbind(e,r,this.analyticsTrackerConsts.EVENT_NAMESPACE)},Object(r.__decorate)([Object(t.c)("TrackedElement2EventBinder",{ctx:n.a,dependencies:"AnalyticsTrackerConsts, AnalyticsTrackerLogger, TrackedElement2EventDataSender, TrackedElement2EventHandlerFactory, PageVisitGuidProvider, ChangesTrackerFactory"})],a));function a(e,t,n,r,i,a){this.analyticsTrackerConsts=e,this.analyticsTrackerLogger=t,this.trackedElementEventDataSender=n,this.trackedElementEventHandlerFactory=r,this.pageVisitGuidProvider=i,this.changesTrackerFactory=a}},2508:function(e,t,n){"use strict";n.r(t),n.d(t,"TrackedElement2EventDataSender",function(){return i});var r=n(0),a=n(1),t=n(7),n=n(1255),i=(c.prototype.send=function(e,t,n,r,i){t={type:a.EVENT_SENDER_EVENT_APPS.EngagedElement,oId:n.Id,oName:n.Name,owType:a.EVENT_SENDER_EVENT_APPS.EngagedPage,eventType:n.Event,pId:(r?r.Id:"0")+"_"+t},r?(t.owId=r.Id,t.owName=r.Name):(t.owId=0,t.owName="Site-Wide"),this.commonEvents.raiseEvent(a.EVENTS.TrackedElementBeforeSendEvent,{eventName:e,eventData:t,trackedElement:n,trackedPage:r,element:i}),this.eventSender.postEvent(e,t)},Object(r.__decorate)([Object(t.c)("TrackedElement2EventDataSender",{ctx:n.a,dependencies:"EventSender, CommonEvents"})],c));function c(e,t){this.eventSender=e,this.commonEvents=t}},2509:function(e,t,n){"use strict";n.r(t),n.d(t,"TrackedElement2InteractionsToggler",function(){return i});var r=n(0),t=n(7),n=n(1255),i=(a.prototype.toggleBinder=function(e,t,n,r){r?this.trackedElement2EventBinder.bind(e,t,n):this.trackedElement2EventBinder.unbind(e,t)},a.prototype.stopBinder=function(e,t){e&&this.trackedElement2EventBinder.unbind(e,t)},Object(r.__decorate)([Object(t.c)("TrackedElement2InteractionsToggler",{ctx:n.a,dependencies:"TrackedElement2EventBinder"})],a));function a(e){this.trackedElement2EventBinder=e}},2510:function(e,t,n){"use strict";n.r(t),n.d(t,"TrackedElement2EventHandlerFactory",function(){return c});var r=n(0),i=n(1),t=n(7),a=n(1255),c=(o.prototype.get=function(e){switch(e.Event){case i.EVENT_TYPE.Click:case i.EVENT_TYPE.Input:return a.a.get("InteractionEventHandler");case i.EVENT_TYPE.Hover:return a.a.get("ThrottledInteractionEventHandler");case i.EVENT_TYPE.Visible:return a.a.get("VisibilityEventHandler")}},Object(r.__decorate)([Object(t.c)("TrackedElement2EventHandlerFactory",{ctx:a.a})],o));function o(){}},2511:function(e,t,n){"use strict";n.r(t),n.d(t,"TrackedElement2VisibilityTrackerFactory",function(){return c});var r=n(0),t=n(7),i=n(209),a=n(208),n=n(1255),c=(o.prototype.create=function(e){return e=new i.TrackedElementVisibilityTracker(this.analyticsTrackerLogger,this.trackedElementEventDataSender,this.pageVisitGuidProvider,this.changesTrackerFactory,this.trackedElementVisibilityEvaluatorFactory,e),new a.LibTrackedElementVisibilityTracker(this.trackedElementInteractionsToggler,e)},Object(r.__decorate)([Object(t.c)("TrackedElement2VisibilityTrackerFactory",{ctx:n.a,dependencies:"AnalyticsTrackerLogger, TrackedElement2EventDataSender, PageVisitGuidProvider, ChangesTrackerFactory, TrackedElement2InteractionsToggler, TrackedElementVisibilityEvaluatorFactory"})],o));function o(e,t,n,r,i,a){this.analyticsTrackerLogger=e,this.trackedElementEventDataSender=t,this.pageVisitGuidProvider=n,this.changesTrackerFactory=r,this.trackedElementInteractionsToggler=i,this.trackedElementVisibilityEvaluatorFactory=a}},2512:function(e,t,n){"use strict";n.r(t),n.d(t,"InteractionEventHandler",function(){return i});var r=n(0),t=n(7),n=n(1255),i=(a.prototype.bind=function(e,t,n,r){(e=wmjQuery(e)).off(""+t+n),e.on(""+t+n,{eventName:t},function(){return r()})},a.prototype.unbind=function(e,t,n){this.wmjQuerySafe(e).off(""+t+n)},Object(r.__decorate)([Object(t.c)("InteractionEventHandler",{ctx:n.a,proto:!0,dependencies:"wmjQuerySafe"})],a));function a(e){this.wmjQuerySafe=e}},2513:function(e,t,n){"use strict";n.r(t),n.d(t,"ThrottledInteractionEventHandler",function(){return i});var r=n(0),a=n(268),t=n(7),n=n(1255),i=Object(r.__decorate)([Object(t.c)("ThrottledInteractionEventHandler",{ctx:n.a,proto:!0,dependencies:"InteractionEventHandler"})],function(e){var i=this;this.interactionEventHandler=e,this.bind=function(e,t,n,r){return i.interactionEventHandler.bind(e,t,n,Object(a.a)(function(){return r()},500))},this.unbind=function(e,t,n){return i.interactionEventHandler.unbind(e,t,n)}})},2514:function(e,t,n){"use strict";n.r(t),n.d(t,"VisibilityEventHandler",function(){return i});var r=n(0),t=n(7),n=n(1255),i=(a.prototype.bind=function(e,t,n,r){r()},a.prototype.unbind=function(e,t,n){},Object(r.__decorate)([Object(t.c)("VisibilityEventHandler",{ctx:n.a})],a));function a(){}},2777:function(e,t,n){"use strict";n.r(t);var r=n(0),i=(a.prototype.stopTrack=function(){this.trackedElementVisibilityTracker.stopTrack()},a.prototype.startTrack=function(){var n=this;wmjQuery(this.linkedElements).each(function(e,t){return n.trackedElementVisibilityTracker.startTrack(t)})},a);function a(e,t,n){this.linkedElements=[],this.linkedElements=e.getAllByPageId(null===(e=n.trackedPage)||void 0===e?void 0:e.Id),this.trackedElementVisibilityTracker=t.create(n)}var c=n(7),o=n(1255);n.d(t,"TrackedElements2VisibilityTrackerFactory",function(){return s});var s=(d.prototype.create=function(e){var t=o.a.get("TrackedElements2Manager");return new i(t,this.trackedElement2VisibilityTrackerFactory,e)},Object(r.__decorate)([Object(c.c)("TrackedElements2VisibilityTrackerFactory",{ctx:o.a,dependencies:"TrackedElement2VisibilityTrackerFactory"})],d));function d(e){this.trackedElement2VisibilityTrackerFactory=e}}}]);