local fps = 0
local function drawText(data)
    SetTextFont(4)
    SetTextScale(0.0, data.size)
    SetTextColour(data.color[1], data.color[2], data.color[3], data.color[4])
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextOutline()
    SetTextCentre(true)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(data.text)
    EndTextCommandDisplayText(data.location.x, data.location.y)
end

local drawing = false
local function fpsDrawText()
    if drawing then return end
    drawing = true
    CreateThread(function()
        local fpsCountdown = 60
        local lastCheck = GetGameTimer()
        while fps > 60 do
            Wait(0)
            drawText({
                text = string.format("%s FPS", fps),
                location = {
                    x = 0.5, y = 0.3,
                },
                color = { 255, 255, 255, 255 },
                size = 3.0
            })
            drawText({
                text = "Your FPS is higher than 60! Fix your FPS to 60",
                location = {
                    x = 0.5, y = 0.5,
                },
                color = { 220, 220, 220, 255 },
                size = 1.0
            })
            drawText({
                text = string.format("%ss", fpsCountdown),
                location = {
                    x = 0.5, y = 0.6,
                },
                color = { 255, 0, 0, 255 },
                size = 2.0
            })

            local gameTimer = GetGameTimer()
            if gameTimer > lastCheck + 1000 then
                lastCheck = gameTimer
                fpsCountdown = fpsCountdown - 1
                if fpsCountdown <= 0 then
                    TriggerServerEvent("tgiann-fps-limit:kick")
                end
            end
        end
        drawing = false
    end)
end

local function init()
    while true do
        local startCount = GetFrameCount()
        Wait(1000)
        local endCount = GetFrameCount()
        fps = endCount - startCount
        print(fps)
        if fps > 60 then fpsDrawText() end
        Wait(fps > 60 and 0 or 4000)
    end
end

CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsSessionStarted() then
            break
        end
    end
    init()
end)
