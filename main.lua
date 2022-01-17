print("Avian - Loading...")

local saycmds = true
local prefix = ";"
local autoloadconfig = false
local noclip = false
local chatlogs = false

local config = game:GetService("HttpService"):JSONDecode(readfile('avian_config.json'))
if config.autoloadconfig then
    if config.prefix then
        prefix = config.prefix 
    end
    if config.saycmds then
        saycmds = config.saycmds
    end
    if config.autoloadconfig then
        autoloadconfig = config.autoloadconfig
    end

    print("Loaded config!")
end

local mouse = game.Players.LocalPlayer:GetMouse()
repeat wait() until mouse
local plr = game.Players.LocalPlayer
local flying = false
local deb = true
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}
local maxspeed = 50
local speed = 0

function Fly()
if game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:findFirstChild("Torso") and game.Players.LocalPlayer.Character:findFirstChild("Humanoid") then
local torso = plr.Character.Torso
local bg = Instance.new("BodyGyro", torso)
bg.P = 9e4
bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
bg.cframe = torso.CFrame
local bv = Instance.new("BodyVelocity", torso)
bv.velocity = Vector3.new(0,0.1,0)
bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
repeat wait()
plr.Character.Humanoid.PlatformStand = true
if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
speed = speed+.5+(speed/maxspeed)
if speed > maxspeed then
speed = maxspeed
end
elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
speed = speed-1
if speed < 0 then
speed = 0
end
end
if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
else
bv.velocity = Vector3.new(0,0.1,0)
end
bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
until not flying
ctrl = {f = 0, b = 0, l = 0, r = 0}
lastctrl = {f = 0, b = 0, l = 0, r = 0}
speed = 0
bg:Destroy()
bv:Destroy()
plr.Character.Humanoid.PlatformStand = false
end
mouse.KeyDown:connect(function(key)
if key:lower() == "e" then
if flying then flying = false
else
flying = true
Fly()
end
elseif key:lower() == "w" then
ctrl.f = 1
elseif key:lower() == "s" then
ctrl.b = -1
elseif key:lower() == "a" then
ctrl.l = -1
elseif key:lower() == "d" then
ctrl.r = 1
end
end)
mouse.KeyUp:connect(function(key)
if key:lower() == "w" then
ctrl.f = 0
elseif key:lower() == "s" then
ctrl.b = 0
elseif key:lower() == "a" then
ctrl.l = 0
elseif key:lower() == "d" then
ctrl.r = 0
end
end)
end

