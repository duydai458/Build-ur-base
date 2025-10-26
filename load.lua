--// ThinGUI_Root - Full Chapter + Mics Auto Buy + Auto Jump
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

if CoreGui:FindFirstChild("ThinGUI_Root") then
    CoreGui.ThinGUI_Root:Destroy()
end

local Root = Instance.new("ScreenGui")
Root.Name = "ThinGUI_Root"
Root.ResetOnSpawn = false
Root.IgnoreGuiInset = true
Root.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Root.Parent = CoreGui

-- Background
local background = Instance.new("Frame")
background.Size = UDim2.new(1,0,1,0)
background.BackgroundColor3 = Color3.fromRGB(0,0,0)
background.BackgroundTransparency = 1
background.ZIndex = 1
background.Parent = Root

-- Panels
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
local chapters={"Chapter 1","Chapter 2","Chapter 3","Chapter 4","Mics"}
local leftButtons={}
local selectedLeft=nil
local currentChapter="Chapter 1"

local function createLeftButton(parent,text,yOffset)
    local btn=Instance.new("TextButton")
    btn.Size=UDim2.new(0.9,0,0,40)
    btn.Position=UDim2.new(0.05,0,0,yOffset)
    btn.BackgroundColor3=Color3.fromRGB(59,31,122)
    btn.BackgroundTransparency=0
    btn.AutoButtonColor=false
    btn.Text=text
    btn.TextColor3=Color3.fromRGB(255,255,255)
    btn.Font=Enum.Font.Gotham
    btn.TextSize=16
    btn.TextXAlignment=Enum.TextXAlignment.Center
    btn.TextYAlignment=Enum.TextYAlignment.Center
    btn.ZIndex=6
    btn.Parent=parent
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
    local stroke=Instance.new("UIStroke",btn)
    stroke.Color=Color3.fromRGB(140,110,255)
    stroke.Thickness=1.2
    stroke.Transparency=0.18
    stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
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
title.TextXAlignment=Enum.TextXAlignment.Center
title.ZIndex=6
title.Parent=RightPanel

local scroll=Instance.new("ScrollingFrame")
scroll.Size=UDim2.new(1,-20,1,-64)
scroll.Position=UDim2.new(0,10,0,50)
scroll.BackgroundTransparency=1
scroll.BorderSizePixel=0
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
    btn.BackgroundTransparency=0
    btn.Text=name
    btn.Font=Enum.Font.Gotham
    btn.TextSize=16
    btn.TextColor3=Color3.fromRGB(255,255,255)
    btn.Parent=scroll
    btn.ZIndex=7
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,10)
    local stroke=Instance.new("UIStroke",btn)
    stroke.Color=Color3.fromRGB(200,180,255)
    stroke.Transparency=0.35
    stroke.Thickness=1
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundTransparency=0}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundTransparency=0}):Play()
    end)
    return btn
end

-- =======================
-- CHAPTER ITEMS + MICS
-- =======================
local chapterItems = {
    -- Chapter 1-4 đầy đủ giống trước
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
        {"CircusTurret", {"Blocks","CircusTurret"}}
    },
    ["Mics"] = {
        {"AbilityClaim", function()
            local net=ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("UIController"):WaitForChild("NetLink"):WaitForChild("Net")
            local claimEvent=net:WaitForChild("RE/ClaimFreeAbilityCard")
            claimEvent:FireServer()
        end},
        {"HalloweenSoul", function()
            local net=ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("UIController"):WaitForChild("NetLink"):WaitForChild("Net")
            local collectSoulEvent=net:WaitForChild("RE/CollectHarvestingDepositEvent")
            local submitSoulEvent=net:WaitForChild("RE/SoulHarvestingDepositEvent")
            pcall(function()
                collectSoulEvent:FireServer()
                submitSoulEvent:FireServer()
            end)
        end},
        {"AutoShoot", function()
            local args={true}
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("ToolState"):FireServer(unpack(args))
        end},
        {"AutoJump", "toggle"} -- chỉ định toggle, logic AutoJump riêng
    }
}

-- Toggle states
local toggleStates = {}
local toggles = {}

local function createTogglesForChapter(chap)
    for _,v in ipairs(scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    toggles={}
    toggleStates[chap]=toggleStates[chap] or {}
    for _,item in ipairs(chapterItems[chap]) do
        local name,val=item[1],item[2]
        toggleStates[chap][name]=toggleStates[chap][name] or false
        local btn=createToggle(name)
        btn.Parent=scroll
        btn.BackgroundColor3 = toggleStates[chap][name] and Color3.fromRGB(60,200,60) or Color3.fromRGB(80,60,180)
        btn.MouseButton1Click:Connect(function()
            toggleStates[chap][name]=not toggleStates[chap][name]
            local newColor=toggleStates[chap][name] and Color3.fromRGB(60,200,60) or Color3.fromRGB(80,60,180)
            TweenService:Create(btn,TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=newColor}):Play()
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

-- Auto run toggles (1s interval)
spawn(function()
    while true do
        for chap,togs in pairs(toggleStates) do
            for name,active in pairs(togs) do
                if active then
                    local val
                    for _,v in ipairs(chapterItems[chap]) do
                        if v[1]==name then val=v[2]; break end
                    end
                    if val then
                        if typeof(val)=="table" then
                            pcall(function()
                                ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("BuyStock"):InvokeServer(unpack(val))
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

-- AutoJump (5 giây/lần, toggle bật/tắt)
spawn(function()
    local LocalPlayer = Players.LocalPlayer
    while true do
        if toggleStates["Mics"] and toggleStates["Mics"]["AutoJump"] then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
        task.wait(5)
    end
end)

-- ICON
local icon=Instance.new("TextButton")
icon.Size=UDim2.new(0,50,0,50)
icon.AnchorPoint=Vector2.new(0,0)
icon.Text="⚙️"
icon.Font=Enum.Font.Gotham
icon.TextSize=22
icon.TextColor3=Color3.fromRGB(0,0,0)
icon.BackgroundColor3=Color3.fromRGB(255,223,0)
icon.BorderSizePixel=0
icon.ZIndex=1000
icon.Parent=Root
Instance.new("UICorner",icon).CornerRadius=UDim.new(1,0)
icon.Position=UDim2.new(1,-80,0,40)
icon.MouseButton1Click:Connect(function()
    if guiVisible then hideGUI() else showGUI() end
end)

do
    local dragging=false
    local dragStart,startPos
    local function clamp(x,y)
        local screen=workspace.CurrentCamera.ViewportSize
        local w,h=icon.AbsoluteSize.X,icon.AbsoluteSize.Y
        return math.clamp(x,0,screen.X-w),math.clamp(y,0,screen.Y-h)
    end
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
            local newX=startPos.X.Offset+delta.X
            local newY=startPos.Y.Offset+delta.Y
            newX,newY=clamp(newX,newY)
            icon.Position=UDim2.new(0,newX,0,newY)
        end
    end)
end

-- Start GUI
selectedLeft=leftButtons[1]
TweenService:Create(selectedLeft,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(150,100,255)}):Play()
createTogglesForChapter(currentChapter)
showGUI()