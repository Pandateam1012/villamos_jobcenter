Config = {}

Config.QTarget = false

Config.Positions = {
    {name = "[~b~Márkó~s~]~n~Munkaügyi Hivatal", model = GetHashKey("a_m_y_business_02"), blip = true, x = -269.22, y = -955.19, z = 30.32, h = 221.2},
}

Config.Jobs = {
--['job'] = "leírás",
    ['unemployed'] = "Inkább nem dolgozom.",
    ['miner'] = "Egyszerűen végezhető munka a városon kívül, jó fizetéssel.",
    ['fisherman'] = "Egyszerű, nyugalmas munka a városon belül.",
}

Config.Webhook = false

Config.KickMessage = "Hekker!" --set to false to don't kick

if Config.QTarget and GetResourceState("qtarget") == "missing" then 
    Config.QTarget = false
end 