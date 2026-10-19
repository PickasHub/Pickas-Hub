-- Example Usage: https://raw.githubusercontent.com/pickapicksmm/Pickas-Hub/refs/heads/main/Icons/ExampleUsage.lua

local BASE = "https://raw.githubusercontent.com/pickapicksmm/Pickas-Hub/refs/heads/main/Icons/Pickas-Hub"

local IconModule = {
    Version = "2.0.0",
    Name = "PICKA'S HUB IconsModule",
    IconsType = "lucide",
    BaseURL = BASE,
    Icons = {},
    Loaded = {},
    Errors = {},
}

local SOURCES = {
    gravity = "https://raw.githubusercontent.com/pickapicksmm/Pickas-Hub/refs/heads/main/Icons/dist/gravity.lua",
    lucide = "https://raw.githubusercontent.com/pickapicksmm/Pickas-Hub/refs/heads/main/Icons/dist/lucide.lua",
    sfsymbols = "https://raw.githubusercontent.com/pickapicksmm/Pickas-Hub/refs/heads/main/Icons/dist/sfsymbols.lua",
    solar = "https://raw.githubusercontent.com/pickapicksmm/Pickas-Hub/refs/heads/main/Icons/dist/solar.lua",
}

local function NormalizeName(name)
    if type(name) ~= "string" then
        return nil
    end

    name = name:gsub("([a-z0-9])([A-Z])", "%1-%2")
    name = name:lower()
    name = name:gsub("[%s_]+", "-")
    name = name:gsub("%-+", "-")
    name = name:gsub("^%-", "")
    name = name:gsub("%-$", "")

    return name
end

local function GetLocalModule(libraryName)
    if not script or not script.Parent then
        return nil
    end

    local moduleScript = script.Parent:FindFirstChild(libraryName)

    if not moduleScript then
        return nil
    end

    if not moduleScript:IsA("ModuleScript") then
        return nil
    end

    local success, result = pcall(require, moduleScript)

    if success and type(result) == "table" then
        return result
    end

    return nil
end

local function LoadRemoteLibrary(url)
    if type(loadstring) ~= "function" then
        return nil, "loadstring is unavailable"
    end

    if not game or type(game.HttpGet) ~= "function" then
        return nil, "HTTP loading is unavailable"
    end

    local success, source = pcall(function()
        return game:HttpGet(url)
    end)

    if not success or type(source) ~= "string" then
        return nil, "Failed to download icon source"
    end

    if source == "" then
        return nil, "Downloaded source is empty"
    end

    local compileSuccess, compiled = pcall(loadstring, source)

    if not compileSuccess or type(compiled) ~= "function" then
        return nil, "Failed to compile icon source"
    end

    local executeSuccess, result = pcall(compiled)

    if not executeSuccess then
        return nil, "Failed to execute icon source"
    end

    if type(result) ~= "table" then
        return nil, "Icon source did not return a table"
    end

    return result
end

local function LoadLibrary(libraryName, url)
    libraryName = NormalizeName(libraryName)

    if not libraryName or not SOURCES[libraryName] then
        return nil, "Unknown icon library"
    end

    if IconModule.Loaded[libraryName] then
        return IconModule.Icons[libraryName]
    end

    local icons, remoteError = LoadRemoteLibrary(url)

    if type(icons) ~= "table" then
        icons = GetLocalModule(libraryName)
    end

    if type(icons) ~= "table" then
        IconModule.Errors[libraryName] =
            remoteError or "Remote and local loading failed"

        return nil, IconModule.Errors[libraryName]
    end

    IconModule.Icons[libraryName] = icons
    IconModule.Loaded[libraryName] = true
    IconModule.Errors[libraryName] = nil

    return icons
end

function IconModule.Load(libraryName)
    libraryName = NormalizeName(libraryName)

    local url = SOURCES[libraryName]

    if not url then
        return nil, "Unknown icon library: " .. tostring(libraryName)
    end

    return LoadLibrary(libraryName, url)
end

function IconModule.LoadAll()
    local results = {}

    for libraryName, url in pairs(SOURCES) do
        local icons, err = LoadLibrary(libraryName, url)

        results[libraryName] = {
            Success = type(icons) == "table",
            Count = type(icons) == "table" and #icons or 0,
            Error = err,
        }

        if type(icons) == "table" then
            local count = 0

            for _ in pairs(icons) do
                count += 1
            end

            results[libraryName].Count = count
        end
    end

    return results
