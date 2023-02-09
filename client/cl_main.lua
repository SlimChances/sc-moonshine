local QBCore = exports['qb-core']:GetCoreObject()

local spawwnedSugarLeaf = 0
local SugarPlants = {}
local isPickingUp, isProcessing, inSugarField = false, false, false

local started = false
local dropOffCount = 0
local hasDropOff = false

local oxyPed = nil
local madeDeal = false

local dropOffBlip = nil

local peds = {
	'a_m_y_stwhi_02',
	'a_m_y_stwhi_01',
	'a_f_y_genhot_01',
	'a_f_y_vinewood_04',
	'a_m_m_golfer_01',
	'a_m_m_soucent_04',
	'a_m_o_soucent_02',
	'a_m_y_epsilon_01',
	'a_m_y_epsilon_02',
	'a_m_y_mexthug_01'
}

--- This function can be used to trigger your desired dispatch alerts
local AlertCops = function()
	--exports['qb-dispatch']:DrugSale() -- Project-SLoth qb-dispatch
	--TriggerServerEvent('police:server:policeAlert', 'Suspicious Hand-off') -- Regular qbcore
	local data = exports['cd_dispatch']:GetPlayerInfo()
TriggerServerEvent('cd_dispatch:AddNotification', {
    job_table = {'police'}, 
    coords = data.coords,
    title = 'Possible Drug Sale',
    message = 'A '..data.sex..' is possibly selling drugs at '..data.street, 
    flash = 0,
    unique_id = tostring(math.random(0000000,9999999)),
    blip = {
        sprite = 431, 
        scale = 1.2, 
        colour = 3,
        flashes = false, 
        text = '911 - Drug Sale',
        time = (5*60*1000),
        sound = 1,
    }
})
end

