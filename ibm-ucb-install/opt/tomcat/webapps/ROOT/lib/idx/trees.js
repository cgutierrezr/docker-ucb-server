//>>built
define("idx/trees",["dojo/_base/lang","idx/main","dojo/dom","dijit/Tree"],function(a,c,d,b){var a=a.getObject("trees",!0,c),b=b.prototype,e=b.isExpandoNode;b.isExpandoNode=function(b,a){return e.call(this,b,a)?!0:!a.expandoNodeText?!1:d.isDescendant(b,a.expandoNodeText)};return a});