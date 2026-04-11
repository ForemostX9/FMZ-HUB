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
_G.AntiAFK = false
local lp = game.Players.LocalPlayer
local IgnoreList = {} 
local MineBlacklist = {} 

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
-- [ SINGLE PAGE TAB ]
-------------------------------------------------------
local MainTab = Window:CreateTab("Main Farm", 4483362458)

-- หัวข้อที่ 1: ฟาร์มวิญญาณ
MainTab:CreateSection("👻 Soul Farm System")

MainTab:CreateToggle({
   Name = "Auto Farm Spirit",
   CurrentValue = false,
   Flag = "SoulToggle",
   Callback = function(Value)
      _G.AutoFarm = Value
   end,
})

MainTab:CreateButton({
   Name = "🌲 TP to Forest to Use Auto Farm Spirit",
   Callback = function()
      local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
      if root then
          root.CFrame = CFrame.new(957.475037, 45.4387665, 494.011627, 1, 0, 0, 0, 1, 0, 0, 0, 1)
          Rayfield:Notify({Title = "Teleport", Content = "Teleported to Forest!", Duration = 3})
      end
   end,
})

-- หัวข้อที่ 2: ขุดแร่
MainTab:CreateSection("⛏️ Mining System")

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
   Name = "📍 TP to Mining Zone to Use Auto Farm Ore",
   Callback = function()
      local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
      if root then
          root.CFrame = CFrame.new(1225.1167, 229.666229, -1339.41138, 0, 0, -1, 0, 1, 0, 1, 0, 0)
          Rayfield:Notify({Title = "Teleport", Content = "Teleported to Mining Zone!", Duration = 3})
      end
   end,
})

-- หัวข้อที่ 3: ระบบตั้งค่าอื่นๆ
MainTab:CreateSection("⚙️ Misc Settings")

MainTab:CreateToggle({
   Name = "Anti AFK",
   CurrentValue = false,
   Flag = "AntiAFK",
   Callback = function(Value)
      _G.AntiAFK = Value
   end,
})

-------------------------------------------------------
-- [ LOGIC SECTION ]
-------------------------------------------------------

-- ระบบ Anti AFK Logic
lp.Idled:Connect(function()
    if _G.AntiAFK then
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- ฟังก์ชันเช็คตัวละคร
local function getReady()
    local c = lp.Character or lp.CharacterAdded:Wait()
    local r = c:WaitForChild("HumanoidRootPart", 10)
    local h = c:WaitForChild("Humanoid", 10)
    return r, h
end

-- ลูปฟาร์มวิญญาณ + ระบบ Auto Re-TP 10 วินาที
task.spawn(function()
    local lastFoundTime = tick() -- เริ่มนับเวลา

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
                        local act = v.ActionText or ""
                        local objT = v.ObjectText or ""
                        
                        if string.find(act, "Purify") or string.find(act, "ชำระ") or string.find(objT, "วิญญาณ") then
                            foundTarget = true
                            lastFoundTime = tick() -- เจอแล้ว รีเซ็ตเวลา
                            
                            local pos = pObj:IsA("BasePart") and pObj.Position or (pObj:IsA("Attachment") and pObj.WorldPosition)
                            if pos then
                                IgnoreList[v] = true
                                root.CFrame = CFrame.new(pos + Vector3.new(0, 2.5, 0))
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

                -- ถ้าหาไม่เจอวิญญาณนานเกิน 10 วินาที
                if not foundTarget and (tick() - lastFoundTime) > 10 then
                    root.CFrame = CFrame.new(957.475037, 45.4387665, 494.011627, 1, 0, 0, 0, 1, 0, 0, 0, 1) -- วาร์ปไปพิกัดป่า
                    Rayfield:Notify({
                        Title = "Auto-Recovery", 
                        Content = "Soul not found for 10s. Teleporting to Forest...", 
                        Duration = 3
                    })
                    lastFoundTime = tick() -- รีเซ็ตเวลาหลังวาร์ป
                end
            end)
        else
            lastFoundTime = tick() -- ถ้าปิดฟาร์ม ให้รีเซ็ตเวลาไว้เสมอ
        end
    end
end)

-- ลูปขุดแร่
local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 5) and game:GetService("ReplicatedStorage").Remotes:WaitForChild("Mining", 5)

local function canMine(ore)
    if ore and ore.Parent == workspace and not MineBlacklist[ore] then
        if ore:FindFirstChildWhichIsA("BasePart") or ore:FindFirstChildWhichIsA("MeshPart") then
            return true
        end
    end
    return false
end

local function getClosestOre()
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, dist = nil, math.huge
    for _, v in pairs(workspace:GetChildren()) do
        if (v.Name:lower():find("ore")) and v:IsA("Model") and canMine(v) then
            local p = v:GetModelCFrame().Position
            local d = (root.Position - p).Magnitude
            if d < dist then
                closest = v
                dist = d
            end
        end
    end
    return closest
end

task.spawn(function()
    while true do
        task.wait()
        if _G.AutoMine then
            local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            local target = getClosestOre()
            
            if target and root then
                pcall(function()
                    root.CFrame = target:GetModelCFrame() * CFrame.new(0, 2, 4)
                end)
                task.wait(0.1)
                
                local startTime = tick()
                while _G.AutoMine and target.Parent == workspace and (tick() - startTime < 10) do
                    if remotes then remotes:FireServer(target, "Mining") end
                    root.Velocity = Vector3.new(0,0,0)
                    task.wait(0.05)
                    if not target:FindFirstChildWhichIsA("BasePart") and not target:FindFirstChildWhichIsA("MeshPart") then
                        break
                    end
                end
                MineBlacklist[target] = true
            else
                if next(MineBlacklist) ~= nil then
                    MineBlacklist = {}
                end
                task.wait(1)
            end
        end
    end
end)

Rayfield:Notify({
   Title = "FMZ HUB Ready!",
   Content = "Auto-Fix (10s) Enabled | Press P to Toggle UI",
   Duration = 5,
})
