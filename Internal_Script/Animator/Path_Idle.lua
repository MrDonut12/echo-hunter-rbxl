while true do
	local root = script.Parent.Parent:WaitForChild("HumanoidRootPart")
	local lastPosition = root.Position
	task.wait(0.1)
	if (lastPosition - root.Position).magnitude > 0 then 
		script.Parent.atIdle.Value = false 
	end
	if (lastPosition - root.Position).magnitude < 0.4 then 
		script.Parent.atIdle.Value = true 
	end
	task.wait(0.1)
end