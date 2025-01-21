local Locations = Config.NpcInteracts

local onHunting = false
local baitVars = {
    onBait = false, 
    coordsBait = nil,
    baitObjc = nil
}

local animalVars = {
    animal_object = nil
}

local catch = false

local aiming = false


local function GetAnimalName(animalEntity)
    local modelHash = GetEntityModel(animalEntity)
    for animalName, _ in pairs(Config.AnimalsItems) do
        if GetHashKey(animalName) == modelHash then
            return animalName
        end
    end
    return nil
end


local function CreateAnimal()

    debug("create animal called") 

    Notify("Hunting", "You have just geo-located another animal, it is marked on your gps.", "info")

    local randomCoords = GetRandomCoords(Config.SpawnAnimals)
    local animalModel = Config.Animals[math.random(#Config.Animals)] 

    lib.requestModel(animalModel, 5000) 

    animalVars.animal_object = CreatePed(28, GetHashKey(animalModel), randomCoords.x, randomCoords.y, randomCoords.z, 0.0, true, false)

    local blip = AddBlipForEntity(animalVars.animal_object)
    SetBlipSprite(blip, 141) 
    SetBlipColour(blip, 1) 
    SetBlipScale(blip, 0.7)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Wild Animal")
    EndTextCommandSetBlipName(blip)

    SetEntityHealth(animalVars.animal_object, 1000)

    ClearPedTasksImmediately(trapEntity)
    TaskSmartFleePed(animalVars.animal_object, PlayerPedId(), 150.0, 20.0, false, false)

    catch = true 

    Citizen.CreateThread(function()
        while catch do
            Citizen.Wait(1) 
            local playerPed = cache.ped
            local playerCoords = GetEntityCoords(playerPed)
            local animalCoords = GetEntityCoords(animalVars.animal_object)
            local baitCoords = GetEntityCoords(baitVars.baitObjc)
            local distance = #(playerCoords - animalCoords)

            local distanceBait = #(animalCoords - animalCoords)

  
            if IsPlayerFreeAiming(PlayerId()) then
                if Config.ForceFirstPerson then 
                    SetFollowPedCamViewMode(4)
                    ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.5)
                    aiming = true
                end
            else 
                if aiming then 
                    SetFollowPedCamViewMode(1) 
                    aiming = false
                end
            end
       
            if baitVars.onBait and distanceBait < 2.5 then 
                baitVars.onBait = false
                ClearPedTasks(animalVars.animal_object)
                TaskSmartFleePed(animalVars.animal_object, PlayerPedId(), 200.0, -1) 
                debug("esta cerca de la carnada")
            end

            ---interact
            if distance < 1.5 and IsEntityDead(animalVars.animal_object) then
                ShowHelpNotification(Config.Lang.cut_animal_interact, vector3(animalCoords.x, animalCoords.y, animalCoords.z))

                if IsControlJustPressed(0, 38) then
                    local currentWeapon = GetSelectedPedWeapon(cache.ped) 

                    if currentWeapon == GetHashKey(Config.WeaponNedKnife) or not Config.NeedKnife then 
                        local playerPed = cache.ped
                        local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
                        local animName = "machinic_loop_mechandplayer"
                    
                        lib.requestAnimDict(animDict, 5000) 
                    
                        TaskPlayAnim(playerPed, animDict, animName, 8.0, 8.0, -1, 1, 0, false, false, false)

                        local progress = ProgressBar(12500)  

                        if progress then 
                            ClearPedTasks(cache.ped)
                            local animalName = GetAnimalName(animalVars.animal_object)
                            TriggerServerEvent("an_hunting:giveLoot", animalName)
                            catch = false 
                            Wait(3500) 
                            debug("break createanimal")
                            CreateAnimal()
                            return
                        end
                    else
                        Notify("Hunting", "Need a knife in hands", "error")
                    end
                end
            end
        end
    end)
end


local function HuntingMenu()
    local options = {
        {
            title = Config.Lang.start_hunting,
            description = Config.Lang.start_hunting_desc,
            icon = "fa-solid fa-paw",
            event = "an_hunting:StartStop"
        },
        {
            title = Config.Lang.buy_weapon,
            description = Config.Lang.buy_weapon_desc,
            icon = "fa-solid fa-gun",
            event = "an_hunting:buyWeapons"
        },
        {
            title = Config.Lang.buy_bait,
            description = Config.Lang.buy_bait_desc,
            icon = "fa-solid fa-bone",
            event = "an_hunting:buyAnimalBaits"
        }
    }
    
    lib.registerContext({
        id = "hunting_menu",
        title = Config.Lang.menu_title,
        options = options
    })

    lib.showContext("hunting_menu")    
end

local function InteractEvent(event)
    if event == "central" then 
        HuntingMenu()
    end
end

CreateThread(function()
    if Config.SpawnModels then
        for _, npcData in pairs(Config.NpcModels) do
            lib.requestModel(npcData.model)

            local npc = CreatePed(4, GetHashKey(npcData.model), npcData.coords.x, npcData.coords.y, npcData.coords.z,
                npcData.coords.w, false, true)
            SetEntityAsMissionEntity(npc, true, true)
            SetEntityInvincible(npc, true)
            FreezeEntityPosition(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)

            if npcData.animation then

                lib.requestAnimDict(npcData.animation.dict)

                TaskPlayAnim(npc, npcData.animation.dict, npcData.animation.name, 8.0, 0.0, -1, 1, 0, false, false, false)
            end

            if npcData.giveweapon then 
                GiveWeaponToPed(npc, npcData.giveweapon, 250, false, true)
            end
        end
    end

    if Config.InteractEnabled then
        debug("interact enabled")
        for i = 1, #Locations do
            local pointing = lib.points.new({
                coords = Locations[i].coords,
                distance = Locations[i].interact_distance
            })
            function pointing:nearby()
                ShowHelpNotification(Locations[i].label, vector3(Locations[i].coords.x, Locations[i].coords.y, Locations[i].coords.z + 2))
                if IsControlJustPressed(0, Locations[i].interact_key) and self.currentDistance < Locations[i].interact_distance then
                    debug("interact event: " .. Locations[i].event)
                    InteractEvent(Locations[i].event)
                end
            end
        end
    end
end)


--events

RegisterNetEvent("an_hunting:UseAnimalBait", function()

    baitVars.coords = cache.coords 
    baitVars.onBait = true 

    FreezeEntityPosition(cache.ped, true)
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)

    local progress = ProgressBar(9500) 


    lib.requestModel("prop_cs_steak", 1250)

    if progress then 
        baitVars.baitObjc = CreateObject("prop_cs_steak", baitVars.coords.x, baitVars.coords.y, baitVars.coords.z, false, false)
        PlaceObjectOnGroundProperly(baitVars.baitObjc)
        ClearPedTasks(cache.ped)
        FreezeEntityPosition(cache.ped, false)          
        
        Notify("Hunting", "Bait placed, wait 6 seconds for the animal to arrive, if it does not arrive it is because you are too far away from it", "success")
        Wait(6500)
        TaskGoToEntity(baitVars.baitObjc, baitVars.baitObjc, -1, 1.0, 1.0, 0, 0)
    end

    debug(json.encode(baitVars))
end)

RegisterNetEvent("an_hunting:buyWeapons", function()
    TriggerServerEvent("an_hunting:giveitem", Config.WeaponNedKnife, 1)
    TriggerServerEvent("an_hunting:giveitem", "weapon_musket", 1)
    TriggerServerEvent("an_hunting:giveitem", "ammo-musket", 250)
end)

RegisterNetEvent("an_hunting:buyAnimalBaits", function()
    TriggerServerEvent("an_hunting:giveitem", "animal_bait", 10)
end)

RegisterNetEvent("an_hunting:StartStop", function()

    if onHunting then 
        onHunting = false
        catch = false 
        DeleteEntity(animalVars.animal_object)
        Notify("Hunting", "You quit hunting, you can come back whenever you want", "info")
        return 
    end


    if not onHunting then 
        onHunting = true 
        CreateAnimal()
    end
end)

debug("client side npc_interact.lua loaded")
