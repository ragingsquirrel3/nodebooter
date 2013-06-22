define(['jade'], function(jade) {
var JST = {};
JST['public_index'] = function anonymous(locals) {
var buf = [];
with (locals || {}) {
buf.push("<div id=\"j_public-index-view\"><sh1>App Index View</sh1></div>");
}
return buf.join("");
};
return JST;
});
