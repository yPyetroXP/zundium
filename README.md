# Zundium UI Library
Uma biblioteca de interface para Roblox, criada por yPyetroXP, com foco em exploits e personalização.

## Como Usar
1. Coloque `Zundium.lua` em um `ModuleScript` no Roblox.
2. Use em seus scripts:
```lua
local Zundium = require(game.ReplicatedStorage.Zundium)
local window = Zundium:CreateWindow("Minha UI")
window:AddButton("Teste", function() print("Oi!") end)