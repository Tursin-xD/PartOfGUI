
local Rayfield= nil
if _G.Gen2 then
--hmm.
Rayfield= loadstring(game:HttpGet("https://raw.githubusercontent.com/SyncUnofficial/Rayfield_Gen_2_fanmade/refs/heads/main/source.lua"))()
else
Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

end

local Window = Rayfield:CreateWindow({
    Name = "Vehicle Universal stuff",
    LoadingTitle = "Loading",
    LoadingSubtitle = "by Crabby",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local CoordTab = Window:CreateTab("XYZ Teleport", 4483362458)


local targetX = 0
local targetY = 10
local targetZ = 0
local chosenKeybind = Enum.KeyCode.E 


local function teleportVehicle()
    local player = game.Players.LocalPlayer
    local character = player.Character
    local targetCFrame = CFrame.new(targetX, targetY, targetZ)
    
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        
        if humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat") then
            local vehicleSeat = humanoid.SeatPart
            local vehicleModel = vehicleSeat:FindFirstAncestorOfClass("Model")
            
            if vehicleModel then
                if vehicleModel.PrimaryPart then
                    vehicleModel:SetPrimaryPartCFrame(targetCFrame)
                else
                    vehicleSeat.CFrame = targetCFrame
                end
            end
        else
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.CFrame = targetCFrame
            end
        end
        
        Rayfield:Notify({
            Title = "Teleport!",
            Content = "Your teleported to : " .. math.floor(targetX) .. ", " .. math.floor(targetY) .. ", " .. math.floor(targetZ),
            Duration = 2,
            Image = 4483362458,
        })
    end
end

-- Секция Live-координат
CoordTab:CreateSection("Current position (Live Mode):")

local LiveLabel = CoordTab:CreateLabel("Waitting for Connection...")


task.spawn(function()
    local player = game.Players.LocalPlayer
    while task.wait(0.1) do 
        pcall(function()
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local pos = character.HumanoidRootPart.Position
                LiveLabel:Set("📍 Current XYZ:  X: " .. math.floor(pos.X) .. "  |  Y: " .. math.floor(pos.Y) .. "  |  Z: " .. math.floor(pos.Z))
            else
                LiveLabel:Set("Not found (loading or dead)")
            end
        end)
    end
end)

CoordTab:CreateSection("Input for teleporting")

CoordTab:CreateInput({
    Name = "Input x (right or left)",
    PlaceholderText = "Like: 150",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        if num then targetX = num end
    end,
})

CoordTab:CreateInput({
    Name = "Input Y (height)",
    PlaceholderText = "Например: 50",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        if num then targetY = num end
    end,
})

CoordTab:CreateInput({
    Name = "Input Z (Straight or Back)",
    PlaceholderText = "Например: -300",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        if num then targetZ = num end
    end,
})

CoordTab:CreateSection("Teleport Control")


CoordTab:CreateButton({
    Name = "Teleport Button",
    Callback = function()
        teleportVehicle()
    end,
})


CoordTab:CreateKeybind({
    Name = "Keybind for fast teleport",
    CurrentKeybind = "E",
    HoldToInteract = false,
    Flag = "TeleportKeybind",
    Callback = function(Keybind)
        teleportVehicle()
    end,
})
