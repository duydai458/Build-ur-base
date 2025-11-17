-- Auto Menu V2 - Full Chapter 1–5 + Mics (FINAL BUILD)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Destroy old GUI
if PlayerGui:FindFirstChild("AutoMenuV2") then
    PlayerGui.AutoMenuV2:Destroy()
end

-- Root GUI
local Root = Instance.new("ScreenGui")
Root.Name = "AutoMenuV2"
Root.ResetOnSpawn = false
Root.IgnoreGuiInset = true
Root.Parent = PlayerGui

-- Background
local background = Instance.new("Frame")
background.Size = UDim2.new(1,0,1,0)
background.BackgroundColor3 = Color3.fromRGB(0,0,0)
background.BackgroundTransparency = 1
background.ZIndex = 1
background.Parent = Root

-- Panel factory
local function makePanel(name,pos,size)
    local f=Instance.new("Frame")
    f.Name=name
    f.Position=pos
    f.Size=size
    f.BackgroundColor3=Color3.fromRGB(15,10,25)
    f.BackgroundTransparency=0.25
    f.BorderSizePixel=0
    f.ZIndex=2
    f.Parent=Root
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,14)
    local st=Instance.new("UIStroke",f)
    st.Thickness=1.6
    st.Color=Color3.fromRGB(120,90,255)
    st.Transparency=0.18
    st.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    return f
end

local LeftPanel=makePanel("LeftPanel",UDim2.new(0.02,0,0.09,0),UDim2.new(0.22,0,0.82,0))
local RightPanel=makePanel("RightPanel",UDim2.new(0.26,0,0.09,0),UDim2.new(0.70,0,0.82,0))

-- Tween helpers
local tweenInfo = TweenInfo.new(0.28,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
local function tweenBackgroundTo(v) TweenService:Create(background,tweenInfo,{BackgroundTransparency=v}):Play() end
local function tweenTransparency(obj,val) TweenService:Create(obj,tweenInfo,{BackgroundTransparency=val}):Play() end

-- GUI show/hide
local guiVisible = true
local function showGUI()
    if guiVisible then return end
    guiVisible=true
    LeftPanel.Visible=true
    RightPanel.Visible=true
    background.Visible=true
    tweenBackgroundTo(0.5)
    tweenTransparency(LeftPanel,0.25)
    tweenTransparency(RightPanel,0.25)
end
local function hideGUI()
    if not guiVisible then return end
    guiVisible=false
    tweenTransparency(LeftPanel,1)
    tweenTransparency(RightPanel,1)
    tweenBackgroundTo(1)
    task.delay(0.32,function()
        LeftPanel.Visible=false
        RightPanel.Visible=false
        background.Visible=false
    end)
end

-- LEFT PANEL
local chapters={"Chapter 1","Chapter 2","Chapter 3","Chapter 4","Chapter 5","Mics"}
local leftButtons={}
local selectedLeft=nil
local currentChapter="Chapter 1"

local function createLeftButton(parent,text,yOffset)
    local btn=Instance.new("TextButton")
    btn.Size=UDim2.new(0.9,0,0,40)
    btn.Position=UDim2.new(0.05,0,0,yOffset)
    btn.BackgroundColor3=Color3.fromRGB(59,31,122)
    btn.AutoButtonColor=false
    btn.Text=text
    btn.TextColor3=Color3.fromRGB(255,255,255)
    btn.Font=Enum.Font.Gotham
    btn.TextSize=16
    btn.ZIndex=6
    btn.Parent=parent
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
    local stroke=Instance.new("UIStroke",btn)
    stroke.Color=Color3.fromRGB(140,110,255)
    stroke.Thickness=1.2
    return btn
end

local startY=18
local gap=52
for i,name in ipairs(chapters) do
    local b=createLeftButton(LeftPanel,name,startY+(i-1)*gap)
    table.insert(leftButtons,b)
end

-- RIGHT PANEL
local title=Instance.new("TextLabel")
title.Size=UDim2.new(1,-20,0,36)
title.Position=UDim2.new(0,10,0,8)
title.BackgroundTransparency=1
title.Text="Auto Buy / Mics"
title.Font=Enum.Font.Gotham
title.TextSize=18
title.TextColor3=Color3.fromRGB(255,255,255)
title.ZIndex=6
title.Parent=RightPanel

local scroll=Instance.new("ScrollingFrame")
scroll.Size=UDim2.new(1,-20,1,-64)
scroll.Position=UDim2.new(0,10,0,50)
scroll.BackgroundTransparency=1
scroll.ScrollBarThickness=6
scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
scroll.Parent=RightPanel

local listLayout=Instance.new("UIListLayout",scroll)
listLayout.Padding=UDim.new(0,8)
listLayout.SortOrder=Enum.SortOrder.LayoutOrder

local function createToggle(name)
    local btn=Instance.new("TextButton")
    btn.Size=UDim2.new(1,-10,0,44)
    btn.BackgroundColor3=Color3.fromRGB(80,60,180)
    btn.Text=name
    btn.Font=Enum.Font.Gotham
    btn.TextSize=16
    btn.TextColor3=Color3.fromRGB(255,255,255)
    btn.ZIndex=7
    btn.Parent=scroll
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,10)
    return btn
