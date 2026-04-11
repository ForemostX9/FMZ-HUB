local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🔥 FMZ HUB 🔥 (Testing)",
   LoadingTitle = "Loading Scripts...",
   LoadingSubtitle = "by MostX",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "FMZScripts",
      FileName = "FarmConfig"
   },
   Keybind = Enum.KeyCode.P 
})

-- ตัวแปรควบคุม
_G.AutoFarm = false
_G.AutoMine = false
_G.AutoBoss = false
_G.AntiAFK = true
-- ตัวแปรควบคุมสกิล
_G.SkillZ = true
_G.SkillX = true
_G.SkillT = true
_G.SkillV = true

local lp = game.Players.LocalPlayer
local IgnoreList = {} 
local MineBlacklist = {} 
local VirtualInputManager = game:GetService("VirtualInputManager")

-------------------------------------------------------
-- [ SYSTEM: FORCE ANTI AFK ]
-------------------------------------------------------
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        if _G.AntiAFK then
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end)
    while task.wait(120) do
        if _G.AntiAFK then
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end
    end
end)

-------------------------------------------------------
-- [ MAIN FARM TAB ]
-------------------------------------------------------
local MainTab = Window:CreateTab("Main Farm", 4483362458)

MainTab:CreateSection("Boss Farm System")

MainTab:CreateToggle({
   Name = "Auto Farm Boss (Malphas)",
   CurrentValue = false,
   Flag = "BossToggle",
   Callback = function(Value)
      _G.AutoBoss = Value
   end,
})

MainTab:CreateSection("Soul Farm System 👻")

MainTab:CreateToggle({
   Name = "Auto Farm Spirit",
   CurrentValue = false,
   Flag = "SoulToggle",
   Callback = function(Value)
      _G.AutoFarm = Value
   end,
})

MainTab:CreateButton({
   Name = "TP to Forest",
   Callback = function()
      local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
      if root then
          root.Velocity = Vector3.new(0,0,0)
          root.CFrame = CFrame.new(957.475037, 48.0, 494.011627)
          Rayfield:Notify({Title = "Teleport", Content = "Teleported to Forest!", Duration = 3})
      end
   end,
})

MainTab:CreateSection("Mining System ⛏️")

MainTab:CreateToggle({
   Name = "Auto Farm Ore",
   CurrentValue = false,
   Flag = "MineToggle",
   Callback = function(Value)
      _G.AutoMine = Value
      if not Value then
          MineBlacklist = {}
      end
   end,
})

MainTab:CreateButton({
   Name = "Tp to Cavern",
   Callback = function()
      local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
      if root then
          root.Velocity = Vector3.new(0,0,0)
          -- ปรับความสูงจาก 229 เป็น 235 เพื่อกันจมดิน
          root.CFrame = CFrame.new(1225.1167, 235.0, -1332.55298)
          Rayfield:Notify({Title = "Teleport", Content = "Teleported to Cavern (Safe Height)!", Duration = 3})
      end
   end,
})

-------------------------------------------------------
-- [ TELEPORT TAB ]
-------------------------------------------------------
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

TeleportTab:CreateSection("📍Tp to Boss")

TeleportTab:CreateButton({
   Name = "Boss Location 1",
   Callback = function()
      local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
      if root then
          root.Velocity = Vector3.new(0,0,0)
          root.CFrame = CFrame.new(39.6044769, 146.0, -1304.91309)
      end
   end,
})

TeleportTab:CreateButton({
   Name = "Boss Location 2",
   Callback = function()
      local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
      if root then
          root.Velocity = Vector3.new(0,0,0)
          root.CFrame = CFrame.new(-306.524597, 155.0, 994.546631)
      end
   end,
})

-------------------------------------------------------
-- [ MISC TAB ]
-------------------------------------------------------
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateSection("Auto Skill Settings")

MiscTab:CreateToggle({
   Name = "Use Skill Z",
   CurrentValue = true,
   Flag = "Skill_Z",
   Callback = function(Value) _G.SkillZ = Value end,
})

MiscTab:CreateToggle({
   Name = "Use Skill X",
   CurrentValue = true,
   Flag = "Skill_X",
   Callback = function(Value) _G.SkillX = Value end,
})

MiscTab:CreateToggle({
   Name = "Use Skill T",
   CurrentValue = true,
   Flag = "Skill_T",
   Callback = function(Value) _G.SkillT = Value end,
})

MiscTab:CreateToggle({
   Name = "Use Skill V",
   CurrentValue = true,
   Flag = "Skill_V",
   Callback = function(Value) _G.SkillV = Value end,
})

MiscTab:CreateSection("Misc Settings")

local AntiAFK_Toggle = MiscTab:CreateToggle({
   Name = "Anti AFK",
   CurrentValue = true, 
   Flag = "AntiAFK_Flag",
   Callback = function(Value)
      _G.AntiAFK = Value
   end,
})

-------------------------------------------------------
-- [ LOGIC SECTION ]
-------------------------------------------------------

local function getReady()
    local c = lp.Character or lp.CharacterAdded:Wait()
    local r = c:WaitForChild("HumanoidRootPart", 10)
    local h = c:WaitForChild("Humanoid", 10)
    return r, h
