--// ============================================================
--// GROW A GARDEN 2 | HUB  —  made by ashfall
--// Key System GUI
--// ============================================================

local Players            = game:GetService("Players")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local HttpService        = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- ⚙️  CONFIG — edit these whenever you want
-- ============================================================
local CONFIG = {
    HUB_NAME     = "GROW A GARDEN 2",
    HUB_SUBTITLE = "HUB made by ashfall",

    -- Paste your key-link (linkvertise / your own site / etc) here any time:
    KEY_LINK = "[https://sub2unlock.me/r5Z6eUm]",

    -- Paste the URL your key system checks against here any time
    -- (e.g. a raw pastebin/github list of valid keys, or your own API).
    -- Leave as-is if you just want the local VALID_KEYS table below.
    KEY_API_URL = "[https://pastebin.com/raw/MMZzFLqK]",

    -- Fallback / offline valid keys (used if KEY_API_URL is left blank
    -- or fails to load). Add/remove keys freely.
    VALID_KEYS = {
        "ASHFALL-DEMO-KEY",
    },
}

-- ============================================================
-- 🔑  KEY VALIDATION LOGIC
-- ============================================================
local function fetchRemoteKeys()
    if CONFIG.KEY_API_URL == "" or CONFIG.KEY_API_URL:find("PASTE YOUR") then
        return nil -- no remote source configured, fall back to local table
    end

    local ok, result = pcall(function()
        return game:HttpGet(CONFIG.KEY_API_URL)
    end)

    if not ok or not result then return nil end

    -- Supports either a plain newline-separated key list,
    -- or a JSON array like ["KEY1","KEY2"]
    local decodeOk, decoded = pcall(function()
        return HttpService:JSONDecode(result)
    end)

    if decodeOk and typeof(decoded) == "table" then
        return decoded
    end

    local lines = {}
    for line in result:gmatch("[^\r\n]+") do
        table.insert(lines, line:match("^%s*(.-)%s*$")) -- trim whitespace
    end
    return lines
end

local function isKeyValid(inputKey)
    inputKey = inputKey:match("^%s*(.-)%s*$") -- trim
    if inputKey == "" then return false end

    local remoteKeys = fetchRemoteKeys()
    local keyList = remoteKeys or CONFIG.VALID_KEYS

    for _, k in ipairs(keyList) do
        if k == inputKey then
            return true
        end
    end
    return false
end

-- ============================================================
-- 🎨  GUI BUILD
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrowAGarden2_KeySystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

-- ---------- Main Frame ----------
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 420, 0, 230)
Main.Position = UDim2.new(0.5, -210, 0.5, -115)
Main.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 200, 90)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.3
MainStroke.Parent = Main

-- subtle gradient background
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 32, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 20)),
})
MainGradient.Rotation = 90
MainGradient.Parent = Main

-- ---------- Title Bar ----------
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 54)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

-- mask the bottom corners of the title bar so it looks flush
local TitleMask = Instance.new("Frame")
TitleMask.Size = UDim2.new(1, 0, 0, 14)
TitleMask.Position = UDim2.new(0, 0, 1, -14)
TitleMask.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
TitleMask.BorderSizePixel = 0
TitleMask.ZIndex = 0
TitleMask.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 18, 0, 6)
Title.Size = UDim2.new(1, -36, 0, 24)
Title.Font = Enum.Font.GothamBold
Title.Text = CONFIG.HUB_NAME
Title.TextColor3 = Color3.fromRGB(120, 230, 140)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local Subtitle = Instance.new("TextLabel")
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 18, 0, 28)
Subtitle.Size = UDim2.new(1, -36, 0, 18)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = CONFIG.HUB_SUBTITLE
Subtitle.TextColor3 = Color3.fromRGB(160, 160, 165)
Subtitle.TextSize = 13
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -40, 0, 13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ---------- Status / Info label ----------
local StatusLabel = Instance.new("TextLabel")
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 18, 0, 66)
StatusLabel.Size = UDim2.new(1, -36, 0, 40)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Enter your key below, or get one with Copy Link."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
StatusLabel.TextSize = 13
StatusLabel.TextWrapped = true
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
StatusLabel.Parent = Main

-- ---------- Key Input Box ----------
local KeyBox = Instance.new("TextBox")
KeyBox.Position = UDim2.new(0, 18, 0, 108)
KeyBox.Size = UDim2.new(1, -36, 0, 38)
KeyBox.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
KeyBox.PlaceholderText = "Paste your key here..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 125)
KeyBox.Text = ""
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.TextColor3 = Color3.fromRGB(230, 230, 230)
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = Main

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.CornerRadius = UDim.new(0, 8)
KeyBoxCorner.Parent = KeyBox

local KeyBoxStroke = Instance.new("UIStroke")
KeyBoxStroke.Color = Color3.fromRGB(70, 70, 76)
KeyBoxStroke.Thickness = 1
KeyBoxStroke.Parent = KeyBox

