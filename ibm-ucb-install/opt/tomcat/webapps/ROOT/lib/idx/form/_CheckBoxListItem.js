//>>built
require({cache:{"url:idx/form/templates/_CheckBoxListItem.html":'<div class="dijitReset ${baseClass}"\r\n\t><input id="${_inputId}" dojoType="dijit.form.CheckBox" dojoAttachPoint="focusNode" type="checkbox"\r\n\t/><label for="${_inputId}" dojoAttachPoint="labelNode"></label\r\n></div>'}});
define("idx/form/_CheckBoxListItem","dojo/_base/declare,dijit/_Widget,dijit/_CssStateMixin,dijit/_TemplatedMixin,dijit/_WidgetsInTemplateMixin,idx/form/_InputListItemMixin,dojo/text!./templates/_CheckBoxListItem.html,dijit/form/CheckBox".split(","),function(a,b,c,d,e,f,g){return a("idx.form._CheckBoxListItem",[b,c,d,e,f],{templateString:g,baseClass:"idxCheckBoxListItem",_changeBox:function(){if(!this.get("disabled")&&!this.get("readOnly"))this.option.selected=!!this.focusNode.get("checked"),this.parent.set("value",
this.parent._getValueFromOpts()),this.parent.focusChild(this)}})});