define(['jade'], function(jade) {
var JST = {};
JST['public_index'] = function anonymous(locals) {
var buf = [];
with (locals || {}) {
buf.push("<h1>App Index View</h1>");
}
return buf.join("");
};
return JST;
});
