local AI  = script.Parent
local hipHeight = AI.Humanoid.HipHeight
local TP = Instance.new("BindableEvent")
local Safe_Zone_ = workspace.AI.Modules.Safe_Zone:GetChildren()
local PathfindingService = game:GetService("PathfindingService")
local TargetedEvent = game:GetService("ReplicatedStorage"):WaitForChild("AITarget")
local _Path = require(game:GetService("ServerScriptService"):WaitForChild("PathModule"):WaitForChild("_Path"))
local Runing = false -- if he is running or not (do not change that)
local Sacer = false -- old jumpscare system
local Foot = false
local root = AI.HumanoidRootPart

local SETTINGS = {
	Max_distance_Chase = script.Parent.Configurations.Vision.MaxChaseDis.Value;
	Max_distance_Listens_To_Foot_Sounds = script.Parent.Configurations.Vision.HearMaxDis.Value;
	See_Path = script.Parent.Configurations.SeePath.Value;
	Sound_Chase = nil;
}

local Speed = {
	Speed_Walk = 13;
	Speed_Run = 25;
}
if SETTINGS.Sound_Chase ~= nil then
	SETTINGS.Sound_Chase.Playing = false
end
AI.Humanoid.WalkSpeed = Speed.Speed_Walk
local pathParams = {
	["AgentHeight"] = AI.Humanoid.HipHeight,
	["AgentRadius"] = script.Parent.HumanoidRootPart.Size.X,
	["AgentCanJump"] = false
	
}

laughon = false
if script.Parent.Configurations.ChaseLaugh.ChaseLaugh.Value == true then
	laughon = true
	chaselaugh = script.Parent.Configurations.ChaseLaugh.LaughLocation.Value
else
	laughon = false
end
local function getHumPos()
	return (AI.HumanoidRootPart.Position - Vector3.new(1,hipHeight,2))
end
local function FindPotentialPlayer()
	local players = game.Players:GetPlayers()
	local maxDistance = script.Parent.Configurations.Vision.VisionMaxDis.Value
	local nearestTarget

	for index, player in pairs(players) do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			if player.Character.Humanoid.Health > 0 then
				local target = player.Character
				local distance = (AI.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude

				if distance < maxDistance then
					nearestTarget = player
					maxDistance = distance
				end
			end
		end
	end

	return nearestTarget
end

local function displayPath(waypoints)
	local color = BrickColor.Random()
	for index, waypoint in pairs(waypoints) do
		local part = Instance.new("Part")
		part.BrickColor = color
		part.Anchored = true
		part.CanCollide = false
		part.Size = Vector3.new(2,2,2)
		part.Position = waypoint.Position
		part.Parent = workspace
		local Debris = game:GetService("Debris")
		Debris:AddItem(part, 1)
		part.Material = Enum.Material.Neon
		part.Shape = Enum.PartType.Ball
	end
end


local function See_Players(target)
	if target and target:FindFirstChild("HumanoidRootPart") then
		local origin = AI.HumanoidRootPart.Position
		local direction = (target.HumanoidRootPart.Position - AI.HumanoidRootPart.Position).unit * 100000
		local ray = Ray.new(origin, direction)
		local ignoreList = {AI}
		script.Parent.HumanoidRootPart:SetNetworkOwner(nil)
		local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)

		-- check if it exists
		if hit then
			-- check if it hit
			if hit:IsDescendantOf(target) then
				-- check health
				if target.Humanoid.Health > 0 then
					-- check if target is _Z or not

					if  target.Safe.Value == false then
						-- check if monster can see
						local unit = (target.HumanoidRootPart.Position - getHumPos()).Unit
						local lv = AI.HumanoidRootPart.CFrame.LookVector
						local dp = unit:Dot(lv)
	
						if dp > 0 then
							return true
						end		
					end			
				end
			end
		else
			return false
		end	
	end
end

