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
_G.AntiAFK = true -- บังคับค่าตัวแปรเป็น true ไว้ก่อน

local lp = game.Players.LocalPlayer
local IgnoreList = {} 
local MineBlacklist = {} 

-------------------------------------------------------
-- [ SYSTEM: FORCE ANTI AFK ]
-------------------------------------------------------
-- ระบบป้องกันการถูกเตะออก (ทำงานเบื้องหลังทันที)
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        if _G.AntiAFK then
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end)
    -- ป้องกันแบบสำรอง (ขยับตัวเล็กน้อยทุก 2 นาที)
    while task.wait(120) do
        if _G.AntiAFK then
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end
    end
end)

-------------------------------------------------------
-- [ SYSTEM: TOGGLE UI WITH KEYBOARD ]
-------------------------------------------------------
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.P then
        local gui = game:GetService("CoreGui"):FindFirstChild("Rayfield")
        if gui then
            gui.Enabled = not gui.Enabled
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

MainTab:CreateSection("Soul Farm System")

MainTab:CreateToggle({
   Name = "Auto Farm Spirit 👻",
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
          root.CFrame = CFrame.new(1225.1167, 229.666229, -1332.55298, -0.209189296, 0, -0.977875292, 0, 1, 0, 0.977875292, 0, -0.209189296)
          Rayfield:Notify({Title = "Teleport", Content = "Teleported to Cavern!", Duration = 3})
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
          Rayfield:Notify({Title = "Teleport", Content = "TP Boss 1: Safe Height Applied", Duration = 3})
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
          Rayfield:Notify({Title = "Teleport", Content = "TP Boss 2: Safe Height Applied", Duration = 3})
      end
   end,
})

-------------------------------------------------------
-- [ MISC TAB ]
-------------------------------------------------------
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateSection("Misc Settings")

local AntiAFK_Toggle = MiscTab:CreateToggle({
   Name = "Anti AFK",
   CurrentValue = true, 
   Flag = "AntiAFK_Flag",
   Callback = function(Value)
      _G.AntiAFK = Value
   end,
})

-- บังคับให้ UI แสดงสถานะ "เปิด" (On) ทันทีที่รัน
AntiAFK_Toggle:Set(true)

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
    while true do
        task.wait(0.1)
        if _G.AutoBoss then
            pcall(function()
                local root, hum = getReady()
                local boss = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Malphas")
                local bossRoot = boss and boss:FindFirstChild("HumanoidRootPart")
                local bossHum = boss and boss:FindFirstChild("Humanoid")

                if bossRoot and bossHum and bossHum.Health > 0 then
                    root.CFrame = bossRoot.CFrame * CFrame.new(0, 0, 4)
                    local args = {[1] = "NormalFist",[2] = 1,[3] = "NormalHit",[4] = bossRoot}
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("KatanaCombat"):FireServer(unpack(args))
                    task.wait(0.4)
                end
            end)
        end
    end
end)

-- ลูปฟาร์มวิญญาณ
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
                        local pObj = v.Parent
                        if not pObj or IgnoreList[v] then continue end
                        if string.find(v.ActionText or "", "Purify") or string.find(v.ObjectText or "", "วิญญาณ") then
                            foundTarget = true
                            lastFoundTime = tick()
                            local pos = pObj:IsA("BasePart") and pObj.Position or (pObj:IsA("Attachment") and pObj.WorldPosition)
                            if pos then
                                IgnoreList[v] = true
                                root.CFrame = CFrame.new(pos + Vector3.new(0, 3.0, 0))
                                task.wait(0.05)
                                fireproximityprompt(v)
                                local t = tick()
                                repeat
                                    fireproximityprompt(v)
                                    task.wait()
                                until not v.Parent or (tick() - t) > (v.HoldDuration + 0.15) or not _G.AutoFarm
                                task.delay(2, function() IgnoreList[v] = nil end)
                                break 
                            end
                        end
                    end
                end
                if not foundTarget and (tick() - lastFoundTime) > 10 then
                    root.CFrame = CFrame.new(957.475037, 48.0, 494.011627)
                    lastFoundTime = tick()
                end
            end)
        else
            lastFoundTime = tick()
        end
    end
end)

-- ลูปขุดแร่
task.spawn(function()
    local mineRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 5) and game:GetService("ReplicatedStorage").Remotes:WaitForChild("Mining", 5)
    local lastMineFoundTime = tick()
    local mineResetPos = CFrame.new(1225.1167, 229.666229, -1332.55298, -0.209189296, 0, -0.977875292, 0, 1, 0, 0.977875292, 0, -0.209189296)

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
                    task.wait(0.1)
                    local startTime = tick()
                    while _G.AutoMine and target.Parent == workspace and (tick() - startTime < 10) do
                        if mineRemote then mineRemote:FireServer(target, "Mining") end
                        root.Velocity = Vector3.new(0,0,0)
                        task.wait(0.05)
                    end
                    MineBlacklist[target] = true
                else
                    if (tick() - lastMineFoundTime) > 10 then
                        root.CFrame = mineResetPos
                        Rayfield:Notify({Title = "Mining System", Content = "Auto-Returning to Cavern...", Duration = 3})
                        MineBlacklist = {}
                        lastMineFoundTime = tick()
                        task.wait(2)
                    end
                    task.wait(0.5)
                end
            end
        else
            lastMineFoundTime = tick()
        end
    end
end)

Rayfield:Notify({
   Title = "FMZ HUB Loaded!",
   Content = "Anti AFK is now ON",
   Duration = 5,
})
