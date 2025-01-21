CreateUsableItem(Config.ItemsWork.animal_bait, function(source, item)
    if Config.Framework == "qbcore" then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.RemoveItem(Config.ItemsWork.animal_bait, 1) then
        TriggerClientEvent("an_hunting:UseAnimalBait", source)
        end
    elseif Config.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(Config.ItemsWork.animal_bait, 1)
        TriggerClientEvent("an_hunting:UseAnimalBait", source)
        debug("animal bait used esx")
    end
end)

RegisterNetEvent("an_hunting:giveLoot", function(animalName)
    local src = source
    local Player

    if Config.Framework == "qbcore" then
        Player = QBCore.Functions.GetPlayer(src)
    elseif Config.Framework == "esx" then
        Player = ESX.GetPlayerFromId(src)
    end

    if not Player then
        debug("❌ Could not retrieve player.")
        return
    end

    if not Config.AnimalsItems[animalName] then
        debug("❌ No loot configured for this animal") 
        print(animalName)
        return
    end

    for _, itemData in ipairs(Config.AnimalsItems[animalName].items) do
        local randomChance = math.random(1, 100)

        debug(randomChance)

        if randomChance <= itemData.chance then
            if Config.Framework == "qbcore" then
                Player.Functions.AddItem(itemData.item_name, itemData.item_count)
            elseif Config.Framework == "esx" then
                Player.addInventoryItem(itemData.item_name, itemData.item_count)
            end
            
            TriggerClientEvent("ox_lib:notify", src, { type = "success", description = "You received " .. itemData.item_count .. "x " .. itemData.item_name })
        else
            debug("❌ You did not receive " .. itemData.item_name .. " due to probability.")
        end
    end
end)

RegisterNetEvent("an_hunting:giveitem", function(name, count)
    local src = source
    local Player

    if Config.Framework == "qbcore" then
        Player = QBCore.Functions.GetPlayer(src)
    elseif Config.Framework == "esx" then
        Player = ESX.GetPlayerFromId(src)
    end

    if Player then
        GiveItem(Player, name, count)
        TriggerClientEvent("ox_lib:notify", src, { type = "success", description = "You received " .. count .. "x " .. name })
    else
        debug("❌ Could not retrieve player.")
    end
end)