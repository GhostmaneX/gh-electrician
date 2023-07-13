local QBCore = exports['qb-core']:GetCoreObject()
local onDuty = false
local DeliveriesCount = 0
local LastGoal = 0
local Delivered = false
local xxx, yyy, zzz
local Blipy = {}
local Cooldowns = {}

local alreadyStartedJob = false

RegisterNetEvent('gh-electrician:client:startjobs')
AddEventHandler('gh-electrician:client:startjobs', function()
    if onDuty then
        TriggerEvent("gh-electrician:client:startjob", source)
    else
        if alreadyStartedJob then
            QBCore.Functions.Notify("Someone has already started the job. Please wait for 20 minutes.", "error")
        else
            TriggerEvent("gh-electrician:client:startjob", source)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if alreadyStartedJob then
            Citizen.Wait(1200000) -- Wait for 20 minutes
            alreadyStartedJob = false
        end
    end
end)

RegisterNetEvent('gh-electrician:client:startjob')
AddEventHandler('gh-electrician:client:startjob', function(source)
    onDuty = not onDuty
    if onDuty then
        DrawTarget()
        alreadyStartedJob = true
        TriggerEvent('QBCore:Notify', 'You have started working.', 'success')
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        PullOutVehicle()
    else
        TriggerEvent('QBCore:Notify', 'You have stopped working.', 'error')
        EndOfWork()
    end
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(192.97676, -1392.88, 29.299201) -- Replace xxx, yyy, zzz with the desired coordinates

    SetBlipSprite(blip, 769) -- Blip sprite (1 = standard white circle)
    SetBlipDisplay(blip, 2) -- Blip display (2 = minimap and world map)
    SetBlipScale(blip, 0.7) -- Blip scale
    SetBlipColour(blip, 4) -- Blip color (3 = red)
    SetBlipAsShortRange(blip, true) -- Blip shown only at short range
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Electrician Job") -- Blip name
    EndTextCommandSetBlipName(blip)
end)

function AddObjBlip(TargetPos)
    Blipy['obj'] = AddBlipForCoord(TargetPos.x, TargetPos.y, TargetPos.z)
    SetBlipSprite(Blipy['obj'], 767) -- Blip sprite (1 = standard white circle)
    SetBlipDisplay(Blipy['obj'], 2) -- Blip display (2 = minimap and world map)
    SetBlipScale(Blipy['obj'], 0.8) -- Blip scale
    SetBlipColour(Blipy['obj'], 66) -- Blip color (66 = yellow)
    SetBlipAsShortRange(Blipy['obj'], true) -- Blip shown only at short range
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Ruined Power") -- Blip name
    EndTextCommandSetBlipName(Blipy['obj'])

    SetBlipRoute(Blipy['obj'], true) -- Set the blip as a waypoint
end

Config.Zones = {
	Vehicle = {
		Pos   = {x = 191.16, y = -1394.60, z = 29.29}
	},

	Spawn = {
        Pos   = {x = 191.16, y = -1394.60, z = 29.29, h = 150.44},
        Heading = 150.44
	},
}

function PullOutVehicle()
    if ownsVan == true then
        QBCore.Functions.Notify("You already have a van! Go and collect it or end your job.", "error")
    elseif ownsVan == false then
        coords = Config.Zones.Spawn.Pos
        QBCore.Functions.SpawnVehicle('balzer', function(veh)
            SetVehicleNumberPlateText(veh, "ELECTRICIAN"..tostring(math.random(1000, 9999)))
            SetEntityHeading(veh, coords.h)
            exports['qb-fuel']:SetFuel(veh, 100.0)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            SetPedIntoVehicle(PlayerPedId(), veh, -1) -- Ensures the player spawns inside the vehicle
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            SetVehicleEngineOn(veh, true, true)
            plaquevehicule = GetVehicleNumberPlateText(veh)
        end, coords, true)
        InService = true
        DrawTarget()
        AddCancelBlip()
        ownsVan = true
        TriggerServerEvent("gh-electrician:TakeDeposit")
    end
end

function DrawTarget()
    local RandomPoint = math.random(1, 5)
    local xxx, yyy, zzz

    if RandomPoint == 1 then
        xxx, yyy, zzz = -655.2207, -2364.063, 13.779356
        LastGoal = 1
    elseif RandomPoint == 2 then
        xxx, yyy, zzz = -1110.571, -759.502, 18.478544
        LastGoal = 2
    elseif RandomPoint == 3 then
        xxx, yyy, zzz = 1146.9346, -414.1597, 67.322448
        LastGoal = 3
    elseif RandomPoint == 4 then
        xxx, yyy, zzz = 1191.3104, 2656.7163, 37.597339
        LastGoal = 4
    elseif RandomPoint == 5 then
        xxx, yyy, zzz = -3241.934, 1012.8008, 12.152571
        LastGoal = 5
    end
    
    local TargetPos = vector3(xxx, yyy, zzz)
    AddObjBlip(TargetPos)
    QBCore.Functions.Notify("Go Fix Some Ruined Power", "success")
