ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local shouldShowMessage = false

RegisterCommand('pcheck', function(source, args, rawCommand)
    local targetid = tostring(args[1])
    lib.callback('pcheck:admin:data', source, function(data)
        ESX.ShowNotification(data.msg)
        if data.status then
            SetEntityCoordsNoOffset(PlayerPedId(), 733.0211, -1085.1116, 22.1690, false, false, false)
            NetworkResurrectLocalPlayer(733.0211, -1085.1116, 22.1690, 30.0, true, false)
            Wait(1000)
            ExecuteCommand("bring "..targetid.."")
            if data.action == "showMessage" then
                ExecuteCommand("freeze "..targetid.."")
                ExecuteCommand("takeinv "..targetid.."")
            else
                ExecuteCommand("unfreeze "..targetid.."")
                ExecuteCommand("returninv "..targetid.."")
                ExecuteCommand("bringback "..targetid.."")
            end
        end
    end, targetid)    
end)

RegisterCommand('pcheckban', function(source, args, rawCommand)
    local targetid = tostring(args[1])
    lib.callback('pcheck:admin:data2', source, function(data)
        ESX.ShowNotification(data.msg)
    end, targetid)    
end)

RegisterNetEvent('pcheck:toggleUI')
AddEventHandler('pcheck:toggleUI', function(action, adminname)
    -- print(action)
    -- print(adminname)
    if action == "showMessage" then
        shouldShowMessage = true
        startMessageLoop(adminname)
        SendNUIMessage({
            adminName = adminname,
            showScreen = true,
        })
    else
        shouldShowMessage = false
        SendNUIMessage({
            showScreen = false,
        })
    end
end)

function startMessageLoop(adminname)
    Citizen.CreateThread(function()
        while shouldShowMessage do
            --print("pcheck")
            Citizen.Wait(1000)
        end
    end)
end
