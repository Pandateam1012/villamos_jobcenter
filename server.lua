ESX = nil
local jobs = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('onResourceStart', function(res)
	if res == GetCurrentResourceName() then
        Wait(3000)
        MySQL.Async.fetchAll('SELECT * FROM jobs', {}, function (sqljobs)
    
            for k, v in pairs(Config.Jobs) do 
                local label
                for i=1, #sqljobs, 1 do
                    if k == sqljobs[i].name then 
                        label = sqljobs[i].label
                        break
                    end 
                end

                if label then 
                    table.insert(jobs, {name = k, label = label, text = v})
                else 
                    print("FIGYELEM! Nem létező job: "..k)
                end 
            end 
        
            TriggerClientEvent('villamos_jobcenter:setJobs', -1, jobs)
        end)
	end
end)

RegisterNetEvent('villamos_jobcenter:login')
AddEventHandler('villamos_jobcenter:login', function()
    local src = source 
    TriggerClientEvent('villamos_jobcenter:setJobs', src, jobs)
end)

RegisterNetEvent('villamos_jobcenter:setJob')
AddEventHandler('villamos_jobcenter:setJob', function(job)
    local xPlayer = ESX.GetPlayerFromId(source)
    local oldjob = xPlayer.getJob().name
    if Config.Jobs[job] then 
        if oldjob ~= job then 
            xPlayer.setJob(job, 0)
            TriggerClientEvent('villamos_jobcenter:notify', xPlayer.source, "Az új munkád mostmár: "..xPlayer.getJob().label.."!")
            LogToDiscord(GetPlayerName(xPlayer.source), xPlayer.source, xPlayer.identifier, oldjob, job)
        else 
            TriggerClientEvent('villamos_jobcenter:notify', xPlayer.source, "Már ebben a munkában dolgozol!")
        end 
    elseif Config.KickMessage then  
        xPlayer.kick(Config.KickMessage)
    end 
end)

function LogToDiscord(playername, id, identifier, oldjob, newjob) 
    if Config.Webhook then 
        local connect = {
            {
                ["color"] = 8389379,
                ["title"] = playername .." új munkát választott",
                ["description"] = "**[Játékos neve]: **"..playername.."s\n**[Játékos idje]: **"..id.."\n**[Játékos identifiere]: **"..identifier.."\n**[Régi munka]: **"..oldjob.."\n**[Új munka]: **"..newjob,
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
end 