end

function IconModule.GetIcon(iconName, libraryName)
    libraryName = NormalizeName(libraryName or IconModule.IconsType)
    iconName = NormalizeName(iconName)

    if not iconName then
        return nil
    end

    local icons = IconModule.Icons[libraryName]

    if type(icons) ~= "table" then
        icons = IconModule.Load(libraryName)
    end

    if type(icons) ~= "table" then
        return nil
    end

    local directValue = icons[iconName]

    if type(directValue) == "string" then
        return directValue
    end

    for key, value in pairs(icons) do
        if NormalizeName(key) == iconName then
            if type(value) == "string" then
                return value
            end

            if type(value) == "table" then
                return value.Image
                    or value.image
                    or value.Icon
                    or value.icon
                    or value.Asset
                    or value.asset
            end
        end
    end

    return nil
end

function IconModule.GetIcons(iconNames, libraryName)
    if type(iconNames) ~= "table" then
        return {}
    end

    local results = {}

    for _, iconName in ipairs(iconNames) do
        results[iconName] = IconModule.GetIcon(
            iconName,
            libraryName
        )
    end

    return results
end

function IconModule.GetLibrary(libraryName)
    libraryName = NormalizeName(libraryName or IconModule.IconsType)

    if not IconModule.Icons[libraryName] then
        IconModule.Load(libraryName)
    end

    return IconModule.Icons[libraryName]
end

function IconModule.SetDefault(libraryName)
    libraryName = NormalizeName(libraryName)

    if not SOURCES[libraryName] then
        return false
    end

    IconModule.IconsType = libraryName
    return true
end

function IconModule.IsLoaded(libraryName)
    libraryName = NormalizeName(libraryName)
    return IconModule.Loaded[libraryName] == true
end

function IconModule.GetStatus()
    local status = {}

    for libraryName in pairs(SOURCES) do
        local icons = IconModule.Icons[libraryName]
        local count = 0

        if type(icons) == "table" then
            for _ in pairs(icons) do
                count += 1
            end
        end

        status[libraryName] = {
            Loaded = IconModule.Loaded[libraryName] == true,
            Count = count,
            Error = IconModule.Errors[libraryName],
        }
    end

    return status
end

local GetIcons = {}

local function CreateLibraryGetter(libraryName)
    return function(first, ...)
        local names

        if first == GetIcons then
            names = {...}
        else
            names = {first, ...}
        end

        local library = IconModule.GetLibrary(libraryName)

        if not library then
            return {}
        end

        if #names == 0 or names[1] == nil then
            return library
        end

        local results = {}

        for _, iconName in ipairs(names) do
            if type(iconName) == "string" then
                results[iconName] = IconModule.GetIcon(
                    iconName,
                    libraryName
                )
            end
        end

        return results
    end
end

GetIcons.Gravity = CreateLibraryGetter("gravity")
GetIcons.Lucide = CreateLibraryGetter("lucide")
GetIcons.SFSymbols = CreateLibraryGetter("sfsymbols")
GetIcons.Solar = CreateLibraryGetter("solar")

GetIcons.SfSymbols = GetIcons.SFSymbols
GetIcons.SF = GetIcons.SFSymbols

function GetIcons.GetIcon(first, second, third)
    local iconName
    local libraryName

    if first == GetIcons then
        libraryName = second
        iconName = third
    else
        iconName = first
        libraryName = second
    end

    return IconModule.GetIcon(iconName, libraryName)
end

function GetIcons.GetLibrary(first, second)
    local libraryName

    if first == GetIcons then
        libraryName = second
    else
        libraryName = first
    end

    return IconModule.GetLibrary(libraryName)
end

function GetIcons.Load(first, second)
    local libraryName

    if first == GetIcons then
        libraryName = second
    else
        libraryName = first
    end

    return IconModule.Load(libraryName)
end

function GetIcons.SetDefault(first, second)
    local libraryName

    if first == GetIcons then
        libraryName = second
    else
        libraryName = first
    end

    return IconModule.SetDefault(libraryName)
end

function GetIcons.GetStatus()
    return IconModule.GetStatus()
end

IconModule.GetIcons = GetIcons
IconModule.API = GetIcons

return IconModule
