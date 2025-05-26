local replicatedStorage = game.ReplicatedStorage
local Framework = replicatedStorage.Framework
local Guns = Framework.Assets.Guns
local Events = Framework.Events

Events.Fire.OnServerEvent:Connect(function(player : Player , Origin : Vector3 , Direction : {Vector3})

	local WeaponName = player.Character:FindFirstChildOfClass('Tool')
	if not WeaponName or WeaponName:GetTags()[1] ~= 'FPSWeapon' then return end

	local Config = require(Guns[WeaponName.Name].Config)

	local GunSound = Guns[WeaponName.Name].PrimaryPart.Sounds:FindFirstChild('Fire')

	local OutPutDamage = 0
	local HitPart = nil
	local Kill = nil

	local param = RaycastParams.new()
	param.FilterType = Enum.RaycastFilterType.Exclude
	param.FilterDescendantsInstances = {player.Character , workspace.Dumped}
	
	local result = nil

	for i , v in pairs(Direction) do
		local temp = workspace:Raycast(Origin, v , param)

		if temp then
			result = temp
			local Hit = result.Instance
			local Humanoid = Hit.Parent:FindFirstChildOfClass('Humanoid')

			if Humanoid and Humanoid.Health > 0 then
				HitPart = 'Hitmarker'
				if Hit:IsA('BasePart') then
					if Hit.Name == 'Head' then  OutPutDamage += Config.HeadShotMultiply * Config.Damage HitPart = 'HSHitMarker' else OutPutDamage = Config.Damage end
				elseif Hit:IsA('Accessory') then
					Hit = Hit:FindFirstDescendant('AccessoryWeld')
					if Hit then
						if Hit.C1.Name == 'Head' then OutPutDamage += Config.HeadShotMultiply * Config.Damage HitPart = 'HSHitMarker' else OutPutDamage = Config.Damage end
					end
				end

				Humanoid:TakeDamage(OutPutDamage)
				if Humanoid.Health <= 0 then Kill = true Humanoid.Parent.Parent = workspace.Dumped end 
			end
		end
	end

	Events.Fire:FireAllClients(player , result , HitPart , GunSound , Kill)
end)