end

function RemoveBlipObj()
    RemoveBlip(Blipy['obj'])
end

function RemoveAllBlips()
    RemoveBlip(Blipy['obj'])
end

function EndOfWork()
    RemoveAllBlips()
    local ped = GetPlayerPed(-1)
    if IsPedInAnyVehicle(ped, false) then
        local Van = GetVehiclePedIsIn(ped, false)
        if IsVehicleModel(Van, GetHashKey('balzer')) then
            QBCore.Functions.DeleteVehicle(Van)
            if Delivered == true then
                TriggerServerEvent("gh-electrician:ReturnDeposit", 'end')
            end
            InService = false
            BlipSell = nil
            BlipEnd = nil
            TargetPos = nil
            HasDrugs = false
            LastGoal = nil
            DeliveriesCount = 0
            xxx = nil
            yyy = nil
            zzz = nil
            ownsVan = false
            Delivered = false
        else
            QBCore.Functions.Notify("You must return to Drugs balzer!", "error")
            QBCore.Functions.Notify("If you lost the balzer cancel the job on foot", "error")
        end
    else
        InService = false
        BlipSell = nil
        BlipEnd = nil
        TargetPos = nil
        HasDrugs = false
        LastGoal = nil
        DeliveriesCount = 0
        xxx = nil
        yyy = nil
        zzz = nil
        ownsVan = false
        Delivered = false
    end
end

local alreadyFixed = false

RegisterNetEvent('gh-electrician:client:fix')
AddEventHandler("gh-electrician:client:fix", function()
    if onDuty then
        QBCore.Functions.Progressbar("fix_power", "Fixing Power", 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            anim = "machinic_loop_mechandplayer",
            flags = 16,
        }, {}, {}, function() 
            local playerPed = PlayerPedId()
            local time = math.random(5, 7)
            local circles = math.random(3, 4)
            local success = exports['qb-lock']:StartLockPickCircle(circles, time)
            if success then
                StopAnimTask(playerPed, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                TriggerServerEvent("gh-electrician:server:Payment")
                ClearPedTasks(playerPed)
                alreadyFixed = true
                DrawTarget()
                RemoveBlipObj()
                SetBlipRoute(BlipSell, false)
            else
                QBCore.Functions.Notify("Failed Fixing Power, Took 200$ From You For The Tools", "error")
                TriggerServerEvent("gh-electrician:server:Fail")
                ClearPedTasks(playerPed)
            end
        end)
    else
        QBCore.Functions.Notify("You Are Not On Duty.", "error")
    end
end)

RegisterNetEvent('gh-electrician:client:fixPower')
AddEventHandler('gh-electrician:client:fixPower', function()
    if alreadyFixed then
        QBCore.Functions.Notify("Already Fixed, Wait 10 Minutes", "error")
    else
        TriggerEvent("gh-electrician:client:fix", source)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if alreadyFixed then
            Citizen.Wait(600000)
            alreadyFixed = false
        end
    end
end)

local alreadyFixed2 = false

RegisterNetEvent('gh-electrician:client:fix2')
AddEventHandler("gh-electrician:client:fix2", function()
    if onDuty then
    QBCore.Functions.Progressbar("fix_power", "Fixing Power", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        anim = "machinic_loop_mechandplayer",
        flags = 16,
    }, {}, {}, function() 
        local playerPed = PlayerPedId()
        local time = math.random(5, 7)
        local circles = math.random(3, 4)
        local success = exports['qb-lock']:StartLockPickCircle(circles, time)
        if success then
            StopAnimTask(ped, dict, "machinic_loop_mechandplayer", 1.0)
            TriggerServerEvent("gh-electrician:server:Payment")
            ClearPedTasks(playerPed)
            alreadyFixed2 = true
            DrawTarget()
        else
            QBCore.Functions.Notify("Failed Fixing Power, Took 200$ From You For The Tools", "error")
            TriggerServerEvent("gh-electrician:server:Fail")
            ClearPedTasks(playerPed)
        end
    end)
else
    QBCore.Functions.Notify("You Are Not On Duty.", "error")
end
end)

RegisterNetEvent('gh-electrician:client:fixPower2')
AddEventHandler('gh-electrician:client:fixPower2', function()
    if alreadyFixed2 then
        QBCore.Functions.Notify("Already Fixed, Wait 10 Minutes", "error")
    else
        TriggerEvent("gh-electrician:client:fix2", source)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if alreadyFixed2 then
            Citizen.Wait(600000)
            alreadyFixed2 = false
        end
    end
end)

