if Config.Framework == "esx" then 
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == "qbcore" then 
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == "standalone" then 
    debug("no framework loaded")
end