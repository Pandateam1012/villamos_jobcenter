local isInUi = false

function SetNuiState(state)
    SetNuiFocus(state, state)
	isInUi = state

	SendNUIMessage({
		type = "show",
		enable = state
	})
end

RegisterNUICallback('exit', function(data, cb)
    SetNuiState(false)
    cb('ok')
end)

RegisterNUICallback('setjob', function(data, cb)
    TriggerServerEvent('villamos_jobcenter:setJob', data.job)
    cb('ok')
end)

AddEventHandler("villamos_jobcenter:open", function()
    SetNuiState(true)
end)

RegisterNetEvent('villamos_jobcenter:setJobs')
AddEventHandler('villamos_jobcenter:setJobs', function(data)
        Wait(3000)
	SendNUIMessage({
		type = "setjobs",
		jobs = data,
	})
end)

CreateThread(function()
    while not ESX or not ESX.PlayerLoaded do
		Wait(10)
	end

    if not Config.QTarget then 
        AddTextEntry('jobcenter_open_msg', '~INPUT_PICKUP~ a Munkaügyi Hivatal megnyitáshoz')
    end 

    for i=1, #Config.Positions, 1 do 
        if IsModelInCdimage(Config.Positions[i].model) then 
            RequestModel(Config.Positions[i].model)
            while not HasModelLoaded(Config.Positions[i].model) do
                Wait(1)
            end
            local ped = CreatePed(1, Config.Positions[i].model, Config.Positions[i].x, Config.Positions[i].y, Config.Positions[i].z, Config.Positions[i].h, false, false)
            PlaceObjectOnGroundProperly(ped)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
            SetModelAsNoLongerNeeded(Config.Positions[i].model)

            if Config.Positions[i].blip then 
                local blip = AddBlipForCoord(Config.Positions[i].x, Config.Positions[i].y, Config.Positions[i].z)
                SetBlipSprite (blip, 408)
                SetBlipScale  (blip, 1.0)
                SetBlipColour (blip, 26)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName("Munkaügyi Hivatal")
                EndTextCommandSetBlipName(blip)
            end 

            if Config.QTarget then 
                exports.qtarget:AddTargetEntity(ped, {
                    options = {
                        {
                            event = "villamos_jobcenter:open",
                            icon = "fas fa-briefcase",
                            label = "Munkaügyi hivatal megnyitása",
                            num = 1
                        }
                    },
                    distance = 2.5
                })
            else 
                Config.Positions[i].marker = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.8, -1.0)
            end 
            
            Wait(10)
        else 
            print("FIGYELEM! Érvénytelen ped model hash: "..Config.Positions[i].model)
        end 
    end 

    TriggerServerEvent("villamos_jobcenter:login")

    while true do 
        local coords = GetEntityCoords(PlayerPedId())
        local sleep = 1000

        for _, v in pairs(Config.Positions) do 
            if #(coords - vector3(v.x, v.y, v.z)) < 20 then 
                sleep = 2
                DrawText3D(v.x, v.y, v.z+2.1, v.name)
                if not Config.QTarget then 
                    DrawMarker(6, v.marker.x, v.marker.y, v.marker.z, 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.5, 1.5, 1.5, 0, 155, 20, 100, false, true, 2, false, false, false, false)
                    DrawMarker(21, v.marker.x, v.marker.y, v.marker.z+0.6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 0, 155, 20, 100, false, true, 2, false, false, false, false)
                    if #(coords - vector3(v.marker.x, v.marker.y, v.marker.z+0.6)) < 1.5 then 
                        DisplayHelpTextThisFrame('jobcenter_open_msg')
                        if IsControlJustReleased(0, 38) then
                            SetNuiState(true)
                        end 
                    end 
                end 
            end 
        end 

        Wait(sleep)
    end 
end)

RegisterNetEvent('villamos_jobcenter:notify')
AddEventHandler('villamos_jobcenter:notify', function(msg)
	ESX.ShowNotification(msg)
end)


function DrawText3D(x, y, z, text) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.0, 0.4*scale)
        SetTextFont(4)
        SetTextColour(255, 255, 255, 255)
        SetTextCentre(1)
        BeginTextCommandDisplayText("STRING")
	    AddTextComponentString(text)
	    EndTextCommandDisplayText(_x, _y)
    end
end


