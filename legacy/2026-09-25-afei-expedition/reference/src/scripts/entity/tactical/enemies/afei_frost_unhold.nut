this.afei_frost_unhold <- this.inherit("scripts/entity/tactical/enemies/unhold_frost", {
 function create() {this.unhold_frost.create();this.m.Name="北境白影";},
 function onInit() {this.unhold_frost.onInit();this.getFlags().set("afei_frost_unhold",true);}
});