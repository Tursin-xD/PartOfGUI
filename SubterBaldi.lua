-- Load the Rayfield Library
local Rayfield= nil
if _G.Gen2 then
--hmm.
Rayfield= loadstring(game:HttpGet("https://raw.githubusercontent.com/SyncUnofficial/Rayfield_Gen_2_fanmade/refs/heads/main/source.lua"))()
else
Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

end

-- Create the Main Window (Key system completely disabled)
local Window = Rayfield:CreateWindow({
   Name = "SubterBaldi exploits [LEGACY]",
   LoadingTitle = "SubterBaldi [LEGACY]",
   LoadingSubtitle = "For you",
   ConfigurationSaving = { Enabled = false },
   Discord = { Enabled = false },
   KeySystem = false -- Disabled!
})

-- Create our Main Tab
local MainTab = Window:CreateTab("Main Cheats", 4483362458)

---

-- 1. Collect Notebooks Button (Fires all ClickDetectors)
MainTab:CreateButton({
   Name = "Collect Notebooks",
   Callback = function()
       local clickCount = 0
       
       -- Loop through everything in the workspace to find ClickDetectors
       for _, object in ipairs(workspace:GetDescendants()) do
           if object:IsA("ClickDetector") then
               -- fireclickdetector takes the detector itself
               fireclickdetector(object)
               clickCount = clickCount + 1
           end
       end
       
       -- Notify the user how many were collected
       Rayfield:Notify({
          Title = "Notebooks Collected",
          Content = "Successfully fired " .. tostring(clickCount) .. " ClickDetectors!",
          Duration = 3,
          Image = 4483362458,
       })
   end,
})

---

-- 2. Get Items Button (Fires all TouchInterests)
MainTab:CreateButton({
   Name = "Get Items",
   Callback = function()
       local player = game.Players.LocalPlayer
       -- Ensure the player's character and RootPart exist before running
       local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
       
       if not rootPart then
           Rayfield:Notify({
              Title = "Error",
              Content = "BRO SPAWN",
              Duration = 3,
              Image = 4483362458,
           })
           return
       end

       local touchCount = 0
       
       -- Loop through everything in the workspace to find TouchTransmitters/TouchInterests
       for _, object in ipairs(workspace:GetDescendants()) do
           if object:IsA("TouchTransmitter") then
 
               local touchablePart = object.Parent
               if touchablePart and touchablePart:IsA("BasePart") then
                   firetouchinterest(touchablePart, rootPart, 0)
                   task.wait() -- A tiny delay to let the engine register it safely
                   firetouchinterest(touchablePart, rootPart, 1)
                   
                   touchCount = touchCount + 1
               end
           end
       end
       
       -- Notify the user how many items were touched
       Rayfield:Notify({
          Title = "Items Collected",
          Content = "Successfully triggered " .. tostring(touchCount) .. " TouchInterests!",
          Duration = 3,
          Image = 4483362458,
       })
   end,
   -- 5. Fire All Proximity Prompts (With Auto-Teleport Bypasses)
MainTab:CreateButton({
   Name = "TP & Fire All Prompts",
   Callback = function()
       local player = game.Players.LocalPlayer
       local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
       
       if not rootPart then
           Rayfield:Notify({
              Title = "Error",
              Content = "bruhhh. just spawn.",
              Duration = 3,
              Image = 4483362458,
           })
           return
       end
       
       if not fireproximityprompt then
           Rayfield:Notify({
              Title = "Executor Error",
              Content = "Your executor does not support 'fireproximityprompt'!",
              Duration = 4,
              Image = 4483362458,
           })
           return
       end


       local originalCFrame = rootPart.CFrame
       local promptCount = 0
       
       for _, object in ipairs(workspace:GetDescendants()) do
           if object:IsA("ProximityPrompt") then
               -- Ensure the prompt is active and its parent has a physical position
               if object.Enabled and object.Parent and object.Parent:IsA("BasePart") then
                   
                   rootPart.CFrame = object.Parent.CFrame
                   task.wait(0.15)
                   
                   fireproximityprompt(object)
                   promptCount = promptCount + 1
                   
                   task.wait(0.1) 
               end
           end
       end
       
       rootPart.CFrame = originalCFrame
       
       Rayfield:Notify({
          Title = "Prompts Triggered",
          Content = "Teleported and fired " .. tostring(promptCount) .. " ProximityPrompts!",
          Duration = 3,
          Image = 4483362458,
       })
   end,
})
})
