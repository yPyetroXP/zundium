-- Zundium UI Library
-- Criado por yPyetroXP com assistência de Grok @ xAI
-- Desenvolvido para suportar exploits no Roblox
local Zundium = {}
local TweenService = game:GetService("TweenService")

-- Configurações globais
local ZundiumConfig = {
    Theme = {
        PrimaryColor = Color3.fromRGB(50, 50, 50),
        AccentColor = Color3.fromRGB(0, 170, 255),
        TextColor = Color3.fromRGB(255, 255, 255),
        ToggleOnColor = Color3.fromRGB(0, 255, 100),
        ToggleOffColor = Color3.fromRGB(80, 80, 80),
        SliderColor = Color3.fromRGB(100, 100, 100)
    },
    Version = "1.2 by yPyetroXP",
    AnimationSpeed = 0.3 -- Velocidade das animações em segundos
}

-- Função principal para criar uma janela
function Zundium:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TitleBar = Instance.new("TextLabel")
    local Container = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local MinimizeButton = Instance.new("TextButton")
    local HideButton = Instance.new("TextButton")

    -- Configuração básica da janela
    ScreenGui.Name = "ZundiumUI_" .. tostring(math.random(1000, 9999))
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 350, 0, 0) -- Começa fechado para animação
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
    MainFrame.BackgroundColor3 = ZundiumConfig.Theme.PrimaryColor
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true

    TitleBar.Parent = MainFrame
    TitleBar.Size = UDim2.new(1, -60, 0, 30) -- Ajustado para dois botões
    TitleBar.BackgroundColor3 = ZundiumConfig.Theme.AccentColor
    TitleBar.Text = "Zundium - " .. title .. " | " .. ZundiumConfig.Version
    TitleBar.TextColor3 = ZundiumConfig.Theme.TextColor
    TitleBar.TextSize = 16
    TitleBar.Font = Enum.Font.SourceSansBold

    MinimizeButton.Parent = MainFrame
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
    MinimizeButton.BackgroundColor3 = ZundiumConfig.Theme.AccentColor
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = ZundiumConfig.Theme.TextColor
    MinimizeButton.TextSize = 16

    HideButton.Parent = MainFrame
    HideButton.Size = UDim2.new(0, 30, 0, 30)
    HideButton.Position = UDim2.new(1, -30, 0, 0)
    HideButton.BackgroundColor3 = ZundiumConfig.Theme.AccentColor
    HideButton.Text = "X"
    HideButton.TextColor3 = ZundiumConfig.Theme.TextColor
    HideButton.TextSize = 16

    Container.Parent = MainFrame
    Container.Size = UDim2.new(1, -10, 1, -40)
    Container.Position = UDim2.new(0, 5, 0, 35)
    Container.BackgroundTransparency = 1

    UIListLayout.Parent = Container
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Animação de abertura
    local openTween = TweenService:Create(MainFrame, TweenInfo.new(ZundiumConfig.AnimationSpeed, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 350, 0, 400)})
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

    -- Sistema de minimizar com animação
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        local targetSize = minimized and UDim2.new(0, 350, 0, 30) or UDim2.new(0, 350, 0, 400)
        local tween = TweenService:Create(MainFrame, TweenInfo.new(ZundiumConfig.AnimationSpeed, Enum.EasingStyle.Quad), {Size = targetSize})
        tween:Play()
        Container.Visible = not minimized
        MinimizeButton.Text = minimized and "+" or "-"
    end)

    -- Sistema de esconder com animação
    HideButton.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(ZundiumConfig.AnimationSpeed, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 350, 0, 0)})
        closeTween:Play()
        closeTween.Completed:Connect(function()
            ScreenGui:Destroy() -- Remove a UI completamente após a animação
        end)
    end)

    -- Objeto da janela
    local Window = { Elements = {} }

    -- Função para adicionar botão
    function Window:AddButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Parent = Container
        Button.Size = UDim2.new(1, -10, 0, 30)
        Button.Text = text
        Button.BackgroundColor3 = ZundiumConfig.Theme.AccentColor
        Button.TextColor3 = ZundiumConfig.Theme.TextColor
        Button.Font = Enum.Font.SourceSans
        Button.TextSize = 14
        Button.MouseButton1Click:Connect(callback)
        table.insert(self.Elements, Button)
        return Button
    end

    -- Função para adicionar toggle
    function Window:AddToggle(text, default, callback)
        local Toggle = Instance.new("TextButton")
        local state = default or false

        Toggle.Parent = Container
        Toggle.Size = UDim2.new(1, -10, 0, 30)
        Toggle.Text = text .. (state and " [ON]" or " [OFF]")
        Toggle.BackgroundColor3 = state and ZundiumConfig.Theme.ToggleOnColor or ZundiumConfig.Theme.ToggleOffColor
        Toggle.TextColor3 = ZundiumConfig.Theme.TextColor
        Toggle.Font = Enum.Font.SourceSans
        Toggle.TextSize = 14

        Toggle.MouseButton1Click:Connect(function()
            state = not state
            Toggle.Text = text .. (state and " [ON]" or " [OFF]")
            local targetColor = state and ZundiumConfig.Theme.ToggleOnColor or ZundiumConfig.Theme.ToggleOffColor
            local tween = TweenService:Create(Toggle, TweenInfo.new(ZundiumConfig.AnimationSpeed / 2), {BackgroundColor3 = targetColor})
            tween:Play()
            callback(state)
        end)

        table.insert(self.Elements, Toggle)
        return Toggle
    end

    -- Função para adicionar textbox
    function Window:AddTextbox(placeholder, callback)
        local TextBox = Instance.new("TextBox")
        TextBox.Parent = Container
        TextBox.Size = UDim2.new(1, -10, 0, 30)
        TextBox.PlaceholderText = placeholder
        TextBox.Text = ""
        TextBox.BackgroundColor3 = ZundiumConfig.Theme.PrimaryColor
        TextBox.TextColor3 = ZundiumConfig.Theme.TextColor
        TextBox.Font = Enum.Font.SourceSans
        TextBox.TextSize = 14
        TextBox.ClearTextOnFocus = false

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
        local DropFrame = Instance.new("Frame")
        local DropList = Instance.new("UIListLayout")
        local isOpen = false

        Dropdown.Parent = Container
        Dropdown.Size = UDim2.new(1, -10, 0, 30)
        Dropdown.Text = "Selecione uma opção"
        Dropdown.BackgroundColor3 = ZundiumConfig.Theme.AccentColor
        Dropdown.TextColor3 = ZundiumConfig.Theme.TextColor
        Dropdown.Font = Enum.Font.SourceSans
        Dropdown.TextSize = 14

        DropFrame.Parent = Container
        DropFrame.Size = UDim2.new(1, -10, 0, 0)
        DropFrame.Position = UDim2.new(0, 0, 0, 35)
        DropFrame.BackgroundColor3 = ZundiumConfig.Theme.PrimaryColor
        DropFrame.ClipsDescendants = true
        DropFrame.Visible = false

        DropList.Parent = DropFrame
        DropList.SortOrder = Enum.SortOrder.LayoutOrder

        local function updateDropdown()
            local targetSize = isOpen and UDim2.new(1, -10, 0, #options * 30) or UDim2.new(1, -10, 0, 0)
            local tween = TweenService:Create(DropFrame, TweenInfo.new(ZundiumConfig.AnimationSpeed, Enum.EasingStyle.Quad), {Size = targetSize})
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
            OptionButton.Parent = DropFrame
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.Text = option
            OptionButton.BackgroundColor3 = ZundiumConfig.Theme.AccentColor
            OptionButton.TextColor3 = ZundiumConfig.Theme.TextColor
            OptionButton.Font = Enum.Font.SourceSans
            OptionButton.TextSize = 14

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
        local SliderKnob = Instance.new("Frame")
        local value = default or min

        SliderFrame.Parent = Container
        SliderFrame.Size = UDim2.new(1, -10, 0, 40)
        SliderFrame.BackgroundTransparency = 1

        SliderLabel.Parent = SliderFrame
        SliderLabel.Size = UDim2.new(1, 0, 0, 20)
        SliderLabel.Text = text .. ": " .. value
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.TextColor3 = ZundiumConfig.Theme.TextColor
        SliderLabel.Font = Enum.Font.SourceSans
        SliderLabel.TextSize = 14

        SliderBar.Parent = SliderFrame
        SliderBar.Size = UDim2.new(1, 0, 0, 10)
        SliderBar.Position = UDim2.new(0, 0, 0, 25)
        SliderBar.BackgroundColor3 = ZundiumConfig.Theme.SliderColor
        SliderBar.BorderSizePixel = 0

        SliderKnob.Parent = SliderBar
        SliderKnob.Size = UDim2.new(0, 10, 0, 10)
        SliderKnob.BackgroundColor3 = ZundiumConfig.Theme.AccentColor
        SliderKnob.BorderSizePixel = 0
        SliderKnob.Position = UDim2.new((value - min) / (max - min), 0, 0, 0)

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
                SliderKnob.Position = UDim2.new(relativeX, 0, 0, 0)
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
        Label.Size = UDim2.new(1, -10, 0, 30)
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