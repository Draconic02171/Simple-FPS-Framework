local replicatedStorage = game:GetService('ReplicatedStorage')
local frameworkFolder = replicatedStorage:WaitForChild('Framework')
local Assets = frameworkFolder:WaitForChild('Assets')
local Modules = frameworkFolder:WaitForChild('Modules')
local services = require(Modules:WaitForChild("Services"))
local util	= require(Modules:WaitForChild('Utillities'))
local Framework = require(frameworkFolder:WaitForChild('Main'))

local MouseIconOn = services.UserInput.MouseIconEnabled
local Main = Framework.Init()

workspace.Camera.FieldOfView = 80


services.RunService.RenderStepped:Connect(function(deltaTime)
	local ProperDeltaTime = util:GetProperDeltaTime(deltaTime , 30)
	Main:Update(ProperDeltaTime)
end)

services.RunService.Heartbeat:Connect(function(deltaTime)
	local ProperDeltaTime = util:GetProperDeltaTime(deltaTime , 30)
	Main:HB_Update(ProperDeltaTime)
end)

services.UserInput.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.R then Main:Reload() end	
end)

services.UserInput.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then Main.IsTriggering = false end	
end)

Main.Humanoid.Died:Once(function()
	Main:Unequip()
end)

Main.Character.ChildAdded:Connect(function(item)
	if not item:IsA('Tool') and item:GetTags()[1] ~= 'FPSWeapon' then return end
	Main:Equip(item)
end)

Main.Character.ChildRemoved:Connect(function(item)
	if not item:IsA('Tool') and item:GetTags()[1] ~= 'FPSWeapon' then return end
	Main:Unequip(item)
end)

task.spawn(function()
	while Main.Humanoid do
		if services.UserInput:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then Main:Fire() end
		services.RunService.Heartbeat:Wait()
	end
end)