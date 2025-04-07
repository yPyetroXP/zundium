-- Zundium UI Library
-- Criado por yPyetroXP com assistência de Grok @ xAI
-- Inspirado na Fluent UI Library: transparente e minimalista
local Zundium = {}
local TweenService = game:GetService("TweenService")

-- Configurações globais
local ZundiumConfig = {
    Theme = {
        PrimaryColor = Color3.fromRGB(20, 20, 25),
        AccentColor = Color3.fromRGB(0, 200, 255),
        SecondaryColor = Color3.fromRGB(35, 35, 40),
        TextColor = Color3.fromRGB(220, 220, 220),
        ToggleOnColor = Color3.fromRGB(0, 255, 120),
        ToggleOffColor = Color3.fromRGB(50, 50, 55),
        SliderColor = Color3.fromRGB(80, 80, 85)
    },
    Version = "1.3 by yPyetroXP",
    AnimationSpeed = 0.25
} -- <--- Faltava este "}"

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

    ScreenGui.Name = "ZundiumUI_" .. tostring(math.random(1000sha9999))
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 300, 0, 0) -- Tamanho menor e inicial fechado
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = ZundiumConfig.Theme.PrimaryColor
    MainFrame.BackgroundTransparency = ZundiumConfig.Theme.Transparency
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true

    UICorner.Parent = MainFrame
    UICorner.CornerRadius = UDim.new(0, 10) -- Bordas suavemente arredondadas

    TitleBar.Parent = MainFrame
    TitleBar.Size = UDim2.new(1, 0, 0, 25)
    TitleBar.BackgroundColor3 = ZundiumConfig.Theme.AccentColor
    TitleBar.BackgroundTransparency = 0.8 -- Barra de título mais transparente
    TitleBar.BorderSizePixel = 0

    TitleLabel.Parent = TitleBar
    TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    TitleLabel.Position = UDim2.new(0, 5, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = ZundiumConfig.Theme.TextColor
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.SourceSansSemibold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    MinimizeButton.Parent = TitleBar
    MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    MinimizeButton.Position = UDim2.new(1, -50, 0, 0)
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = ZundiumConfig.Theme.TextColor
    MinimizeButton.TextSize = 16
    MinimizeButton.Font = Enum.Font.SourceSansBold

    HideButton.Parent = TitleBar
    HideButton.Size = UDim2.new(0, 25, 0, 25)
    HideButton.Position = UDim2.new(1, -25, 0, 0)
    HideButton.BackgroundTransparency = 1
    HideButton.Text = "×"
    HideButton.TextColor3 = ZundiumConfig.Theme.TextColor
    HideButton.TextSize = 16
    HideButton.Font = Enum.Font.SourceSansBold

    Container.Parent = MainFrame
    Container.Size = UDim2.new(1, 0, 1, -30)
    Container.Position = UDim2.new(0, 0, 0, 30)
    Container.BackgroundTransparency = 1

    UIListLayout.Parent = Container
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    UIPadding.Parent = Container
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)
    UIPadding.PaddingTop = UDim.new(0, 5)

    -- Animação de abertura
    local openTween = TweenService:Create(MainFrame, TweenInfo.new(ZundiumConfig.AnimationSpeed, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, 350)})
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
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        elseif input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    -- Sistema de minimizar
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        local targetSize = minimized and UDim2.new(0, 300, 0, 25) or UDim2.new(0, 300, 0, 350)
        local tween = TweenService:Create(MainFrame, TweenInfo.new(ZundiumConfig.AnimationSpeed, Enum.EasingStyle.Sine), {Size = targetSize})
        tween:Play()
        Container.Visible = not minimized
        MinimizeButton.Text = minimized and "+" or "−"
    end)

    -- Sistema de esconder
    HideButton.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(ZundiumConfig.AnimationSpeed, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 300, 0, 0)})
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
        Button.Size = UDim2.new(1, 0, 0, 30)
        Button.BackgroundColor3 = ZundiumConfig.Theme.AccentColor
        Button.BackgroundTransparency = 0.85
        Button.Text = text
        Button.TextColor3 = ZundiumConfig.Theme.TextColor
        Button.Font = Enum.Font.SourceSans
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
        Toggle.Size = UDim2.new(1, 0, 0, 30)
        Toggle.BackgroundColor3 = state and ZundiumConfig.Theme.ToggleOnColor or ZundiumConfig.Theme.ToggleOffColor
        Toggle.BackgroundTransparency = 0.85
        Toggle.Text = text .. (state and " [ON]" or " [OFF]")
        Toggle.TextColor3 = ZundiumConfig.Theme.TextColor
        Toggle.Font = Enum.Font.SourceSans
        Toggle.TextSize = 14
        UICorner.Parent = Toggle
        UICorner.CornerRadius = UDim.new(0, 6)
        Toggle.MouseButton1Click:Connect(function()
            state = not state
            Toggle.Text = text .. (state and " [ON]" or " [OFF]")
            local targetColor = state and ZundiumConfig.Theme.ToggleOnColor or ZundiumConfig.Theme.ToggleOffColor
            TweenService:Create(Toggle, TweenInfo.new(ZundiumConfig.AnimationSpeed, Enum.EasingStyle.Sine), {BackgroundColor3 = targetColor}):Play()
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
        TextBox.Size = UDim2.new(1, 0, 0, 30)
        TextBox.BackgroundColor3 = ZundiumConfig.Theme.PrimaryColor
        TextBox.BackgroundTransparency = 0.85
        TextBox.PlaceholderText = placeholder
        TextBox.Text = ""
        TextBox.TextColor3 = ZundiumConfig.Theme.TextColor
        TextBox.Font = Enum.Font.SourceSans
        TextBox.TextSize = 14
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
        Dropdown.Size = UDim2.new(1, 0, 0, 30)
        Dropdown.BackgroundColor3 = ZundiumConfig.Theme.AccentColor
        Dropdown.BackgroundTransparency = 0.85
        Dropdown.Text = "Select an option"
        Dropdown.TextColor3 = ZundiumConfig.Theme.TextColor
        Dropdown.Font = Enum.Font.SourceSans
        Dropdown.TextSize = 14
        UICorner.Parent = Dropdown
        UICorner.CornerRadius = UDim.new(0, 6)

        DropFrame.Parent = Container
        DropFrame.Size = UDim2.new(1, 0, 0, 0)
        DropFrame.Position = UDim2.new(0, 0, 0, 35)
        DropFrame.BackgroundColor3 = ZundiumConfig.Theme.PrimaryColor
        DropFrame.BackgroundTransparency = 0.85
        DropFrame.ClipsDescendants = true
        DropFrame.Visible = false
        DropUICorner.Parent = DropFrame
        DropUICorner.CornerRadius = UDim.new(0, 6)

        DropList.Parent = DropFrame
        DropList.SortOrder = Enum.SortOrder.LayoutOrder
        DropList.Padding = UDim.new(0, 2)

        local function updateDropdown()
            local targetSize = isOpen and UDim2.new(1, 0, 0, #options * 32) or UDim2.new(1, 0, 0, 0)
            local tween = TweenService:Create(DropFrame, TweenInfo.new(ZundiumConfig.AnimationSpeed, Enum.EasingStyle.Sine), {Size = targetSize})
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
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.BackgroundColor3 = ZundiumConfig.Theme.AccentColor
            OptionButton.BackgroundTransparency = 0.85
            OptionButton.Text = option
            OptionButton.TextColor3 = ZundiumConfig.Theme.TextColor
            OptionButton.Font = Enum.Font.SourceSans
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
        SliderFrame.Size = UDim2.new(1, 0, 0, 40)
        SliderFrame.BackgroundTransparency = 1

        SliderLabel.Parent = SliderFrame
        SliderLabel.Size = UDim2.new(1, 0, 0, 15)
        SliderLabel.Text = text .. ": " .. value
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.TextColor3 = ZundiumConfig.Theme.TextColor
        SliderLabel.Font = Enum.Font.SourceSans
        SliderLabel.TextSize = 12

        SliderBar.Parent = SliderFrame
        SliderBar.Size = UDim2.new(1, 0, 0, 4)
        SliderBar.Position = UDim2.new(0, 0, 0, 20)
        SliderBar.BackgroundColor3 = ZundiumConfig.Theme.SliderColor
        SliderBar.BackgroundTransparency = 0.7
        UICornerBar.Parent = SliderBar
        UICornerBar.CornerRadius = UDim.new(0, 2)

        SliderFill.Parent = SliderBar
        SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        SliderFill.BackgroundColor3 = ZundiumConfig.Theme.AccentColor
        SliderFill.BackgroundTransparency = 0.5
        UICornerFill.Parent = SliderFill
        UICornerFill.CornerRadius = UDim.new(0, 2)

        SliderKnob.Parent = SliderBar
        SliderKnob.Size = UDim2.new(0, 10, 0, 10)
        SliderKnob.BackgroundColor3 = ZundiumConfig.Theme.TextColor
        SliderKnob.BackgroundTransparency = 0.2
        SliderKnob.Position = UDim2.new((value - min) / (max - min), -5, 0, -3)

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
                SliderKnob.Position = UDim2.new(relativeX, -5, 0, -3)
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
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.Text = text
        Label.BackgroundTransparency = 1
        Label.TextColor3 = ZundiumConfig.Theme.TextColor
        Label.Font = Enum.Font.SourceSans
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