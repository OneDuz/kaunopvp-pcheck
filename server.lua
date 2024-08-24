ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local playerUIState = {}

lib.callback.register('pcheck:admin:data', function(source, targetId2)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = {
        status = false,
        msg = 'error?',
        action = "hideMessage"
    }
    if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' then
        local adminName = GetPlayerName(source)
        local targetId = tonumber(targetId2)
        if targetId then
            local target = ESX.GetPlayerFromId(targetId)
            if target then
                local currentState = playerUIState[tostring(targetId)]
                local action = currentState and currentState.showing and "hideMessage" or "showMessage"
                
                data.msg = 'Player sent pcheck screen'
                data.action = action
                data.status = true
                
                TriggerClientEvent('pcheck:toggleUI', targetId, action, adminName)
                
                if action == "showMessage" then
                    local timestampPlusTwoHours = os.time() + (2 * 60 * 60)
                    local formattedTimestamp = os.date("%Y-%m-%d %H:%M:%S", timestampPlusTwoHours)
                    playerUIState[tostring(targetId)] = { showing = true, admin = adminName, time = formattedTimestamp }
                else
                    playerUIState[tostring(targetId)] = nil
                end
                
                print(string.format("PCheck: %s action for player %d by admin %s", action, targetId, adminName))
            else
                data.msg = 'Player not found.'
            end
        else
            data.msg = 'Invalid player ID.'
        end
    else
        data.msg = 'You do not have permission to use this command.'
    end
    return data
end)

lib.callback.register('pcheck:admin:data2', function(source, targetId2)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = {
        status = false,
        msg = 'error?',
    }
    if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin' then
        local adminName = GetPlayerName(source)
        local targetId = tonumber(targetId2) -- Ensure targetId is a number
        if targetId then
            local target = ESX.GetPlayerFromId(targetId)
            if target then
                data.msg = 'Player banned'
                data.status = true
                local timestampPlusTwoHours = os.time() + (2 * 60 * 60)     -- 2 hours * 60 minutes * 60 seconds
                local formattedTimestamp = os.date("%Y-%m-%d %H:%M:%S", timestampPlusTwoHours)
                print(string.format("PCheck: banned by for player %d by admin %s", targetId, adminName))
                local banReason = string.format("Pc check by %s at %s and found cheats", adminName, formattedTimestamp)
                print('Attempting to ban player:', targetId, 'Reason:', banReason)
                exports["KaunasPvP-Direction"]:fg_BanPlayer(targetId, banReason, true)
                playerUIState[targetId] = nil
            else
                data.msg = 'Player not found.'
            end
        else
            data.msg = 'Invalid player ID.'
        end
    else
        data.msg = 'You do not have permission to use this command.'
    end
    return data
end)

AddEventHandler('playerDropped', function(reason)
    local droppedPlayerId = tostring(source) -- Convert to string for consistency
    print('Player Dropped:', droppedPlayerId)
    if playerUIState[droppedPlayerId] and playerUIState[droppedPlayerId].showing then
        local adminName = playerUIState[droppedPlayerId].admin
        local time = playerUIState[droppedPlayerId].time
        local banReason = string.format("Avoiding pc check by %s at %s and left the server", adminName, time)
        print('Attempting to ban player:', droppedPlayerId, 'Reason:', banReason)
        exports["KaunasPvP-Direction"]:fg_BanPlayer(droppedPlayerId, banReason, true)
        print('Player ' .. droppedPlayerId .. ' has been successfully banned.')
        playerUIState[droppedPlayerId] = nil
    else
        print('No UI state found for player:', droppedPlayerId)
    end
end)
