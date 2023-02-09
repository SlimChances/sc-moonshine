# sc-moonshine
Moonshine runs and Processing for QB-CORE

This script was made using code from:
@LionH34rt oxy runs https://github.com/Lionh34rt/qb-oxyruns
Project Sloth's ps-drugprocessing script https://github.com/Project-Sloth/ps-drugprocessing

<h1>How To Install</h1>
Add to qb-core/shared/items.lua

```
["moonshine"]					 = {["name"] = "moonshine",						["label"] = "Moonshine",				["weight"] = 30,		["type"] = "item",		["image"] = "images/moonshine.png",			["unique"] = false,     ["useable"] = false,    ["shouldclose"] = false,    ["combinable"] = nil,   ["description"] = "XXX The Good Shit"},
["mash"]					 	 = {["name"] = "mash",							["label"] = "Mash Bottle",				["weight"] = 30,		["type"] = "item",		["image"] = "images/mash.png",					["unique"] = false,     ["useable"] = false,    ["shouldclose"] = false,    ["combinable"] = nil,   ["description"] = "Mash Bottle Maybe its used for something"},
["sugar"]					 	 = {["name"] = "sugar",							["label"] = "Sugar",					["weight"] = 30,		["type"] = "item",		["image"] = "images/sugar.png",				["unique"] = false,     ["useable"] = false,    ["shouldclose"] = false,    ["combinable"] = nil,   ["description"] = "Sweet or Salty"},
["corn"]					 	 = {["name"] = "corn",							["label"] = "Corn",					["weight"] = 30,		["type"] = "item",		["image"] = "images/corn.png",				["unique"] = false,     ["useable"] = false,    ["shouldclose"] = false,    ["combinable"] = nil,   ["description"] = "How Corny?"},
["trimming_scissors"] 		 	 = {["name"] = "trimming_scissors",           	["label"] = "Trimming Scissors",	 	["weight"] = 1500, 		["type"] = "item", 		["image"] = "images/trimming_scissors.png", 	["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["expire"] = 90,  ["description"] = "Very Sharp Trimming Scissors"},
```
add this to qb-smallresources/server/consumables.lua
```
QBCore.Functions.CreateUseableItem("moonshine", function(source, item)
    TriggerClientEvent("consumables:client:DrinkAlcohol", source, item.name)
end)
```
add the imgages in the install/images folder to 
qb-inventory/html/images

add qb-moonshine to your resources folder 

restart your server and enjoy.

add your phone to sh_config.lua under line 3 to the phone you use. Example: if you use qb-phone put Config.Phone = "qb-phone"

all things in the shared/sh_config.lua are configurable.


Preview https://streamable.com/0qvhz9
