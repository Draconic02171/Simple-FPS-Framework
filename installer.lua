local Http = game:GetService('HttpService')
local Insert = game:GetService('InsertService')

local codes = {}
codes.Main = 'https://raw.githubusercontent.com/Draconic02171/Simple-FPS-Framework/refs/heads/main/ReplicatedStorage/Main.lua'
codes.Utill = 'https://raw.githubusercontent.com/Draconic02171/Simple-FPS-Framework/refs/heads/main/ReplicatedStorage/Utillities.lua'
codes.Services = 'https://raw.githubusercontent.com/Draconic02171/Simple-FPS-Framework/refs/heads/main/ReplicatedStorage/services.lua'
codes.Loader = 'https://raw.githubusercontent.com/Draconic02171/Simple-FPS-Framework/refs/heads/main/Cilent/Loader.lua'
codes.ServerHandler = 'https://raw.githubusercontent.com/Draconic02171/Simple-FPS-Framework/refs/heads/main/Server/ServerHandler.lua'
codes.CreditsText = 'https://raw.githubusercontent.com/Draconic02171/Simple-FPS-Framework/refs/heads/main/CreditCilent.txt'

local Sounds = {
	HSHitMarker = 'rbxassetid://4817809188',
	Hitmarker = 'rbxassetid://137166459647708',
	KillFeedSound = 'rbxassetid://7644722553',
}

local FrameworkFolder = Instance.new('Configuration' , game.ReplicatedStorage)
FrameworkFolder.Name = 'Framework'

local AssetsFolder = Instance.new('Folder' , FrameworkFolder)
AssetsFolder.Name = 'Assets'

local EventsFolder = Instance.new('Folder' , FrameworkFolder)
EventsFolder.Name = 'Events'

local modulesFolder = Instance.new('Folder' , FrameworkFolder)
modulesFolder.Name = 'Modules'

local GunsFolder = Instance.new('Folder' , AssetsFolder)
GunsFolder.Name = 'Guns'

local SoundsFolder = Instance.new('Folder' , AssetsFolder)
SoundsFolder.Name = 'Sounds'

if not workspace:FindFirstChild('BulletHole') then
	local BulletHole = Instance.new('Folder' , workspace)
	BulletHole.Name = 'BulletHole'
end

if not workspace:FindFirstChild('Dumped') then
	local DumpedFolder = Instance.new('Folder' , workspace)
	DumpedFolder.Name = 'Dumped'

end

local Main = Instance.new('ModuleScript' , FrameworkFolder)
Main.Name = 'Main'
Main:SetAttribute('framework' , codes.CreditsText)
Main.Source = Http:GetAsync(codes.Main)

local Utillities = Instance.new('ModuleScript' , modulesFolder)
Utillities.Name = 'Utillities'
Utillities.Source = Http:GetAsync(codes.Utill)

local Services = Instance.new('ModuleScript' , modulesFolder)
Services.Name = 'Services'
Services.Source = Http:GetAsync(codes.Services)

local Loader = Instance.new('LocalScript' , game.StarterPlayer.StarterCharacterScripts)
Loader.Name = 'Loader'
Loader.Source = Http:GetAsync(codes.Loader)

local Serverhandler = Instance.new('Script' , game.ServerScriptService)
Serverhandler.Name = 'ServerHandler'
Serverhandler.Source = Http:GetAsync(codes.ServerHandler)



local FireEvent = Instance.new('RemoteEvent' , EventsFolder)
FireEvent.Name = 'Fire'




local Picking = Instance.new('BoolValue' , Main)
Picking.Name = 'Picking'

local Picking = Instance.new('BoolValue' , Main)
Picking.Name = 'Reload'



local HSHitmarker = Instance.new('Sound' , SoundsFolder)
HSHitmarker.Name = 'HSHitmarker'
HSHitmarker.SoundId = Sounds.HSHitMarker

local HitMarker = Instance.new('Sound' , SoundsFolder)
HitMarker.Name = 'Hitmarker'
HitMarker.SoundId = Sounds.Hitmarker

local KillFeedSound = Instance.new('Sound' , SoundsFolder)
KillFeedSound.Name = 'KillFeedSound'
KillFeedSound.SoundId = Sounds.KillFeedSound

