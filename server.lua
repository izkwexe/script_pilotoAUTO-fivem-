-- server.lua

RegisterServerEvent("Notify")
AddEventHandler("Notify", function(type, message, duration)
    TriggerClientEvent("Notify", source, type, message, duration)
end)
