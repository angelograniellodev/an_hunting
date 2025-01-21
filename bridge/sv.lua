if Config.Framework == "esx" then 
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == "qbcore" then 
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == "standalone" then 
    debug("no framework loaded")
end

function CreateUsableItem(...)
    if Config.Framework == "qbcore" then
        QBCore.Functions.CreateUseableItem(...)
    elseif Config.Framework == "esx" then
        ESX.RegisterUsableItem(...)
    end
end

function GiveItem(player, name, count)
    if Config.Framework == "qbcore" then
        player.Functions.AddItem(name, count)
    elseif Config.Framework == "esx" then
        player.addInventoryItem(name, count)
    end
end