end

-- CHAPTER ITEMS (FULL)
local chapterItems = {
    ["Chapter 1"] = {
        {"MinigunTurret", {"Blocks","MinigunTurret"}},
        {"Flamethrower", {"Blocks","Flamethrower"}},
        {"DoubleTurret", {"Blocks","DoubleTurret"}},
        {"Turret", {"Blocks","Turret"}},
        {"CrossbowTurret", {"Blocks","CrossbowTurret"}},
        {"MetalBlock", {"Blocks","MetalBlock"}},
        {"MetalLaserDoor", {"Blocks","MetalLaserDoor"}},
        {"StoneLaserDoor", {"Blocks","StoneLaserDoor"}},
        {"Block", {"Blocks","Block"}},
        {"MetalSpikes", {"Blocks","MetalSpikes"}}
    },

    ["Chapter 2"] = {
        {"HeavyTurret", {"Blocks","HeavyTurret"}},
        {"MinigunMK2Turret", {"Blocks","MinigunMK2Turret"}},
        {"DoubleMinigunTurret", {"Blocks","DoubleMinigunTurret"}},
        {"DragonFlamethrower", {"Blocks","DragonFlamethrower"}},
        {"PlasmaTurret", {"Blocks","PlasmaTurret"}},
        {"ObsidianSpikes", {"Blocks","ObsidianSpikes"}},
        {"SteelSpikes", {"Blocks","SteelSpikes"}},
        {"MagmaSpikes", {"Blocks","MagmaSpikes"}},
        {"SteelBlock", {"Blocks","SteelBlock"}},
        {"ObsidianBlock", {"Blocks","ObsidianBlock"}},
        {"MagmaBlock", {"Blocks","MagmaBlock"}},
        {"ObsidianWedge", {"Blocks","ObsidianWedge"}},
        {"ObsidianStair", {"Blocks","ObsidianStair"}},
        {"ObsidianLaserDoor", {"Blocks","ObsidianLaserDoor"}},
        {"MagmaWindow", {"Blocks","MagmaWindow"}},
        {"MagmaStair", {"Blocks","MagmaStair"}},
        {"MagmaWedge", {"Blocks","MagmaWedge"}},
        {"MagmaLaserDoor", {"Blocks","MagmaLaserDoor"}}
    },

    ["Chapter 3"] = {
        {"CannonTurret", {"Blocks","CannonTurret"}},
        {"DoubleCannonTurret", {"Blocks","DoubleCannonTurret"}},
        {"RayGun", {"Blocks","RayGun"}},
        {"DoubleRaygun", {"Blocks","DoubleRaygun"}},
        {"TeslaCoil", {"Blocks","TeslaCoil"}},
        {"HackerBlock", {"Blocks","HackerBlock"}},
        {"HackerLaserDoor", {"Blocks","HackerLaserDoor"}},
        {"HackerWedge", {"Blocks","HackerWedge"}},
        {"HackerWindow", {"Blocks","HackerWindow"}},
        {"HackerStair", {"Blocks","HackerStair"}},
        {"GuestBlock", {"Blocks","GuestBlock"}},
        {"GuestStair", {"Blocks","GuestStair"}},
        {"GuestWindow", {"Blocks","GuestWindow"}},
        {"GuestWedge", {"Blocks","GuestWedge"}},
        {"GuestLaserDoor", {"Blocks","GuestLaserDoor"}},
        {"NoobBlock", {"Blocks","NoobBlock"}},
        {"NoobWedge", {"Blocks","NoobWedge"}},
        {"NoobStair", {"Blocks","NoobStair"}},
        {"NoobWindow", {"Blocks","NoobWindow"}},
        {"NoobLaserDoor", {"Blocks","NoobLaserDoor"}}
    },

    ["Chapter 4"] = {
        {"DoubleCircusCannon", {"Blocks","DoubleCircusCannon"}},
        {"CircusMinigun", {"Blocks","CircusMinigun"}},
        {"CircusPlasma", {"Blocks","CircusPlasma"}},
        {"CircusBlock", {"Blocks","CircusBlock"}},
        {"CircusLaserDoor", {"Blocks","CircusLaserDoor"}},
        {"CircusTurret", {"Blocks","CircusTurret"}},
        {"CircusWedge", {"Blocks","CircusWedge"}},
        {"CircusStair", {"Blocks","CircusStair"}}
    },

    ["Chapter 5"] = {
        {"ArcticTurret", {"Blocks","ArcticTurret"}},
        {"DoubleArcticTurret", {"Blocks","DoubleArcticTurret"}},
        {"ArcticSnowthrower", {"Blocks","ArcticSnowthrower"}},
        {"ArcticMinigunTurret", {"Blocks","ArcticMinigunTurret"}},
        {"ArcticCrystal", {"Blocks","ArcticCrystal"}},
        {"GlacierBlock", {"Blocks","GlacierBlock"}},
        {"IceBlock", {"Blocks","IceBlock"}},
        {"GlacierLaserDoor", {"Blocks","GlacierLaserDoor"}},
        {"IceLaserDoor", {"Blocks","IceLaserDoor"}},
        {"GlacierStair", {"Blocks","GlacierStair"}},
        {"GlacierWedge", {"Blocks","GlacierWedge"}},
        {"IceWedge", {"Blocks","IceWedge"}},
        {"IceStair", {"Blocks","IceStair"}}
    },

    ["Mics"] = {
        {"AbilityClaim", function()
            local net=ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("UIController"):WaitForChild("NetLink"):WaitForChild("Net")
            net:WaitForChild("RE/ClaimFreeAbilityCard"):FireServer()
        end},

        {"HalloweenSoul", function()
            local net=ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("UIController"):WaitForChild("NetLink"):WaitForChild("Net")
            pcall(function()
                net:WaitForChild("RE/CollectHarvestingDepositEvent"):FireServer()
                net:WaitForChild("RE/SoulHarvestingDepositEvent"):FireServer()
            end)
        end},

        {"AutoShoot", function()
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("ToolState"):FireServer(true)
        end},

        {"AutoJump","toggle"}
    }
}

