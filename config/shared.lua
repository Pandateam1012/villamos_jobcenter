Config = {}

Config.Locale = "en" -- en, hu

Config.Positions = {
    vector3(-269.22, -955.19, 30.32)
}

Config.Blip = { --set to false if you don't want
    sprite = 408,
    color = 26
}

Config.Jobs = {
    --['job'] = "description",
    ['unemployed'] = "I don't want to work.",
}

Config.KickMessage = "Fuck u" --set to false to don't kick

if not IsDuplicityVersion() then 
    Config.Notify = function(msg)
        TriggerEvent("esx:showNotification", msg)
    end 
end 