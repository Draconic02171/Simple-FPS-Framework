local replicatedStorage = game:GetService('ReplicatedStorage')
local frameworkFolder = replicatedStorage:WaitForChild('Framework')
local Events = frameworkFolder:WaitForChild('Events')
local Assets = frameworkFolder:WaitForChild('Assets')
local Guns = Assets:WaitForChild('Guns')
local Modules = frameworkFolder:WaitForChild('Modules')

local services = require(Modules:WaitForChild("Services"))
local util	= require(Modules:WaitForChild('Utillities'))
local Timer = util.Timer.Create()

local text = script:GetAttribute('framework')
if not text then return {} end

print(text)

local framework = {}
framework.__index = framework

function framework.Init()
	local self = setmetatable({}, framework)
	
	self.Player = game.Players.LocalPlayer :: Player
	self.Character = self.Player.Character or self.Player.CharacterAdded:Wait() :: Model
	self.PlayerGui = self.Player:WaitForChild('PlayerGui') :: PlayerGui
	self.WeaponGui = self.PlayerGui:WaitForChild('WeaponGui') :: ScreenGui
	
	self.WeapGui = {}

	self.WeapGui.Crosshair 		= self.WeaponGui:WaitForChild('CrossHair')		:: Frame
	self.WeapGui.C_Top 			= self.WeapGui.Crosshair:WaitForChild('Top')		:: Frame
	self.WeapGui.C_Bottom 		= self.WeapGui.Crosshair:WaitForChild('Bottom')	:: Frame
	self.WeapGui.C_Left 		= self.WeapGui.Crosshair:WaitForChild('Left')		:: Frame
	self.WeapGui.C_Right 		= self.WeapGui.Crosshair:WaitForChild('Right')	:: Frame
	self.WeapGui.HitMarker		= self.WeapGui.Crosshair:WaitForChild('HitMarker'):: ImageLabel

	self.WeapGui.Ammo			= self.WeaponGui:WaitForChild('Ammo')			:: Frame
	self.WeapGui.AmmoText		= self.WeapGui.Ammo:WaitForChild('Ammo')			:: Frame
	self.WeapGui.WeaponName		= self.WeapGui.Ammo:WaitForChild('WeaponName')	:: Frame
	
	self.Humanoid = self.Character:WaitForChild('Humanoid') :: Humanoid
	self.HRP = self.Character:WaitForChild('HumanoidRootPart') :: Part
	
	self.Parameter = RaycastParams.new()
	self.Parameter.FilterDescendantsInstances = {workspace.Camera , self.Character , workspace.BulletHole}
	self.Parameter.FilterType = Enum.RaycastFilterType.Exclude
	self.Parameter.IgnoreWater = true
	
	self.cache = Instance.new('Folder' , self.Player.PlayerScripts)
	self.cache.Name = 'GunModelCache'
		
	self.mouse = self.Player:GetMouse()
		
	self.GunModel = nil
	self.GunSounds = nil
	self.GunModelOffset = nil
	self.Config = nil
	self.FirePoint = nil :: Attachment
	self.CFAnims = CFrame.new()
	self.Anims = CFrame.new()
	self.targetCF = CFrame.new()
	self.FireCF = CFrame.new()
	self.Recoil = CFrame.new()
	self.GunSize = 1
	self.Inaccruracy = 0
	
	--joint
	self.SlideJoint = nil :: Motor6D
	
	self.IsEquipping = false
	self.IsFiring = false
	self.IsTriggering = false
	self.IsReloading = false
	self.IsRechambering = false
	
	self.Ammo = 0
	self.MaxAmmo = 0
	
	self.WeapGui.Ammo.Visible = false
	self.WeapGui.Crosshair.Visible = false
	
	Events.Fire.OnClientEvent:Connect(function(player : Player , result : RaycastResult , GotHit : boolean , FireSound : Sound , Kill : boolean)
		if player == self.Player then
			if GotHit then
				task.spawn(function()
					local sound = replicatedStorage.Framework.Assets.Sounds[GotHit]:Clone() :: Sound
					sound.PlaybackSpeed = (math.random(-100 , 100) / 800) + 1
					sound.PlayOnRemove = true
					sound.Parent = game.SoundService
					sound:Destroy()
				end)
				if GotHit == 'HSHitMarker' then self.WeapGui.HitMarker.ImageColor3 = Color3.new(1, 0, 0) else self.WeapGui.HitMarker.ImageColor3 = Color3.new(1, 1, 1) end
				self.WeapGui.HitMarker.ImageTransparency = 0
				self.WeapGui.HitMarker.Size = UDim2.new(1.5, 0,1.5, 0)
				local Goal = {}
				Goal.ImageTransparency = 1
				Goal.Size = UDim2.new(0.8,0,0.8,0)
				Goal.Rotation = math.random(-100 , 100) / 40
				game.TweenService:Create(
					self.WeapGui.HitMarker , TweenInfo.new(0.3 , Enum.EasingStyle.Cubic , Enum.EasingDirection.Out) , Goal
				):Play()
			end
			if Kill then
				task.spawn(function()
					local sound = replicatedStorage.Framework.Assets.Sounds:FindFirstChild('KillFeedSound'):Clone() :: Sound
					sound.PlayOnRemove = true
					sound.Parent = game.SoundService
					sound:Destroy()
				end)
			end
		else
			
		end
	end)

	return self
