﻿/*!
 * WalkMe
 * http://www.walkme.com/
 *
 * Copyright 2012, WalkMe ltd
 */
function WalkmeSnippet(){window._walkmeInternals=window._walkmeInternals||{},function(e){try{if(e.timing){e.timing.perf={};for(var n=0;n<e.timing.list.length;n++)e.timing.perf[e.timing.list[n].name]=ke()-(Date.now()-e.timing.list[n].time)}}catch(e){}}(window._walkmeInternals),ve("snippetStartInit",{mark:!0});var e,i,a,r,n,o,t,s,l=this,u=!1,d="40",c=0,w={publish:0,preview:1},m=w.publish,f="32",p="d648d1a9b13e455cbf23ed3e7dfa726a",g="###MOBILE_WEB_USER_GUID###",v="https://papi.walkme.com",k=".br",_=".js",b=/^https:\/\/(.*)\.walkme(|dev|qa)\.com($|\/)/,h="wm-brotli-disabled";function S(e){s.snippetLog.push(e)}function y(){window["walkme_custom_settings_data"]?(S("lso"),E(walkme_custom_settings_data)):(S("lsp"),ve("settingsFileStartLoad",{mark:!0}),ue(o,null,s.isSelfHosted,"fixedCallback",E))}function E(e){if(ve("settingsFileEndLoad",{mark:!0,measureName:"SettingsFile",startMark:"settingsFileStartLoad"}),!A()&&window.document.dontLoadTriangle)return window["walkme_snippet_blocked"]=!0,s.blocked=!0,void(s.continueLoad=function(){I(e)});S("cls"),I(e)}function I(n){i=N(n),window.walkme&&window.walkme.prepCdnFormat&&(n.PublicPath=window.walkme.prepCdnFormat(n.PublicPath),Object.keys(n.Components||{}).forEach(function(e){n.Components[e]=window.walkme.prepCdnFormat(n.Components[e])}));var e=window.walkme_settings_callback||window.walkme&&window.walkme.walkme_settings_callback||window._walkmeConfig&&window._walkmeConfig.walkme_settings_callback;e&&e(i);var t=pe("walkme_is_enabled_override");if(void 0!==t){if("0"===t)return}else if(!n.IsEnabled)return;!function(e){try{if(L(i.LibFile)){var n=i.LibFile.replace(_,k+_),t=i.PublicPath.replace(/.$/,k+"/");i.LibFile=e.LibFile=n,i.PublicPath=e.PublicPath=t}var r=i.DataFiles[0].url;L(r)&&function(e){return e<Date.now()-1e3*60*5}(e.PublishDate)&&(i.DataFiles[0].url=r.replace(_,k+_))}catch(e){}}(n),function(e){if(window.walkme_custom_jquery)window.mtjQuery=walkme_custom_jquery,C();else{var n=j("walkmeCustomjQueryUrl");if(0!=n&&(e=n),s.localjQueryUrlPath){var t=e.lastIndexOf("/"),r=e.substring(t+1);e=s.localjQueryUrlPath+r}ue(e,C)}}(n.jQueryFile),function(e){if(!function(){var e=document.createElement("link").relList;return!!(e&&e.supports&&e.supports("preload"))}()||j("wm_skipPreload"))return S("spls");S("pls"),G(D(e)),G(T(e)),G(e.WalkMeConfigFile);try{var n=function(e){var n=j("wm-lang"),t=e[0].url;if(n&&function(e,n){for(var t=0;t<n.length;t++)if(n[t].shortName==e)return!0;return!1}(n,e[0].languages)){var r=we(t)?".br":"",i=ce(t);return t.substring(0,t.length-i.length-r.length-1)+"_"+n+r+"."+i}return t}(e.DataFiles),t=function(e){return/json($|\?)/.test(ce(e))}(n);window.Worker&&"true"===j("wm-worker-enabled")?(window._walkmeInternals.wmWorker||(function(){var e="self.map=new Map();self.callbackMap=new Map();self.window=self;self.onmessage="+function(e){if(!e||!e.data)return;if(Array.isArray(e.data))for(var n=0;n<e.data.length;n++)_e(e.data[n]);else _e(e.data)}.toString()+"; "+_e.toString()+he.toString()+be.toString();ue(null,null,!1,null,null,"wm-worker",e,"javascript/worker")}(),ue(null,null,!1,null,null,"wm-blob","var blob=new Blob([document.querySelector('#wm-worker').textContent],{type:'text/javascript'});window._walkmeInternals.wmWorker=new Worker(window.URL.createObjectURL(blob));")),function(e,n){_walkmeInternals.wmWorker&&_walkmeInternals.wmWorker.postMessage({action:n?"loadJson":"loadJsDataFile",message:{url:e,callbackName:"appendDataPackage",callbackVar:"_makeTutorial"},channel:"dataFileLoader"})}(n,t)):t||G(n)}catch(e){}S("prc"),H(e.PlayerApiServer),function(e){var n=e.Storage;return!!n&&1===n["ss"]}(e)&&H(e.PlayerServer);!function(){var e=j("wm.preload-fonts");if(!e)return;for(var n=JSON.parse(e),t=0;t<n.length;t++)G(n[t])}()}(n)}function L(e){var n,t=window._walkmeConfig&&window._walkmeConfig.hashData;return j("wm-enable-brotli")&&b.test(e)&&e.indexOf(k)<0&&("Chrome"===(n=Q()).browser&&50<=n.version||"Edge"===n.browser&&15<=n.version||"Firefox"===n.browser&&44<=n.version||"Safari"===n.browser&&11<=n.version||"Opera"===n.browser&&38<=n.version)&&!A()&&!t&&!s.isSelfHosted&&function(){var e=j(h);if(parseInt(e)!==i.PublishDate)return U(h),!0;return!1}()}function C(){if(ve("jQueryScriptLoaded",{mark:!0,measureName:"jQueryLoaded",startMark:"settingsFileEndLoad"}),null==window["mtjQuery"])return;if(u)return;if(u=!0,window.walkme_custom_jquery||mtjQuery.noConflict(),"true"===j("wm-wait-win-load")){function e(){ve("jQueryWindowLoadEvent",{measureName:"jQueryWindowLoad",startMark:"jQueryScriptLoaded"}),P(i)}S("wwl"),mtjQuery(document).ready(function(){ve("jQueryDocumentReadyEvent",{measureName:"jQueryDocumentReady",startMark:"jQueryScriptLoaded"})}),"complete"===document.readyState?e():window.addEventListener("load",e)}else i.WaitDocumentReady?(S("wdr"),mtjQuery(document).ready(function(){ve("jQueryDocumentReadyEvent",{measureName:"jQueryDocumentReady",startMark:"jQueryScriptLoaded"}),P(i)})):(S("ndr"),P(i))}function P(e){ve("jQueryDocumentReady"),"true"===j("wm-load-cd-snippet")&&function(){var e=function(e){if(!e)return e;if("string"==typeof e)return e;var n=e[X];return n[Q().string]||n[Q().browser]||n["*"]}(l.getSettingsFile().Storage),n=~["crossdomain","crossdomain_ls","crossdomain_ck","dap","proxy"].indexOf(e);if(n&&"Safari"===Q().browser&&function(){var e=/iPad Simulator|iPhone Simulator|iPod Simulator|iPad|iPhone|iPod/.test(navigator.platform),n=-1<navigator.userAgent.indexOf("Mac")&&"ontouchend"in document;return e||n}())return;"proxy"===e?(ve("initProxyHiddenIframeStart",{mark:!0,level:1}),function(e){var n="walkme-proxy-iframe";(r=document.getElementById(n))?e():r=le("about:blank",n,!1,e,null,null,!0)}(function(){try{ve("initProxyHiddenIframeDone",{mark:!0,level:1,measureName:"initProxyIframe",startMark:"initProxyHiddenIframeStart"});var e=mtjQuery(r).contents(),n=r.contentWindow||r.window;re(e.find("body")[0]),ve("initIframeMessageSenderStart",{mark:!0,level:1}),function(e,n,t){if(n.document.getElementById("wm-hidden-iframe-script"))return;var r=ie(te(),"wm-hidden-iframe-script",n);window._walkmeInternals.hiddenIframeCallback=t,e.find("head")[0].appendChild(r)}(e,n,function(){ve("initIframeMessageSenderDone",{level:1,measureName:"injectMessageSender",startMark:"initIframeMessageSenderStart"}),window._walkmeInternals.hiddenIframeCallbackCalled=!0})}catch(e){}})):n&&re()}();try{(t=D(n=e))&&""!=t?(ve("preLibStartLoad",{mark:!0}),window["walkme_pre_lib_loaded"]=function(){window["walkme_pre_lib_loaded"]=function(){try{console.log("walkme_pre_lib_loaded was called twice.")}catch(e){}},x(n)},ue(t)):x(n)}catch(e){}var n,t}function M(e){try{var n=pe("wm_load_test_"+p+"_"+f),t=parseInt(n);if(t)return ve("startLoadingTest"),_walkmeInternals.loadingTestDone=function(){ve("endLoadingTest"),_walkmeInternals.loadingTestDone=void 0,e&&e()},void setTimeout(_walkmeInternals.loadingTestDone,1e3*t)}catch(e){}e&&e()}function T(e){var n;s.localLibUrl&&(n=s.localLibUrl);var t=j("walkmeCustomeLibUrl");if(0!=t)return t;return n||e.LibFile}function D(e){return j("wm-prelibjs")||e.PreLibJsFile}function x(e){ve("libStartLoad",{mark:!0,measureName:"Prelib",startMark:"preLibStartLoad"}),ue(T(e))}function O(){return A()?"wmPreviewSnippet":"wmSnippet"}function A(){return m==w.preview}function F(){this.recorderServer="###RECORDER_SERVER_NAME###",this.cdnServerName="###AUTO_DETECT###",this.storage="proxy",this.userGuids=["d648d1a9b13e455cbf23ed3e7dfa726a"],window.walkme_custom_cdn_server&&(this.cdnServerName=walkme_custom_cdn_server),window.walkme_custom_app_server&&(this.recorderServer=walkme_custom_app_server),window.walkme_custom_data_url?this.triangleUrl=walkme_custom_data_url:this.triangleUrl=this.cdnServerName+"###SPECIAL_TRIANGLE_FILE###",window.walkme_custom_datafile_url?this.datafilesArray=walkme_custom_datafile_url:this.datafilesArray="###SPECIAL_DATA_FILE###",window.walkme_custom_widget_url?this.widgetUrl=walkme_custom_widget_url:this.widgetUrl="###SPECIAL_WIDGET_FILE###"}function N(e){if(null==t)return e;return function e(n,t){{if("string"==typeof n)return t(n);if("[object Array]"===Object.prototype.toString.call(n)){for(var r=0;r<n.length;r++)n[r]=e(n[r],t);return n}if("object"==typeof n){for(var r in n)Object.hasOwnProperty.call(n,r)&&(n[r]=e(n[r],t));return n}}return n}(e,function(e){return e.replace("###AUTO_DETECT###",t)})}function j(e){try{var n=window.localStorage.getItem(e);if(null!=n)return n}catch(e){}return!1}function R(e,n){try{window.localStorage.setItem(e,n)}catch(e){}}function U(e){try{window.localStorage.removeItem(e)}catch(e){}}function W(e){return new RegExp(e,"i").test(navigator.userAgent||navigator.vendor||window.opera)}function Q(){if(n)return n;var e={init:function(){this.browser=this.searchString(this.dataBrowser)||"An unknown browser",this.version=this.searchVersion(navigator.userAgent)||this.searchVersion(navigator.appVersion)||"an unknown version",this.OS=this.searchString(this.dataOS)||"an unknown OS"},searchString:function(e){for(var n=0;n<e.length;n++){var t=e[n].string,r=e[n].prop;if(this.versionSearchString=e[n].versionSearch||e[n].identity,t){if(-1!=t.indexOf(e[n].subString))return e[n].identity}else if(r)return e[n].identity}},searchVersion:function(e){var n=e.indexOf(this.versionSearchString);if(-1==n)return;return parseFloat(e.substring(n+this.versionSearchString.length+1))},dataBrowser:[{string:navigator.userAgent,subString:"Chrome",identity:"Chrome"},{string:navigator.userAgent,subString:"OmniWeb",versionSearch:"OmniWeb/",identity:"OmniWeb"},{string:navigator.vendor,subString:"Apple",identity:"Safari",versionSearch:"Version"},{prop:window.opera,identity:"Opera",versionSearch:"Version"},{string:navigator.vendor,subString:"iCab",identity:"iCab"},{string:navigator.vendor,subString:"KDE",identity:"Konqueror"},{string:navigator.userAgent,subString:"Firefox",identity:"Firefox"},{string:navigator.vendor,subString:"Camino",identity:"Camino"},{string:navigator.userAgent,subString:"Netscape",identity:"Netscape"},{string:navigator.userAgent,subString:"MSIE",identity:"Explorer",versionSearch:"MSIE"},{string:navigator.userAgent,subString:"Trident",identity:"Explorer",versionSearch:" rv"},{string:navigator.userAgent,subString:"Edge",identity:"Edge"},{string:navigator.userAgent,subString:"Gecko",identity:"Mozilla",versionSearch:"rv"},{string:navigator.userAgent,subString:"Mozilla",identity:"Netscape",versionSearch:"Mozilla"}],dataOS:[{string:navigator.platform,subString:"Win",identity:"Windows"},{string:navigator.platform,subString:"Mac",identity:"Mac"},{string:navigator.userAgent,subString:"iPhone",identity:"iPhone/iPod"},{string:navigator.platform,subString:"Linux",identity:"Linux"}]};return e.init(),n={version:e.version,browser:e.browser,string:e.browser+" "+e.version,OS:e.OS}}function G(e){J(e,"preload","script")}function H(e){J(e,"preconnect")}function V(){U("wm-enable-brotli"),R(h,i.PublishDate),i.LibFile=me(i.LibFile),i.PublicPath=me(i.PublicPath),i.DataFiles[0].url=me(i.DataFiles[0].url)}function B(e){if(e&&e.srcElement){var n=e.srcElement.src||e.srcElement.href;if(we(n)){V();var t=me(n);"LINK"===e.srcElement.tagName?G(t):ue(t)}}}function J(e,n,t){if(!e)return;try{var r=document.createElement("link");r.href=e,window&&window.walkme&&window.walkme.prepCdnFormat&&(r.href=window.walkme.prepCdnFormat(r.href)),se(r,e),r.onerror=B,r.rel=n,t&&(r.as=t),r.id="wm_link"+c++,de().appendChild(r)}catch(e){}}function $(){return l.getSettingsFile().PublicPath}var q="resources/CD/",z="CDhiddenIframe",K="cdHiddenIframeScript.js",X="st",Y="cm";function Z(e){if(window&&window.walkme&&window.walkme.prepCdnFormat)return window.walkme.prepCdnFormat(e);return e}var ee,ne=function(){var e=function(e,n){var t=l.getSettingsFile().Storage;if(!t||void 0===t[e])return n;return t[e]}(Y,!0)?".compress":"";return Z($()+q+z+e+".html")},te=function(){return Z($()+q+K)};function re(e){var n="walkme-hidden-iframe",t=(e?e.ownerDocument:document).getElementById(n);if(!t){ve("initHiddenIframeStart",{mark:!0,level:1}),window._walkmeInternals.hiddenIframeSnippetLoad=!0;t=le(ne(),n,!1,function(){ve("initHiddenIframeDone",{mark:!0,level:1,measureName:"initHiddenIframe",startMark:"initHiddenIframeStart"}),window._walkmeInternals.hiddenIframeLoaded=!0,window._walkmeInternals.hiddenIframeLoadCallback&&window._walkmeInternals.hiddenIframeLoadCallback()},null,e,!0)}}function ie(e,n,t){var r=(t||window).document.createElement("script");return r.setAttribute("id",n||"mt_script_"+(Date.now()+Math.random()).toString().replace(/(^.{7})|(\.)/g,"")),r.setAttribute("async","true"),r.setAttribute("class","walkme-to-remove"),e&&(r.src=oe(e)),se(r,e),r}function ae(e){if(window._walkmeInternals&&window._walkmeInternals.trustedTypePolicy&&e)return window._walkmeInternals.trustedTypePolicy.createHTML(e);return e}function oe(e){if(window._walkmeInternals&&window._walkmeInternals.trustedTypePolicy&&e)return window._walkmeInternals.trustedTypePolicy.createScriptURL(e);return e}function se(e,n){window._walkmeExtension&&window._walkmeExtension.nonceValue&&e.setAttribute("nonce",window._walkmeExtension.nonceValue);var t=window._walkmeConfig&&window._walkmeConfig.hashData;if(!n||!t||!t.Files)return;var r=n.indexOf("?"),i=-1!==r?n.substring(0,r):n;t.Files[i]&&(e.setAttribute("crossorigin",""),e.setAttribute("integrity",t.Files[i]))}function le(e,n,t,r,i,a,o,s){a=a||document.body;var l=document.createElement("iframe");try{a.appendChild(l)}catch(e){l=a.ownerDocument.createElement("iframe"),a.appendChild(l)}if(l.id=n,o||(l.className="walkme-to-remove"),t||(l.style.cssText="display:none;visibility:hidden;"),s)for(var u in s)s.hasOwnProperty(u)&&l.setAttribute(u,s[u]);return l.addEventListener("load",function e(n){l.removeEventListener&&l.removeEventListener("load",e),r&&r(n)},!1),l.src=e,l}function ue(e,n,t,r,i,a,o,s){window._walkmeConfig=window._walkmeConfig||{},t&&e&&!0!==window._walkmeConfig.disableWMTS&&(e+=(-1==e.indexOf("?")?"?":"&")+"_wmts="+(new Date).getTime());var l=ie(e,a);window&&window.walkme&&window.walkme.prepCdnFormat&&(l.src=window.walkme.prepCdnFormat(l.src)),s&&(l.type=s),o&&(l.text=o),n&&(l.onload=n,l.onreadystatechange=n),l.onerror=B,function(n,t){if(n&&t){var r=window[n];window[n]=function(e){window[n]=r,t(e)}}}(r,i),de().appendChild(l)}function de(){return e=e||document.getElementsByTagName("head")[0]}function ce(e){return e.split(".").pop()}function we(e){return e&&0<e.indexOf(".br")}function me(e){return e&&e.replace(".br","")}function fe(e){return e.replace(/^\s+|\s+$/g,"")}function pe(e,n){var t=n?j(e):function(e){var n,t,r,i=document.cookie.split(";");for(n=0;n<i.length;n++)if(t=i[n].substr(0,i[n].indexOf("=")),r=i[n].substr(i[n].indexOf("=")+1),(t=t.replace(/^\s+|\s+$/g,""))==e)return r;return!1}(e);if(!1!==t)return t;var r=window[e]||window.walkme&&window.walkme[e]||window._walkmeConfig&&window._walkmeConfig[e];if(null!=r)return r;return}function ge(e){if(void 0===ee&&(ee=j("wmAddPerfMeasures")),ee)return!e||e<=ee;return!1}function ve(e,n){try{var t,r,i=ke(),a=Date.now();if(r=_walkmeInternals.timing?a-(t=_walkmeInternals.timing).list[t.list.length-1].time:((t=_walkmeInternals.timing={}).map={},t.perf={},t.list=[],t.delta=[],0),t.perf[e])return;if(n&&n.level&&!ge(n.level))return;t.map[e]=a,t.perf[e]=i,t.list.push({name:e,time:a}),t.delta.push({name:e,delta:r}),function(e,n){if(!n||!ge(n.level))return;var t="wm-",r=t+e;if(n.mark&&performance.mark(r),n.measureName){var i=n.startMark&&t+n.startMark,a=n.endMark&&t+n.endMark;performance.measure(t+n.measureName,i,a)}}(e,n)}catch(e){}}function ke(){if(window.performance&&window.performance.now)return parseInt(window.performance.now())}function _e(e){if(!e.action)return;var n={getData:function(e,n){var t=e.url;if(!t||!n)return;self.map.has(t)?(postMessage({channel:n,message:self.map.get(t)}),self.map.delete(t)):e.isJson?he(t,function(e){postMessage({channel:n,message:e})}):be(e.url,e.callbackName,e.callbackVar,function(e){postMessage({channel:n,message:e})})},loadJson:function(n){if(!n.url)return;he(n.url,function(e){self.map.set(n.url,e)})},loadScriptWithCallback:function(n){if(!n.url)return;be(n.url,n.callbackName,n.callbackVar,function(e){self.map.set(n.url,e)})},loadJsDataFile:function(n){if(!n.url)return;self.window.wmSnippet={},self.window.wmSnippet.getServerSettings=function(){return!0},be(n.url,n.callbackName,n.callbackVar,function(e){self.map.set(n.url,e)})}}[e.action];try{n&&n(e.message,e.channel)}catch(e){}}function be(t,e,n,r){if(self.callbackMap.has(t))return void self.callbackMap.set(t,r);self.callbackMap.set(t,r),n?self[n]=self:n="window",self[n][e]=function(e){var n=self.callbackMap.get(t);n&&n(e),self.callbackMap.delete(t)},importScripts(t)}function he(n,e){if(self.callbackMap.has(n))return void self.callbackMap.set(n,e);self.callbackMap.set(n,e);var t=new XMLHttpRequest;t.responseType="json",t.onreadystatechange=function(){if(4===t.readyState&&200===t.status){var e=self.callbackMap.get(n);e&&e(t.response),self.callbackMap.delete(n)}},t.open("GET",n,!0),t.send(null)}function Se(e,n){try{S(e),console.log(n)}catch(e){}}if(this.getSnippetVersion=function(){return d},this.getSettingsFile=function(){return i},this.getServerSettings=function(){return a},this.fixAutoDetectPaths=N,!_walkmeInternals.__tti&&"PerformanceObserver"in window){var ye=[];if("PerformanceResourceTiming"in window&&ye.push("resource"),"PerformancePaintTiming"in window&&ye.push("paint"),"PerformanceLongTaskTiming"in window&&ye.push("longtask"),"LargestContentfulPaint"in window&&ye.push("largest-contentful-paint"),0<ye.length){var Ee=_walkmeInternals.__tti={e:[]};Ee.o=new PerformanceObserver(function(e){Ee.e=Ee.e.concat(e.getEntries())}),Ee.o.observe({entryTypes:ye})}}setTimeout(function(){if(window._walkmeConfig=window._walkmeConfig||{},(s=_walkmeInternals).snippetLog=[],s.addTimeStamp=ve,s.getTrustedScriptUrl=oe,s.getTrustedHtml=ae,window.doNotLoadWalkMe)return S("dlw"),void(s.removeWalkMeReason="doNotLoadWalkMe variable on the window");if(_walkmeInternals.loadingTestDone)return void Se("ltt","WalkMe Loading Test is already running - aborting snippet");var e;S("ish"),s.isSelfHosted="true"=="true",S("ssm"),"###IS_PREVIEW_MODE###"=="true"&&(m=w.preview),a=new F,S("lsu");var i=!1,n=_walkmeConfig.loadPlatform&&_walkmeConfig.loadPlatform.toLowerCase();(i="web"===n?(S("fsw"),!1):"mobile"===n||false===!0?(S("fsm"),!0):false&&W("android|blackberry|iemobile|ip(ad|hone|od)|phone|symbian|windows (ce|phone)"))?(S("lsm"),e="###GET_MOBILE_SETTINGS_URL###",_walkmeConfig.platform=3):(S("lsw"),e="###AUTO_DETECT###/settings.js"),-1<a.cdnServerName.indexOf("###AUTO_DETECT###")&&(S("lad"),t=function(e,n){for(var t=document.getElementsByTagName("script"),r=0;r<t.length;r++){var i=t[r].src;if(i&&0<i.indexOf("walkme_")){if(e){r=i.indexOf(e);var a=fe(i.substr(0,r));S("dst")}else{r=i.indexOf("walkme_"),a=fe(i.substr(0,r-1));S("dso")}return n&&s.isSelfHosted&&(a=a.split(p).join(g),S("dsm")),a}}return""}(a.cdnServerName.replace("###AUTO_DETECT###",""),i),a=N(a)),function(t,r){if(!_walkmeConfig.snippetManager)return r(t);var i=3===_walkmeConfig.platform?g:p,l="wm_snippet_cache_",u=8e3;if(!v)return d("PlayerApi is not defined");var a=v+"/snippetmanager";function d(e,n){Se("sme","SnippetManager cannot get client guid. Using partner system as a fallback.\n"+e),n||r(t)}function o(e,t,r){var i=!1,a=l+e,n=j(a);if(n)try{var o=JSON.parse(n);r(o),i=!0}catch(e){}function s(e){U(a),d(e,i)}setTimeout(function(){var n=new XMLHttpRequest;n.onerror=function(){s("Network error.")},n.onload=function(){if(200===n.status)try{var e=JSON.parse(n.responseText);R(a,n.responseText),i||r(e)}catch(e){s("Response parsing error\n"+e)}else s(n.responseText)},n.open("GET",t,!0),n.send()},i?u:0)}function s(e,n){if(!e||!n)return void d("Client identification settings are not valid");switch(e){case"var":var t=function(e,n){for(var t=0,r=(n=n.split(".")).length;t<r;t++)if(null==(e=e[n[t]]))return;return e}(window,n);if(!t)return void d("Client identification variable does not exist in the global scope");return t;default:return void d("Unknown client identification type")}}o("settings_"+i,a+"/getSettingsByGuid?guid="+i,function(e){var n=s(e.id_type,e.id_key);n&&o("clientGuid_"+i+"_"+n,a+"/getClientGuid?partnerGuid="+i+"&clientId="+n,function(e){var n=e.clientGuid;if(!n)return void d("clientGuid was not received");r(t.split(i).join(n))})})}(e=function(e){var n=pe("walkme_segmented_settings_"+p+"_"+f,!0);if(n)return S("seg"),n;return e}(e),function(e){if(o=function(e){var n="walkme_custom_user_settings_",t=pe(n+"url",!0),r=pe(n+"guid",!0),i=pe(n+"env",!0),a=function(){var e=j("walkMe_wm-settings-cache-bust");if(e){var n=/{"val":"(true|false)","exp":(\d+)}/.exec(e);if(n&&"true"==n[1]&&(new Date).getTime()<parseInt(n[2]))return!0}return window.walkme&&window.walkme.walkme_settings_cache_bust||window._walkmeConfig.walkme_settings_cache_bust||!1}();t&&(e=t);r&&(e=e.replace(/(users\/)([^\/]*)(\/)/,"$1"+r+"$3"));!i&&""!==i||(i&&(i+="/"),e=e.replace(/(users\/[^\/]*\/)(.*)(sett)/,"$1"+i+"$3"));e=N(e),s.settingsUrl=e,S(a?"cb":"ncb"),a&&(e+="?forceUpdate="+(new Date).getTime());return e}(e),a=a,S("cli"),_walkmeConfig.smartLoad){if(top!=window&&!function(){try{if(parent.location.href)return!1}catch(e){}return!0}()&&function(){try{var e=window;do{if((e=e.parent.window)._walkmeConfig)return!0}while(e!=top)}catch(e){}return!1}())return}else if(1!=window["walkme_load_in_iframe"]&&top!=window)return;if(S("cuc"),!i&&!function(){if("1"===pe("walkme_dont_check_browser")||A())return!0;var e=function(){var e=Q();if("Chrome"==e.browser||"Firefox"==e.browser||"Safari"==e.browser&&"Windows"!=e.OS)return!0;if("Explorer"==e.browser&&7<=e.version)return!0;return Se("icb","WalkMe: Incompatible browser."),!1}(),n=!W("android.+mobile|blackberry|iemobile|ip(hone|od)|phone|symbian|windows (ce|phone)")&&!function(){var e,n=-1<navigator.userAgent.toLowerCase().indexOf("chrome")&&-1<navigator.vendor.toLowerCase().indexOf("google");e=void 0===window.devicePixelRatio||n?1:window.devicePixelRatio;var t=window.screen.width*e,r=window.screen.height*e,i=Math.max(t,r),a=Math.min(t,r);return i<800||a<600}();return e&&n}()){try{S("bns"),walkme_browser_not_supported()}catch(e){}return}S("exl");var n,t=window[O()],r=s.blocked;if(S("lsl"),n=O(),window[n]=l,S("ipm"),!A()&&(S("clt"),window.document.dontLoadTriangle))return S("bsl"),window["walkme_snippet_blocked"]=!0,s.blocked=!0,void(s.continueLoad=function(){M(y)});S("slb"),t&&!r&&Se("slt","WalkMe Snippet was loaded twice"),window._walkmeExtension&&"true"===window._walkmeExtension.useTrustedTypePolicy&&function(){if(window.trustedTypes&&window.trustedTypes.createPolicy){_walkmeInternals.trustedTypePolicy=window.trustedTypes.createPolicy("walkme-player",{createHTML:function(e){return e},createScriptURL:function(e){return e},createScript:function(e){return e}})}}(),S("lss"),M(y),S("eok")})},0)}new WalkmeSnippet;