end

-- Boss Farm Logic
task.spawn(function()
    local bv, bg
    while true do
        task.wait()
        if _G.AutoBoss then
            pcall(function()
                local root, hum = getReady()
                local boss = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Malphas")
                local bossRoot = boss and boss:FindFirstChild("HumanoidRootPart")
                local bossHum = boss and boss:FindFirstChild("Humanoid")

                if bossRoot and bossHum and bossHum.Health > 0 then
                    if not root:FindFirstChild("FmzStabilizerV") then
                        bv = Instance.new("BodyVelocity", root)
                        bv.Name = "FmzStabilizerV"
                        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                        bv.Velocity = Vector3.new(0, 0, 0)
                    end
                    if not root:FindFirstChild("FmzStabilizerG") then
                        bg = Instance.new("BodyGyro", root)
                        bg.Name = "FmzStabilizerG"
                        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                        bg.P = 30000
                    end
                    
                    root.CFrame = bossRoot.CFrame * CFrame.new(0, 0, 3.5)
                    bg.CFrame = bossRoot.CFrame

                    local skillKeys = {
                        {Key = Enum.KeyCode.Z, Enabled = _G.SkillZ},
                        {Key = Enum.KeyCode.X, Enabled = _G.SkillX},
                        {Key = Enum.KeyCode.T, Enabled = _G.SkillT},
                        {Key = Enum.KeyCode.V, Enabled = _G.SkillV}
                    }

                    for _, skill in pairs(skillKeys) do
                        if skill.Enabled then
                            VirtualInputManager:SendKeyEvent(true, skill.Key, false, game)
                            task.wait(0.01)
                            VirtualInputManager:SendKeyEvent(false, skill.Key, false, game)
                        end
                    end

                    local args = {[1] = "NormalFist",[2] = 1,[3] = "NormalHit",[4] = bossRoot}
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("KatanaCombat"):FireServer(unpack(args))
                    task.wait(0.05)
                else
                    if root:FindFirstChild("FmzStabilizerV") then root.FmzStabilizerV:Destroy() end
                    if root:FindFirstChild("FmzStabilizerG") then root.FmzStabilizerG:Destroy() end
                end
            end)
        else
            local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if root:FindFirstChild("FmzStabilizerV") then root.FmzStabilizerV:Destroy() end
                if root:FindFirstChild("FmzStabilizerG") then root.FmzStabilizerG:Destroy() end
            end
            task.wait(1)
        end
    end
end)

-- Soul Farm Loop
task.spawn(function()
    local lastFoundTime = tick()
    while true do
        task.wait() 
        if _G.AutoFarm then
            pcall(function()
                local root, hum = getReady()
                if not root or not hum or hum.Health <= 0 then return end
                local foundTarget = false
                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if not _G.AutoFarm or hum.Health <= 0 then break end
                    if v:IsA("ProximityPrompt") and v.Enabled then
                        if string.find(v.ActionText or "", "Purify") or string.find(v.ObjectText or "", "วิญญาณ") then
                            foundTarget = true
                            lastFoundTime = tick()
                            local pos = v.Parent:IsA("BasePart") and v.Parent.Position or v.Parent.WorldPosition
                            root.CFrame = CFrame.new(pos + Vector3.new(0, 3.0, 0))
                            task.wait(0.05)
                            fireproximityprompt(v)
                            task.wait(v.HoldDuration + 0.1)
                            break 
                        end
                    end
                end
                if not foundTarget and (tick() - lastFoundTime) > 10 then
                    root.CFrame = CFrame.new(957.475037, 48.0, 494.011627)
                    lastFoundTime = tick()
                end
            end)
        end
    end
end)

-- Mining Farm Loop
task.spawn(function()
    local mineRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 5) and game:GetService("ReplicatedStorage").Remotes:WaitForChild("Mining", 5)
    local lastMineFoundTime = tick()
    while true do
        task.wait()
        if _G.AutoMine then
            local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local target = nil
                local dist = math.huge
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name:lower():find("ore") and v:IsA("Model") and not MineBlacklist[v] then
                        local p = v:GetModelCFrame().Position
                        local d = (root.Position - p).Magnitude
                        if d < dist then target = v dist = d end
                    end
                end
                if target then
                    lastMineFoundTime = tick()
                    pcall(function() root.CFrame = target:GetModelCFrame() * CFrame.new(0, 3, 4) end)
                    task.wait(0.2)
                    local startTime = tick()
                    while _G.AutoMine and target.Parent == workspace and (tick() - startTime < 10) do
                        if mineRemote then mineRemote:FireServer(target, "Mining") end
                        task.wait(0.05)
                    end
                    MineBlacklist[target] = true
                else
                    if (tick() - lastMineFoundTime) > 10 then
                        root.CFrame = CFrame.new(1225.1167, 235.0, -1332.55298)
                        MineBlacklist = {}
                        lastMineFoundTime = tick()
                    end
                end
            end
        end
    end
end)

Rayfield:Notify({
   Title = "FMZ HUB Loaded!",
   Content = "TP Cavern Fixed (Anti-Grounding)",
   Duration = 5,
})
