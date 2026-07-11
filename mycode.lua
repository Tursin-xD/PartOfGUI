local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Dark Journey [ALPHA]",
   LoadingTitle = "Dark Journey Game exploits",
   LoadingSubtitle = "by Crabby",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false
})

local Tab1 = Window:CreateTab("Preset Teleports", 4483362458)
local Tab2 = Window:CreateTab("Custom TP", 4483362458)
local Tab3 = Window:CreateTab("Dabux Scanner", 4483362458)

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

local autoDabuxActive = false
local serverHopEnabled = false
local savedCFrame = nil

local function teleportTo(position)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

local function serverHop()
    local x, y = pcall(function()
        if typeof(queue_on_teleport) == "function" or typeof(syn and syn.queue_on_teleport) == "function" then
            local qot = queue_on_teleport or (syn and syn.queue_on_teleport)
            qot([[
                repeat task.wait() until game:IsLoaded()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Tursin-xD/PartOfGUI/refs/heads/main/mycode.lua'))()
            ]])
        end

        local servers = {}
        local req = http_request or request or (syn and syn.request)
        if req then
            local res = req({
                Url = string.format("https://roblox.com", game.PlaceId),
                Method = "GET"
            })
            if res and res.Body then
                local body = HttpService:JSONDecode(res.Body)
                if body and body.data then
                    for _, v in ipairs(body.data) do
                        if v.playing and tonumber(v.playing) < tonumber(v.maxPlayers) and v.id ~= game.JobId then
                            table.insert(servers, v.id)
                        end
                    end
                end
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], player)
        else
            TeleportService:Teleport(game.PlaceId, player)
        end
    end)
    if not x then
        TeleportService:Teleport(game.PlaceId, player)
    end
end

local teleports = {
    {name = "Start",    pos = Vector3.new(114.0, 3.4, 13998.2)},
    {name = "Outpost 2", pos = Vector3.new(9409.4, 3.4, 10679.7)},
    {name = "Outpost 3", pos = Vector3.new(5179.2, 3.4, -13750.0)},
    {name = "Outpost 4", pos = Vector3.new(14341.1, 3.4, 2157.3)},
    {name = "Outpost 5", pos = Vector3.new(12687.4, 3.4, -7387.9)},
    {name = "Outpost 6", pos = Vector3.new(-12122.2, 3.4, -7523.2)},
    {name = "Outpost 7", pos = Vector3.new(-13870.1, 3.4, 2035.1)},
    {name = "End",      pos = Vector3.new(-8677.8, 3.4, 10884.3)}
}

for _, loc in ipairs(teleports) do
    Tab1:CreateButton({
        Name = loc.name,
        Callback = function() teleportTo(loc.pos) end,
    })
end

local customPositionText = ""
Tab2:CreateInput({
   Name = "TP to position",
   PlaceholderText = "Example: 114, 3.4, 13998",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text) customPositionText = Text end,
})

Tab2:CreateButton({
   Name = "TELEPORT TO POSITION",
   Callback = function()
      local coords = {}
      for word in string.gmatch(customPositionText:gsub(",", " "), "%S+") do
         table.insert(coords, tonumber(word))
      end
      if #coords >= 3 then
         teleportTo(Vector3.new(coords[1], coords[2], coords[3]))
      else
         Rayfield:Notify({Title = "Error", Content = "Invalid Format", Duration = 3})
      end
   end,
})

local foundDabuxParts = {} 
local dropdownOptions = {"No parts scanned yet"} 

local DabuxDropdown = Tab3:CreateDropdown({
   Name = "Select Found Dabux Part",
   Options = dropdownOptions,
   CurrentOption = {"No parts scanned yet"},
   MultipleOptions = false,
   Callback = function(SelectedOptions)
      local selectedName = SelectedOptions[1]
      local partObj = foundDabuxParts[selectedName]
      
      if partObj then
         if partObj:IsA("Model") and partObj.PrimaryPart then
            teleportTo(partObj.PrimaryPart.Position)
         elseif partObj:IsA("BasePart") then
            teleportTo(partObj.Position)
         end
         
         Rayfield:Notify({
            Title = "Teleported!",
            Content = "Moved to " .. selectedName,
            Duration = 3,
            Image = 4483362458,
         })
      end
   end,
})

