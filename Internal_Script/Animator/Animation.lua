wait()
local lastPosition2 = script.Parent.HumanoidRootPart.Position
local root = script.Parent.HumanoidRootPart
local boon = Instance.new("BoolValue")
local Animation_Walk = script.Parent.Humanoid:LoadAnimation(script.Parent.Humanoid.WalkAnim)
local Animation_Run = script.Parent.Humanoid:LoadAnimation(script.Parent.Humanoid.RunAnim)
local Animation_Jumpscare = script.Parent.Humanoid:LoadAnimation(script.Parent.Humanoid.Jumpscare)
local Idle_Animation = script.Parent.Humanoid:LoadAnimation(script.Parent.Humanoid.IdleAnim)
local Humanoid = script.Parent.Humanoid
local oldSpeed = Humanoid.WalkSpeed
local Sacer = false
local atidle = false
wait(0.1)
local xd = script.Parent.Scared
Animation_Walk:Play()
if script.Parent:FindFirstChild('AnimSaves') ~= nil then
	script.Parent.AnimSaves:Destroy()
end

Humanoid.Changed:Connect(function()
	if Humanoid.WalkSpeed ~= oldSpeed then
		boon.Value = true
	else
		boon.Value = false
	end
end)
boon.Changed:Connect(function()
	if Sacer == false then
		if boon.Value == true and atidle == false then
			Animation_Walk:Stop(1)
			Animation_Run:Play(1)
		else
			Animation_Walk:Play(1)
			Animation_Run:Stop(1)
		end
	else
		Animation_Walk:Play(1)
		Animation_Run:Stop(1)
	end
end)

xd.Changed:Connect(function()
	if xd.Value == true then
		Animation_Walk:Stop()
		Animation_Run:Stop()
	elseif xd.Value == false then 
		Animation_Walk:Play()
	end 
end)

script.atIdle.Changed:Connect(function()
	local Index = script.atIdle 
	local Contact = 0.2
	if Index.Value == false then -- WALK
		if Idle_Animation.IsPlaying then 
			Idle_Animation:Stop(Contact)
		end 
		if not Animation_Walk.IsPlaying then 
			Animation_Walk:Play(Contact)
		end 
	elseif Index.Value == true then -- NOT WALK
		if Animation_Walk.IsPlaying then 
			Animation_Walk:Stop(Contact)
		end 
		if not Idle_Animation.IsPlaying then
			Idle_Animation:Play(Contact)
		end 
	end
end)

script.tp.Changed:Connect(function()
	if script.tp.Value == true then 
		script._PathIdle.Enabled = true
		if Animation_Walk.IsPlaying then 
			Animation_Walk:Stop()
		end
		if Animation_Run.IsPlaying then 
			Animation_Run:Stop()
		end
		if Idle_Animation.IsPlaying then 
			Idle_Animation:Stop()
		end
	elseif script.tp.Value == false then 
		script._PathIdle.Enabled = false 
		Animation_Walk:Play(1)
	end
end)