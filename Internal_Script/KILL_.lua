-- cat sus and ph helped --

local ME = script.Parent
local humanoid = ME.Humanoid
local Time = script.Parent.Configurations.Hitbox.JumpscareTime.Value
local Distance = script.Parent.Configurations.Hitbox.HitboxSize.Value

local function getHumPos()
	return (ME.Configurations.Hitbox.HitboxPart.Value.Position)
end

local function attack(target, teddyPart)
	local distance = (teddyPart.Position - getHumPos()).Magnitude
	if distance < Distance and game.Players:GetPlayerFromCharacter(target) then
		target.Humanoid.Health = 0
		local plr = game.Players:GetPlayerFromCharacter(target)
		game:GetService("ReplicatedStorage").AIJumpscare:FireClient(plr,ME,Time)
		script.Parent.AntiStuck.Enabled = false
		wait(Time)
		wait(0.1)
		script.Parent.AntiStuck.Enabled = true
	end
end

local function detection(part, teddyPart)
	if part.Parent:FindFirstChild("Humanoid") then
		local character = part.Parent
		if game.Players:GetPlayerFromCharacter(character) then
			if character.Humanoid.Health > 0 and character ~= ME then
				attack(character, teddyPart)
			end
		end
	end
end

for i,v in pairs(script.Parent:GetDescendants()) do
	if v:IsA("BasePart") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
		if not string.find(v.Name, "cloth") then
			v.Touched:Connect(function(hit)
				detection(hit, v)
			end)
		end
	end
end