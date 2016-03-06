//>>built
require({cache:{"url:idx/widget/templates/ModalDialog.html":'<div class="dijitDialog" role="alertdialog" aria-labelledby="${id}_title" aria-describedby="${id}_desc" style="width:416px;"\r\n\t><div dojoAttachPoint="titleBar" class="dijitDialogTitleBar"\r\n\t\t><span dojoAttachPoint="titleNode" class="dijitDialogTitle" id="${id}_title"></span\r\n\t\t><span dojoAttachPoint="closeButtonNode" class="dijitDialogCloseIcon" dojoAttachEvent="ondijitclick: onCancel" title="${buttonCancel}" role="button" tabIndex="-1"\r\n\t\t\t><span dojoAttachPoint="closeText" class="closeText" title="${buttonCancel}">x</span\r\n\t\t></span\r\n\t></div\r\n\t><div class="messageSummary"\r\n\t\t><span class="imgSpan"><img dojoAttachPoint="icon" class="message${type}Icon" src="${_blankGif}" alt="${type}" /></span\r\n\t\t><span id="${id}_desc" role="alert" dojoAttachPoint="description" class="messageDescription" tabindex="0">${text}</span\r\n\t></div\r\n\t><div dojoAttachPoint="messageWrapper" class="messageWrapper compact"\r\n\t\t><div dojoAttachPoint="containerNode" class="dijitDialogPaneContent" tabindex="0"\r\n\t\t></div\r\n\t></div\r\n\t><div class="messageDialogFooter" dojoAttachPoint="actionBar"\r\n\t\t><span class="messageRef"\r\n\t\t\t><a dojoAttachPoint="reference">${messageId}</a\r\n\t\t></span\r\n\t\t><span class="messageTimeStamp" dojoAttachPoint="timestamp">${messageTimeStamp}</span\r\n\t\t><span class="messageAction"\r\n\t\t\t><input dojoAttachPoint="confirmAction"/\r\n\t\t\t><input dojoAttachPoint="closeAction"/\r\n\t\t></span\r\n\t></div\r\n></div>'}});
define("idx/widget/ModalDialog","dojo/_base/kernel,dojo/_base/array,dojo/_base/declare,dojo/_base/html,dojo/_base/event,dojo/_base/lang,dojo/query,dojo/dom-attr,dojo/dom-class,dojo/dom-style,dojo/i18n,dojo/keys,dojo/on,dojo/ready,dojo/date/locale,dijit/_base/wai,dijit/_base/manager,dijit/a11y,dijit/focus,dijit/layout/ContentPane,dijit/Dialog,dijit/layout/TabContainer,dijit/TitlePane,dijit/form/Button,dojo/text!./templates/ModalDialog.html,dojo/i18n!./nls/ModalDialog".split(","),function(t,j,k,u,f,
c,g,h,d,b,l,m,v,w,i,e,x,n,y,o,p,q,z,r,s){return c.getObject("idx.oneui.messaging",!0).ModalDialog=k("idx.widget.ModalDialog",[p],{templateString:s,widgetsInTemplate:!0,baseClass:"idxModalDialog",alert:!1,_messagingTypeMap:{error:"Error",warning:"Warning",information:"Information",success:"Success",confirmation:"Confirmation",question:"Question"},type:"",text:"",info:"",messageId:"",messageRef:null,messageTimeStamp:"",closeButtonLabel:"",showActionBar:!0,showIcon:!0,showCancel:!0,postMixInProperties:function(){this._nlsResources=
l.getLocalization("idx.widget","ModalDialog",this.lang);var a=this._messagingTypeMap[(this.type||"information").toLowerCase()];c.mixin(this,{title:this._nlsResources[a]||"Information",type:a});c.mixin(this.params,{type:a});this.messageTimeStamp=this.messageTimeStamp||"";this.messageTime=this.messageTime||!1;if(!this.alert&&"Error"==this.type)this.alert=!0;this.inherited(arguments)},buildRendering:function(){this.inherited(arguments);!this.messageId&&this.reference&&b.set(this.reference,"display",
"none");this.timestamp&&!this.messageTime&&!this.messageTimeStamp&&b.set(this.timestamp,"display","none");if(this.info&&c.isArray(this.info))this.tabs=new q({useMenu:!1,useSlider:!1,style:"height:175px"},this.containerNode),b.set(this.messageWrapper,"borderTop","0 none"),j.forEach(this.info,function(a){a=new o({title:a.title,content:a.content});e.setWaiRole(a.domNode,"document");this.tabs.addChild(a)},this);this.showActionBarNode(this.showActionBar);this.showIconNode(this.showIcon)},postCreate:function(){this.inherited(arguments);
b.set(this.confirmAction,"display","none");this.closeAction=new r({label:this.closeButtonLabel||this._nlsResources.closeButtonLabel||"Close",onClick:c.hitch(this,function(a){this.onCancel();f.stop(a)})},this.closeAction);this.showCancelNode(this.showCancel);this.tabs?this.connect(this,"show",function(){g(".dijitTabPane",this.messageWrapper).attr("tabindex",0).style({padding:"6px",margin:"2px"});this.tabs.resize()}):(e.setWaiRole(this.containerNode,"document"),this.info&&this.set("content",this.info));
this.alert&&e.setWaiRole(this.domNode,"alertdialog");g(".dijitTitlePaneContentInner",this.messageWrapper).attr("tabindex",0);this.reference&&(this.messageRef?h.set(this.reference,"href",this.messageRef):d.add(this.reference,"messageIdOnly"));!this.info&&!c.trim(this.containerNode.innerHTML)&&b.set(this.messageWrapper,"display","none")},_onKey:function(a){this.inherited(arguments);var b=a.target;if(!h.has(b,"href")&&!(b==this.closeAction.focusNode||b==this.confirmAction.focusNode)){for(;b;){if(b==
this.domNode||d.contains(b,"dijitPopup"))if(a.keyCode==m.ENTER)this.onExecute();else return;b=b.parentNode}f.stop(a)}},onShow:function(){this.timestamp&&(this.timestamp.innerHTML=(this.messageTimeStamp&&"object"==typeof this.messageTimeStamp?i.format(this.messageTimeStamp,{formatLength:"medium"}):this.messageTimeStamp)||i.format(new Date,{formatLength:"medium"}));this.inherited(arguments)},startup:function(){this.tabs&&this.tabs.startup();this.inherited(arguments)},_setTypeAttr:function(a){d.remove(this.icon,
"message"+this.type+"Icon");this.type=a;this.set("title",this._nlsResources[this.type]||"Information");d.add(this.icon,"message"+this.type+"Icon")},_setTextAttr:function(a){this.description.innerHTML=this.text=a},_getFocusItems:function(){if(this._firstFocusItem)this._firstFocusItem=this.description;else{if(this.tabs){var a=n._getTabNavigable(this.messageWrapper);this._firstFocusItem=a.lowest||a.first||this.closeButtonNode||this.domNode}else this._firstFocusItem=this.closeAction.focusNode;this._lastFocusItem=
this.closeAction.focusNode}},hide:function(){this.inherited(arguments);this._firstFocusItem=null},showActionBarNode:function(a){b.set(this.actionBar,"display",a?"":"none")},showIconNode:function(a){b.set(this.icon,"display",a?"":"none")},showCancelNode:function(a){b.set(this.closeAction.domNode,"display",a?"":"none")},_setLabelCancelAttr:function(a){this.closeAction.set("label",a||this._nlsResources.cancelButtonLabel||"Cancel")}})});