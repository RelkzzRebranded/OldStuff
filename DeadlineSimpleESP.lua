-- Compiled with roblox-ts v2.3.0
-- DEADLINE PLAYER ESP
--[[
	************************************************************
	 * These UTILITIES arent mine they are from TerminalVibes
	 ************************************************************
]]
local Players = cloneref(game:GetService("Players"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local Workspace = cloneref(game:GetService("Workspace"))
--[[
	***********************************************************
	 * VARIABLES
	 * Description: Variables referenced globally in the script
	 ***********************************************************
]]
local charactersFolder = Workspace:WaitForChild("characters")
--[[
	***********************************************************
	 * UTILITIES
	 * Description: Helper functions and classes
	 ***********************************************************
]]
local Bin
do
	Bin = setmetatable({}, {
		__tostring = function()
			return "Bin"
		end,
	})
	Bin.__index = Bin
	function Bin.new(...)
		local self = setmetatable({}, Bin)
		return self:constructor(...) or self
	end
	function Bin:constructor()
	end
	function Bin:add(item)
		local node = {
			item = item,
		}
		if self.head == nil then
			self.head = node
		end
		if self.tail then
			self.tail.next = node
		end
		self.tail = node
		return item
	end
	function Bin:batch(...)
		local args = { ... }
		for _, item in args do
			local node = {
				item = item,
			}
			if self.head == nil then
				self.head = node
			end
			if self.tail then
				self.tail.next = node
			end
			self.tail = node
		end
		return args
	end
	function Bin:destroy()
		while self.head do
			local item = self.head.item
			if type(item) == "function" then
				item()
			elseif typeof(item) == "RBXScriptConnection" then
				item:Disconnect()
			elseif type(item) == "thread" then
				task.cancel(item)
			elseif item.destroy ~= nil then
				item:destroy()
			elseif item.Destroy ~= nil then
				item:Destroy()
			end
			self.head = self.head.next
		end
	end
	function Bin:isEmpty()
		return self.head == nil
	end
end
--[[
	***********************************************************
	 * MAIN COMPONENTS
	 * Description: Classes for specific entities/objects
	 ***********************************************************
]]
local BaseComponent
do
	BaseComponent = setmetatable({}, {
		__tostring = function()
			return "BaseComponent"
		end,
	})
	BaseComponent.__index = BaseComponent
	function BaseComponent.new(...)
		local self = setmetatable({}, BaseComponent)
		return self:constructor(...) or self
	end
	function BaseComponent:constructor(instance)
		self.instance = instance
		self.bin = Bin.new()
	end
	function BaseComponent:destroy()
		self.bin:destroy()
	end
end
--[[
	***********************************************************
	 * COMPONENTS
	 * Description: Classes for specific entities/objects
	 ***********************************************************
]]
local ESPComponent
do
	local super = BaseComponent
	ESPComponent = setmetatable({}, {
		__tostring = function()
			return "ESPComponent"
		end,
		__index = super,
	})
	ESPComponent.__index = ESPComponent
	function ESPComponent.new(...)
		local self = setmetatable({}, ESPComponent)
		return self:constructor(...) or self
	end
	function ESPComponent:constructor(character)
		super.constructor(self, character)
		-- Initialize:
		self:createVisual()
		character.AncestryChanged:Connect(function(_, parent)
			print(parent)
			return parent == nil and self:destroy()
		end)
		character.PrimaryPart.AncestryChanged:Connect(function(_, parent)
			return parent == nil and self:destroy()
		end)
	end
	function ESPComponent:createVisual()
		local _binding = self
		local bin = _binding.bin
		-- Instances:
		local BillboardGui = Instance.new("BillboardGui")
		local Cham = Instance.new("Highlight")
		local Box = Instance.new("Frame")
		local Outline = Instance.new("UIStroke")
		-- Properties:
		BillboardGui.Adornee = self.instance.PrimaryPart
		BillboardGui.AlwaysOnTop = true
		BillboardGui.ResetOnSpawn = false
		BillboardGui.Size = UDim2.new(5, 0, 10, 0)
		BillboardGui.MaxDistance = math.huge
		BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		Cham.Adornee = self.instance
		Cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		Cham.OutlineColor = Color3.fromRGB(255, 255, 255)
		Cham.FillColor = Color3.fromRGB(255, 0, 255)
		Cham.FillTransparency = 0.8
		Cham.OutlineTransparency = 0.3
		Box.BackgroundTransparency = 1
		Box.AnchorPoint = Vector2.new(0.5, 0.5)
		Box.Position = UDim2.new(0.5, 0, 0.5, 0)
		Box.Size = UDim2.new(0.9, 0, 0.7, 0)
		Outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		Outline.LineJoinMode = Enum.LineJoinMode.Miter
		Outline.Color = Color3.fromRGB(255, 255, 255)
		Outline.Thickness = 1.5
		-- Initialize:
		Outline.Parent = Box
		Box.Parent = BillboardGui
		Cham.Parent = CoreGui
		BillboardGui.Parent = CoreGui
		bin:add(Cham)
		bin:add(BillboardGui)
	end
end
--[[
	***********************************************************
	 * CONTROLLERS
	 * Description: Singletons that are used once
	 ***********************************************************
]]
local ESPController = {}
do
	local _container = ESPController
	local onSpot = function(character)
		if character:IsA("Model") and character.Name ~= "StarterCharacter" and character:FindFirstChild("hitbox") ~= nil then
			--print(character.Name);
			ESPComponent.new(character)
		end
	end
	local function __init()
		for _, child in charactersFolder:GetChildren() do
			task.spawn(onSpot, child)
		end
		charactersFolder.ChildAdded:Connect(function(child)
			onSpot(child)
		end)
	end
	_container.__init = __init
end
--[[
	***********************************************************
	 * INITIALIZATION
	 * Description: Initializes and starts the runtime
	 ***********************************************************
]]
ESPController.__init()
return 0
