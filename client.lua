local QBCore = exports['qb-core']:GetCoreObject()
local deliveryPoints = {
    {x = 200.0, y = -1500.0, z = 29.0},
    {x = 250.0, y = -1400.0, z = 29.0},
    {x = 300.0, y = -1300.0, z = 29.0}
}

local startJobPoint = {x = 100.0, y = -1000.0, z = 29.0} 
local isOnJob = false
local currentPoint = 1

RegisterNetEvent('qb-pizza:client:startDelivery')
AddEventHandler('qb-pizza:client:startDelivery', function()
    if not isOnJob then
        isOnJob = true
        currentPoint = 1
        QBCore.Functions.Notify('Job started! Go to the first delivery point.', 'success')
        SetNewWaypoint(deliveryPoints[currentPoint].x, deliveryPoints[currentPoint].y)
    else
        QBCore.Functions.Notify('You are already on a job!', 'error')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distanceToStart = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, startJobPoint.x, startJobPoint.y, startJobPoint.z)

        if distanceToStart < 10.0 then
            DrawMarker(1, startJobPoint.x, startJobPoint.y, startJobPoint.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
            if distanceToStart < 1.5 then
                QBCore.Functions.DrawText3D(startJobPoint.x, startJobPoint.y, startJobPoint.z, '[E] Start Pizza Delivery Job')
                if IsControlJustReleased(0, 38) then -- E key
                    TriggerEvent('qb-pizza:client:startDelivery')
                end
            end
        end

        if isOnJob then
            local distanceToPoint = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, deliveryPoints[currentPoint].x, deliveryPoints[currentPoint].y, deliveryPoints[currentPoint].z)

            if distanceToPoint < 10.0 then
                DrawMarker(1, deliveryPoints[currentPoint].x, deliveryPoints[currentPoint].y, deliveryPoints[currentPoint].z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
                if distanceToPoint < 1.0 then
                    QBCore.Functions.Notify('Delivery point reached! Proceed to the next one.', 'success')
                    currentPoint = currentPoint + 1
                    if currentPoint > #deliveryPoints then
                        isOnJob = false
                        QBCore.Functions.Notify('All deliveries completed! Job finished.', 'success')
                        TriggerServerEvent('qb-pizza:server:pay')
                    else
                        SetNewWaypoint(deliveryPoints[currentPoint].x, deliveryPoints[currentPoint].y)
                    end
                end
            end
        end
    end
end)