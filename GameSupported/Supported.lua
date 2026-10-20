local allowedGames = {
    [1234567890] = true,  -- GameId (universe)
    [9876543210] = true,
}

if not allowedGames[game.GameId] then
    warn("Game not supported")
    return
end

print("Game supported!")