-- Toggle states
local toggleStates = {}
local toggles = {}

local function createTogglesForChapter(chap)
    for _,v in ipairs(scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    toggles={}
    toggleStates[chap]=toggleStates[chap] or {}

    for _,item in ipairs(chapterItems[chap] or {}) do
        local name,val=item[1],item[2]
        toggleStates[chap][name]=toggleStates[chap][name] or false

        local btn=createToggle(name)
        btn.BackgroundColor3 = toggleStates[chap][name] and Color3.fromRGB(60,200,60) or Color3.fromRGB(80,60,180)

        btn.MouseButton1Click:Connect(function()
            toggleStates[chap][name]=not toggleStates[chap][name]
            local newColor=toggleStates[chap][name] and Color3.fromRGB(60,200,60) or Color3.fromRGB(80,60,180)
            TweenService:Create(btn,TweenInfo.new(0.22),{BackgroundColor3=newColor}):Play()
        end)

        toggles[name]=btn
    end
end

-- Left button click
for _,btn in ipairs(leftButtons) do
    btn.MouseButton1Click:Connect(function()
        if selectedLeft and selectedLeft~=btn then
            TweenService:Create(selectedLeft,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(59,31,122)}):Play()
        end
        selectedLeft=btn
        TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(150,100,255)}):Play()
        currentChapter=btn.Text
        createTogglesForChapter(currentChapter)
    end)
end

-- Auto Buy Loop
spawn(function()
    while true do
        for chap,togs in pairs(toggleStates) do
            for name,active in pairs(togs) do
                if active then
                    local val
                    for _,v in ipairs(chapterItems[chap] or {}) do
                        if v[1]==name then val=v[2] break end
                    end
                    if val then
                        if typeof(val)=="table" then
                            pcall(function()
                                ReplicatedStorage.Remotes.Functions.BuyStock:InvokeServer(unpack(val))
                            end)
                        elseif typeof(val)=="function" then
                            pcall(val)
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-- Auto Jump
spawn(function()
    while true do
        if toggleStates["Mics"] and toggleStates["Mics"]["AutoJump"] then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end
        task.wait(5)
    end
end)

-- ICON
local icon=Instance.new("TextButton")
icon.Size=UDim2.new(0,50,0,50)
icon.Text="⚙️"
icon.Font=Enum.Font.Gotham
icon.TextSize=22
icon.BackgroundColor3=Color3.fromRGB(255,223,0)
icon.ZIndex=1000
icon.Parent=Root
Instance.new("UICorner",icon).CornerRadius=UDim.new(1,0)
icon.Position=UDim2.new(1,-80,0,40)

icon.MouseButton1Click:Connect(function()
    if guiVisible then hideGUI() else showGUI() end
end)

-- Drag icon
do
    local dragging=false
    local dragStart,startPos
    icon.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            dragStart=input.Position
            startPos=icon.Position
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then dragging=false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta=input.Position-dragStart
            icon.Position=UDim2.new(
                0, startPos.X.Offset + delta.X,
                0, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Start GUI
selectedLeft=leftButtons[1]
TweenService:Create(selectedLeft,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(150,100,255)}):Play()
createTogglesForChapter(currentChapter)
showGUI()
