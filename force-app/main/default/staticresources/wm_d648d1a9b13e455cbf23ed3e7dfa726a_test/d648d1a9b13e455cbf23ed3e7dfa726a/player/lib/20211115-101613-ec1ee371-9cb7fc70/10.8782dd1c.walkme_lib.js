window,(window._walkmeWebpackJP=window._walkmeWebpackJP||[]).push([[10],{1192:function(t,e,n){var o=_walkmeInternals.ctx;o.register("LiveChatElement").asCtor(n(2434)).dependencies("Mustache, MessageSender, EventSender, Consts, CommonUtils, CommonEvents"),o.register("LiveChatVendorFactory").asCtor(n(2435)).dependencies("EventsTrigger"),o.register("LiveChatSettings").asCtor(n(2436)).dependencies("SiteConfigManager, Logger, BBCodeParser, HtmlDecoder, EventsTrigger"),o.register("LiveChat").asCtor(n(2437)).dependencies("Logger, LiveChatElement, LiveChatVendorFactory").asProto(),o.register("LiveChatAppender").asCtor(n(2438)).dependencies("EventsTrigger, TimerManager, Logger, ConditionTreeEvaluator").asProto(),o.register("TawkChat").asCtor(n(2439)).asProto(),o.register("LiveAgentChat").asCtor(n(2440)).asProto(),o.register("ZopimChat").asCtor(n(2441)).dependencies("Logger, DictionaryUtils, ArrayUtils, CommonUtils").asProto(),o.register("OlarkChat").asCtor(n(2442)).asProto(),o.register("IntercomChat").asCtor(n(2443)).asProto(),o.register("ZendeskChat").asCtor(n(2444)).asProto(),o.register("GenericChat").asCtor(n(2445)).asProto(),o.register("LivechatChat").asCtor(n(2446)).dependencies("ScriptInjector").asProto(),o.register("SnapengageChat").asCtor(n(2447)).asProto(),o.register("HablaChat").asCtor(n(2448)).asProto(),o.register("PureChat").asCtor(n(2449)).asProto(),o.register("ChristianCareMembersChat").asCtor(n(2450)).asProto(),t.exports={init:function(){}}},2434:function(t,e){t.exports=function(n,o,a,r,s,c){var t=this;t.getLiveChatElement=function(t){var e=n.to_html(t.mustacheTemplate,t.mustacheData),e=wmjQuery(e);return s.isValueTrue(t.addDisabledClass)&&e.addClass(t.disabledButtonClass),(t=o.send("BeforeAppendingLiveChatButton",{button:e}))?t.button:e},t.registerLiveChatClickListener=function(t,e,n){var o,i;s.isValueTrue(e.bindAction)&&(o=e,i=n,t.on("click.walkmeLiveChat",function(t){t.preventDefault(),s.isValueTrue(o.closeWalkmeOnChatOpen)&&window.WalkMePlayerAPI.toggleMenu(),i&&i(),c.raiseEvent(r.EVENTS.LiveChat.LiveChatClicked,{options:o})})),wmjQuery(document).on("click",".walkme-chat-button",function(){var t={type:a.EVENT_APPS.LiveChat,pInit:{type:r.STEP_PLAY_INITIATOR_ENUM.WIDGET}};a.postEvent(a.EVENT_TYPES.Click,t)})},t.destroyLiveChatElement=function(t){wmjQuery(document).off("click",".walkme-chat-button"),t.off("click.walkmeLiveChat"),t.off("click"),t.remove()},function(){}.apply(this,arguments)}},2435:function(t,e,n){!function(i){t.exports=function(n){var o={tawk:"TawkChat",liveagent:"LiveAgentChat",zopim:"ZopimChat",olark:"OlarkChat",intercom:"IntercomChat",zendesk:"ZendeskChat",livechat:"LivechatChat",snapengage:"SnapengageChat",habla:"HablaChat",purechat:"PureChat",ccm:"ChristianCareMembersChat",generic:"GenericChat"};this.create=function(t){var e=o[t.chatVendor.toLowerCase()];if(!e)throw"No chat factory found";return n.sync("BeforeChatIsCreated",t,null),t=i.create(e,t),n.sync("ChatIsCreated",t,null),t},function(){}.apply(this,arguments)}}.call(this,n(2))},2436:function(t,e){t.exports=function(o,i,a,r,s){var c=["chatPlacementSelector","livechatButtonSelector","minimizedChatSelector"],h={closeWalkmeOnChatOpen:!0,chatPlacementSelector:"#walkme-footer",mustacheTemplate:'<div class="walkme-override-css walkme-chat-wrapper"><a id="walkme-livechat-button" class="walkme-chat-button" href="#"><div class="walkme-item-icon walkme-livechat-icon"></div><div class="walkme-item-title walkme-livechat-title">{{buttonText}}</div></a></div>',mustacheData:{buttonText:"Chat With Us"},checkPlayerDelay:500,checkPlayerTimes:10,livechatButtonSelector:"#walkme-livechat-button",disabledButtonClass:"walkme-chat-disabled",position:"after",bindAction:"true",addDisabledClass:"false"};this.getLiveChatSettings=function(){var t=h,e=o.get().Settings;if(e&&e.liveChat){var n=e.liveChat.mustacheTemplate;return n&&(n=r.decodeHtml(n,["&","'",'"',">","<"]),e.liveChat.mustacheTemplate=a.parse(n)),function(t,e){for(var n,o=0;o<t.length;o++)e.hasOwnProperty(t[o])&&(void 0===(n=e[t[o]])||0===n.length||"string"==typeof n&&0===wmjQuery.trim(n).length)&&delete e[t[o]]}(["chatPlacementSelector","mustacheTemplate","livechatButtonSelector","disabledButtonClass","position"],e.liveChat),t=wmjQuery.extend({},t,e.liveChat),function(t,e){for(var n=0;n<t.length;n++){var o=t[n];e[o]&&(e[o]=r.decodeHtml(e[o],["&","'",'"',">"]))}}(c,t),function(t){for(var e in t)t.hasOwnProperty(e)&&(t[e]=r.decodeHtml(t[e],["&","'",'"',">","<"]))}(t.mustacheData),s.sync("LiveChatOptionsLoaded",t,t)}i.customerLog('No custom JSON settings found in the account. Please, check the features tab and make sure there is an entry for "liveChat" in the JSON settings',3)},function(){}.apply(this,arguments)}},2437:function(t,e){t.exports=function(n,t,o,e){var i=this;i.chat=void 0,i.element=void 0,i.shouldCheckForChat=!0,i.destroy=function(){i.element&&t.destroyLiveChatElement(i.element),i.shouldCheckForChat=!1},function(){i.options=e,i.chat=function(e){try{return o.create(e)}catch(t){return void n.customerLog("Impossible to initialize Chat Factory. Make sure the vendor "+e.chatVendor+" is supported",3)}}(i.options),i.chat&&(i.options=wmjQuery.extend(i.options,i.chat.options)),i.element=t.getLiveChatElement(i.options),t.registerLiveChatClickListener(i.element,i.options,function(){i.chat.openChat()})}.apply(this,arguments)}},2438:function(t,e){t.exports=function(a,r,s,c){var h=0,p={before:"walkme-chat-wrapper-left",after:"walkme-chat-wrapper-right"},l={before:function(t,e){t.prepend(e)},after:function(t,e){t.append(e)}};this.append=function(t,e){var n,o,i;e.chat?t.length<1?s.customerLog("Error. I couldn't find the container "+e.options.chatPlacementSelector+" for the button",3):1<t.find(".walkme-chat-wrapper").length?s.customerLog("Button already exists in the footer. Skipping...",3):(e.element.hide(),n=t,(o=e.element).addClass(p[(i=e).options.position]),l[i.options.position].call(i,n,o),e.shouldCheckForChat=!0,function t(e,n){var o;(o=n).isLiveChatPresent&&o.isLiveChatPresent()||o.chat.isChatPresent()&&(void 0===(o=o.options.displayCondition)||c.evaluate(o))?(s.customerLog("Chat validation passed.",3),n.element.show()):n.options.checkPlayerTimes>h&&n.shouldCheckForChat?(h++,s.customerLog("Chat validation #"+h+" failed. Trying again",3),checkLivechatTimeout=r.libSetTimeout(function(){t(e,n)},n.options.checkPlayerDelay)):(a.sync("LiveChatNotFound",n),s.customerLog("Max amount of checks reached, chat is not present",3))}(t,e)):s.customerLog("Error. couldn't append element to an empty live chat configuration",3)}}},2439:function(t,e){function n(t){!function(){this.options=t}.apply(this,arguments)}n.prototype.isChatPresent=function(){return"undefined"!=typeof Tawk_API},n.prototype.openChat=function(){Tawk_API.toggle()},t.exports=n},2440:function(t,e){function n(t){!function(){this.options=t,this.liveAgentId=t.liveAgentId}.apply(this,arguments)}n.prototype.isChatPresent=function(){return"undefined"!=typeof liveagent},n.prototype.openChat=function(){liveagent.startChat(this.liveAgentId)},t.exports=n},2441:function(t,e){function n(t,n,o,e,i){var a={top:100,left:window.screen.width-430,width:450,height:650,menubar:"no",location:"no",resizable:"yes",toolbar:"no",scrollbars:"yes",status:"no"};this.launchChatWindow=function(t){var e=(e=n.getDictionaryKeys(a),o.map(e,function(t){return t+"="+a[t]}).join(",")+",");window.open(t,"",e)},function(){this.options=i,this.options.openNewWindow=e.isValueTrue(i.openNewWindow),i.openNewWindow&&!i.key&&t.customerLog("ERROR: Open in new window needs a Key to work in the plugin settings",3)}.apply(this,arguments)}n.prototype.isChatPresent=function(){return this.options.openNewWindow||"undefined"!=typeof $zopim},n.prototype.openChat=function(){this.options.openNewWindow?this.launchChatWindow("http://v2.zopim.com/widget/livechat.html?key="+this.options.key):$zopim.livechat.window.show()},t.exports=n},2442:function(t,e){function n(t){!function(){this.options=t}.apply(this,arguments)}n.prototype.isChatPresent=function(){return"undefined"!=typeof olark},n.prototype.openChat=function(){olark("api.box.expand")},t.exports=n},2443:function(t,e){function n(t){!function(){this.options=t}.apply(this,arguments)}n.prototype.isChatPresent=function(){return"undefined"!=typeof Intercom},n.prototype.openChat=function(){Intercom("show")},t.exports=n},2444:function(t,e){function n(t){!function(){this.options=t}.apply(this,arguments)}n.prototype.isChatPresent=function(){return"undefined"!=typeof zE},n.prototype.openChat=function(){zE.activate()},t.exports=n},2445:function(t,e){function n(t){this.options=t,this.windowObjectReference=null}n.prototype.isChatPresent=function(){return!!this.options.url},n.prototype.openChat=function(){var t,e,n;null==this.windowObjectReference||this.windowObjectReference.closed?(t=(n=this.options).url,e=n.windowWidth,n=void 0===(n=n.windowHeight)?500:n,this.windowObjectReference=window.open(t,"WmGenericChatWindowName","resizable,width=".concat(void 0===e?500:e,",height=").concat(n))):this.windowObjectReference.focus()},t.exports=n},2446:function(t,e){function n(e,n){!function(){var t;(this.options=n).license&&(t=n.license,window.LC_API=window.LC_API||{},window.__lc={license:t},e.loadScriptAsFirstElement({url:("https:"==document.location.protocol?"https://":"http://")+"cdn.livechatinc.com/tracking.js",id:""}))}.apply(this,arguments)}n.prototype.isChatPresent=function(){return"undefined"!=typeof LC_API},n.prototype.openChat=function(){LC_API.open_chat_window()},t.exports=n},2447:function(t,e){function n(t){!function(){this.options=t}.apply(this,arguments)}n.prototype.isChatPresent=function(){return!!window.SnapEngage},n.prototype.openChat=function(){window.SnapEngage.startPreChat()},t.exports=n},2448:function(t,e){function n(t){!function(){this.options=t}.apply(this,arguments)}n.prototype.isChatPresent=function(){return"undefined"!=typeof habla_window},n.prototype.openChat=function(){habla_window.expand()},t.exports=n},2449:function(t,e){function n(t){!function(){this.options=t}.apply(this,arguments)}n.prototype.isChatPresent=function(){return window.purechatApi&&purechatApi.get("chatbox.available")},n.prototype.openChat=function(){purechatApi.set("chatbox.expanded",!0)},t.exports=n},2450:function(t,e){function n(t){!function(){this.options=t}.apply(this,arguments)}n.prototype.isChatPresent=function(){return"undefined"!=typeof chatNow},n.prototype.openChat=function(){chatNow()},t.exports=n}}]);