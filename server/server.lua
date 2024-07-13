RegisterNetEvent('tgiann-fps-limit:kick')
AddEventHandler('tgiann-fps-limit:kick', function()
    DropPlayer(source, "Your FPS is higher than 60! Fix your FPS to 60")
end)
