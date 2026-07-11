local Lib = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Win = Lib:CreateWindow({
    Name = "Dark Journey [ALPHA]",
    LoadingTitle = "Dark Journey [ALPHA] Exploitss",
    LoadingSubtitle = "by Crabby",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = false
})

local T1 = Win:CreateTab("Preset Teleports", 4483362458)
local T2 = Win:CreateTab("Custom TP", 4483362458)
local T3 = Win:CreateTab("Dabux Scanner", 4483362458)

local Plrs = game:GetService("Players")
local Http = game:GetService("HttpService")
local Tele = game:GetService("TeleportService")
local lp = Plrs.LocalPlayer

local activeDabux = false
local hopEnabled = false
local returnPos = nil

local function tp(pos)
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = CFrame.new(pos) end
end

local function hop()
    pcall(function()
        if typeof(queue_on_teleport) == "function" or typeof(syn and syn.queue_on_teleport) == "function" then
            local qot = queue_on_teleport or (syn and syn.queue_on_teleport)
            qot([[
                repeat task.wait() until game:IsLoaded()
                    loadstring(game:HttpGet('https://raw.githubusercontent.com/Tursin-xD/PartOfGUI/refs/heads/main/mycode.lua'))()
                    --restarts itself bruhh
            ]])
        end

        local api = "https://roblox.com" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local list = {}
        
        local req = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
        if req then
            local res = req({Url = api, Method = "GET"})
            if res and res.Body then
                local json = Http:JSONDecode(res.Body)
                if json and json.data then
                    for _, s in ipairs(json.data) do
                        if s.playing and tonumber(s.playing) < tonumber(s.maxPlayers) and s.id ~= game.JobId then
                            table.insert(list, s.id)
                        end
                    end
                end
            end
        end

        if #list > 0 then
            Tele:TeleportToPlaceInstance(game.PlaceId, list[math.random(1, #list)], lp)
        else
            Tele:Teleport(game.PlaceId, lp)
        end
    end)
end

local nodes = {
    {n = "Start",      p = Vector3.new(114.0, 3.4, 13998.2)},
    {n = "Outpost 2",  p = Vector3.new(9409.4, 3.4, 10679.7)},
    {n = "Outpost 3",  p = Vector3.new(5179.2, 3.4, -13750.0)},
    {n = "Outpost 4",  p = Vector3.new(14341.1, 3.4, 2157.3)},
    {n = "Outpost 5",  p = Vector3.new(12687.4, 3.4, -7387.9)},
    {n = "Outpost 6",  p = Vector3.new(-12122.2, 3.4, -7523.2)},
    {n = "Outpost 7",  p = Vector3.new(-13870.1, 3.4, 2035.1)},
    {n = "End",        p = Vector3.new(-8677.8, 3.4, 10884.3)}
}

for _, n in ipairs(nodes) do
    T1:CreateButton({Name = n.n, Callback = function() tp(n.p) end})
end

local inStr = ""
T2:CreateInput({
    Name = "Enter Vector3 / Position",
    PlaceholderText = "Example: 114, 3.4, 13998",
    RemoveTextAfterFocusLost = false,
    Callback = function(val) inStr = val end
})

T2:CreateButton({
    Name = "TELEPORT TO POSITION",
    Callback = function()
        local vec = {}
        for s in string.gmatch(inStr:gsub(",", " "), "%S+") do
            table.insert(vec, tonumber(s))
        end
        if #vec >= 3 then tp(Vector3.new(vec[1], vec[2], vec[3])) end
    end
})

local cache = {}
local drop = T3:CreateDropdown({
    Name = "Select Found Dabux Part",
    Options = {"No parts scanned yet"},
    CurrentOption = {"No parts scanned yet"},
    MultipleOptions = false,
    Callback = function(opt)
        local item = cache[opt]
        if item then
            local pos = item:IsA("Model") and item.PrimaryPart and item.PrimaryPart.Position or item.Position
            if pos then tp(pos) end
        end
    end
})

T3:CreateButton({
    Name = "SCAN MAP FOR DABUX PARTS",
    Callback = function()
        cache = {}
        local opts = {}
        local r, m = 0, 0
        for _, o in ipairs(workspace:GetDescendants()) do
            if o.Name == "Dabux_Random_Pos" or o.Name == "Dabux_Map_Pos" then
                local p = o:FindFirstChildWhichIsA("ProximityPrompt", true)
                if p and p.Enabled then
                    if o.Name == "Dabux_Random_Pos" then r = r + 1 else m = m + 1 end
                    local label = o.Name .. " [#" .. (#opts + 1) .. "]"
                    cache[label] = o
                    table.insert(opts, label)
                end
            end
        end
        if #opts > 0 then 
            drop:Refresh(opts) 
            Lib:Notify({Title = "Scan Complete", Content = "Found " .. r .. " Random and " .. m .. " Map positions!", Duration = 4})
        else 
            drop:Refresh({"No parts found on this map"}) 
            Lib:Notify({Title = "Scan Complete", Content = "No items found on this map.", Duration = 4})
        end
    end
})

T3:CreateToggle({Name = "Server Hop on Clear", CurrentValue = false, Flag = "H1", Callback = function(v) hopEnabled = v end})

T3:CreateToggle({
    Name = "Auto-Dabux",
    CurrentValue = false,
    Flag = "A1",
    Callback = function(v)
        activeDabux = v
        if activeDabux then
            local char = lp.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then returnPos = root.CFrame end
            
            Lib:Notify({Title = "Auto-Farm", Content = "Started hunting Dabux items...", Duration = 3})
            
            task.spawn(function()
                while activeDabux do
                    local list = {}
                    for _, o in ipairs(workspace:GetDescendants()) do
                        if o.Name == "Dabux_Random_Pos" or o.Name == "Dabux_Map_Pos" then
                            local p = o:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if p and p.Enabled and p.Parent then table.insert(list, o) end
                        end
                    end
                    
                    if #list == 0 then 
                        Lib:Notify({Title = "Auto-Farm", Content = "Map cleared completely!", Duration = 4})
                        if hopEnabled then 
                            Lib:Notify({Title = "Server Hop", Content = "Initiating server transition...", Duration = 3})
                            task.wait(1)
                            hop() 
                        end 
                        break 
                    end
                    
                    for _, o in ipairs(list) do
                        if not activeDabux then break end
                        local p = o:FindFirstChildWhichIsA("ProximityPrompt", true)
                        local loc = o:IsA("Model") and (o.PrimaryPart and o.PrimaryPart.Position or o:FindFirstChildWhichIsA("BasePart", true).Position) or o.Position
                        if loc and p and p.Enabled then
                            tp(loc)
                            task.wait(0.3)
                            if p and p.Enabled then
                                if fireproximityprompt then fireproximityprompt(p) end
                                if firesignal then firesignal(p.Triggered, lp) end
                                local cl = 0
                                while activeDabux and p and p.Parent and p.Enabled and cl < 25 do
                                    task.wait(0.1)
                                    cl = cl + 1
                                end
                            end
                        end
                    end
                    task.wait(0.5)
                end
                if returnPos and not hopEnabled then
                    local char = lp.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then root.CFrame = returnPos end
                    Lib:Notify({Title = "Auto-Farm", Content = "Returned to initial starting point.", Duration = 3})
                end
            end)
        else
            Lib:Notify({Title = "Auto-Farm", Content = "Manually halted by operator.", Duration = 3})
        end
    end
})
