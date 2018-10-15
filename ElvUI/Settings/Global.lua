local E, L, V, P, G = unpack(ElvUI)

G["general"] = {
	["autoScale"] = true,
	["minUiScale"] = 0.64,
	["eyefinity"] = false,
	["smallerWorldMap"] = true,
	["WorldMapCoordinates"] = {
		["enable"] = true,
		["position"] = "BOTTOMLEFT",
		["xOffset"] = 0,
		["yOffset"] = 0
	}
}

G["classCache"] = {}

G["classtimer"] = {}

G["nameplates"] = {}

G["chat"] = {
	["classColorMentionExcludedNames"] = {}
}

G["bags"] = {
	["ignoredItems"] = {}
}

G["unitframe"] = {
	["aurafilters"] = {},
	["buffwatch"] = {},
	["raidDebuffIndicator"] = {
		["instanceFilter"] = "RaidDebuffs",
		["otherFilter"] = "CCDebuffs",
	},
	["spellRangeCheck"] = {
		["PRIEST"] = {
			["enemySpells"] = {
				[585] = true, -- Smite (30 yards)
			},
			["longEnemySpells"] = {
				[589] = true, -- Shadow Word: Pain (30 yards)
			},
			["friendlySpells"] = {
				[2050] = true, -- Lesser Heal (40 yards)
			},
			["resSpells"] = {
				[2006] = true, -- Resurrection (30 yards)
			},
			["petSpells"] = {},
		},
		["DRUID"] = {
			["enemySpells"] = {
				[33786] = true, -- Cyclone (20 yards)
			},
			["longEnemySpells"] = {
				[5176] = true, -- Wrath (30 yards)
			},
			["friendlySpells"] = {
				[5185] = true, -- Healing Touch (40 yards)
			},
			["resSpells"] = {
				[20484] = true, -- Rebirth (30 yards)
			},
			["petSpells"] = {},
		},
		["PALADIN"] = {
			["enemySpells"] = {
				[20271] = true, -- Judgement (10 yards)
			},
			["longEnemySpells"] = {
				[879] = true, -- Exorcism (30 yards)
			},
			["friendlySpells"] = {
				[635] = true, -- Holy Light (40 yards)
			},
			["resSpells"] = {
				[7328] = true, -- Redemption (30 yards)
			},
			["petSpells"] = {},
		},
		["SHAMAN"] = {
			["enemySpells"] = {
				[8042] = true, -- Earth Shock (20 yards)
			},
			["longEnemySpells"] = {
				[403] = true, -- Lightning Bolt (30 yards)
			},
			["friendlySpells"] = {
				[331] = true, -- Healing Wave (40 yards)
			},
			["resSpells"] = {
				[2008] = true, -- Ancestral Spirit (30 yards)
			},
			["petSpells"] = {},
		},
		["WARLOCK"] = {
			["enemySpells"] = {
				[5782] = true, -- Fear (20 yards)
			},
			["longEnemySpells"] = {
				[686] = true, -- Shadow Bolt (30 yards)
			},
			["friendlySpells"] = {
				[5697] = true, -- Unending Breath (30 yards)
			},
			["resSpells"] = {},
			["petSpells"] = {
				[755] = true, -- Health Funnel (20 yards)
			},
		},
		["MAGE"] = {
			["enemySpells"] = {
				[2136] = true, -- Fire Blast (20 yards)
				[12826] = true, -- Polymorph (30 yards)
			},
			["longEnemySpells"] = {
				[133] = true, -- Fireball (35 yards)
			},
			["friendlySpells"] = {
				[475] = true, -- Remove Curse (40 yards)
			},
			["resSpells"] = {},
			["petSpells"] = {},
		},
		["HUNTER"] = {
			["enemySpells"] = {
				[75] = true, -- Auto Shot (35 yards)
			},
			["longEnemySpells"] = {},
			["friendlySpells"] = {},
			["resSpells"] = {},
			["petSpells"] = {
				[136] = true, -- Mend Pet (45 yards)
			},
		},
		["ROGUE"] = {
			["enemySpells"] = {
				[2094] = true, -- Blind (10 yards)
			},
			["longEnemySpells"] = {
				[26679] = true, -- Deadly Throw (30 yards)
			},
			["friendlySpells"] = {},
			["resSpells"] = {},
			["petSpells"] = {},
		},
		["WARRIOR"] = {
			["enemySpells"] = {
				[5246] = true, -- Intimidating Shout (10 yards)
			},
			["longEnemySpells"] = {
				[100] = true, -- Charge (25 yards)
			},
			["friendlySpells"] = {
				[3411] = true, -- Intervene (25 yards)
			},
			["resSpells"] = {},
			["petSpells"] = {},
		}
	}
}

G["profileCopy"] = {
	--Specific values
	["selected"] = "Minimalistic",
	["movers"] = {},
	--Modules
	["actionbar"] = {
		["general"] = true,
		["bar1"] = true,
		["bar2"] = true,
		["bar3"] = true,
		["bar4"] = true,
		["bar5"] = true,
		["bar6"] = true,
		["barPet"] = true,
		["barShapeShift"] = true,
		["microbar"] = true,
		["cooldown"] = true
	},
	["auras"] = {
		["general"] = true,
		["cooldown"] = true
	},
	["bags"] = {
		["general"] = true,
		["split"] = true,
		["vendorGrays"] = true,
		["bagBar"] = true,
		["cooldown"] = true
	},
	["chat"] = {
		["general"] = true
	},
	["cooldown"] = {
		["general"] = true,
		["fonts"] = true
	},
	["databars"] = {
		["experience"] = true,
		["reputation"] = true
	},
	["datatexts"] = {
		["general"] = true,
		["panels"] = true
	},
	["nameplates"] = {
		["general"] = true,
		["reactions"] = true,
		["units"] = {
			["FRIENDLY_PLAYER"] = true,
			["ENEMY_PLAYER"] = true,
			["FRIENDLY_NPC"] = true,
			["ENEMY_NPC"] = true
		}
	},
	["tooltip"] = {
		["general"] = true,
		["visibility"] = true,
		["healthBar"] = true
	},
	["unitframes"] = {
		["general"] = true,
		["cooldown"] = true,
		["colors"] = {
			["general"] = true,
			["power"] = true,
			["reaction"] = true,
			["healPrediction"] = true,
			["classResources"] = true,
			["frameGlow"] = true,
			["debuffHighlight"] = true
		},
		["units"] = {
			["player"] = true,
			["target"] = true,
			["targettarget"] = true,
			["targettargettarget"] = true,
			["focus"] = true,
			["focustarget"] = true,
			["pet"] = true,
			["pettarget"] = true,
			["arena"] = true,
			["party"] = true,
			["raid"] = true,
			["raid40"] = true,
			["raidpet"] = true,
			["tank"] = true,
			["assist"] = true
		}
	}
}