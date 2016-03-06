//>>built
define("idx/widget/ResizeHandle","dojo/_base/declare,dojo/_base/html,dojo/_base/event,dojo/keys,dojox/layout/ResizeHandle,idx/resources".split(","),function(f,b,g,d,h,i){return f("idx.widget.ResizeHandle",h,{postCreate:function(){this.inherited(arguments);var a=i.getResources("idx/widget/ResizeHandle",this.lang).idxResizeHandle_resize;b.attr(this.resizeHandle.firstChild||this.resizeHandle,"innerHTML","<span class='idxResizeHandleText' title='"+a+"'>/</span>");b.attr(this.resizeHandle,"tabindex",0);
this.connect(this.resizeHandle,"keypress",this._onKeyPress)},_onKeyPress:function(a){if(a&&a.shiftKey){var c=a.keyCode;if(this._resizeX&&(c==d.LEFT_ARROW||c==d.RIGHT_ARROW)||this._resizeY&&(c==d.UP_ARROW||c==d.DOWN_ARROW))if(this.targetWidget=dijit.byId(this.targetId),this.targetDomNode=this.targetContainer||(this.targetWidget?this.targetWidget.domNode:b.byId(this.targetId))){c=this.targetWidget?b.marginBox(this.targetDomNode):b.contentBox(this.targetDomNode);this.startSize={w:c.w,h:c.h};this._changeSizing(a);
if(!this.intermediateChanges)this.onResize(a);g.stop(a)}}},_getNewCoords:function(a){if(a&&a.keyCode){var c=a.keyCode,e=this.startSize.w,b=this.startSize.h;c==d.UP_ARROW?b-=10:c==d.DOWN_ARROW?b+=10:c==d.LEFT_ARROW?e=this.isLeftToRight()?e-10:e+10:c==d.RIGHT_ARROW&&(e=this.isLeftToRight()?e+10:e-10);return this._checkConstraints(e,b)}return this.inherited(arguments)},_setResizeAxisAttr:function(a){b.removeClass(this.resizeHandle,this._getResizeClass());this._resizeAxis=a;this._resizeX=-1<a.indexOf("x");
this._resizeY=-1<a.indexOf("y");dojo.addClass(this.resizeHandle,this._getResizeClass())},_getResizeClass:function(){var a=this._resizeAxis;return"xy"==a?"dojoxResizeNW":"x"==a?"dojoxResizeW":"y"==a?"dojoxResizeN":""}})});