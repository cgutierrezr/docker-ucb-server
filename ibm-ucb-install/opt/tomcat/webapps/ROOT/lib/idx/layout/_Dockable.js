//>>built
define("idx/layout/_Dockable","dojo/_base/declare,dojo/_base/lang,dojo/_base/array,dojo/_base/window,dojo/_base/html,dojo/_base/event,dojo/_base/connect,dojo/keys,dijit/registry,idx/html,idx/util".split(","),function(k,l,i,h,d,j,f,e){return k("idx.layout._Dockable",null,{dockArea:"",delay:10,dragNode:null,topicId:"",_dragging:!1,buildRendering:function(){this.inherited(arguments);d.addClass(this.domNode,"idxDockable")},postCreate:function(){this.inherited(arguments);this.dragNode=this.dragNode||this.focusNode||
this.domNode},startup:function(){this._started||(this.inherited(arguments),this.connect(this.dragNode,"onmousedown","_onDragMouseDown"),this.connect(this.dragNode,"onkeyup","_onKey"))},_setDockAreaAttr:function(a){this.dockArea=a;a="float"!=a;d.toggleClass(this.domNode,"idxDockableDocked",a);d.toggleClass(this.domNode,"idxDockableFloating",!a)},_setParentSelectable:function(a){var b=this.domNode.parentNode;b||(b=h.body());d.setSelectable(b,a)},_onKey:function(a){var b=a.keyCode;if(b==e.SHIFT&&this._dragging){var c=
d.position(this.domNode),a=d.marginBox(this.domNode);this._publish("/idx/move/end",{clientX:c.x+a.w/2,clientY:c.y});this._dragging=!1;this._setParentSelectable(!0);if(dojo.isIE){var g=this;setTimeout(function(){g.focusNode.focus()},30)}}else if(b==e.ENTER||b==e.SPACE)this.toggleable&&this.toggle(),j.stop(a);else if(a.shiftKey&&(b==e.UP_ARROW||b==e.DOWN_ARROW||b==e.LEFT_ARROW||b==e.RIGHT_ARROW))this._offsetX=this._offsetY=0,c=d.position(this.domNode),b==e.UP_ARROW?c.y-=20:b==e.DOWN_ARROW?c.y+=20:b==
e.LEFT_ARROW?c.x-=20:b==e.RIGHT_ARROW&&(c.x+=20),this._dragging||(this._setParentSelectable(!1),this._startMove(a),g=this,setTimeout(function(){g.focusNode?g.focusNode.focus():g.focus?g.focus():g.domNode.focus()},0)),this.position(c.x,c.y),this._publish("/idx/move",{clientX:c.x+d.marginBox(this.domNode).w/2,clientY:c.y}),j.stop(a)},_startMove:function(a){this._dragging=!0;this._startLoc={x:a.clientX,y:a.clientY};if("float"!=this.get("dockArea"))this.onUndock(this.get("dockArea"));this._publish("/idx/move/start",
a)},_endMove:function(a){this._dragging=!1;this._publish("/idx/move/end",a)},_onDragMouseDown:function(a){this._setParentSelectable(!1);this._mouseDown=!0;this._initX=a.clientX;this._initY=a.clientY;var b=d.position(this.domNode);this._offsetX=a.clientX-b.x;this._offsetY=a.clientY-b.y;this._globalMouseMove=this._globalMouseMove||[];this._globalMouseUp=this._globalMouseUp||[];this._globalMouseMove.push(f.connect(h.body(),"onmousemove",this,"_onDragMouseMove"));this._globalMouseUp.push(f.connect(h.body(),
"onmouseup",this,"_onDragMouseUp"))},_onDragMouseUp:function(a){this._mouseDown=!1;i.forEach(this._globalMouseMove,f.disconnect);i.forEach(this._globalMouseUp,f.disconnect);this._dragging&&this._endMove(a);this._setParentSelectable(!0)},_onDragMouseMove:function(a){this._mouseDown&&(!1==this._dragging?(Math.abs(this._initX-a.clientX)>this.delay||Math.abs(this._initY-a.clientY)>this.delay)&&this._startMove(a):(this._publish("/idx/move",a),this.position(a.clientX,a.clientY)))},beforeDock:function(){},
onDock:function(){},onUndock:function(){this.set("dockArea","float");d.style(this.domNode,{width:"",height:""})},position:function(a,b){var c=d.position(this.domNode.offsetParent),e=d.contentBox(this.domNode.offsetParent),f=d.marginBox(this.domNode),f=Math.min(Math.max(a-c.x-this._offsetX,0),e.w-f.w),c=Math.min(Math.max(b-c.y-this._offsetY,0),e.h-this._offsetY);d.marginBox(this.domNode,{l:f,t:c})},_publish:function(a,b){f.publish(this.topicId+a,[{target:this,content:this,event:b,start:this._startLoc}])}})});