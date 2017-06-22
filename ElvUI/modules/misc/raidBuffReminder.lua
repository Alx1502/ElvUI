local E, L, V, P, G = unpack(ElvUI)
local RB = E:NewModule("ReminderBuffs", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

local GetPlayerBuffTimeLeft = GetPlayerBuffTimeLeft
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local UnitBuff = UnitBuff

local BUFF_MAX_DISPLAY = BUFF_MAX_DISPLAY

E.ReminderBuffs = RB

RB.Spell1Buffs = {
	28521, -- Flask of Blinding Light
	28518, -- Flask of Fortification
	28519, -- Flask of Mighty Restoration
	28540, -- Flask of Pure Death
	28520, -- Flask of Relentless Assault
	42735, -- Flask of Chromatic Wonder
	46839, -- Shattrath Flask of Blinding Light
	41607, -- Shattrath Flask of Fortification
	41605, -- Shattrath Flask of Mighty Restoration
	46837, -- Shattrath Flask of Pure Death
	41608, -- Shattrath Flask of Relentless Assault
	41611, -- Shattrath Flask of Supreme Power
	17629, -- Flask of Chromatic Resistance
	17628, -- Flask of Supreme Power
	17626, -- Flask of the Titans
	17627, -- Flask of Distilled Wisdom

	33721, -- Adept's Elixir
	28509, -- Elixir of Major Mageblood
	45373, -- Bloodberry Elixir
	28502, -- Elixir of Major Defense
	39627, -- Elixir of Draenic Wisdom
	33726, -- Elixir of Mastery
	28491, -- Elixir of Healing Power
	39625, -- Elixir of Major Fortitude
	28497, -- Elixir of Mighty Agility
	11406, -- Elixir of Demonslaying
}

RB.Spell2Buffs = {
	43706, -- +23 Spellcrit (Skullfish Soup Buff)
	33257, -- +30 Stamina
	33256, -- +20 Strength
	33259, -- +40 AP
	33261, -- +20 Agility
	33263, -- +23 Spelldmg
	33265, -- +8 MP5
	33268, -- +44 Addheal
	35272, -- +20 Stamina
	33254, -- +20 Stamina
	43764, -- +20 Meleehit
	45619, -- +8 Spellresist
}

RB.Spell3Buffs = {
	26991, -- Gift of the Wild
	26990, -- Mark of the Wild
}

RB.Spell4Buffs = {
	25898, -- Greater Blessing of Kings
	20217, -- Blessing of Kings
}

RB.CasterSpell5Buffs = {
	27127, -- Arcane Brilliance
	27126, -- Arcane Intellect
}

RB.MeleeSpell5Buffs = {
	25392, -- Prayer of Fortitude
	25389, -- Power Word: Fortitude
}

RB.CasterSpell6Buffs = {
	27143, -- Greater Blessing of Wisdom
	27142, -- Blessing of Wisdom
}

RB.MeleeSpell6Buffs = {
	27141, -- Greater Blessing of Might
	27140, -- Blessing of Might
}

function RB:CheckFilterForActiveBuff(filter)
	local spellName, name, texture, duration, expirationTime

	for _, spellID in pairs(filter) do
		spellName = GetSpellInfo(spellID)

		if spellName then
			for i = 1, BUFF_MAX_DISPLAY do
				name, _, texture, _, duration, expirationTime = UnitBuff("player", i)

				if spellName == name then
					if duration and expirationTime then
						expirationTime = GetTime() + (expirationTime - duration) + duration
					else
						duration = GetPlayerBuffTimeLeft(i)
						expirationTime = GetTime() + duration
					end

					return true, texture, duration, expirationTime
				end
			end
		end
	end

	return false
end

function RB:UpdateReminderTime(elapsed)
	self.expiration = self.expiration - elapsed

	if self.nextUpdate > 0 then
		self.nextUpdate = self.nextUpdate - elapsed
		return
	end

	if self.expiration <= 0 then
		self.timer:SetText("")
		self:SetScript("OnUpdate", nil)
		return
	end

	local timervalue, formatid
	timervalue, formatid, self.nextUpdate = E:GetTimeInfo(self.expiration, 4)
	self.timer:SetFormattedText(("%s%s|r"):format(E.TimeColors[formatid], E.TimeFormats[formatid][1]), timervalue)
end

function RB:UpdateReminder()
	for i = 1, 6 do
		local hasBuff, texture, duration, expirationTime = self:CheckFilterForActiveBuff(self["Spell" .. i .. "Buffs"], i)
		local button = self.frame[i]
		local reverseStyle = E.db.general.reminder.reverse

		if hasBuff then
			button.t:SetTexture(texture)

			if (duration == 0 and expirationTime == 0) or not E.db.general.reminder.durations then
				button.t:SetAlpha(reverseStyle and 1 or 0.3)
				button:SetScript("OnUpdate", nil)
				button.timer:SetText(nil)
				CooldownFrame_SetTimer(button.cd, 0, 0, 0)
			else
				button.expiration = expirationTime - GetTime()
				button.nextUpdate = 0
				button.t:SetAlpha(1)
				CooldownFrame_SetTimer(button.cd, expirationTime - duration, duration, 1)
				button.cd:SetReverse(reverseStyle)
				button:SetScript("OnUpdate", self.UpdateReminderTime)
			end
		else
			CooldownFrame_SetTimer(button.cd, 0, 0, 0)
			button.t:SetAlpha(reverseStyle and 0.3 or 1)
			button:SetScript("OnUpdate", nil)
			button.timer:SetText(nil)
			button.t:SetTexture(self.DefaultIcons[i])
		end
	end
end

function RB:CreateButton()
	local button = CreateFrame("Button", nil, ElvUI_ReminderBuffs)
	button:SetTemplate("Default")

	button.t = button:CreateTexture(nil, "OVERLAY")
	button.t:SetTexCoord(unpack(E.TexCoords))
	button.t:SetInside()
	button.t:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

	button.cd = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
	button.cd:SetInside()
	button.cd.noOCC = true
	button.cd.noCooldownCount = true

	button.timer = button.cd:CreateFontString(nil, "OVERLAY")
	button.timer:SetPoint("CENTER")

	return button
end

function RB:EnableRB()
	ElvUI_ReminderBuffs:Show()
	self:RegisterEvent("PLAYER_AURAS_CHANGED", "UpdateReminder")
	E.RegisterCallback(self, "RoleChanged", "UpdateSettings")
	self:UpdateReminder()
end

function RB:DisableRB()
	ElvUI_ReminderBuffs:Hide()
	self:UnregisterEvent("PLAYER_AURAS_CHANGED")
	E.UnregisterCallback(self, "RoleChanged", "UpdateSettings")
end

function RB:UpdateSettings(isCallback)
	local frame = self.frame
	frame:Width(E.RBRWidth)

	self:UpdateDefaultIcons()

	for i = 1, 6 do
		local button = frame[i]
		button:ClearAllPoints()
		button:SetWidth(E.RBRWidth)
		button:SetHeight(E.RBRWidth)

		if i == 1 then
			button:Point("TOP", ElvUI_ReminderBuffs, "TOP", 0, 0)
		else
			button:Point("TOP", frame[i - 1], "BOTTOM", 0, E.Border - E.Spacing*3)
		end

		if i == 6 then
			button:Point("BOTTOM", ElvUI_ReminderBuffs, "BOTTOM", 0, 0)
		end

		if E.db.general.reminder.durations then
			button.cd:SetAlpha(1)
		else
			button.cd:SetAlpha(0)
		end

		local font = LSM:Fetch("font", E.db.general.reminder.font)
		button.timer:FontTemplate(font, E.db.general.reminder.fontSize, E.db.general.reminder.fontOutline)
	end

	if not isCallback then
		if E.db.general.reminder.enable then
			RB:EnableRB()
		else
			RB:DisableRB()
		end
	else
		self:UpdateReminder()
	end
end

function RB:UpdatePosition()
	Minimap:ClearAllPoints()
	ElvConfigToggle:ClearAllPoints()
	ElvUI_ReminderBuffs:ClearAllPoints()

	if E.db.general.reminder.position == "LEFT" then
		Minimap:Point("TOPRIGHT", MMHolder, "TOPRIGHT", -E.Border, -E.Border)
		ElvConfigToggle:SetPoint("TOPRIGHT", LeftMiniPanel, "TOPLEFT", E.Border - E.Spacing*3, 0)
		ElvConfigToggle:SetPoint("BOTTOMRIGHT", LeftMiniPanel, "BOTTOMLEFT", E.Border - E.Spacing*3, 0)
		ElvUI_ReminderBuffs:SetPoint("TOPRIGHT", Minimap.backdrop, "TOPLEFT", E.Border - E.Spacing*3, 0)
		ElvUI_ReminderBuffs:SetPoint("BOTTOMRIGHT", Minimap.backdrop, "BOTTOMLEFT", E.Border - E.Spacing*3, 0)
	else
		Minimap:Point("TOPLEFT", MMHolder, "TOPLEFT", E.Border, -E.Border)
		ElvConfigToggle:SetPoint("TOPLEFT", RightMiniPanel, "TOPRIGHT", -E.Border + E.Spacing*3, 0)
		ElvConfigToggle:SetPoint("BOTTOMLEFT", RightMiniPanel, "BOTTOMRIGHT", -E.Border + E.Spacing*3, 0)
		ElvUI_ReminderBuffs:SetPoint("TOPLEFT", Minimap.backdrop, "TOPRIGHT", -E.Border + E.Spacing*3, 0)
		ElvUI_ReminderBuffs:SetPoint("BOTTOMLEFT", Minimap.backdrop, "BOTTOMRIGHT", -E.Border + E.Spacing*3, 0)
	end
end

function RB:UpdateDefaultIcons()
	self.DefaultIcons = {
		[1] = "Interface\\Icons\\INV_Potion_97",
		[2] = "Interface\\Icons\\Spell_Misc_Food",
		[3] = "Interface\\Icons\\Spell_Nature_Regeneration",
		[4] = "Interface\\Icons\\Spell_Magic_GreaterBlessingofKings",
		[5] = (E.Role == "Caster" and "Interface\\Icons\\Spell_Holy_MagicalSentry") or "Interface\\Icons\\Spell_Holy_WordFortitude",
		[6] = (E.Role == "Caster" and "Interface\\Icons\\Spell_Holy_GreaterBlessingofWisdom") or "Interface\\Icons\\Ability_Warrior_BattleShout"
	}

	if E.Role == "Caster" then
		self.Spell5Buffs = self.CasterSpell5Buffs
		self.Spell6Buffs = self.CasterSpell6Buffs
	else
		self.Spell5Buffs = self.MeleeSpell5Buffs
		self.Spell6Buffs = self.MeleeSpell6Buffs
	end
end

function RB:Initialize()
	if not E.private.general.minimap.enable then return end

	self.db = E.db.general.reminder

	local frame = CreateFrame("Frame", "ElvUI_ReminderBuffs", Minimap)
	frame:Width(E.RBRWidth)

	if E.db.general.reminder.position == "LEFT" then
		frame:Point("TOPRIGHT", Minimap.backdrop, "TOPLEFT", E.Border - E.Spacing*3, 0)
		frame:Point("BOTTOMRIGHT", Minimap.backdrop, "BOTTOMLEFT", E.Border - E.Spacing*3, 0)
	else
		frame:Point("TOPLEFT", Minimap.backdrop, "TOPRIGHT", -E.Border + E.Spacing*3, 0)
		frame:Point("BOTTOMLEFT", Minimap.backdrop, "BOTTOMRIGHT", -E.Border + E.Spacing*3, 0)
	end
	self.frame = frame

	for i = 1, 6 do
		frame[i] = self:CreateButton()
		frame[i]:SetID(i)
	end

	self:UpdateSettings()
end

local function InitializeCallback()
	RB:Initialize()
end

E:RegisterModule(RB:GetName(), InitializeCallback)