local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local lp, Ignore, MineBL = game.Players.LocalPlayer, {}, {}

local Window = Rayfield:CreateWindow({
   Name = "🔥 FMZ HUB 🔥",
   LoadingTitle = "FMZ Scripts",
   LoadingSubtitle = "by MostX",
   Keybind = Enum.KeyCode.P
})

local Main = Window:CreateTab("Main Farm", 4483362458)

Main:CreateSection("👻 Soul Farm System")
Main:CreateToggle({Name = "Auto Farm Souls", CurrentValue = false, Callback = function(v) _G.AutoFarm = v end})

Main:CreateSection("⛏️ Mining System")
Main:CreateToggle({Name = "Auto Mine", CurrentValue = false, Callback = function(v) _G.AutoMine = v; if not v then MineBL = {} end end})
Main:CreateButton({Name = "📍 TP to Mining Zone", Callback = function() 
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = CFrame.new(1225.1167, 229.666229, -1339.41138, 0, 0, -1, 0, 1, 0, 1, 0, 0) 
    end
end})

local function getChar() return lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") end
local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 5):WaitForChild("Mining", 5)

task.spawn(function()
    while task.wait() do
        if _G.AutoFarm and getChar() then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Enabled and not Ignore[v] then
                        if v.ActionText:find("Purify") or v.ActionText:find("ชำระ") then
                            Ignore[v] = true
                            getChar().CFrame = v.Parent.CFrame + Vector3.new(0, 2, 0)
                            task.wait(0.1) fireproximityprompt(v)
                            task.delay(2, function() Ignore[v] = nil end) break
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if _G.AutoMine and getChar() then
            local target, dist = nil, math.huge
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name:lower():find("ore") and v:IsA("Model") and not MineBL[v] then
                    local d = (getChar().Position - v:GetModelCFrame().Position).Magnitude
                    if d < dist then target, dist = v, d end
                end
            end
            if target then
                getChar().CFrame = target:GetModelCFrame() * CFrame.new(0, 2, 4)
                local s = tick()
                while _G.AutoMine and target.Parent == workspace and (tick()-s < 10) do
                    remotes:FireServer(target, "Mining")
                    getChar().Velocity = Vector3.zero
                    task.wait(0.05)
                end
                MineBL[target] = true
            else MineBL = {} end
        end
    end
end)

