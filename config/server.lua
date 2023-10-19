Config.Webhook = false

Config.Notify = function(src, msg)
    TriggerClientEvent("esx:showNotification", src, msg)
end 