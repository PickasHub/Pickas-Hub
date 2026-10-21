local ok, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/pickapicksmm/Pickas-Hub/refs/heads/main/Script/Source/KeysystemLoader.lua"))()
end)

if not ok then
    warn("Failed to load script: " .. tostring(err))
end
