local ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback("salkin_banking:getPlayerData", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        -- Beachte: Die Tabelle 'banking' muss in deiner DB existieren für die Transaktionen
        MySQL.Async.fetchAll('SELECT * FROM banking WHERE identifier = @identifier ORDER BY time DESC LIMIT 10', {
            ['@identifier'] = xPlayer.getIdentifier()
        }, function(transactions)
            cb({
                playerName = xPlayer.getName(),
                money = xPlayer.getMoney(),
                bankMoney = xPlayer.getAccount('bank').money,
                transactionHistory = transactions or {}
            })
        end)
    end
end)

RegisterServerEvent('salkin_banking:doingType')
AddEventHandler('salkin_banking:doingType', function(typeData)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local amount = 0

    if typeData.deposit then
        amount = tonumber(typeData.deposit)
        if amount and amount > 0 and xPlayer.getMoney() >= amount then
            xPlayer.removeMoney(amount)
            xPlayer.addAccountMoney('bank', amount)
            xPlayer.showNotification('Erfolgreich $'..amount..' eingezahlt.', 'success')
        else
            xPlayer.showNotification('Nicht genug Bargeld!', 'error')
        end
    elseif typeData.withdraw then
        amount = tonumber(typeData.withdraw)
        if amount and amount > 0 and xPlayer.getAccount('bank').money >= amount then
            xPlayer.removeAccountMoney('bank', amount)
            xPlayer.addMoney(amount)
            xPlayer.showNotification('Erfolgreich $'..amount..' abgehoben.', 'success')
        else
            xPlayer.showNotification('Nicht genug Guthaben!', 'error')
        end
    end

    TriggerClientEvent("salkin_banking:updateMoneyInUI", src, "update", xPlayer.getAccount('bank').money, xPlayer.getMoney())
end)