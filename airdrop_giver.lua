-- Compiled with roblox-ts v2.3.0
local Worksapce = cloneref(game:GetService("Workspace"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local Players = cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer
local Interactable = Worksapce:WaitForChild("Interactable")
local Containers = Interactable:WaitForChild("Containers")
local AirdropCollector = {}
do
	local _container = AirdropCollector
	local dropCounter = 0
	local start = function()
		local _exp = Containers:GetChildren()
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _callback = function(child)
			return child:IsA("Model")
		end
		local _length = 0
		for _k, _v in _exp do
			if _callback(_v, _k - 1, _exp) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		local modelAirdrops = _newValue
		for _, airdrop in modelAirdrops do
			local container = airdrop
			local _value = (string.find(container.Name, "Drop"))
			if _value ~= 0 and _value == _value and _value then
				dropCounter += 1
				local pivot = LocalPlayer.Character:GetPivot()
				local _lookVector = pivot.LookVector
				local _arg0 = dropCounter * 5
				local offsetPosition = pivot + (_lookVector * _arg0)
				container:PivotTo(offsetPosition)
			end
		end
		dropCounter = 0
	end
	local function __init()
		UserInputService.InputBegan:Connect(function(input, processing)
			if not processing then
				if input.KeyCode == Enum.KeyCode.KeypadPlus then
					task.defer(start)
				end
			end
		end)
	end
	_container.__init = __init
end
AirdropCollector.__init()
return nil
