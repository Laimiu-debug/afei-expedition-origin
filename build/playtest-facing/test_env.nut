local ancestor = {name="ancestor", method=function(){print(this.name+"\n");}};
local native = ancestor.method;
local actor = {name="actor", run=function(){ native(); native.call(this); }};
actor.run();
local bound = native.bindenv(ancestor);
actor.run = function(){bound(); bound.call(this);};
actor.run();
