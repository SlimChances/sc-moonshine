Config = {}

Config.Phone = "gks" -- either qb-phone - qs-smartphone or gks
Config.StartLocation = vector4(1401.18, 3601.01, 35.03, 204.22) -- Start location for Moonshine run (gives the corn needed to make mash)
Config.RunAmount = math.random(7, 10) -- How many drop-offs the player can make each run.
Config.StartShinePayment = 1000 -- How much you pay at the start to start the run
Config.PaymentAmount = math.random(750, 1000)
Config.MinCops = 0 -- Minimum required amount of cops
Config.CallCopsChance = 0 -- %Chance to alert police
--alerts for police are configured for cd_dispatch. If you want to change it it is in the client.lua

Config.LaunderChance = 100 -- %Chance to launder money
Config.LaunderItem = 'bands' 
Config.LauderPay = math.random(100,200)

Config.ShineChance = 100 -- %Chance to receive corn
Config.ShineItem = 'corn'

Config.RareLoot = 3 -- %Chance to receive a rare loot item
Config.RareLootItem = 'gatecrack' -- Rare loot item

Config.Locations = { -- Drop-off locations
    vector4(74.5, -762.17, 31.68, 160.98),
    vector4(100.58, -644.11, 44.23, 69.11),
    vector4(175.45, -445.95, 41.1, 92.72),
    vector4(130.3, -246.26, 51.45, 219.63),
    vector4(198.1, -162.11, 56.35, 340.09),
    vector4(341.0, -184.71, 58.07, 159.33),
    vector4(-26.96, -368.45, 39.69, 251.12),
    vector4(-155.88, -751.76, 33.76, 251.82),
    vector4(-305.02, -226.17, 36.29, 306.04),
    vector4(-347.19, -791.04, 33.97, 3.06),
    vector4(-703.75, -932.93, 19.22, 87.86),
    vector4(-659.35, -256.83, 36.23, 118.92),
    vector4(-934.18, -124.28, 37.77, 205.79),
    vector4(-1214.3, -317.57, 37.75, 18.39),
    vector4(-822.83, -636.97, 27.9, 160.23),
    vector4(308.04, -1386.09, 31.79, 47.23),
    vector4(-1041.13, -392.04, 37.81, 25.98),
    vector4(-731.69, -291.67, 36.95, 330.53),
    vector4(-835.17, -353.65, 38.68, 265.05),
    vector4(-1062.43, -436.19, 36.63, 121.55),
    vector4(-1147.18, -520.47, 32.73, 215.39),
    vector4(-1174.68, -863.63, 14.11, 34.24),
    vector4(-1688.04, -1040.9, 13.02, 232.85),
    vector4(-1353.48, -621.09, 28.24, 300.64),
    vector4(-1029.98, -814.03, 16.86, 335.74),
    vector4(-893.09, -723.17, 19.78, 91.08),
    vector4(-789.23, -565.2, 30.28, 178.86),
    vector4(-345.48, -1022.54, 30.53, 341.03),
    vector4(218.9, -916.12, 30.69, 6.56),
    vector4(57.66, -1072.3, 29.45, 245.38)
}


---processing
--delay between processing items
Config.Delays = {
	
	MashProcessing = 1000 * 10,
   
	
}
--cirlce zones of the areas below needs to be changed in the target.lua also.
Config.CircleZones = {


	SugarField = {coords = vector3(-170.56, 3755.7, 37.9), name = ('Sugar'), radius = 100.0}, --place to get the sugar from
	MashProcessing = {coords = vector3(1087.14, -3195.31, -38.99), name = ('Sugar Process'), radius = 20.0}, --used if you are processing sugar cane item to sugar
	Mash = {coords = vector3(1390.98, 3606.3, 38.73), name = ('Mash Making'), radius = 20.0},--place to make mash
	Moonshine = {coords = vector3(1389.83, 3608.71, 38.94), name = ('Bottle Up Moonshine'), radius = 20.0},--mash to moonshine
	



}



Config.MoonshineLab = {
	["enter"] = {
        coords = vector4(1388.37, 3615.65, 38.92, 27.56), --enter moonshine lab
    },
    ["exit"] = {
        coords = vector4(1398.95, 3608.34, 38.94, 97.93), -- exit moonshine lab
    },
}





--------------------------------
-- Moonshine PROCESSING AMOUNTS --
--------------------------------
--amounts of the processing you receive 
Config.MoonshineProcessing = {
	SugarLeaf = 1, -- Amount of Sugar Needed to Process
	
	Sugar = 1, -- amount of sugar needed
	Corn = 1, -- Amount of Baking Soda Needed for Small Brick
	Mash = 5,
	-- Process Small Bricks Into Large Brick --
	Moonshine = 5, -- Amount of Small Bricks Required
	
 } 