do
	local WeaponGui = Instance.new('ScreenGui')
	WeaponGui.Name = 'WeaponGui'
	WeaponGui.IgnoreGuiInset = true

	local AmmoFrame = Instance.new('Frame' , WeaponGui)
	AmmoFrame.Name = 'Ammo'
	AmmoFrame.AnchorPoint = Vector2.new(1 , 1)
	AmmoFrame.Position = UDim2.fromScale(0.99 , 0.99)
	AmmoFrame.Size = UDim2.fromScale(0.5 , 0.185)
	AmmoFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
	AmmoFrame.BackgroundTransparency = 1
	AmmoFrame.ZIndex = 0
	AmmoFrame.Visible = true

	local Line = Instance.new('Frame' , AmmoFrame)
	Line.Name = 'Line'
	Line.AnchorPoint = Vector2.new(0.5 , 0.5)
	Line.Position = UDim2.fromScale(0.505 , 0.63)
	Line.Size = UDim2.fromScale(0.914 , 0.05)
	Line.SizeConstraint = Enum.SizeConstraint.RelativeXY
	Line.BackgroundTransparency = 0
	Line.BorderSizePixel = 0
	Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Line.ZIndex = 1
	Line.Visible = true

	local AmmoBackGround = Instance.new('TextLabel' , AmmoFrame)
	AmmoBackGround.Name = 'BackGound'
	AmmoBackGround.AnchorPoint = Vector2.new(1 , 1)
	AmmoBackGround.Position = UDim2.fromScale(0.962 , 0.6)
	AmmoBackGround.Size = UDim2.fromScale(0.914 , 0.582)
	AmmoBackGround.SizeConstraint = Enum.SizeConstraint.RelativeXY
	AmmoBackGround.BackgroundTransparency = 1
	AmmoBackGround.ZIndex = 0
	AmmoBackGround.Text = '000'
	AmmoBackGround.TextScaled = true
	AmmoBackGround.Font = Enum.Font.Code
	AmmoBackGround.TextColor3 = Color3.fromRGB(75, 75, 75)
	AmmoBackGround.TextXAlignment = Enum.TextXAlignment.Right
	AmmoBackGround.Visible = true

	local AmmoText = Instance.new('TextLabel' , AmmoFrame)
	AmmoText.Name = 'Ammo'
	AmmoText.AnchorPoint = Vector2.new(1 , 1)
	AmmoText.Position = UDim2.fromScale(0.962 , 0.6)
	AmmoText.Size = UDim2.fromScale(0.914 , 0.582)
	AmmoText.SizeConstraint = Enum.SizeConstraint.RelativeXY
	AmmoText.BackgroundTransparency = 1
	AmmoText.ZIndex = 1
	AmmoText.Text = '310'
	AmmoText.TextScaled = true
	AmmoText.Font = Enum.Font.Code
	AmmoText.TextColor3 = Color3.fromRGB(255, 255, 255)
	AmmoText.TextXAlignment = Enum.TextXAlignment.Right
	AmmoText.Visible = true

	local WeaponName = Instance.new('TextLabel' , AmmoFrame)
	WeaponName.Name = 'WeaponName'
	WeaponName.AnchorPoint = Vector2.new(1 , 0)
	WeaponName.Position = UDim2.fromScale(0.962 , 0.7)
	WeaponName.Size = UDim2.fromScale(0.914 , 0.272)
	WeaponName.SizeConstraint = Enum.SizeConstraint.RelativeXY
	WeaponName.BackgroundTransparency = 1
	WeaponName.ZIndex = 1
	WeaponName.Text = 'WeaponName'
	WeaponName.TextScaled = true
	WeaponName.Font = Enum.Font.Code
	WeaponName.TextColor3 = Color3.fromRGB(255, 255, 255)
	WeaponName.TextXAlignment = Enum.TextXAlignment.Right
	WeaponName.Visible = true

	local CrossHair = Instance.new('Frame' , WeaponGui)
	CrossHair.Name = 'CrossHair'
	CrossHair.AnchorPoint = Vector2.new(0.5 ,0.5)
	CrossHair.Position = UDim2.fromScale(0.5 , 0.5)
	CrossHair.Size = UDim2.fromScale(0.08 , 0.08)
	CrossHair.SizeConstraint = Enum.SizeConstraint.RelativeYY
	CrossHair.BackgroundTransparency = 1
	CrossHair.ZIndex = 0
	CrossHair.Visible = true

	local Top = Instance.new('Frame' , CrossHair)
	Top.Name = 'Top'
	Top.AnchorPoint = Vector2.new(0.5 ,1)
	Top.Position = UDim2.fromScale(0.5 , 0.4)
	Top.Size = UDim2.fromScale(0.05 , 0.17)
	Top.BackgroundTransparency = 0
	Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Top.BorderSizePixel = 1
	Top.ZIndex = 1
	Top.Visible = true

	local Bottom = Instance.new('Frame' , CrossHair)
	Bottom.Name = 'Bottom'
	Bottom.AnchorPoint = Vector2.new(0.5 ,0)
	Bottom.Position = UDim2.fromScale(0.5 , 0.6)
	Bottom.Size = UDim2.fromScale(0.05 , 0.17)
	Bottom.BackgroundTransparency = 0
	Bottom.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Bottom.BorderSizePixel = 1
	Bottom.ZIndex = 1
	Bottom.Visible = true

	local Left = Instance.new('Frame' , CrossHair)
	Left.Name = 'Left'
	Left.AnchorPoint = Vector2.new(1 , 0.5)
	Left.Position = UDim2.fromScale(0.4 , 0.5)
	Left.Size = UDim2.fromScale(0.17 , 0.05)
	Left.BackgroundTransparency = 0
	Left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Left.BorderSizePixel = 1
	Left.ZIndex = 1
	Left.Visible = true

	local Right = Instance.new('Frame' , CrossHair)
	Right.Name = 'Right'
	Right.AnchorPoint = Vector2.new(0 , 0.5)
	Right.Position = UDim2.fromScale(0.6 , 0.5)
	Right.Size = UDim2.fromScale(0.17 , 0.05)
	Right.BackgroundTransparency = 0
	Right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Right.BorderSizePixel = 1
	Right.ZIndex = 1
	Right.Visible = true

	local HitMarker = Instance.new('ImageLabel' , CrossHair)
	HitMarker.Name = 'HitMarker'
	HitMarker.AnchorPoint = Vector2.new(0.5 ,0.5)
	HitMarker.Position = UDim2.fromScale(0.5 ,0.5)
	HitMarker.Size = UDim2.fromScale(1 , 1)
	HitMarker.BackgroundTransparency = 1
	HitMarker.Image = 'rbxassetid://8134157779'
	HitMarker.ImageTransparency = 1

	WeaponGui.Parent = game.StarterGui
