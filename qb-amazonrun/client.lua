------------
-- CONFIG --
------------

Config              = {}

Config.Zones = {

	Vehicle = {---vector3(78.89, 111.64, 81.17)
		Pos   = {x = 78.89, y = 111.64, z = 81.17}
	},

	Spawn = {   -- vector4(69.0, 119.32, 79.14, 155.53)
        Pos   = {x = 69.0, y = 119.32, z = 79.14, h = 155.53},
        Heading = 155.53
	},

}

QBCore = exports['qb-core']:GetCoreObject()
PlayerData = {}
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)


RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = QBCore.Functions.GetPlayerData()
end)


local InService = false
local Hired = true
local BlipSell = nil
local BlipEnd = nil
local BlipCancel = nil
local TargetPos = nil
local HasBoxes = false
local NearVan = false
local LastGoal = 0
local DeliveriesCount = 0
local Delivered = false
local xxx = nil
local yyy = nil
local zzz = nil
local Blipy = {}
local JuzBlip = false
local BoxesDelivered = false
local ownsVan = false



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if not JuzBlip then
            Blipy['work'] = AddBlipForCoord(78.53, 111.58, 81.17, 27.71) ---- AddBlipForCoord(538.17, 101.61, 95.63)
            SetBlipSprite(Blipy['work'], 269)
            SetBlipDisplay(Blipy['work'], 4)
            SetBlipScale(Blipy['work'], 0.6)
            SetBlipAsShortRange(Blipy['work'], true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('lS Deliverys')
            EndTextCommandSetBlipName(Blipy['work'])
						JuzBlip = true
        end
    end
end)

--Spawn Van
function PullOutVehicle()
    if ownsVan == true then
        QBCore.Functions.Notify("You already have a vehicle that belongs to us, bring it back or use it.", "error")
    elseif ownsVan == false then
        coords = Config.Zones.Spawn.Pos
        QBCore.Functions.SpawnVehicle('Benson', function(veh)
            SetVehicleNumberPlateText(veh, "Boxes"..tostring(math.random(1000, 9999)))
            SetEntityHeading(veh, coords.h)
           exports['lj-fuel']:SetFuel(veh, GetVehicleNumberPlateText(veh), 100.0, false)
		    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh),true)
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            SetVehicleEngineOn(veh, true, true)
            plaquevehicule = GetVehicleNumberPlateText(veh)
        end, coords, true)
        InService = true
        DrawTarget()
        AddCancelBlip()
        ownsVan = true
        TriggerServerEvent("RouteBoxes:TakeDeposit")
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Hired then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local dist = GetDistanceBetweenCoords(pos, Config.Zones.Vehicle.Pos.x, Config.Zones.Vehicle.Pos.y, Config.Zones.Vehicle.Pos.z, true)
            if dist <= 2.5 then
                local GaragePos = {
                    ["x"] = Config.Zones.Vehicle.Pos.x,
                    ["y"] = Config.Zones.Vehicle.Pos.y,
                    ["z"] = Config.Zones.Vehicle.Pos.z + 1
                }
                DrawText3Ds(GaragePos["x"],GaragePos["y"],GaragePos["z"], "Press [~g~E~s~] to start work")
                if dist <= 3.0 then
                    if IsControlJustReleased(0, 46) then
                        PullOutVehicle()
                    end
                end
            end
        end
    end
end)

-------------------
-- Target Search --
-------------------