local alreadyFixed3 = false

RegisterNetEvent('gh-electrician:client:fix3')
AddEventHandler("gh-electrician:client:fix3", function()
    if onDuty then
    QBCore.Functions.Progressbar("fix_power", "Fixing Power", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        anim = "machinic_loop_mechandplayer",
        flags = 16,
    }, {}, {}, function() 
        local playerPed = PlayerPedId()
        local time = math.random(5, 7)
        local circles = math.random(3, 4)
        local success = exports['qb-lock']:StartLockPickCircle(circles, time)
        if success then
            StopAnimTask(ped, dict, "machinic_loop_mechandplayer", 1.0)
            TriggerServerEvent("gh-electrician:server:Payment")
            ClearPedTasks(playerPed)
            alreadyFixed3 = true
            DrawTarget()
        else
            QBCore.Functions.Notify("Failed Fixing Power, Took 200$ From You For The Tools", "error")
            TriggerServerEvent("gh-electrician:server:Fail")
            ClearPedTasks(playerPed)
        end
    end)
else
    QBCore.Functions.Notify("You Are Not On Duty.", "error")
end
end)

RegisterNetEvent('gh-electrician:client:fixPower3')
AddEventHandler('gh-electrician:client:fixPower3', function()
    if alreadyFixed3 then
        QBCore.Functions.Notify("Already Fixed, Wait 10 Minutes", "error")
    else
        TriggerEvent("gh-electrician:client:fix3", source)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if alreadyFixed3 then
            Citizen.Wait(600000)
            alreadyFixed3 = false
        end
    end
end)

local alreadyFixed4 = false

RegisterNetEvent('gh-electrician:client:fix4')
AddEventHandler("gh-electrician:client:fix4", function()
    if onDuty then
    QBCore.Functions.Progressbar("fix_power", "Fixing Power", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        anim = "machinic_loop_mechandplayer",
        flags = 16,
    }, {}, {}, function() 
        local playerPed = PlayerPedId()
        local time = math.random(5, 7)
        local circles = math.random(3, 4)
        local success = exports['qb-lock']:StartLockPickCircle(circles, time)
        if success then
            StopAnimTask(ped, dict, "machinic_loop_mechandplayer", 1.0)
            TriggerServerEvent("gh-electrician:server:Payment")
            ClearPedTasks(playerPed)
            alreadyFixed4 = true
            DrawTarget()
        else
            QBCore.Functions.Notify("Failed Fixing Power, Took 200$ From You For The Tools", "error")
            TriggerServerEvent("gh-electrician:server:Fail")
            ClearPedTasks(playerPed)
        end
    end)
else
    QBCore.Functions.Notify("You Are Not On Duty.", "error")
end
end)

RegisterNetEvent('gh-electrician:client:fixPower4')
AddEventHandler('gh-electrician:client:fixPower4', function()
    if alreadyFixed4 then
        QBCore.Functions.Notify("Already Fixed, Wait 10 Minutes", "error")
    else
        TriggerEvent("gh-electrician:client:fix4", source)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if alreadyFixed4 then
            Citizen.Wait(600000)
            alreadyFixed4 = false
        end
    end
end)

local alreadyFixed5 = false

RegisterNetEvent('gh-electrician:client:fix5')
AddEventHandler("gh-electrician:client:fix5", function()
    if onDuty then
    QBCore.Functions.Progressbar("fix_power", "Fixing Power", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        anim = "machinic_loop_mechandplayer",
        flags = 16,
    }, {}, {}, function() 
        local playerPed = PlayerPedId()
        local time = math.random(5, 7)
        local circles = math.random(3, 4)
        local success = exports['qb-lock']:StartLockPickCircle(circles, time)
        if success then
            StopAnimTask(ped, dict, "machinic_loop_mechandplayer", 1.0)
            TriggerServerEvent("gh-electrician:server:Payment")
            ClearPedTasks(playerPed)
            alreadyFixed5 = true
            DrawTarget()
        else
            QBCore.Functions.Notify("Failed Fixing Power, Took 200$ From You For The Tools", "error")
            TriggerServerEvent("gh-electrician:server:Fail")
            ClearPedTasks(playerPed)
        end
    end)
else
    QBCore.Functions.Notify("You Are Not On Duty.", "error")
end
end)

RegisterNetEvent('gh-electrician:client:fixPower5')
AddEventHandler('gh-electrician:client:fixPower5', function()
    if alreadyFixed5 then
        QBCore.Functions.Notify("Already Fixed, Wait 10 Minutes", "error")
    else
        TriggerEvent("gh-electrician:client:fix5", source)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if alreadyFixed5 then
            Citizen.Wait(600000)
            alreadyFixed5 = false
        end
    end
end)