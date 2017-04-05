local E, L, V, P, G = unpack(ElvUI)
local AB = E:NewModule("ActionBars", "AceHook-3.0", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local gsub = string.gsub

AB["handledbuttons"] = {}

function AB:CreateActionBars()
	self:CreateBar1()
	self:CreateBar2()
	self:CreateBar3()
	self:CreateBar4()
	self:CreateBar5()
	--self:CreateBarPet()
	--self:CreateBarShapeShift()
	
	if ( E.myclass == "SHAMAN" ) then
	--	self:CreateTotemBar()
	end
end

function AB:PLAYER_REGEN_ENABLED()
	self:UpdateButtonSettings()
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

function AB:PositionAndSizeBar()
	self:PositionAndSizeBar1()
	self:PositionAndSizeBar2()
	self:PositionAndSizeBar3()
	self:PositionAndSizeBar4()
	self:PositionAndSizeBar5()
end

function AB:UpdateButtonSettings()
	if InCombatLockdown() then self:RegisterEvent("PLAYER_REGEN_ENABLED") return end
	for button, _ in pairs(self["handledbuttons"]) do
		if button then
			self:StyleButton(button, button.noBackdrop)
		else
			self["handledbuttons"][button] = nil
		end
	end
	
	self:PositionAndSizeBar()
	--self:PositionAndSizeBarPet()
	--self:PositionAndSizeBarShapeShift()
end

function AB:GetPage(bar, defaultPage, condition)
	local page = self.db[bar]["paging"][E.myclass]
	if not condition then condition = "" end
	if not page then page = "" end
	if page then
		condition = condition.." "..page
	end
	condition = condition.." "..defaultPage
	return condition
end

function AB:StyleButton(noBackdrop)	
	local name = this:GetName()
	local icon = _G[name.."Icon"]
	local count = _G[name.."Count"]
	local flash = _G[name.."Flash"]
	local hotkey = _G[name.."HotKey"]
	local border = _G[name.."Border"]
	local macroName = _G[name.."Name"]
	local normal = _G[name.."NormalTexture"]
	local buttonCooldown = _G[name.."Cooldown"]
	local normal2 = this:GetNormalTexture()
	local combat = InCombatLockdown()
	
	if flash then flash:SetTexture(nil) end
	if normal then normal:SetTexture(nil) normal:Hide() normal:SetAlpha(0) end	
	if normal2 then normal2:SetTexture(nil) normal2:Hide() normal2:SetAlpha(0) end	
	if border then border:Kill() end
	
	if not this.noBackdrop then
		this.noBackdrop = noBackdrop
	end
	
	if count then
		count:ClearAllPoints()
		count:SetPoint("BOTTOMRIGHT", 0, 2)
		count:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, self.db.fontOutline)
	end
	
	if macroName then
		if self.db.macrotext then
			macroName:Show()
			macroName:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, self.db.fontOutline)
			macroName:ClearAllPoints()
			macroName:Point("BOTTOM", 2, 2)
			macroName:SetJustifyH("CENTER")
		else
			macroName:Hide()
		end
	end
	
	if not this.noBackdrop and not this.backdrop then
		this:CreateBackdrop("Default", true)
		this.backdrop:SetAllPoints()
	end
	
	if icon then
		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()
	end
	
	if self.db.hotkeytext then
		hotkey:FontTemplate(LSM:Fetch("font", self.db.font), self.db.fontSize, self.db.fontOutline)
	end
	
	self:FixKeybindText(this)
	this:StyleButton()
	
	if(not self.handledbuttons[this]) then
		E:RegisterCooldown(buttonCooldown)
		
		self.handledbuttons[this] = true
	end
end

function AB:Bar_OnEnter(bar)
	UIFrameFadeIn(bar, 0.2, bar:GetAlpha(), 1)
end

function AB:Bar_OnLeave(bar)
	UIFrameFadeOut(bar, 0.2, bar:GetAlpha(), 0)
end

function AB:Button_OnEnter(button)
	local bar = button:GetParent()
	UIFrameFadeIn(bar, 0.2, bar:GetAlpha(), 1)