local function Move_To_Block()
	if Runing == false then
		local Player = FindPotentialPlayer()
		if Foot == false then
			if Sacer == false then
				if Player ~= nil then
					if script.Parent.Configurations.LoopPointsFolder.Value ~= nil then
						local goal = script.Parent.Configurations.LoopPointsFolder.Value:GetChildren()[Random.new():NextInteger(1,#script.Parent.Configurations.LoopPointsFolder.Value:GetChildren())]
						local Part_LoopPoints = PathfindingService:CreatePath()
						Part_LoopPoints:ComputeAsync(AI.HumanoidRootPart.Position,goal.Position)
						if SETTINGS.See_Path == true then
							displayPath(Part_LoopPoints:GetWaypoints())
						end
						for i,LoopPoints in ipairs(Part_LoopPoints:GetWaypoints()) do
							if Player then
								if See_Players(Player.Character) then
									break
								end
							end
							if Player.Character:FindFirstChild("Humanoid").MoveDirection.Magnitude > 0 then
								if  Player.Character.Safe.Value == false then
									if (Player.Character.HumanoidRootPart.Position - AI.HumanoidRootPart.Position).Magnitude < SETTINGS.Max_distance_Listens_To_Foot_Sounds then
										if Player.Character.Sound_.Value == 3 or Player.Character.Sound_.Value > 3 then
											local Foot_Fineing = PathfindingService:CreatePath()
											Foot_Fineing:ComputeAsync(AI.HumanoidRootPart.Position , Player.Character.HumanoidRootPart.Position)
											for i,v in ipairs(Foot_Fineing:GetWaypoints()) do
												if FindPotentialPlayer() and See_Players(FindPotentialPlayer().Character) and FindPotentialPlayer().Character.Humanoid.Health > 0 and Sacer == false then
													Foot = true
													break 
												else
													AI.Humanoid:MoveTo(v.Position)
													AI.Humanoid.MoveToFinished:Wait()
												end
											end
										end
									end
								end
							end
							if Foot == true then
								break
							end
							if Player and See_Players(Player.Character) and Player.Character.Humanoid.Health > 0 and Sacer == false then
								break 
							end
							if Player then
								if See_Players(Player.Character) then
									break
								end
							end
							if SETTINGS.Sound_Chase ~= nil then
								SETTINGS.Sound_Chase.Playing = false
							end
							AI.Humanoid:MoveTo(LoopPoints.Position)
							AI.Humanoid.MoveToFinished:Wait()
						end
					else
						error("AI Error Not LoopPoints in workspace")
					end
				end
			else

				print("Not Character Players")
			end
		end
	end
end
TP.Event:Connect(function()
	Runing = false
end)
--local Kill_Box = script.Parent.PrimaryPart
--Kill_Box.Touched:Connect(function(hit)
--	if game.Players:FindFirstChild(hit.Parent.Name) ~= nil then
--		if hit.Parent:FindFirstChild("Humanoid").Health ~= 0 then
--			Sacer = true
--			local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
--			script.Parent.Sacer:Fire(SETTINGS.Jump_Sacer_Time)
--			game:GetService("ReplicatedStorage"):WaitForChild("Sacer"):FireClient(plr,AI,SETTINGS.Jump_Sacer_Time)
--			hit.Parent:FindFirstChild("Humanoid").Health = 0
--			wait(SETTINGS.Jump_Sacer_Time)
--			Sacer = false
--		end
--	end
--end)
for i,Safe_Zone in pairs(Safe_Zone_) do
	Safe_Zone.Touched:Connect(function(hit)
		if game.Players:FindFirstChild(hit.Parent.Name) ~= nil then
			hit.Parent.Safe.Value = true
		end
	end)

	Safe_Zone.TouchEnded:Connect(function(hit)
		if game.Players:FindFirstChild(hit.Parent.Name) ~= nil then
			hit.Parent.Safe.Value = false
		end
	end)
end

local function Chase_Player(Path)
	Runing = true
	local Player_For_Chase = FindPotentialPlayer()
	local hrp:BasePart = Player_For_Chase.Character.HumanoidRootPart
	Path:Run(hrp.Position + (hrp.AssemblyLinearVelocity/3))
	TargetedEvent:FireClient(Player_For_Chase,true)
	if Player_For_Chase.Character.Safe.Value == true then
		Path:Stop()
		wait(0.07)
		local path_ = PathfindingService:CreatePath()
		path_:ComputeAsync(AI.HumanoidRootPart.Position, Player_For_Chase.Character.HumanoidRootPart.Position)
		for i,Path_Walk in ipairs(path_:GetWaypoints()) do
			AI.Humanoid:MoveTo(Path_Walk.Position)

			if Player_For_Chase.Character.Safe.Value == false then
				break
			end
			AI.Humanoid.MoveToFinished:Wait()
		end
		if Player_For_Chase.Character.Safe.Value == false then
			return;
		end
		TargetedEvent:FireClient(Player_For_Chase,false)
		Runing = false
	end
	if Player_For_Chase.Character.Humanoid.Health == 0 then
		Runing = false

	end
end

while true do
	local Player = FindPotentialPlayer()
	if Player and See_Players(Player.Character) and Player.Character.Humanoid.Health > 0 and Sacer == false or Foot == true then
		local Path = _Path.new(AI)
		if SETTINGS.See_Path == true then
			Path.Visualize = true
		end
		if laughon == true then
			if chaselaugh:IsA("Sound") then
				chaselaugh:Play()
			else
				print("ChaseLaugh its not a Audio! Change the values")
			end
		end
		repeat
			if SETTINGS.Sound_Chase ~= nil then
				SETTINGS.Sound_Chase.Playing = true
			end
			Foot = false
			AI.Humanoid.WalkSpeed = Speed.Speed_Run
			TargetedEvent:FireClient(Player,true)
			Chase_Player(Path)
		until Path == nil or Runing == false or Player.Character.Humanoid.Health == 0 or (Player.Character.HumanoidRootPart.Position - AI.HumanoidRootPart.Position).Magnitude > SETTINGS.Max_distance_Chase
		AI.Humanoid.WalkSpeed = Speed.Speed_Walk
		Path:Stop()
		for i, v in pairs(game.Players:GetPlayers()) do
			TargetedEvent:FireClient(v,false)
		end
		Runing = false
		Move_To_Block()
		Path = nil
	else
		AI.Humanoid.WalkSpeed = Speed.Speed_Walk
		Move_To_Block()
		AI.Humanoid.WalkSpeed = Speed.Speed_Walk
	end
	game:GetService("RunService").Heartbeat:Wait()
end

return AI;