function DrawTarget()
    local RandomPoint = math.random(1, 21)
    if DeliveriesCount == 4 then
        QBCore.Functions.Notify("All Boxes are delivered!  Great Job","success")
        RemoveCancelBlip()
        SetBlipRoute(BlipSell, false)
        AddFinnishBlip()
        Delivered = true
				xxx = nil
				yyy = nil
				zzz = nil
    else
      local Boxes = 4 - DeliveriesCount
      if Boxes == 1 then
        QBCore.Functions.Notify("You still have one more deliverys to go","inform")
      else
        if Boxes == 4 then
          Boxes = 'Four'
        elseif Boxes == 3 then
          Boxes = 'Three'
        elseif Boxes == 2 then
          Boxes = 'Two'
        end
        QBCore.Functions.Notify("You have "..Boxes.." Boxes deliverys to go","success")
      end
        if LastGoal == RandomPoint then
            DrawTarget()
        else
            if RandomPoint == 1 then
								xxx =-737.17
								yyy =-2276.76    --airport drop
								zzz =13.44
                LastGoal = 1
            elseif RandomPoint == 2 then
								xxx =-418.41
								yyy =-2182.59 -- airport drop 2
								zzz =10.31    
                LastGoal = 2
            elseif RandomPoint == 3 then
								xxx =159.19
								yyy =-2945.01   --Docks
								zzz =7.24
                LastGoal = 3
            elseif RandomPoint == 4 then
								xxx =-41.74
								yyy =-1675.34  -- unused cardealership
								zzz =29.41
                LastGoal = 4
            elseif RandomPoint == 5 then
								xxx =168.01
								yyy =-1505.99   --- go and wash
								zzz =29.26
                LastGoal = 5
            elseif RandomPoint == 6 then
								xxx =240.75
								yyy =-1379.58   ---morge place
								zzz =33.74
                LastGoal = 6
            elseif RandomPoint == 7 then
								xxx =342.48
								yyy =-1299.15   ---vector3(342.48, -1299.15, 32.51)
								zzz =32.51
                LastGoal = 7
            elseif RandomPoint == 8 then
								xxx =810.72
								yyy =-750.2    ---vector3(810.72, -750.2, 26.74)
								zzz =26.74
                LastGoal = 8
            elseif RandomPoint == 9 then
								xxx =756.49
								yyy =-557.74    ---vector3(756.49, -557.74, 33.65)
								zzz =33.65
                LastGoal = 9
            elseif RandomPoint == 10 then
								xxx =1160.6
								yyy =-311.49   ---vector3(1160.6, -311.49, 69.28)
								zzz = 69.28
                LastGoal = 10
            elseif RandomPoint == 11 then
								xxx =689.61
								yyy =600.31    ----vector3(689.61, 600.31, 128.91)
								zzz =128.91
                LastGoal = 11
            elseif RandomPoint == 12 then
								xxx =372.5
								yyy =253.17   ---vector3(372.5, 253.17, 103.01)
								zzz =103.01
                LastGoal = 12
            elseif RandomPoint == 13 then
								xxx =-1405.97
								yyy =526.91    ---vector3(-1405.97, 526.91, 123.83)
								zzz =123.83 
                LastGoal = 13
            elseif RandomPoint == 14 then
								xxx =-1636.6
								yyy =180.84    ---vector3(-1636.6, 180.84, 61.76)
								zzz =61.76
                LastGoal = 14
            elseif RandomPoint == 15 then
								xxx =-1681.43
								yyy =-291.13   ---vector3(-1681.43, -291.13, 51.88)
								zzz = 51.88
                LastGoal = 15
            elseif RandomPoint == 16 then
								xxx =-1193.5
								yyy =-557.58  --- vector3(-1193.5, -557.58, 27.99)
								zzz =27.99
                LastGoal = 16
            elseif RandomPoint == 17 then
								xxx =-818.28
								yyy =-1106.95   ---vector3(-818.28, -1106.95, 11.17)
								zzz =11.17
                LastGoal = 17
            elseif RandomPoint == 18 then
								xxx =-815.61
								yyy =-1346.59  ---vector3(-815.61, -1346.59, 5.15)
								zzz =5.15
                LastGoal = 18
            elseif RandomPoint == 19 then
								xxx =-753.39
								yyy =-1511.23  ---vector3(-753.39, -1511.23, 5.01)
								zzz =5.01
                LastGoal = 19
            elseif RandomPoint == 20 then
								xxx =-620.95
								yyy =-1640.08   ---vector3(-620.95, -1640.08, 26.35)
								zzz =26.35
                LastGoal = 20
            elseif RandomPoint == 21 then
								xxx =253.33
								yyy =-343.91   ---vector3(253.33, -343.91, 44.52)
								zzz =44.52
                LastGoal = 21
            end
		    AddObjBlip(TargetPos)
		    QBCore.Functions.Notify("Deliver the Boxes to the Customer","success")
        end
    end
