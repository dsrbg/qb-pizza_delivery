local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-pizza:server:pay')
AddEventHandler('qb-pizza:server:pay', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local payment = math.random(100, 200) -- Random payment between 100 and 200
    Player.Functions.AddMoney('cash', payment)
    TriggerClientEvent('QBCore:Notify', src, 'You received $' .. payment .. ' for completing the deliveries.', 'success')
end)