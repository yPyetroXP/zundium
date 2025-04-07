-- Zundium UI Library
-- Criado por yPyetroXP com assistência de Grok @ xAI
-- Desenvolvido para suportar exploits no Roblox
local Zundium = {}
local TweenService = game:GetService("TweenService")

-- Configurações globais
local ZundiumConfig = {
    Theme = {
        PrimaryColor = Color3.fromRGB(20, 20, 25),        -- Fundo escuro quase preto
        AccentColor = Color3.fromRGB(0, 200, 255),        -- Ciano neon
        SecondaryColor = Color3.fromRGB(35, 35, 40),      -- Cinza escuro para contraste
        TextColor = Color3.fromRGB(220, 220, 220),        -- Texto claro
        ToggleOnColor = Color3.fromRGB(0, 255, 120),      -- Verde neon
        ToggleOffColor = Color3.fromRGB(50, 50, 55),      -- Cinza apagado
        SliderColor = Color3.fromRGB(80, 80, 85)          -- Cinza para sliders
    },
    Version = "1.3 by yPyetroXP",
    AnimationSpeed = 0.25 -- Ancodecs

-- Função principal para criar uma janela
function Zundium:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TitleBar = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local MinimizeButton = Instance.new("TextButton")
    local HideButton = Instance.new("TextButton")
    local Container = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")

    ScreenGui.Name = "ZundiumUI_" .. tostring(math.random(1000, 9999))
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 350, 0, 0) -- Começa fechado para animação
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
    MainFrame.BackgroundColor3 = ZundiumConfig.Theme.PrimaryColor
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true

    UICorner.Parent = MainFrame
    UICorner.CornerRadius = UDim.new(0, 8) -- Bordas arredondadas

    TitleBar.Parent = MainFrame
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = ZundiumConfig.Theme.AccentColor
    TitleBar.BorderSizePixel = 0

    TitleLabel.Parent = TitleBar
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.Position = UDim2.new(0, 5, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "Zundium - " .. title .. " | " .. ZundiumConfig.Version
    TitleLabel.TextColor3 = ZundiumConfig.Theme.TextColor
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    MinimizeButton.Parent = TitleBar
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
    MinimizeButton.BackgroundColor3 = ZundiumConfig.Theme.SecondaryColor
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = ZundiumConfig.Theme.TextColor
    MinimizeButton.TextSize = 16
    MinimizeButton.Font = Enum.Font.Gotham

    HideButton.Parent = TitleBar
    HideButton.Size = UDim2.new(0, 30, 0, 30)
    HideButton.Position = UDim2.new(1, -30, 0, 0)
    HideButton.BackgroundColor3 = ZundiumConfig.Theme.SecondaryColor
    HideButton.Text = "X"
    HideButton.TextColor3 = ZundiumConfig.Theme.TextColor
    HideButton.TextSize = 16
    HideButton.Font = Enum.Font.Gotham

    Container.Parent = MainFrame
    Container.Size = UDim2.new(1, 0, 1, -40)
    Container.Position = UDim2.new(0, 0, 0, 35)
    Container.BackgroundTransparency = 1

    UIListLayout.Parent = Container
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    UIPadding.Parent = Container
    UIPadding.PaddingLeft = UDim.new(0, 8)
    UIPadding.PaddingRight = UDim.new(0, 8)
    UIPadding.PaddingTop = UDim.new(0, 8)

    -- Animação de abertura
    local openTween = TweenService:Create(MainFrame, TweenInfo.new(ZundiumConfig.AnimationSpeed, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 350, 0, 400)})
    openTween:Play()

    -- Sistema de arrastar
    local dragging, dragInput, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        elseif input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    -- Sistema de minimizar
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        local targetSize = minimized and UDim2.new(0, 350, 0, 30) or UDim2.new(0, 350, 0, 400)
        local tween = TweenService:Create(MainFrame, TweenInfo.new(ZundiumConfig.AnimationSpeed, Enum.EasingStyle.Quart), {Size = targetSize})
        tween:Play()
        Container.Visible = not minimized
        MinimizeButton.Text = minimized and "+" or "-"
    end)

    -- Sistema de esconder
    HideButton.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(ZundiumConfig.AnimationSpeed, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 350, 0, 0)})
        closeTween:Play()
        closeTween.Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)

    -- Objeto da janela
    local Window = { Elements = {} }

    -- Função para adicionar botão
    function Window:AddButton(text, callback)
        local Button = Instance.new("TextButton")
        local UICorner = Instance.new("UICorner")
        Button.Parent = Container
        Button.Size = UDim2.new(1, 0, 0, 35)
        Button.BackgroundColor3 = ZundiumConfig.Theme.AccentColor
        Button.Text = text
        Button.TextColor3 = ZundiumConfig.Theme.TextColor
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 14
        UICorner.Parent = Button
        UICorner.CornerRadius = UDim.new(0, 6)
        Button.MouseButton1Click:Connect(callback)
        table.insert(self.Elements, Button)
        return Button
    end

    -- Função para adicionar toggle
    function Window:AddToggle(text, default, callback)
        local Toggle = Instance.new("TextButton")
        local UICorner = Instance.new("UICorner")
        local state = default or false
        Toggle.Parent = Container
        Toggle.Size = UDim2.new(1, 0, 0, 35)
        Toggle.BackgroundColor3 = state and ZundiumConfig.Theme.ToggleOnColor or ZundiumConfig.Theme.ToggleOffColor
        Toggle.Text = text .. (state and " [ON]" or " [OFF]")
        Toggle.TextColor3 = ZundiumConfig.Theme.TextColor
        Toggle.Font = Enum.Font.Gotham
        Toggle.TextSize = 14
        UICorner.Parent = Toggle
        UICorner.CornerRadius = UDim.new(0, 6)
        Toggle.MouseButton1Click:Connect(function()
            state = not state
            Toggle.Text = text .. (state and " [ON]" or " [OFF]")
            local targetColor = state and ZundiumConfig.Theme.ToggleOnColor or ZundiumConfig.Theme.ToggleOffColor
            TweenService:Create(Toggle, TweenInfo.new(ZundiumConfig.AnimationSpeed / 2, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
            callback(state)
        end)
        table.insert(self.Elements, Toggle)
        return Toggle
    end

    -- Função para adicionar textbox
    function Window:AddTextbox(placeholder, callback)
        local TextBox = Instance.new("TextBox")
        local UICorner = Instance.new("UICorner")
        TextBox.Parent = Container
        TextBox.Size = UDim2.new(1, 0, 0, 35)
        TextBox.BackgroundColor3 = ZundiumConfig.Theme.SecondaryColor
        TextBox.PlaceholderText = placeholder
        TextBox.Text = ""
        TextBox.TextColor3 = ZundiumConfig.Theme.TextColor
        TextBox.Font = Enum.Font.Gotham
        TextBox.TextSize = 14
        TextBox.ClearTextOnFocus = false
        UICorner.Parent = TextBox
        UICorner.CornerRadius = UDim.new(0, 6)
        TextBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                callback(TextBox.Text)
            end
        end)
        table.insert(self.Elements, TextBox)
        return TextBox
    end

    -- Função para adicionar dropdown
    function Window:AddDropdown(options, callback)
        local Dropdown = Instance.new("TextButton")
        local UICorner = Instance.new("UICorner")
        local DropFrame = Instance.new("Frame")
        local DropUICorner = Instance.new("UICorner")
        local DropList = Instance.new("UIListLayout")
        local isOpen = false

        Dropdown.Parent = Container
        Dropdown.Size = UDim2.new(1, 0, 0, 35)
        Dropdown.BackgroundColor3 = ZundiumConfig.Theme.AccentColor
        Dropdown.Text = "Selecione uma opção"
        Dropdown.TextColor3 = ZundiumConfig.Theme.TextColor
        Dropdown.Font = Enum.Font.Gotham
        Dropdown.TextSize = 14
        UICorner.Parent = Dropdown
        UICorner.CornerRadius = UDim.new(0, 6)

        DropFrame.Parent = Container
        DropFrame.Size = UDim2.new(1, 0, 0, 0)
        DropFrame.Position = UDim2.new(0, 0, 0, 40)
        DropFrame.BackgroundColor3 = ZundiumConfig.Theme.SecondaryColor
        DropFrame.ClipsDescendants = true
        DropFrame.Visible = false
        DropUICorner.Parent = DropFrame
        DropUICorner.CornerRadius = UDim.new(0, 6)

        DropList.Parent = DropFrame
        DropList.SortOrder = Enum.SortOrder.LayoutOrder
        DropList.Padding = UDim.new(0, 2)

        local function updateDropdown()
            local targetSize = isOpen and UDim2.new(1, 0, 0, #options * 37) or UDim2.new(1, 0, 0, 0)
            local tween = TweenService:Create(DropFrame, TweenInfo.new(ZundiumConfig.AnimationSpeed, Enum.EasingStyle.Quart), {Size = targetSize})
            DropFrame.Visible = true
            tween:Play()
            tween.Completed:Connect(function()
                if not isOpen then DropFrame.Visible = false end
            end)
        end

        Dropdown.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            updateDropdown()
        end)

        for _, option in pairs(options) do
            local OptionButton = Instance.new("TextButton")
            local OptionUICorner = Instance.new("UICorner")
            OptionButton.Parent = DropFrame
            OptionButton.Size = UDim2.new(1, 0, 0, 35)
            OptionButton.BackgroundColor3 = ZundiumConfig.Theme.AccentColor
            OptionButton.Text = option
            OptionButton.TextColor3 = ZundiumConfig.Theme.TextColor
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.TextSize = 14
            OptionUICorner.Parent = OptionButton
            OptionUICorner.CornerRadius = UDim.new(0, 6)
            OptionButton.MouseButton1Click:Connect(function()
                Dropdown.Text = option
                isOpen = false
                updateDropdown()
                callback(option)
            end)
        end

        table.insert(self.Elements, Dropdown)
        return Dropdown
    end

    -- Função para adicionar slider
    function Window:AddSlider(text, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        local SliderLabel = Instance.new("TextLabel")
        local SliderBar = Instance.new("Frame")
        local SliderFill = Instance.new("Frame")
        local SliderKnob = Instance.new("Frame")
        local UICornerBar = Instance.new("UICorner")
        local UICornerFill = Instance.new("UICorner")
        local value = default or min

        SliderFrame.Parent = Container
        SliderFrame.Size = UDim2.new(1, 0, 0, 50)
        SliderFrame.BackgroundTransparency = 1

        SliderLabel.Parent = SliderFrame
        SliderLabel.Size = UDim2.new(1, 0, 0, 20)
        SliderLabel.Text = text .. ": " .. value
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.TextColor3 = ZundiumConfig.Theme.TextColor
        SliderLabel.Font = Enum.Font.Gotham
        SliderLabel.TextSize = 14

        SliderBar.Parent = SliderFrame
        SliderBar.Size = UDim2.new(1, 0, 0, 8)
        SliderBar.Position = UDim2.new(0, 0, 0, 30)
        SliderBar.BackgroundColor3 = ZundiumConfig.Theme.SliderColor
        UICornerBar.Parent = SliderBar
        UICornerBar.CornerRadius = UDim.new(0, 4)

        SliderFill.Parent = SliderBar
        SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        SliderFill.BackgroundColor3 = ZundiumConfig.Theme.AccentColor
        UICornerFill.Parent = SliderFill
        UICornerFill.CornerRadius = UDim.new(0, 4)

        SliderKnob.Parent = SliderBar
        SliderKnob.Size = UDim2.new(0, 16, 0, 16)
        SliderKnob.BackgroundColor3 = ZundiumConfig.Theme.TextColor
        SliderKnob.BorderSizePixel = 0
        SliderKnob.Position = UDim2.new((value - min) / (max - min), -8, 0, -4)

        local dragging = false
        SliderKnob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)

        SliderKnob.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relativeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * relativeX)
                SliderKnob.Position = UDim2.new(relativeX, -8, 0, -4)
                SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                SliderLabel.Text = text .. ": " .. value
                callback(value)
            end
        end)

        table.insert(self.Elements, SliderFrame)
        return SliderFrame
    end

    -- Função para adicionar label
    function Window:AddLabel(text)
        local Label = Instance.new("TextLabel")
        Label.Parent = Container
        Label.Size = UDim2.new(1, 0, 0, 30)
        Label.Text = text
        Label.BackgroundTransparency = 1
        Label.TextColor3 = ZundiumConfig.Theme.TextColor
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        table.insert(self.Elements, Label)
        return Label
    end

    return Window
end

-- Função para mudar o tema
function Zundium:SetTheme(theme)
    for key, value in pairs(theme) do
        ZundiumConfig.Theme[key] = value
    end
end

return Zundium