function command(str, ...)
    local cmd = str:split(" ")[1]:lower()
    local player = game.Players.LocalPlayer
    local char = player.Character
    
    local args = {}

    for i,v in pairs(str:split(" ")) do
        if i > 1 then
            table.insert(args, v)
        end
    end

    if cmd:sub(1,#prefix) == prefix then
        cmd = cmd:sub(#prefix+1,#cmd)
    else
        return
    end

    if cmd == "print" then
        print(table.concat(args, " "))
    end

    if cmd == "error" then
        error(table.concat(args, " "))
    end
    
    if cmd == "warn" then
        warn(table.concat(args, " "))
    end

    if cmd == "saycmds" then
        saycmds = not saycmds
        print("Saycmds: " .. tostring(saycmds))
    end

    if cmd == "say" then
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(table.concat(args, " "), "All")
    end

    if cmd == "spitfacts" then
        local facts = {
            "avian is cool",
            "hi im " .. game.Players.LocalPlayer.Name,
            "you should probably join gg/amzKaCRH3U",
            "Avian#0002 is a cool guy",
            "hm... "..game.Players:GetPlayers()[math.random(1,#game.Players:GetPlayers())].Name.." is uncool"
        }

        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(facts[math.random(1,#facts)], "All")
    end

    if cmd == "loadstringurl" then
        loadstring(game:HttpGet(args[1]))()
    end

    if cmd == "infiniteyield" then
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end

    if cmd == "walkspeed" then
        char.Humanoid.WalkSpeed = tonumber(args[1])
    elseif cmd == "speed" then
        char.Humanoid.WalkSpeed = tonumber(args[1])
    end

    if cmd == "jumppower" then
        char.Humanoid.JumpPower = tonumber(args[1])
    elseif cmd == "jp" then
        char.Humanoid.JumpPower = tonumber(args[1])
    end

    if cmd == "reset" then
        char.Humanoid.Health = 0
    elseif cmd == "die" then
        char.Humanoid.Health = 0
    end

    if cmd == "view" then
        local plr = findPlayer(args[1])

        if player then
            pcall(function()
                game.Workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid
            end)
        end
    end

    if cmd == "unview" then
        game.Workspace.CurrentCamera.CameraSubject = char.Humanoid
    end

    if cmd == "loadscript" then
        if isfile(args[1]) then
            loadstring(readfile(args[1]))()
        else
            warn("File not found")
        end
    end

    if cmd == "setprefix" then
        prefix = args[1]
    end

    if cmd == "goto" then
        local plr = findPlayer(args[1])

        if plr then
            player.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
        end
    end

    if cmd == "rejoin" then
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end

    if cmd == "shop" then
        local x = {}
    	for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/1/games"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data) do
    		if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
    			x[#x + 1] = v.id
    		end
    	end
    	if #x > 0 then
    		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)])
    	else
    		return notify("Serverhop couldn't find a server.")
    	end
    elseif cmd == "serverhop" then
        local x = {}
    	for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
    		if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
    			x[#x + 1] = v.id
    		end
    	end
    	if #x > 0 then
    		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)])
    	else
    		return notify("Serverhop couldn't find a server.")
    	end
    end

    if cmd == "fly" then
        flying = true
        
        Fly()
    end

    if cmd == "unfly" then
        flying = false
        Fly()
    end

    if cmd == "noclip" then
        noclip = true
    end

    if cmd == "clip" then
        noclip = false
    end

    if cmd == "chatlogs" then
        chatlogs = not chatlogs
    end
    
    if cmd == "joingame" then
        if args[1] and not args[2] then
            game:GetService("TeleportService"):Teleport(tonumber(args[1]))
        else
            game:GetService("TeleportService"):Teleport(tonumber(args[1]),args[2])
        end
    end

    if cmd == "getjobid" then
        setclipboard(game.JobId)
        notify("Job Id copied to clipboard.\n[Avian]: Job ID: "..game.JobId)
    end
    
    if cmd == "prefix" then
        wait(0.1)
        notify("The Current Prefix Is: "..prefix)
    end

    if cmd == "exit" then
        game:shutdown()
    end
    
    if cmd == "saveconfig" then
        writefile("avian_config.json", '{"prefix": "'..prefix..'","saycmds": '..tostring(saycmds)..', "autoloadconfig": '..tostring(autoloadconfig)..'}')
        notify("Saved config! Saved as avian_config.json")
    end
    
    if cmd == "loadconfig" then
        if isfile("avian_config.json") then
            local config = game:GetService("HttpService"):JSONDecode(readfile('avian_config.json'))
            if config.prefix then
                prefix = config.prefix 
            end
            if config.saycmds then
                saycmds = config.saycmds
            end
            if config.autoloadconfig then
                autoloadconfig = config.autoloadconfig
            end
            notify("Config loaded!")
        else
            notify("No config file exists! To create one use "..prefix.."saveconfig")
        end
    end
    
    if cmd == "autoloadconfig" then
        autoloadconfig = not autoloadconfig
        notify("Auto Load Config set to: "..tostring(autoloadconfig))
    end
    
    if cmd == "bypasswalkspeeddetection" then
        bypass("WalkSpeed",16)
    end
    
    if cmd == "bypassjumppowerdetection" then
        bypass("JumpPower",50)
    end
end

function notify(text)
    game.StarterGui:SetCore( "ChatMakeSystemMessage",  { Text = "[Avian]: "..text} )
end

function findPlayer(stringg)
    for _, v in pairs(game.Players:GetPlayers()) do
        if stringg == "me" then
            return game.Players.LocalPlayer
        end
        if stringg == "random" then
            return game.Players:GetPlayers()[math.random(1,#game.Players:GetPlayers())]
        end
        if stringg:lower() == (v.Name:lower()):sub(1, #stringg) then
            return v
        elseif stringg:lower() == (v.DisplayName:lower()):sub(1, #stringg) then
            return v
        end
    end
end

function bypass(index, value)
    local gmt = getrawmetatable(game)
    setreadonly(gmt, false)
    local a

    a = hookfunction(gmt.__index, newcclosure(function(self,a)
        if a == index then
            return value
        end

        return a(self,a)
    end))
end

game.Players.LocalPlayer.Chatted:Connect(function(msg)
    command(msg)
end)

local gmt = getrawmetatable(game)
setreadonly(gmt,false)
local a

a = hookfunction(gmt.__namecall,function(self,...)
    local args = {...}
    if tostring(self) == "SayMessageRequest" then
        if args[1]:sub(1,#prefix) == prefix and not saycmds then
            return
        end
    end

    return a(self,...)
end)

for i,v in pairs(game.Players:GetPlayers()) do
    v.Chatted:Connect(function(msg)
        if chatlogs then
            print("["..v.Name .. "]: " .. msg)
        end
    end)
end

game.Players.PlayerAdded:Connect(function(v)
    v.Chatted:Connect(function(msg)
        if chatlogs then
            print("["..v.Name .. "]: " .. msg)
        end
    end)
end)

local function NoclipLoop()
    if noclip == true and game.Players.LocalPlayer.Character ~= nil then
        for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if child:IsA("BasePart") and child.CanCollide == true then
                child.CanCollide = false
            end
        end
    end
end

Noclipping = game:GetService('RunService').Stepped:Connect(NoclipLoop)

print("Avian - Loaded!")
