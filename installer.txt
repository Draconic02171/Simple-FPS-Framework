local Http = game:GetService('HttpService')
local Insert = game:GetService('InsertService')

local codes = {}
codes.Main = 'https://raw.githubusercontent.com/Draconic02171/Simple-FPS-Framework/refs/heads/main/ReplicatedStorage/Main.lua'
codes.Utill = 'https://raw.githubusercontent.com/Draconic02171/Simple-FPS-Framework/refs/heads/main/ReplicatedStorage/Utillities.lua'
codes.Services = 'https://raw.githubusercontent.com/Draconic02171/Simple-FPS-Framework/refs/heads/main/ReplicatedStorage/services.lua'
codes.Loader = 'https://raw.githubusercontent.com/Draconic02171/Simple-FPS-Framework/refs/heads/main/Cilent/Loader.lua'
codes.ServerHandler = 'https://raw.githubusercontent.com/Draconic02171/Simple-FPS-Framework/refs/heads/main/Server/ServerHandler.lua'

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

local BulletHole = Instance.new('Folder' , workspace)
BulletHole.Name = 'BulletHole'

local DumpedFolder = Instance.new('Folder' , workspace)
DumpedFolder.Name = 'Dumped'



local Main = Instance.new('ModuleScript' , FrameworkFolder)
Main.Name = 'Main'
Main:SetAttribute('framework' , 'smth')
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
	local Gui = Insert:LoadAsset(132306273684786)
	Gui = Gui:FindFirstChildOfClass('ScreenGui')
	if not Gui then warn('Failed to load a WeaponGui') end
	Gui.Parent = game.StarterGui
end

do
	local SimpleGunTemplate = Insert:LoadAsset(89325139351919)
	SimpleGunTemplate = SimpleGunTemplate:FindFirstChildOfClass('Model')
	if not SimpleGunTemplate then warn('Failed to load a TemplateGun') return end
	SimpleGunTemplate.Parent = GunsFolder

	local TemplateTool = Instance.new('Tool' , game.StarterPack)
	TemplateTool.Name = SimpleGunTemplate.Name
	TemplateTool:AddTag('FPSWeapon')
end

warn("Finished Installing Draconic's Simple FPS Framework")

local GreetingsGui = Insert:LoadAsset(72760877291185)
GreetingsGui = GreetingsGui:FindFirstChildOfClass('ScreenGui')
if not GreetingsGui then warn('Failed to load a Greetings Gui') return end

GreetingsGui.Parent = game.StarterGui

local Frame = GreetingsGui:WaitForChild('Frame') :: Frame
local BG1 = Frame:WaitForChild('BG1') :: ImageLabel
local BG2 = Frame:WaitForChild('BG2') :: ImageLabel
local Logo = Frame:WaitForChild('Logo') :: ImageLabel
local BigText = Frame:WaitForChild('BigText') :: TextLabel
local MadeBy = Frame:WaitForChild('MadeBy') :: TextLabel
local ScrollFrame = Frame:WaitForChild('ScrollingFrame') :: ScrollingFrame
local CloseButton = ScrollFrame:WaitForChild('CloseButton') :: TextButton

game["Run Service"].Heartbeat:Connect(function(dt)
	Logo.Rotation += dt * 15
	BG1.Position -= UDim2.fromScale(dt / 30 , 0)
	BG2.Position -= UDim2.fromScale(dt / 30 , 0)
	if BG1.Position.Width.Scale <= 0 then BG1.Position = UDim2.fromScale(1,0.5) end
	if BG2.Position.Width.Scale <= 0 then BG2.Position = UDim2.fromScale(1,0.5) end
end)

BigText.Visible = false
MadeBy.Visible = false
ScrollFrame.Visible = false

Frame.Position = UDim2.new(0.5 , 0 , 2 , 0)

Logo.Position = UDim2.new(0.5 , 0 , 0.5 , 0)
Logo.Size = UDim2.new(0.8 , 0 , 0.8 , 0)
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
	{Size = UDim2.new(0.5,0 , 0.5 , 0)}
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

ScrollFrame.Position = UDim2.new(0.456, 0 , 1, 0)
ScrollFrame.Visible = true
game.TweenService:Create(
	ScrollFrame ,
	TweenInfo.new(1 , Enum.EasingStyle.Quint , Enum.EasingDirection.Out) ,
	{Position = UDim2.new(0.456, 0, 0.217, 0)}
):Play()


CloseButton.MouseButton1Click:Once(function()
	GreetingsGui:Destroy()
end)