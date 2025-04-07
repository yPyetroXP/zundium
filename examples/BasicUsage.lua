local Zundium = require(game.ReplicatedStorage.Zundium) -- Ajuste o caminho

local window = Zundium:CreateWindow("Teste Básico")
window:AddLabel("Bem-vindo à Zundium!")
window:AddButton("Clique Aqui", function()
    print("Botão clicado!")
end)
window:AddToggle("Ativar", false, function(state)
    print("Toggle: " .. (state and "ON" or "OFF"))
end)