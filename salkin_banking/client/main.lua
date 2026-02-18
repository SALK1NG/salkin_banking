local ESX = exports["es_extended"]:getSharedObject()
local uiActive = false

-- Funktion für die Animation
local function StartBankingAction(isAtm)
    local playerPed = PlayerPedId()
    if isAtm then
        TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_ATM", 0, true)
    else
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
    end
    Wait(1000)
    OpenBanking(isAtm)
end

-- OX TARGET SETUP
CreateThread(function()
    -- ATMs
    exports.ox_target:addModel(Config.AtmModels, {
        {
            name = 'banking_atm',
            icon = 'fa-solid fa-credit-card',
            label = 'Geldautomat benutzen',
            onSelect = function()
                StartBankingAction(true)
            end
        }
    })

    -- BANK-PEDS
    exports.ox_target:addModel({`U_M_M_BankMan`}, {
        {
            name = 'banking_berater',
            icon = 'fa-solid fa-building-columns',
            label = 'Mit Bankberater sprechen',
            onSelect = function()
                StartBankingAction(false)
            end
        }
    })

    -- MAIN BANKEN
    for i, bank in pairs(Config.Banks) do
        exports.ox_target:addSphereZone({
            coords = bank.Position.xyz,
            radius = 1.2,
            debug = Config.Debug,
            options = {
                {
                    name = 'main_bank_'..i,
                    icon = 'fa-solid fa-university',
                    label = 'Bank öffnen',
                    onSelect = function()
                        StartBankingAction(false)
                    end
                }
            }
        })
    end
end)

-- Banking UI Logik
function OpenBanking(isAtm)
    uiActive = true
    SetNuiFocus(true, true)
    
    ESX.TriggerServerCallback('salkin_banking:getPlayerData', function(data)
        ESX.ShowNotification('Bankverbindung wird hergestellt...', 'info')
        SendNUIMessage({
            showMenu = true,
            openATM = isAtm,
            datas = {
                your_money_panel = {
                    accountsData = {
                        {name = "cash", amount = data.money},
                        {name = "bank", amount = data.bankMoney}
                    }
                },
                bankCardData = {
                    bankName = "FLEECA BANK",
                    cardNumber = "4532 **** **** 1289",
                    createdDate = "12/28",
                    name = data.playerName
                },
                transactionsData = data.transactionHistory
            }
        })
    end)
end

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    uiActive = false
    SetNuiFocus(false, false)
    ClearPedTasks(PlayerPedId())
    cb('ok')
end)

RegisterNUICallback('clickButton', function(data, cb)
    TriggerServerEvent("salkin_banking:doingType", data)
    cb('ok')
end)

RegisterNetEvent('salkin_banking:updateMoneyInUI', function(doingType, bankMoney, money)
    SendNUIMessage({
        updateData = true,
        data = { bankMoney = bankMoney, money = money }
    })
end)