local KeyBoxPadding = Instance.new("UIPadding")
KeyBoxPadding.PaddingLeft = UDim.new(0, 12)
KeyBoxPadding.PaddingRight = UDim.new(0, 12)
KeyBoxPadding.Parent = KeyBox

-- ---------- Bottom Buttons (Check Key | Copy Link) ----------
local ButtonHolder = Instance.new("Frame")
ButtonHolder.BackgroundTransparency = 1
ButtonHolder.Position = UDim2.new(0, 18, 0, 158)
ButtonHolder.Size = UDim2.new(1, -36, 0, 44)
ButtonHolder.Parent = Main

local ButtonLayout = Instance.new("UIListLayout")
ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
ButtonLayout.Padding = UDim.new(0, 12)
ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
ButtonLayout.Parent = ButtonHolder

-- Left: Check Key
local CheckKeyBtn = Instance.new("TextButton")
CheckKeyBtn.Name = "CheckKeyBtn"
CheckKeyBtn.LayoutOrder = 1
CheckKeyBtn.Size = UDim2.new(0.5, -6, 1, 0)
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(60, 190, 90)
CheckKeyBtn.Text = "Check Key"
CheckKeyBtn.Font = Enum.Font.GothamBold
CheckKeyBtn.TextSize = 15
CheckKeyBtn.TextColor3 = Color3.fromRGB(15, 15, 15)
CheckKeyBtn.AutoButtonColor = false
CheckKeyBtn.Parent = ButtonHolder

local CheckKeyCorner = Instance.new("UICorner")
CheckKeyCorner.CornerRadius = UDim.new(0, 10)
CheckKeyCorner.Parent = CheckKeyBtn

-- Right: Copy Link
local CopyLinkBtn = Instance.new("TextButton")
CopyLinkBtn.Name = "CopyLinkBtn"
CopyLinkBtn.LayoutOrder = 2
CopyLinkBtn.Size = UDim2.new(0.5, -6, 1, 0)
CopyLinkBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
CopyLinkBtn.Text = "Copy Link"
CopyLinkBtn.Font = Enum.Font.GothamBold
CopyLinkBtn.TextSize = 15
CopyLinkBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
CopyLinkBtn.AutoButtonColor = false
CopyLinkBtn.Parent = ButtonHolder

local CopyLinkCorner = Instance.new("UICorner")
CopyLinkCorner.CornerRadius = UDim.new(0, 10)
CopyLinkCorner.Parent = CopyLinkBtn

local CopyLinkStroke = Instance.new("UIStroke")
CopyLinkStroke.Color = Color3.fromRGB(70, 70, 76)
CopyLinkStroke.Thickness = 1
CopyLinkStroke.Parent = CopyLinkBtn

-- ============================================================
-- 🖱️  Hover / press feedback
-- ============================================================
local function addHover(button, baseColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = baseColor}):Play()
    end)
end

addHover(CheckKeyBtn, Color3.fromRGB(60, 190, 90), Color3.fromRGB(75, 210, 105))
addHover(CopyLinkBtn, Color3.fromRGB(40, 40, 46), Color3.fromRGB(55, 55, 62))

-- ============================================================
-- 🖱️  Draggable window
-- ============================================================
do
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ============================================================
-- 🔘  Button behaviour
-- ============================================================
local function setStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color or Color3.fromRGB(200, 200, 205)
end

CopyLinkBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(CONFIG.KEY_LINK)
        setStatus("Link copied to clipboard! Get your key, then paste it above.", Color3.fromRGB(120, 200, 255))
    else
        setStatus("Your executor doesn't support setclipboard. Link:\n" .. CONFIG.KEY_LINK, Color3.fromRGB(255, 180, 90))
    end
end)

CheckKeyBtn.MouseButton1Click:Connect(function()
    local key = KeyBox.Text

    if key == "" then
        setStatus("Please enter a key first.", Color3.fromRGB(255, 120, 120))
        return
    end

    setStatus("Checking key...", Color3.fromRGB(200, 200, 205))
    CheckKeyBtn.Text = "Checking..."

    task.spawn(function()
        local valid = isKeyValid(key)

        if valid then
            setStatus("Key valid! Loading hub...", Color3.fromRGB(120, 230, 140))
            CheckKeyBtn.Text = "Check Key"

            -- ✅ Key accepted — put your hub-loading code here, e.g.:
            -- loadstring(game:HttpGet("[PASTE YOUR MAIN SCRIPT URL HERE]"))()

            task.wait(0.6)
            TweenService:Create(Main, TweenInfo.new(0.25), {
                Size = UDim2.new(0, 420, 0, 0),
                Position = Main.Position + UDim2.new(0, 0, 0, 115),
            }):Play()
            task.wait(0.25)
            ScreenGui:Destroy()
        else
            setStatus("Invalid key. Try Copy Link to get a new one.", Color3.fromRGB(255, 120, 120))
            CheckKeyBtn.Text = "Check Key"
        end
    end)
end)
 Key"
        end
    end)
end)