--- Creates a drop off blip at a given coordinate
--- @param coords vector4 - Coordinates of a location
local CreateDropOffBlip = function(coords)
	dropOffBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(dropOffBlip, 499)
    SetBlipScale(dropOffBlip, 1.0)
    SetBlipAsShortRange(dropOffBlip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Deliver")
    EndTextCommandSetBlipName(dropOffBlip)
end

--- Creates a drop off ped at a given coordinate
--- @param coords vector4 - Coordinates of a location
local CreateDropOffPed = function(coords)
	if oxyPed ~= nil then return end
	local model = peds[math.random(#peds)]
	local hash = GetHashKey(model)

    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(10) end
	oxyPed = CreatePed(5, hash, coords.x, coords.y, coords.z-1, coords.w, true, true)
	while not DoesEntityExist(oxyPed) do Wait(10) end
	ClearPedTasks(oxyPed)
    ClearPedSecondaryTask(oxyPed)
    TaskSetBlockingOfNonTemporaryEvents(oxyPed, true)
    SetPedFleeAttributes(oxyPed, 0, 0)
    SetPedCombatAttributes(oxyPed, 17, 1)
    SetPedSeeingRange(oxyPed, 0.0)
    SetPedHearingRange(oxyPed, 0.0)
    SetPedAlertness(oxyPed, 0)
    SetPedKeepTask(oxyPed, true)
	FreezeEntityPosition(oxyPed, true)
	exports['qb-target']:AddTargetEntity(oxyPed, {
		options = {
			{
				type = "client",
				event = "qb-moonshine:client:DeliverShine",
				icon = 'fas fa-capsules',
				label = 'Make Deal',
			}
		},
		distance = 2.0
	})
end

--- Creates a random drop off location
local CreateDropOff = function()
	hasDropOff = true
	if Config.Phone == "gks" then
		TriggerEvent('gksphone:notifi', {title = "Moonshine", message = "Make your way to the drop-off..", img= '/html/static/img/icons/messages.png', duration = 5000})
	end
	if Config.Phone == "qb-phone" then
	TriggerEvent('qb-phone:client:CustomNotification', 'CURRENT', "Make your way to the drop-off..", 'fas fa-capsules', '#3480eb', 8000)
	end
	if Config.Phone == "qs-smartphone" then
		TriggerEvent('qs-smartphone:client:notify', {
			title = 'Moonshine',
			text = 'Make your way to the drop-off..',
			icon = "./img/apps/whatsapp.png",
			timeout = 1500
		})
	end
	dropOffCount += 1
	local randomLoc = Config.Locations[math.random(#Config.Locations)]
	-- Blip
	CreateDropOffBlip(randomLoc)
	-- PolyZone
	dropOffArea = CircleZone:Create(randomLoc.xyz, 85.0, {
		name = "dropOffArea",
		debugPoly = false
	})
	dropOffArea:onPlayerInOut(function(isPointInside, point)
		if isPointInside then
			if oxyPed == nil then
				if Config.Phone == "gks" then
					TriggerEvent('gksphone:notifi', {title = "Moonshine", message = "Make the delivery...", img= '/html/static/img/icons/messages.png', duration = 5000})
				end
				if Config.Phone == "qb-phone" then
				TriggerEvent('qb-phone:client:CustomNotification', 'CURRENT', "Make the delivery..", 'fas fa-capsules', '#3480eb', 8000)
			end
			if Config.Phone == "qs-smartphone" then
				TriggerEvent('qs-smartphone:client:notify', {
					title = 'Moonshine',
					text = 'Make the delivery...',
					icon = "./img/apps/whatsapp.png",
					timeout = 1500
				})
			end
				CreateDropOffPed(randomLoc)
			end
		end
	end)
end

--- Start an oxy run after paying the initial payment
local StartOxyrun = function()
	if started then return end
	started = true
	if Config.Phone == "gks" then
		TriggerEvent('gksphone:notifi', {title = "Moonshine", message = "Wait for a new location..", img= '/html/static/img/icons/messages.png', duration = 5000})
	end
	if Config.Phone == "qs-smartphone" then
		TriggerEvent('qs-smartphone:client:notify', {
			title = 'Moonshine',
			text = 'Wait for a new location..',
			icon = "./img/apps/whatsapp.png",
			timeout = 1500
		})
	end
	if Config.Phone == "qb-phone" then
	TriggerEvent('qb-phone:client:CustomNotification', 'CURRENT', "Wait for a new location..", 'fas fa-capsules', '#3480eb', 8000)
	end
	while started do
		Wait(4000)
		if not hasDropOff then
			Wait(8000)
			CreateDropOff()
		end
	end
end

--- Deletes the oxy ped
local DeleteOxyped = function()
	FreezeEntityPosition(oxyPed, false)
	SetPedKeepTask(oxyPed, false)
	TaskSetBlockingOfNonTemporaryEvents(oxyPed, false)
	ClearPedTasks(oxyPed)
	TaskWanderStandard(oxyPed, 10.0, 10)
	SetPedAsNoLongerNeeded(oxyPed)
	Wait(20000)
	DeletePed(oxyPed)
	oxyPed = nil
end

RegisterNetEvent("qb-moonshine:client:StartRun", function()
	if started then return end
	QBCore.Functions.TriggerCallback('qb-moonshine:StartMoonshine', function(canStart)
		if canStart then
			StartOxyrun()
		end
	end)
end)

RegisterNetEvent('qb-moonshine:client:DeliverShine', function()
	if madeDeal then return end
	local ped = PlayerPedId()
	if not IsPedOnFoot(ped) then return end
	if #(GetEntityCoords(ped) - GetEntityCoords(oxyPed)) < 5.0 then
		-- Anti spam
		madeDeal = true
		exports['qb-target']:RemoveTargetEntity(oxyPed)

		-- Alert Cops
		if math.random(100) <= Config.CallCopsChance then
			AlertCops()
		end

		-- Face each other
		TaskTurnPedToFaceEntity(oxyPed, ped, 1.0)
		TaskTurnPedToFaceEntity(ped, oxyPed, 1.0)
		Wait(1500)
		PlayAmbientSpeech1(oxyPed, "Generic_Hi", "Speech_Params_Force")
		Wait(1000)

		-- Playerped animation
		RequestAnimDict("mp_safehouselost@")
    	while not HasAnimDictLoaded("mp_safehouselost@") do Wait(10) end
    	TaskPlayAnim(ped, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
		Wait(800)
		
		-- Oxyped animation
		PlayAmbientSpeech1(oxyPed, "Chat_State", "Speech_Params_Force")
		Wait(500)
		RequestAnimDict("mp_safehouselost@")
		while not HasAnimDictLoaded("mp_safehouselost@") do Wait(10) end
		TaskPlayAnim(oxyPed, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0 )
		Wait(3000)

		-- Remove blip
		RemoveBlip(dropOffBlip)
		dropOffBlip = nil

		-- Reward
		TriggerServerEvent('qb-moonshine:server:Reward')

		-- Finishing up
		dropOffArea:destroy()
		Wait(2000)
		if dropOffCount == Config.RunAmount then
			if Config.Phone == "gks" then
				TriggerEvent('gksphone:notifi', {title = "Moonshine", message = "You are done delivery, go back to the spot...", img= '/html/static/img/icons/messages.png', duration = 5000})
			end
			if Config.Phone == "qb-phone"then
			TriggerEvent('qb-phone:client:CustomNotification', 'CURRENT', "You are done delivering, go back to the spot..", 'fas fa-capsules', '#3480eb', 20000)
			end
			if Config.Phone == "qs-smartphone" then
				TriggerEvent('qs-smartphone:client:notify', {
					title = 'Moonshine',
					text = 'You are done delivering, go back to the spot..',
					icon = "./img/apps/whatsapp.png",
					timeout = 1500
				})
			end
			started = false
			dropOffCount = 0
		else
			if Config.Phone == "gks" then
				TriggerEvent('gksphone:notifi', {title = "Moonshine", message = "Delivery was good, you will be updated with the next drop-off..", img= '/html/static/img/icons/messages.png', duration = 5000})
			end
			if Config.Phone == "qb-phone" then
			TriggerEvent('qb-phone:client:CustomNotification', 'CURRENT', "Delivery was good, you will be updated with the next drop-off..", 'fas fa-capsules', '#3480eb', 20000)
			end
			if Config.Phone == "qs-smartphone" then
				TriggerEvent('qs-smartphone:client:notify', {
					title = 'Moonshine',
					text = 'Delivery was good, you will be updated with the next drop-off..',
					icon = "./img/apps/whatsapp.png",
					timeout = 1500
				})
			end

		end
		DeleteOxyped()
		hasDropOff = false
		madeDeal = false
	end
end)

CreateThread(function()
	-- Starter Ped
	local pedModel = `a_m_m_hillbilly_01`
	RequestModel(pedModel)
	while not HasModelLoaded(pedModel) do Wait(10) end
	local ped = CreatePed(0, pedModel, Config.StartLocation.x, Config.StartLocation.y, Config.StartLocation.z-1.0, Config.StartLocation.w, false, false)
	TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD', true)
	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	-- Target
	exports['qb-target']:AddTargetEntity(ped, {
		options = {
			{
				type = "client",
				event = "qb-moonshine:client:StartRun",
				icon = 'fas fa-capsules',
				label = 'Start Moonshine Run ($'..Config.StartShinePayment..')',
			}
		},
		distance = 2.0
	})
end)

--lab

local function LoadAnimationDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(1)
    end
end

local function OpenDoorAnimation()
    local ped = PlayerPedId()
    LoadAnimationDict("anim@heists@keycard@") 
    TaskPlayAnim(ped, "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0)
    Wait(400)
    ClearPedTasks(ped)
end

local function EnterCWarehouse()
    local ped = PlayerPedId()
    OpenDoorAnimation()
    CWarehouse = true
    Wait(500)
    DoScreenFadeOut(250)
    Wait(250)
    SetEntityCoords(ped, Config.MoonshineLab["exit"].coords.x, Config.MoonshineLab["exit"].coords.y, Config.MoonshineLab["exit"].coords.z - 0.98)
    SetEntityHeading(ped, Config.MoonshineLab["exit"].coords.w)
    Wait(1000)
    DoScreenFadeIn(250)
end

local function ExitCWarehouse()
    local ped = PlayerPedId()
    OpenDoorAnimation()
    CWarehouse = true
    Wait(500)
    DoScreenFadeOut(250)
    Wait(250)
    SetEntityCoords(ped, Config.MoonshineLab["enter"].coords.x, Config.MoonshineLab["enter"].coords.y, Config.MoonshineLab["enter"].coords.z - 0.98)
    SetEntityHeading(ped, Config.MoonshineLab["enter"].coords.w)
    Wait(1000)
    DoScreenFadeIn(250)
	CWarehouse = false
end
--process leaf into sugar
local function ProcessSugar()
	isProcessing = true
	local playerPed = PlayerPedId()
	
	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)

	QBCore.Functions.Progressbar("search_register", Lang:t("progressbar.processing"), 15000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function()
		TriggerServerEvent('qb-moonshine:processSugarLeaf')

		local timeLeft = Config.Delays.MashProcessing / 1000
		while timeLeft > 0 do
			Wait(1000)
			timeLeft -= 1

			if #(GetEntityCoords(playerPed)-Config.CircleZones.MashProcessing.coords) > 4 then
				TriggerServerEvent('qb-moonshine:cancelProcessing')
				break
			end
		end
		ClearPedTasks(playerPed)
		isProcessing = false
	end, function()
		ClearPedTasks(playerPed)
		isProcessing = false
	end)
end


local function ValidateSugarLeafCoord(plantCoord)
	local validate = true
	if spawwnedSugarLeaf > 0 then
		for k, v in pairs(SugarPlants) do
			if #(plantCoord - GetEntityCoords(v)) < 5 then
				validate = false
			end
		end
		if not inCokeField then
			validate = false
		end
	end
	return validate
end

local function GetCoordZSugar(x, y)
	local groundCheckHeights = { 1.0, 25.0, 50.0, 73.0, 74.0, 75.0, 76.0, 77.0, 78.0, 79.0, 80.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 77
end

local function GenerateSugarLeafCoords()
	while true do
		Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-35, 35)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-35, 35)

		weedCoordX = Config.CircleZones.SugarField.coords.x + modX
		weedCoordY = Config.CircleZones.SugarField.coords.y + modY

		local coordZ = GetCoordZSugar(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateSugarLeafCoord(coord) then
			return coord
		end
	end
end

local function SpawnSugarPlants()
    while spawwnedSugarLeaf < 15 do
        Wait(0)
        local weedCoords = GenerateSugarLeafCoords()
        RequestModel(`prop_plant_cane_02a`)
        while not HasModelLoaded(`prop_plant_cane_02a`) do
            Wait(100)
        end
        local obj = CreateObject(`prop_plant_cane_02a`, weedCoords.x, weedCoords.y, weedCoords.z, false, true, false)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)
        table.insert(SugarPlants, obj)
        spawwnedSugarLeaf += 1
    end
end
--process into mash with corn and sugar

local function MakeMash()
	isProcessing = true
	local playerPed = PlayerPedId()

	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	QBCore.Functions.Progressbar("search_register", Lang:t("progressbar.processing"), 15000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function()
		TriggerServerEvent('qb-moonshine:processMash')

		local timeLeft = Config.Delays.MashProcessing / 1000
		while timeLeft > 0 do
			Wait(1000)
			timeLeft -= 1

			if #(GetEntityCoords(playerPed)-Config.CircleZones.MashProcessing.coords) > 4 then
				TriggerServerEvent('qb-moonshine:cancelProcessing')
				break
			end
		end
		ClearPedTasks(playerPed)
		isProcessing = false
	end, function()
		ClearPedTasks(playerPed)
		isProcessing = false
	end)
end
--bottle into moonshine
local function ProcessMoonshine()
	isProcessing = true
	local playerPed = PlayerPedId()

	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	QBCore.Functions.Progressbar("search_register", Lang:t("progressbar.packing"), 15000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function()
		TriggerServerEvent('qb-moonshine:processMoonshine')

		local timeLeft = Config.Delays.MashProcessing / 1000
		while timeLeft > 0 do
			Wait(1000)
			timeLeft -= 1

			if #(GetEntityCoords(playerPed)-Config.CircleZones.Moonshine.coords) > 4 then
				TriggerServerEvent('qb-moonshine:cancelProcessing')
				break
			end
		end
		ClearPedTasks(playerPed)
		isProcessing = false
	end, function()
		ClearPedTasks(playerPed)
		isProcessing = false
	end)
end

--[[RegisterNetEvent('qb-moonshine:ProcessSugarFarm', function()
	local coords = GetEntityCoords(PlayerPedId())

	if #(coords-Config.CircleZones.MashProcessing.coords) < 5 then
		if not isProcessing then
			QBCore.Functions.TriggerCallback('qb-moonshine:validate_items', function(result)
				if result.ret then
					ProcessSugar()
				else
					QBCore.Functions.Notify(Lang:t("error.no_item", {item = result.item}))
				end
			end, {sugar = Config.MoonshineProcessing.SugarLeaf, trimming_scissors = 1})
		end
	end
end)]]

RegisterNetEvent('qb-moonshine:processMash', function()
	local coords = GetEntityCoords(PlayerPedId())
	local amount = 10
	local amount2 = 5
	
	if #(coords-Config.CircleZones.Mash.coords) < 5 then
		if not isProcessing then
			local check = {
				sugar = Config.MoonshineProcessing.Sugar,
				corn = Config.MoonshineProcessing.Corn,
				finescale = 1
			}
			QBCore.Functions.TriggerCallback('qb-moonshine:validate_items', function(result)
				if result.ret then
					MakeMash()
				else
					QBCore.Functions.Notify(Lang:t("error.no_item", {item = result.item}))
				end
			end, check)
		else
			QBCore.Functions.Notify(Lang:t("error.already_processing"), 'error')
		end
	end
end)
--------BOTTLE MOONSHINE
RegisterNetEvent('qb-moonshine:processMoonshine', function()
	local coords = GetEntityCoords(PlayerPedId(source))
	local amount = 4
	
	if #(coords-Config.CircleZones.Moonshine.coords) < 5 then
		if not isProcessing then
			QBCore.Functions.TriggerCallback('qb-moonshine:validate_items', function(result)
				if result.ret then
					ProcessMoonshine()
				else
					QBCore.Functions.Notify(Lang:t("error.no_item", {item = result.item}))
				end
			end, {mash = Config.MoonshineProcessing.Moonshine, finescale = 1})
		else
			QBCore.Functions.Notify(Lang:t("error.already_processing"), 'error')
		end
	end
end)
--enter warehouse with a key
RegisterNetEvent('qb-moonshine:EnterMWarehouse', function()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
    local dist = #(pos - vector3(Config.MoonshineLab["enter"].coords.x, Config.MoonshineLab["enter"].coords.y, Config.MoonshineLab["enter"].coords.z))
    if dist < 2 then
		QBCore.Functions.TriggerCallback('qb-moonshine:validate_items', function(result)
			if result.ret then
				EnterCWarehouse()
			else
				QBCore.Functions.Notify(Lang:t("error.no_item", {item = result.item}))
			end
		end, {weedkey=1})
	end
end)

RegisterNetEvent('qb-moonshine:ExitMWarehouse', function()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
    local dist = #(pos - vector3(Config.MoonshineLab["exit"].coords.x, Config.MoonshineLab["exit"].coords.y, Config.MoonshineLab["exit"].coords.z))
    if dist < 2 then
		ExitCWarehouse()
	end
end)
--pick up sugar leaf
RegisterNetEvent('qb-moonshine:pickSugarLeaves', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local nearbyObject, nearbyID

	for i=1, #SugarPlants, 1 do
		if GetDistanceBetweenCoords(coords, GetEntityCoords(SugarPlants[i]), false) < 2 then
			nearbyObject, nearbyID = SugarPlants[i], i
		end
	end

	if nearbyObject and IsPedOnFoot(playerPed) then
		if not isPickingUp then
			isPickingUp = true
			TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

			QBCore.Functions.Progressbar("search_register", Lang:t("progressbar.collecting"), 10000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function() -- Done
				ClearPedTasks(playerPed)
				SetEntityAsMissionEntity(nearbyObject, false, true)
				DeleteObject(nearbyObject)

				table.remove(SugarPlants, nearbyID)
				spawwnedSugarLeaf = spawwnedSugarLeaf - 1

				TriggerServerEvent('qb-moonshine:pickedUpSugarLeaf')
				isPickingUp = false
			end, function()
				ClearPedTasks(playerPed)
				isPickingUp = false
			end)
		end
	end

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(SugarPlants) do
			SetEntityAsMissionEntity(v, false, true)
			DeleteObject(v)
		end
	end
end)

RegisterCommand('fixprops', function()
    for k, v in pairs(GetGamePool('CObject')) do
        if IsEntityAttachedToEntity(PlayerPedId(), v) then
            SetEntityAsMissionEntity(v, true, true)
            DeleteObject(v)
            DeleteEntity(v)
        end
    end
end)

CreateThread(function()
	local cokeZone = CircleZone:Create(Config.CircleZones.SugarField.coords, 10.0, {
		name = "qb-moonshinezone",
		debugPoly = false
	})
	cokeZone:onPlayerInOut(function(isPointInside, point, zone)
        if isPointInside then
            inCokeField = true
            SpawnSugarPlants()
        else
            inCokeField = false
        end
    end)
end)