end

do
	local SimpleGunTemplate = Insert:LoadAsset(83945224178966)
	SimpleGunTemplate = SimpleGunTemplate:FindFirstChildOfClass('Model')
	if not SimpleGunTemplate then warn('Failed to load a TemplateGun') return end
	SimpleGunTemplate.Parent = GunsFolder

	local TemplateTool = Instance.new('Tool' , game.StarterPack)
	TemplateTool.Name = SimpleGunTemplate.Name
	TemplateTool:AddTag('FPSWeapon')
end

warn("Finished Installing Draconic's Simple FPS Framework")

-------------------------------------------------------------------------------------------------------------------------------------------
local GreetingsGui = Instance.new('ScreenGui', game.StarterGui)
GreetingsGui.Name = 'GreetingsGui'
GreetingsGui.IgnoreGuiInset  = true

local Frame = Instance.new('Frame' , GreetingsGui)
Frame.AnchorPoint = Vector2.new(0.5 ,0.5)
Frame.Position = UDim2.fromScale(0.5 , 0.5)
Frame.Size = UDim2.fromScale(1 , 0.8)
Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY
Frame.ZIndex = 1
Frame.Visible = true
Frame.ClipsDescendants = true
Frame.BackgroundColor3 = Color3.fromRGB(0, 19, 43)

local BG1 = Instance.new('ImageLabel' , Frame)
BG1.Name = 'BG1'
BG1.AnchorPoint = Vector2.new(0 , 0.5)
BG1.BackgroundTransparency = 1
BG1.BorderSizePixel = 0
BG1.Position = UDim2.fromScale(1 , 0.5)
BG1.Size = UDim2.fromScale(1 , 1)
BG1.Visible = true
BG1.Image = 'rbxassetid://6028276525'
BG1.ImageTransparency = 0.8
BG1.ImageColor3 = Color3.fromRGB(255, 255, 255)
BG1.ScaleType = Enum.ScaleType.Crop

