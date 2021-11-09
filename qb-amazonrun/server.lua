local QBCore = exports['qb-core']:GetCoreObject()
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('RouteBoxes:Payment')
AddEventHandler('RouteBoxes:Payment', function()
	local _source = source
	local Player = QBCore.Functions.GetPlayer(_source)
    Player.Functions.AddMoney("bank", 100, "sold-Boxes")
    TriggerClientEvent("QBCore:Notify", _source, "You recieved $100", "success")
end)

RegisterServerEvent('RouteBoxes:TakeDeposit')
AddEventHandler('RouteBoxes:TakeDeposit', function()
	local _source = source
	local Player = QBCore.Functions.GetPlayer(_source)
    Player.Functions.RemoveMoney("bank", 100, "Boxes-deposit")
    TriggerClientEvent("QBCore:Notify", _source, "You were charged a deposit of $100", "error")
end)

RegisterServerEvent('RouteBoxes:ReturnDeposit')
AddEventHandler('RouteBoxes:ReturnDeposit', function(info)
	local _source = source
    local Player = QBCore.Functions.GetPlayer(_source)
    
    if info == 'cancel' then
        Player.Functions.AddMoney("bank", 50, "Boxes-return-vehicle")
        TriggerClientEvent("QBCore:Notify", _source, "You returned the vehicle and recieved your deposit back", "success")
    elseif info == 'end' then
        Player.Functions.AddMoney("bank", 100, "Boxes-return-vehicle")
        TriggerClientEvent("QBCore:Notify", _source, "You returned the vehicle and recieved your deposit back", "success")
    end
end)