end

function AB:Button_OnLeave(button)
	local bar = button:GetParent()
	UIFrameFadeOut(bar, 0.2, bar:GetAlpha(), 0)
end

function AB:DisableBlizzard()
	MainMenuBar:SetScale(0.00001)
	MainMenuBar:EnableMouse(false)
	PetActionBarFrame:EnableMouse(false)
	ShapeshiftBarFrame:EnableMouse(false)
	
	local elements = {
		MainMenuBar, 
		MainMenuBarArtFrame, 
		BonusActionBarFrame, 
		VehicleMenuBar,
		PetActionBarFrame, 
		ShapeshiftBarFrame,
		ShapeshiftBarLeft, 
		ShapeshiftBarMiddle, 
		ShapeshiftBarRight,
	}
	for _, element in pairs(elements) do
		if element:GetObjectType() == "Frame" then
			element:UnregisterAllEvents()
			
			if element == MainMenuBarArtFrame then
				element:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
			end
		end
		
		if element ~= MainMenuBar then
			element:Hide()
		end
		element:SetAlpha(0)
	end
	elements = nil
	
	local uiManagedFrames = {
		"MultiBarLeft",
		"MultiBarRight",
		"MultiBarBottomLeft",
		"MultiBarBottomRight",
		"ShapeshiftBarFrame",
		"PETACTIONBAR_YPOS",
		"MultiCastActionBarFrame",
		"MULTICASTACTIONBAR_YPOS",
	}
	for _, frame in pairs(uiManagedFrames) do
		UIPARENT_MANAGED_FRAME_POSITIONS[frame] = nil
	end
	uiManagedFrames = nil

	if PlayerTalentFrame then
		PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	else
		hooksecurefunc("TalentFrame_LoadUI", function() PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED") end)
	end
end

function AB:FixKeybindText(button, type)
	local hotkey = _G[button:GetName().."HotKey"]
	local text = hotkey:GetText()
	
	if text then
		text = gsub(text, "SHIFT%-", L["KEY_SHIFT"])
		text = gsub(text, "ALT%-", L["KEY_ALT"])
		text = gsub(text, "CTRL%-", L["KEY_CTRL"])
		text = gsub(text, "BUTTON", L["KEY_MOUSEBUTTON"])
		text = gsub(text, "MOUSEWHEELUP", L["KEY_MOUSEWHEELUP"])
		text = gsub(text, "MOUSEWHEELDOWN", L["KEY_MOUSEWHEELDOWN"])
		text = gsub(text, "NUMPAD", L["KEY_NUMPAD"])
		text = gsub(text, "PAGEUP", L["KEY_PAGEUP"])
		text = gsub(text, "PAGEDOWN", L["KEY_PAGEDOWN"])
		text = gsub(text, "SPACE", L["KEY_SPACE"])
		text = gsub(text, "INSERT", L["KEY_INSERT"])
		text = gsub(text, "HOME", L["KEY_HOME"])
		text = gsub(text, "DELETE", L["KEY_DELETE"])
		text = gsub(text, "NMULTIPLY", "*")
		text = gsub(text, "NMINUS", "N-")
		text = gsub(text, "NPLUS", "N+")
		
		if hotkey:GetText() == _G["RANGE_INDICATOR"] then
			hotkey:SetText("")
		else
			hotkey:SetText(text)
		end
	end
	
	if self.db.hotkeytext == true then
		hotkey:Show()
	else
		hotkey:Hide()
	end
	
	hotkey:ClearAllPoints()
	hotkey:Point("TOPRIGHT", 0, -3)	
end

function AB:Initialize()
	self.db = E.db.actionbar
	if E.private.actionbar.enable ~= true then return end
	E.ActionBars = AB
	
	self:DisableBlizzard()
	
	--self:SetupMicroBar()
	self:CreateActionBars()
	
	self:UpdateButtonSettings()
	--self:LoadKeyBinder()
	
	self:SecureHook("ActionButton_Update", "StyleButton")
	self:SecureHook("PetActionBar_Update", "UpdatePet")
end

E:RegisterModule(AB:GetName())