local BG2 = Instance.new('ImageLabel' , Frame)
BG2.Name = 'BG2'
BG2.AnchorPoint = Vector2.new(1 , 0.5)
BG2.BackgroundTransparency = 1
BG2.BorderSizePixel = 0
BG2.Position = UDim2.fromScale(1 , 0.5)
BG2.Size = UDim2.fromScale(1 , 1)
BG2.Visible = true
BG2.Image = 'rbxassetid://6028276525'
BG2.ImageTransparency = 0.8
BG2.ImageColor3 = Color3.fromRGB(255, 255, 255)
BG2.ScaleType = Enum.ScaleType.Crop

local ScrollingFrame = Instance.new('ScrollingFrame' , Frame)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Position = UDim2.fromScale(0.456 , 0.217)
ScrollingFrame.Size = UDim2.fromScale(0.518 , 0.697)
ScrollingFrame.Visible = true
ScrollingFrame.ClipsDescendants = true
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.CanvasSize = UDim2.fromScale(0 , 1)
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(26, 76, 129)
ScrollingFrame.ScrollBarThickness = 5
ScrollingFrame.ScrollBarImageTransparency = 0.6
ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y

local UIListLayout = Instance.new('UIListLayout' , ScrollingFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Text = Instance.new('TextLabel' , ScrollingFrame)
Text.BackgroundTransparency = 1
Text.Size = UDim2.fromScale(1 , 1.3)
Text.Text = game.HttpService:GetAsync('https://raw.githubusercontent.com/Draconic02171/Simple-FPS-Framework/refs/heads/main/ReadmeModule.txt')
Text.TextColor3 = Color3.fromRGB(255, 255, 255)
Text.TextScaled = true
Text.Font = Enum.Font.Ubuntu
Text.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new('TextButton' , ScrollingFrame)
CloseButton.Name = 'CloseButton'
CloseButton.Size = UDim2.fromScale(1 , 0.05)
CloseButton.Text = '--Click here to close this Popup--'
CloseButton.TextScaled = true
CloseButton.BackgroundTransparency = 1
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)

CloseButton.MouseButton1Click:Once(function()
	GreetingsGui:Destroy()
end)

local Logo = Instance.new('ImageLabel' , Frame)
Logo.Name =  'Logo'
Logo.AnchorPoint = Vector2.new(0.5 , 0.5)
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.fromScale(0.249 , 0.5)
Logo.Size = UDim2.fromScale(0.35 ,0.35)
Logo.SizeConstraint = Enum.SizeConstraint.RelativeXX
Logo.Visible = true
Logo.Image = 'rbxassetid://18747491567'
Logo.ImageColor3 = Color3.fromRGB(255, 255, 255)
Logo.ImageTransparency = 0

local BigText = Instance.new('TextLabel' , Frame)
BigText.Name = 'BigText'
BigText.AnchorPoint = Vector2.new(0.5 , 0.5)
BigText.Position = UDim2.fromScale(0.672 , 0.12)
BigText.Size = UDim2.fromScale(0.6 , 0.129)
BigText.Visible = true
BigText.BackgroundTransparency = 1
BigText.Text = 'Simple FPS'
BigText.Font = Enum.Font.Ubuntu
BigText.TextScaled = true
BigText.TextColor3 = Color3.fromRGB(255, 255, 255)

local MadeBy = Instance.new('TextLabel' , Frame)
MadeBy.Name = 'MadeBy'
MadeBy.AnchorPoint = Vector2.new(0.5 , 0.5)
MadeBy.Position = UDim2.fromScale(0.672 , 0.202)
MadeBy.Size = UDim2.fromScale(0.6 , 0.034)
MadeBy.Visible = true
MadeBy.BackgroundTransparency = 1
MadeBy.Text = 'A simple FPS Framework by Draconic02171'
MadeBy.Font = Enum.Font.Ubuntu
MadeBy.TextScaled = true
MadeBy.TextColor3 = Color3.fromRGB(255, 255, 255)

