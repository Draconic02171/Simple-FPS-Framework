--This module made by Draconic

local util = {}

function util:GetProperDeltaTime
(
	RawDeltaTime : number,
	MinFramerateCap : number
)
	if not RawDeltaTime then error("First Argument Missed : 'RawDeltaTime : number'") return end
	if not MinFramerateCap then
		MinFramerateCap = 1/30 
	else
		MinFramerateCap = 1 / MinFramerateCap
	end
	
	if RawDeltaTime > MinFramerateCap then 
		return MinFramerateCap
	else
		return RawDeltaTime
	end
end

function util:TrueLinerInterp
(
	Start : number ,
	End : number ,
	DeltaTime : number
)
	if math.abs(Start - End) <= DeltaTime then
		return End
	end
	return Start + math.sign(End - Start) * DeltaTime
end

function util:LinerInterp
(
	Start : number ,
	End : number ,
	DeltaTime : number
)
	return Start + (End - Start) * DeltaTime
end

function util:SpringInterp
(
	Start : number ,
	End : number ,
	DeltaTime : number ,
	Velocity : number ,
	Stiffness : number ,
	Damping : number
)
	local force = (End - Start) * Stiffness
	Velocity = (Velocity + force * DeltaTime) * Damping
	Start = Start + Velocity * DeltaTime
	return Start,Velocity
end

function util:SquareWaveFunc
(
	Time : number ,
	Amp : number ,
	Sqness : number ,
	Freq : number ,
	Offset : number
)
	return (Amp / ((math.abs(Sqness) ^ (Sqness * math.sin(Freq * Time + (Offset or 0)))) + 1)) - (Amp / 2 )
end

function util:RandomPick
(
	ListToPickFrom : table
)
	local Rng = Random.new()
	return ListToPickFrom[Rng:NextInteger(1,#ListToPickFrom)]
end

function util:ScaleCFrame(
	Cframe : CFrame ,
	Scale : number
)
	return CFrame.new(Cframe.Position * Scale) * (Cframe - Cframe.Position)
end

util.Timer = {}
util.Timer.__index = util.Timer
function util.Timer.Create()
	local self = setmetatable({} , util.Timer)
	
	self.ListenToInstance = nil :: Instance
	self.ListenToProperty = nil :: string
	self.TimeLength = 0 :: number
	self.IsRunning = false
	
	return self
end

function util.Timer:StartTimer()
	if not self then error("you must make a variable to store this class") return end
	if not self.ListenToInstance then error("you must setup a ListenToInstance first") return end
	if not self.ListenToProperty then error("you must setup a ListenToProperty") return end
	
	local success = false
	local startTime = os.clock()
	local PreviousEvent = self.ListenToInstance[self.ListenToProperty]
	
	while self.ListenToInstance[self.ListenToProperty] == PreviousEvent do
		self.IsRunning = true
		if os.clock() - startTime > self.TimeLength then success = true break end
		task.wait()
	end
	
	self.IsRunning = false
	return success
end

return util
