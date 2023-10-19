local jobs = {}


AddEventHandler('onResourceStart', function(res)
	if res ~= GetCurrentResourceName() then return end 
    local alljobs = ESX.GetJobs()

    while not next(alljobs) do 
        alljobs = ESX.GetJobs()
        Wait(100)
    end 

    for job, desc in pairs(Config.Jobs) do 
        if alljobs[job] then
            jobs[#jobs+1] = {name = job, label = alljobs[job].label, text = desc}
        else 
            print("WARNING! This job is not existing: "..job)
        end 
    end 
end)

ESX.RegisterServerCallback("villamos_jobcenter:getJobs", function(src, cb)
    cb(jobs)
end)

RegisterNetEvent('villamos_jobcenter:setJob')
AddEventHandler('villamos_jobcenter:setJob', function(job)
    local xPlayer = ESX.GetPlayerFromId(source)
    local oldjob = xPlayer.job.name
    if not Config.Jobs[job] then 
        if Config.KickMessage then  
            xPlayer.kick(Config.KickMessage)
        end 
        return 
    end 
    if oldjob == job then 
        return Config.Notify(xPlayer.source, _U("same_job"))
    end 
    xPlayer.setJob(job, 0)
    Config.Notify(xPlayer.source, _U("your_new_job", xPlayer.job.label))
    LogToDiscord(GetPlayerName(xPlayer.source), xPlayer.source, xPlayer.identifier, oldjob, job)
end)

function LogToDiscord(name, id, identifier, oldjob, newjob) 
    if not Config.Webhook then return end 
    local connect = {
        {
            ["color"] = 8389379,
            ["title"] = "**".._U("selected_new_job").."**",
            ["description"] = _U("player_selected_new_job", name),
            ["fields"] = {
                {
                    ["name"] = _U("player"),
                    ["value"] = id .. " | " .. name .. " | " .. identifier
                },
                {
                    ["name"] = _U("old_job"),
                    ["value"] = oldjob
                },
                {
                    ["name"] = _U("new_job"),
                    ["value"] = newjob
                },
            },
            ["author"] = {
                ["name"] = "Marvel Studios",
                ["url"] = "https://discord.gg/esnawXn5q5",
                ["icon_url"] = "https://cdn.discordapp.com/attachments/917181033626087454/954753156821188658/marvel1.png"
            },
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %X").." | villamos_jobcenter :)",
            },
        }
    }
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = connect}), { ['Content-Type'] = 'application/json' }) 
end 
