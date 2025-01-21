function ShowHelpNotification(msg, coords)
    AddTextEntry('FloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords.x, coords.y, coords.z)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('FloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function TeleportPlayer(coords)
    DoScreenFadeOut(1000)

    Wait(1000) 

    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, true)
    SetEntityHeading(cache.ped, coords.w)

    Wait(2000)
    DoScreenFadeIn(1000) 

    return true
end

function GetRandomCoords(coordsTable)
    if #coordsTable == 0 then
        return nil 
    end
    local randomIndex = math.random(1, #coordsTable) 
    return coordsTable[randomIndex] 
end

function Notify(title, desc, type)
    lib.notify({
        title = title,
        description = desc,
        type = type
    })
end

function ProgressBar(time)
    if lib.progressCircle({
        duration = time,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
        },
    }) then return true else return false end
end

debug("functions.lua loaded")