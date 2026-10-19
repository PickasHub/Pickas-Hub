local IconsModule = require(path.to.IconsModule)
local GetIcons = IconsModule.GetIcons

local gravityIcons = GetIcons.Gravity("settings", "home")
local lucideIcons = GetIcons:Lucide("settings", "home")
local solarIcons = GetIcons.Solar("settings", "home")
local sfIcons = GetIcons:SFSymbols("house", "gear")

print(gravityIcons.settings)
print(lucideIcons.home)
print(solarIcons.settings)
print(sfIcons.house)

local singleIcon = GetIcons.GetIcon("settings", "lucide")
print(singleIcon)

local allLucideIcons = GetIcons.Lucide()
print(allLucideIcons.settings)