end

function framework:Update(deltaTime)
	
	if not self.GunModel then return end
	if not self.GunModelOffset then return end

	self.GunModel:PivotTo(workspace.Camera.CFrame * util:ScaleCFrame(self.GunModelOffset * self.Anims * self.FireCF * self.Recoil , self.GunSize))

	if not self.IsFiring then
		self.Inaccruracy = util:TrueLinerInterp(self.Inaccruracy , self.Config.MinSpread , deltaTime * self.Config.Recovering)
	end
	
	self.WeapGui.C_Top.Position 		= UDim2.new(0.5, 0,0.4 - (self.Inaccruracy / 5), 0)
	self.WeapGui.C_Bottom.Position 	= UDim2.new(0.5, 0,0.6 + (self.Inaccruracy / 5), 0)
	self.WeapGui.C_Left.Position 		= UDim2.new(0.4 - (self.Inaccruracy / 5), 0,0.5, 0)
	self.WeapGui.C_Right.Position 		= UDim2.new(0.6 + (self.Inaccruracy / 5), 0,0.5, 0)
	
	--self.WeapGui.Crosshair.Position = UDim2.new(0 , self.mouse.X ,0 ,self.mouse.Y
	
end

function framework:HB_Update(deltaTime)
	if not self.GunModel then return end
	self.GunModelOffset = self.GunModel:FindFirstChild('Offset')
	if not self.GunModelOffset or not self.GunModelOffset:IsA('CFrameValue') then return end

	local MouseDelta = services.UserInput:GetMouseDelta()
	local GunRotate = CFrame.Angles(
		(-math.clamp(MouseDelta.Y , -50 , 50) / 150) ,
		(-math.clamp(MouseDelta.X , -50 , 50) / 150) 
		, 0
	) * CFrame.new(
		-math.clamp(MouseDelta.X , -50 , 50) / 170 , 0 ,
		-math.clamp(MouseDelta.Y , -50 , 50) / 50
	)
	local Dir = self.HRP.CFrame :: CFrame
	local floating = self.Humanoid:GetState()
	
	if floating == Enum.HumanoidStateType.Freefall then floating = 0 else floating = 1 end
	
	Dir = Dir:VectorToObjectSpace(self.HRP.AssemblyLinearVelocity).Unit * -1
		
	Dir = Vector3.new(
		Dir.X * self.Humanoid.MoveDirection.Magnitude,
		math.clamp(self.HRP.AssemblyLinearVelocity.Y * -0.03 , -1.5, 2.5),
		Dir.Z * self.Humanoid.MoveDirection.Magnitude
	)
	
	local bobing = CFrame.new(
		util:SquareWaveFunc(tick() * floating * self.Humanoid.MoveDirection.Magnitude , 0.25 , 2 , (self.Humanoid.WalkSpeed / 2) * 1 , 0),
		(math.abs(util:SquareWaveFunc(tick()* floating * self.Humanoid.MoveDirection.Magnitude , 0.25 , 3, (self.Humanoid.WalkSpeed) * 0.5 , 0)) - 0.1) * self.Humanoid.MoveDirection.Magnitude,
		0
	)
	self.Recoil = self.Recoil:Lerp(CFrame.new(0,0,0) , deltaTime * 4)
	self.FireCF = self.FireCF:Lerp(CFrame.new(0,0,0) , deltaTime * 12)
	
	local WalkingCF = CFrame.new(Dir * 0.2) * CFrame.Angles(0 , 0 , Dir.X * 0.2)	
	self.CFAnims = self.CFAnims:Lerp(GunRotate * bobing * WalkingCF , deltaTime * 10)
	
	self.Anims = self.Anims:Lerp(self.targetCF , deltaTime * self.Config.ModelEquipingSpeed)
	
	self.GunModelOffset = self.GunModelOffset.Value * self.CFAnims * self.Anims
end

function framework:Fire()
	
	if not self.GunModel then return end
	if not self.IsEquipping or self.IsFiring or self.IsReloading or self.Ammo <= 0 or self.IsRechambering then return end


	self.IsFiring = true

	if self.Config.FireMode == 'single' and self.IsTriggering then
		task.wait(60 / self.Config.FireRate)
		self.IsFiring = false
		return 
	end
	local Direction = {}
	local Hit = false
	
	for i = 1 , self.Config.BulletPerShot do
		Direction[i] = (
			workspace.Camera.CFrame.LookVector + Vector3.new(
				math.rad((math.random(-100 , 100) / 100) * self.Inaccruracy),
				math.rad((math.random(-100 , 100) / 100) * self.Inaccruracy),
				math.rad((math.random(-100 , 100) / 100) * self.Inaccruracy)
			)
		) * 10000
	end
 
	local result = nil
	
	for i , v in pairs(Direction) do
		local temp = workspace:Raycast(workspace.Camera.CFrame.Position , v , self.Parameter)
		
		task.spawn(function()
			if temp and temp.Instance:IsA('BasePart') then
				local find = temp.Instance:FindFirstAncestorOfClass('Model')
				local humanoid = false
				if find then 
					if find:FindFirstChildOfClass('Humanoid') then humanoid = true else humanoid = false end
				else
					humanoid = false
				end
				
				if not humanoid then
					local bulletHole = Instance.new('Part' , workspace.BulletHole or workspace)
					bulletHole.Color = Color3.fromRGB(0,0,0)
					bulletHole.CFrame = CFrame.new(temp.Position , temp.Position - temp.Normal)
					bulletHole.Anchored = true
					bulletHole.Size = Vector3.new(0.1 , 0.1 , 0.001)
					bulletHole.CanCollide = false
					game.Debris:AddItem(bulletHole , 5)
				end
			end
		end)
		
		if temp then result = temp end
	end
	
	
	
	if result then
		Events.Fire:FireServer(workspace.Camera.CFrame.Position , Direction)
	end
	
	if self.GunSounds then
		local sound = self.GunSounds:FindFirstChild('Fire') :: Sound
		if sound then
			sound = sound:Clone()
			sound.Parent = game.SoundService
			sound.PlaybackSpeed = (math.random(-100,100) / 800) + 1
			sound.PlayOnRemove = true
			sound:Destroy()
		end
	end
	self.FireCF *= self.Config.FireCFrame
	self.Recoil *= self.Config.ModelRecoil
	
	if not self.Config.CanBeRechamber then
		if self.SlideJoint and self.SlideJoint:GetAttribute("SlidePos") then
			local goal = {}
			goal.C1 = util:ScaleCFrame(self.SlideJoint:GetAttribute("SlidePos") , self.GunSize)
			game.TweenService:Create(
				self.SlideJoint , TweenInfo.new(0.05 , Enum.EasingStyle.Exponential , Enum.EasingDirection.InOut , 0 ,true) , goal
			):Play()
		end
	end
	
	
	
	self.Inaccruracy = util:TrueLinerInterp(self.Inaccruracy , self.Config.MaxSpread , (60 / self.Config.FireRate) * self.Config.Handling)

	self.Ammo -= 1

	self.WeapGui.AmmoText.Text = self.Ammo

	self.IsTriggering = true
	task.wait(60 / self.Config.FireRate)
	self.IsFiring = false
	
	if self.Config and self.Config.CanBeRechamber then self:ReChamber() end	
	
end

function framework:ReChamber()
	if not self.GunModel then return end
	if not self.Config.CanBeRechamber then return end
	if not self.IsEquipping or self.IsFiring or self.IsReloading or self.Ammo <= 0 or self.IsRechambering then return end
	
	self.IsRechambering = true
	if self.GunSounds then
		local sound = self.GunSounds:FindFirstChild('ReChamber') :: Sound
		if sound then sound:Play() end
	end
	
	if self.SlideJoint and self.SlideJoint:GetAttribute("SlidePos") then
		local goal = {}
		goal.C1 = util:ScaleCFrame(self.SlideJoint:GetAttribute("SlidePos") , self.GunSize)
		game.TweenService:Create(
			self.SlideJoint , TweenInfo.new(self.Config.ReChamberTime / 2 , Enum.EasingStyle.Cubic , Enum.EasingDirection.Out , 0 ,true) , goal
		):Play()
	end
	self.WeapGui.AmmoText.Text = 'RCH'
	task.wait(self.Config.ReChamberTime)
	self.IsRechambering = false
	self.WeapGui.AmmoText.Text = self.Ammo
end

function framework:Reload()

	if not self.GunModel then return end
	if not self.IsEquipping or self.IsFiring or self.IsReloading or self.Ammo >= self.Config.AmmoPerMag then return end
	
	
	self.IsReloading = true
	script.Reload.Value = true
	
	self.WeapGui.AmmoText.Text = 'RLD'
	
	if self.GunSounds then
		local sound = self.GunSounds:FindFirstChild('Reload') :: Sound
		if sound then sound:Play() end
	end
	
	self.targetCF = CFrame.new(0 , -0.5 , 0) * CFrame.Angles(math.rad(-15) , math.rad(-10) , math.rad(30))
	
	Timer.ListenToInstance = script.Reload
	Timer.ListenToProperty = 'Value'
	Timer.TimeLength = self.Config.ReloadTime
	
	local result = Timer:StartTimer()
	
	if not result then return end
	
	self.Ammo = self.Config.AmmoPerMag
	self.WeapGui.AmmoText.Text = self.Ammo
	
	self.targetCF = CFrame.new(0 , 0 , 0)
	self.IsReloading = false
	script.Reload.Value = false
	
	if self.Config and self.Config.CanBeRechamber then self:ReChamber() end	
	
end

function framework:Equip(Tool : Tool)
	if not Tool then return end
	
	self.GunModel = self.cache:FindFirstChild(Tool.Name) or Guns:FindFirstChild(Tool.Name):Clone()
	self.Config = require(self.GunModel:FindFirstChild('Config'))
	self.SlideJoint = self.GunModel.PrimaryPart:FindFirstChild('Slide')
	self.FirePoint = self.GunModel.PrimaryPart:FindFirstChild('FirePoint')
	self.GunSounds = self.GunModel.PrimaryPart:FindFirstChild('Sounds')
	
	self.CFAnims = CFrame.new()
	self.Anims = CFrame.new()
	self.targetCF = CFrame.new()
	self.FireCF = CFrame.new()
	self.Recoil = CFrame.new()

	self.IsEquipping = false
	self.IsFiring = false
	self.IsTriggering = false
	self.IsReloading = false

	self.Ammo = 0
	self.MaxAmmo = 0
	
	self.GunSize = self.GunModel:GetScale()
	
	self.Ammo = Tool:GetAttribute('Ammo')
	self.MaxAmmo = Tool:GetAttribute('MaxAmmo')
	
	if not self.Ammo then self.Ammo = Tool:SetAttribute('Ammo' , self.Config.AmmoPerMag) self.Ammo = Tool:GetAttribute('Ammo') end
	if not self.MaxAmmo then self.MaxAmmo = Tool:SetAttribute('MaxAmmo' , self.Config.AmmoPerMag) self.MaxAmmo = Tool:GetAttribute('MaxAmmo') end
	
	script.Picking.Value = false
	script.Reload.Value = false
	services.UserInput.MouseIconEnabled = false
	
	self.WeapGui.Ammo.Visible = true
	self.WeapGui.Crosshair.Visible = true
	self.WeapGui.WeaponName.Text = Tool.Name
	self.WeapGui.AmmoText.Text = self.Ammo
	
	self.GunModel:PivotTo(workspace.Camera.CFrame * CFrame.new(0 , -2 , 0))
	self.Anims = CFrame.new(0,-2,-1) * CFrame.Angles(math.rad(-45) , 0 , 0)
	self.GunModel.Parent = workspace.Camera
	
	if self.GunSounds then
		local sound = self.GunSounds:FindFirstChild('Equip') :: Sound
		if sound then sound:Play() end
	end
	
	script.Picking.Value = true
	Timer.ListenToInstance = script.Picking
	Timer.ListenToProperty = 'Value'
	Timer.TimeLength = self.Config.EquipTime
	
	local result = Timer:StartTimer()
	if not result then return end
	
	self.IsTriggering = false
	self.IsEquipping = true
	self.IsFiring = false
	self.IsReloading = false
	
end

function framework:Unequip(Tool : Tool)
	if self.GunModel then self.GunModel.Parent = self.cache end
	
	if Tool then
		self.Ammo = Tool:SetAttribute('Ammo' , self.Ammo)
		self.MaxAmmo = Tool:SetAttribute('MaxAmmo' , self.MaxAmmo)
	end
	
	if self.GunSounds :: Folder then
		for i , v in pairs(self.GunSounds:GetChildren()) do
			if v:IsA('Sound') then v:Stop() end
		end
	end
	
	self.GunModel = nil
	self.GunSounds = nil
	self.GunModelOffset = nil
	self.Config = nil
	self.FirePoint = nil :: Attachment
	self.CFAnims = CFrame.new()
	self.Anims = CFrame.new()
	self.targetCF = CFrame.new()
	self.FireCF = CFrame.new()
	self.Recoil = CFrame.new()

	--joint
	self.SlideJoint = nil :: Motor6D

	self.IsEquipping = false
	self.IsFiring = false
	self.IsTriggering = false
	self.IsReloading = false

	self.Ammo = 0
	self.MaxAmmo = 0
	
	self.WeapGui.Ammo.Visible = false
	self.WeapGui.Crosshair.Visible = false
	
	script.Picking.Value = false
	script.Reload.Value = false
	services.UserInput.MouseIconEnabled = true
end

return framework
