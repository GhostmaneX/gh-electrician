local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('gh-electrician:server:Payment')
AddEventHandler('gh-electrician:server:Payment', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local payment = math.random(200, 500)
    Player.Functions.AddMoney('cash', payment, "Power-Fixed")
    TriggerClientEvent("QBCore:Notify", src, "You received $" .. payment, "success")
end)

RegisterServerEvent('gh-electrician:server:Fail')
AddEventHandler('gh-electrician:server:Fail', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local payment = 200
    Player.Functions.RemoveMoney('cash', payment, "Power-Not-Fixed")
end)

RegisterServerEvent('gh-electrician:TakeDeposit', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveMoney("bank", 100, src, "Drugs-deposit")
    TriggerClientEvent("QBCore:Notify", src, "You were charged a deposit of $100", "error")
end)

RegisterServerEvent('gh-electrician:ReturnDeposit', function(info)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if info == 'cancel' then
        Player.Functions.AddMoney("cash", 50, "Drugs-return-vehicle")
        TriggerClientEvent("QBCore:Notify", src, "You returned the vehicle and recieved your deposit back", "success")
    elseif info == 'end' then
        Player.Functions.AddMoney("cash", 150, "Drugs-return-vehicle")
        TriggerClientEvent("QBCore:Notify", src, "You returned the vehicle and recieved your deposit back", "success")
    end
end)