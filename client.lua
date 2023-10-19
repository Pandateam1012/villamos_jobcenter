local opened = false


function OpenJobcenter()
    SetNuiFocus(true, true)
	opened = true

	SendNUIMessage({
		type = "show",
		enable = true
	})
end 

function Close()
    SetNuiFocus(false, false)
	opened = false

	SendNUIMessage({
		type = "show",
		enable = false
	})
end 

RegisterNUICallback('exit', function(data, cb)
    Close()
    cb(1)
end)

RegisterNUICallback('data', function(data, cb)
    while not ESX.PlayerLoaded do 
        Wait(10)
    end 
    local nuilocales = {}
    if not Config.Locale or not Locales[Config.Locale] then return print("^1SCRIPT ERROR: Invilaid locales configuartion") end
    for k, v in pairs(Locales[Config.Locale]) do 
        if string.find(k, "nui") then 
            nuilocales[k] = v
        end 
    end 
    ESX.TriggerServerCallback("villamos_jobcenter:getJobs", function(jobs) 
        cb({
            jobs = jobs,
            locales = nuilocales
        })
    end)
end)

RegisterNUICallback('setjob', function(data, cb)
    TriggerServerEvent('villamos_jobcenter:setJob', data.job)
    cb(1)
end)


CreateThread(function()
    for i=1, #Config.Positions, 1 do
        local blip = AddBlipForCoord(Config.Positions[i])
        SetBlipSprite (blip, Config.Blip.sprite)
        SetBlipScale  (blip, 1.0)
        SetBlipColour (blip, Config.Blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(_U("blip"))
        EndTextCommandSetBlipName(blip)
    end 

    AddTextEntry('jobcenter_open_msg', _U("open_msg"))

    while true do 
        local coords = GetEntityCoords(PlayerPedId())
        local sleep = 1000

        if not opened then 
            for i=1, #Config.Positions, 1 do
                local dis = #(coords - Config.Positions[i])
                if dis < 20 then 
                    sleep = 1
                    DrawMarker(6, Config.Positions[i], 0.0, 0.0, 0.0, -90.0, 0.0, 0.0, 1.5, 1.5, 1.5, 0, 155, 20, 100, false, true, 2, false, false, false, false)
                    DrawMarker(21, Config.Positions[i]+vector3(0.0, 0.0, 0.6), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 0, 155, 20, 100, false, true, 2, false, false, false, false)
                    if dis < 1.5 then 
                        DisplayHelpTextThisFrame('jobcenter_open_msg')
                        if IsControlJustReleased(0, 38) then
                            OpenJobcenter()
                        end 
                    end 
                end 
            end 
        end 

        Wait(sleep)
    end 
end)