-------------------------------------------------------------------------------------------------------------------------------------------

game["Run Service"].Heartbeat:Connect(function(dt)
	Logo.Rotation += dt * 25
	BG1.Position -= UDim2.fromScale(dt / 30 , 0)
	BG2.Position -= UDim2.fromScale(dt / 30 , 0)
	if BG1.Position.Width.Scale <= 0 then BG1.Position = UDim2.fromScale(1,0.5) end
	if BG2.Position.Width.Scale <= 0 then BG2.Position = UDim2.fromScale(1,0.5) end
end)

BigText.Visible = false
MadeBy.Visible = false
ScrollingFrame.Visible = false

Frame.Position = UDim2.new(0.5 , 0 , 2 , 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 72, 161)

Logo.Position = UDim2.new(0.5 , 0 , 0.5 , 0)
Logo.Size = UDim2.new(0.6 , 0 , 0.6 , 0)
Logo.ImageTransparency = 1



game.TweenService:Create(
	Frame ,
	TweenInfo.new(2 , Enum.EasingStyle.Quad , Enum.EasingDirection.InOut) ,
	{Position = UDim2.new(0.5 , 0 , 0.5 , 0)}
):Play()

game.TweenService:Create(
	Logo ,
	TweenInfo.new(2 , Enum.EasingStyle.Quad , Enum.EasingDirection.InOut) ,
	{ImageTransparency = 0}
):Play()

task.wait(1)

game.TweenService:Create(
	Logo , TweenInfo.new(2 ,
		Enum.EasingStyle.Exponential , Enum.EasingDirection.InOut) ,
	{Position = UDim2.new(0.249,0 , 0.5 , 0)}
):Play()

task.wait(0.1)

game.TweenService:Create(
	Logo , 
	TweenInfo.new(1.5 , Enum.EasingStyle.Quad , Enum.EasingDirection.InOut) ,
	{Size = UDim2.new(0.35,0 , 0.35 , 0)}
):Play()
task.wait(1)

BigText.TextTransparency = 1
BigText.Position = UDim2.new(0.672, 0 , 0.55, 0)
BigText.Visible = true
MadeBy.TextTransparency = 1
MadeBy.Position = UDim2.new(0.672, 0 , 0.6, 0)
MadeBy.Visible = true

game.TweenService:Create(
	BigText ,
	TweenInfo.new(0.3 , Enum.EasingStyle.Quint , Enum.EasingDirection.Out) ,
	{Position = UDim2.new(0.672, 0, 0.5, 0) , TextTransparency = 0}
):Play()
task.wait(0.05)
game.TweenService:Create(
	MadeBy ,
	TweenInfo.new(0.3 , Enum.EasingStyle.Quint , Enum.EasingDirection.Out) ,
	{Position = UDim2.new(0.672, 0, 0.587, 0) , TextTransparency = 0}
):Play()
task.wait(2)

game.TweenService:Create(
	Frame ,
	TweenInfo.new(1.1 , Enum.EasingStyle.Quad , Enum.EasingDirection.InOut) ,
	{BackgroundColor3 = Color3.fromRGB(0, 19, 43)}
):Play()

game.TweenService:Create(
	BigText ,
	TweenInfo.new(1 , Enum.EasingStyle.Quint , Enum.EasingDirection.Out) ,
	{Position = UDim2.new(0.672, 0, 0.12, 0) , TextTransparency = 0}
):Play()
task.wait(0.05)
game.TweenService:Create(
	MadeBy ,
	TweenInfo.new(1 , Enum.EasingStyle.Quint , Enum.EasingDirection.Out) ,
	{Position = UDim2.new(0.672, 0, 0.202, 0) , TextTransparency = 0}
):Play()
task.wait(0.2)

ScrollingFrame.Position = UDim2.new(0.456, 0 , 1, 0)
ScrollingFrame.Visible = true
game.TweenService:Create(
	ScrollingFrame ,
	TweenInfo.new(1 , Enum.EasingStyle.Quint , Enum.EasingDirection.Out) ,
	{Position = UDim2.new(0.456, 0, 0.217, 0)}
):Play()

CloseButton.MouseButton1Click:Once(function()
	GreetingsGui:Destroy()
end)