end

--------------------
-- Creating Blips --
--------------------

-- Blip celu podrózy
function AddObjBlip(TargetPos)
    Blipy['obj'] = AddBlipForCoord(xxx, yyy, zzz)
    SetBlipRoute(Blipy['obj'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Delivery')
	EndTextCommandSetBlipName(Blipy['obj'])
end

-- Blip anulowania pracy
function AddCancelBlip()
    Blipy['cancel'] = AddBlipForCoord(61.78, 126.44, 79.22)
		SetBlipColour(Blipy['cancel'], 59)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('cancel orders')
	EndTextCommandSetBlipName(Blipy['cancel'])
end

-- Blip zakonczenia pracy
function AddFinnishBlip()
    Blipy['end'] = AddBlipForCoord(61.67, 118.65, 79.1)
		SetBlipColour(Blipy['end'], 2)
    SetBlipRoute(Blipy['end'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Deliverpoint')
	EndTextCommandSetBlipName(Blipy['end'])
end

------------------
-- Delete Blips --
------------------

function RemoveBlipObj()
    RemoveBlip(Blipy['obj'])
end

function RemoveCancelBlip()
    RemoveBlip(Blipy['cancel'])
end

function RemoveAllBlips()
    RemoveBlip(Blipy['obj'])
    RemoveBlip(Blipy['cancel'])
    RemoveBlip(Blipy['end'])
end

-------------------
-- DELIVERY AREA --
-------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = GetDistanceBetweenCoords(pos, xxx, yyy, zzz, true)
        if dist <= 20.0 and Hired and (not HasBoxes) then
            local DeliveryPoint = {
                ["x"] = xxx,
                ["y"] = yyy,
                ["z"] = zzz
            }
            DrawText3Ds(DeliveryPoint["x"],DeliveryPoint["y"],DeliveryPoint["z"], "Grab the ~y~Parcel~s~ out of the van!")
            local Vehicle = GetClosestVehicle(pos, 6.0, 0, 70)
            if IsVehicleModel(Vehicle, GetHashKey('Benson')) then
                local VehPos = GetEntityCoords(Vehicle)
								local distance = GetDistanceBetweenCoords(pos, VehPos, true)
                DrawText3Ds(VehPos.x,VehPos.y,VehPos.z, "Press [~g~E~s~] to grab the Boxes")
								if dist >= 4 and distance <= 5 then
                	                NearVan = true
								end
            end
        elseif dist <= 25 and HasBoxes and Hired then
            local DeliveryPoint = {
                ["x"] = xxx,
                ["y"] = yyy,
                ["z"] = zzz
            }
            DrawText3Ds(DeliveryPoint["x"],DeliveryPoint["y"],DeliveryPoint["z"], "Press [~g~E~s~] to deliver the Parcel")
            if dist <= 3 then
                if IsControlJustReleased(0, 46) then
                    TakeBoxes()
                    DeliverBoxes()
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if (not HasBoxes) and NearVan then
			if IsControlJustReleased(0, 46) then
                TakeBoxes()
                NearVan = false
			end
		end
	end
end)

-------------------
-- DELIVER Boxes --
-------------------

function loadAnimDict(dict)
	while ( not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end

function TakeBoxes()
    local player = PlayerPedId()
    if not IsPedInAnyVehicle(player, false) then
        local ad = "anim@heists@box_carry@"
        local prop_name = 'prop_cs_cardbox_01'
        if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
            loadAnimDict( ad )
            if HasBoxes then
                TaskPlayAnim( player, ad, "exit", 3.0, 1.0, -1, 49, 0, 0, 0, 0 )
                DetachEntity(prop, 1, 1)
                DeleteObject(prop)
                Wait(1000)
                ClearPedSecondaryTask(PlayerPedId())
                HasBoxes = false
            else
                local x,y,z = table.unpack(GetEntityCoords(player))
                prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
                AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 60309), 0.2, 0.08, 0.2, -45.0, 290.0, 0.0, true, true, false, true, 1, true)
                TaskPlayAnim( player, ad, "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
                HasBoxes = true
            end
        end
    end
end

function DeliverBoxes()
    if not BoxesDelivered then
        BoxesDelivered = true
        DeliveriesCount = DeliveriesCount + 1
        RemoveBlipObj()
        SetBlipRoute(BlipSell, false)
        HasBoxes = false    
        NextDelivery()
        Citizen.Wait(2500)
        BoxesDelivered = false
    end
end

function NextDelivery()
    TriggerServerEvent('RouteBoxes:Payment')
    Citizen.Wait(300)
    DrawTarget()
end
-----------------
-- END OF WORK --
-----------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local DistanceFromEndZone = GetDistanceBetweenCoords(pos, 61.78, 126.44, 79.22, true)
        local DistanceFromCancelZone = GetDistanceBetweenCoords(pos, 61.78, 126.44, 79.22, true)
        if InService then
            if Delivered then
                if DistanceFromEndZone <= 2.5 then
                    local endPoint = { --x = 571.25, y = 116.78, z = 97.36
                    ["x"] = 61.78,
                    ["y"] = 126.44,
                    ["z"] = 79.22
                    }
                    DrawText3Ds(endPoint["x"],endPoint["y"],endPoint["z"], "Press [~g~E~s~] to complete delivery")
                    if DistanceFromEndZone <= 7 then
                        if IsControlJustReleased(0, 46) then
                            QBCore.Functions.Notify("Nice one take some time to rest !", "success")
                            EndOfWork()
                        end
                    end
                end
            else
                if DistanceFromCancelZone <= 2.5 then
                    local cancel = { --61.78, 126.44, 79.22
                        ["x"] = 61.78,
                        ["y"] = 126.44,
                        ["z"] = 79.22
                    }
                    DrawText3Ds(cancel["x"],cancel["y"],cancel["z"], "Press [~g~E~s~] to Quit")
                    if DistanceFromCancelZone <= 7 then
                        if IsControlJustReleased(0, 46) then
                            QBCore.Functions.Notify("Thank you for your service.. have a nice day", "success")
							EndOfWork()
                        end
                    end
                end
            end
        end
    end
end)

function EndOfWork()
    RemoveAllBlips()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local Van = GetVehiclePedIsIn(ped, false)
        if IsVehicleModel(Van, GetHashKey('Benson')) then
            QBCore.Functions.DeleteVehicle(Van)
            if Delivered == false then
                TriggerServerEvent("RouteBoxes:ReturnDeposit", 'end')
            end
            InService = false
            BlipSell = nil
            BlipEnd = nil
            BlipCancel = nil
            TargetPos = nil
            HasBoxes = false
            LastGoal = nil
            DeliveriesCount = 0
            xxx = nil
            yyy = nil
            zzz = nil
            ownsVan = false
            Delivered = false
        else
            QBCore.Functions.Notify("You need to return to your vehicle", "error")
            QBCore.Functions.Notify("If you have lost the company vehicle deliver it on foot!", "error")
        end
    else
        InService = false
        BlipSell = nil
        BlipEnd = nil
        BlipCancel = nil
        TargetPos = nil
        HasBoxes = false
        LastGoal = nil
        DeliveriesCount = 0
        xxx = nil
        yyy = nil
        zzz = nil
        ownsVan = false
        Delivered = false
    end
end

----------------------
-- 3D text function --
----------------------
DrawText3Ds = function(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 370
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
end