Tab3:CreateButton({
   Name = "SCAN MAP FOR DABUX PARTS",
   Callback = function()
      foundDabuxParts = {}
      local newOptions = {}
      local randomCount = 0
      local mapCount = 0
      
      for _, object in ipairs(workspace:GetDescendants()) do
         if object.Name == "Dabux_Random_Pos" or object.Name == "Dabux_Map_Pos" then
            local prompt = object:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt and prompt.Enabled then
               if object.Name == "Dabux_Random_Pos" then 
                   randomCount = randomCount + 1 
               else 
                   mapCount = mapCount + 1 
               end
               
               local uniqueName = object.Name .. " [#" .. (#newOptions + 1) .. "]"
               foundDabuxParts[uniqueName] = object
               table.insert(newOptions, uniqueName)
            end
         end
      end
      
      if #newOptions > 0 then
         DabuxDropdown:Refresh(newOptions)
         Rayfield:Notify({
            Title = "Scan Complete!",
            Content = string.format("Found %d Random and %d Map positions. Now Its in menu. check it if you want", randomCount, mapCount),
            Duration = 5,
            Image = 4483362458,
         })
      else
         DabuxDropdown:Refresh({"No parts found on this map"})
         Rayfield:Notify({
            Title = "Scan Finished",
            Content = "NOOO DABUX THERES NO DABUXESSS",
            Duration = 4,
            Image = 4483362458,
         })
      end
   end,
})

Tab3:CreateToggle({
   Name = "Server Hop on Clear",
   CurrentValue = false,
   Flag = "ServerHopToggle",
   Callback = function(Value)
      serverHopEnabled = Value
   end,
})

Tab3:CreateToggle({
   Name = "Auto-Dabux",
   CurrentValue = false,
   Flag = "AutoDabuxToggle",
   Callback = function(Value)
      autoDabuxActive = Value
      
      if autoDabuxActive then
         local character = player.Character
         if character and character:FindFirstChild("HumanoidRootPart") then
            savedCFrame = character.HumanoidRootPart.CFrame
         end

         task.spawn(function()
            Rayfield:Notify({Title = "FARMING DABUXESSS YAYY", Content = "Dancing above dabuxes (For Protection i recommend you get a ramor so the bandits wont kill you)", Duration = 3})
            
            while autoDabuxActive do
               local characterAlive = player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
               if not characterAlive then
                  task.wait(1)
                  continue
               end

               local farmTargets = {}
               
               for _, object in ipairs(workspace:GetDescendants()) do
                  if object.Name == "Dabux_Random_Pos" or object.Name == "Dabux_Map_Pos" then
                     local prompt = object:FindFirstChildWhichIsA("ProximityPrompt", true)
                     if prompt and prompt.Enabled and prompt.Parent then
                        table.insert(farmTargets, object)
                     end
                  end
               end
               
               if #farmTargets == 0 then
                  Rayfield:Notify({Title = "Finished", Content = "Dabuxxx collected mmm", Duration = 5})
                  if serverHopEnabled then
                     Rayfield:Notify({Title = "Server Hopping", Content = "Dancing and waving for a new server :)", Duration = 3})
                     task.wait(1)
                     serverHop()
                  end
                  break
               end
               
               for _, target in ipairs(farmTargets) do
                  if not autoDabuxActive then break end
                  if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health <= 0 then break end
                  
                  local targetPos = nil
                  if target:IsA("Model") then
                     if target.PrimaryPart then
                        targetPos = target.PrimaryPart.Position
                     else
                        local fallback = target:FindFirstChildWhichIsA("BasePart", true)
                        if fallback then targetPos = fallback.Position end
                     end
                  elseif target:IsA("BasePart") then
                     targetPos = target.Position
                  end
                  
                  local prompt = target:FindFirstChildWhichIsA("ProximityPrompt", true)
                  
                  if targetPos and prompt and prompt.Enabled then
                     teleportTo(targetPos)
                     task.wait(0.3)
                     
                     if prompt and prompt.Parent and prompt.Enabled then
                        if typeof(fireproximityprompt) == "function" then
                           fireproximityprompt(prompt)
                        end
                        
                        if typeof(firesignal) == "function" then
firesignal(prompt.Triggered, player)
end
local maxTimeout = 0
while autoDabuxActive and prompt and prompt.Parent and prompt.Enabled and maxTimeout < 25 do
task.wait(0.1)
maxTimeout = maxTimeout + 1
end
end
end
end
task.wait(0.5)
end
if savedCFrame and not serverHopEnabled then
local currentCharacter = player.Character
if currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart") then
currentCharacter.HumanoidRootPart.CFrame = savedCFrame
Rayfield:Notify({Title = "Returned", Content = "Teleported back to saved position.", Duration = 4})end
end
end)
else
Rayfield:Notify({Title = "Auto-Farm Stopped", Content = "Process halted by user.", Duration = 3})
end
end,})
