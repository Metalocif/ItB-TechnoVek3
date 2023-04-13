local path = GetParentPath(...)
require(path.."palette")
local mod = modApi:getCurrentMod()
local imageOffset = modApi:getPaletteImageOffset(mod.id)

-- this line just gets the file path for your mod, so you can find all your files easily.
local path = mod_loader.mods[modApi.currentMod].resourcePath
	modApi:appendAsset("img/portraits/pilots/Pilot_Meta_TechnoDigger.png", path .."img/portraits/pilots/Pilot_Meta_TechnoDigger.png")
	modApi:appendAsset("img/portraits/pilots/Pilot_Meta_TechnoTumblebug.png", path .."img/portraits/pilots/Pilot_Meta_TechnoTumblebug.png")
	modApi:appendAsset("img/portraits/pilots/Pilot_Meta_TechnoMoth.png", path .."img/portraits/pilots/Pilot_Meta_TechnoMoth.png")
-- locate our mech assets.
local mechPath = path .."img/units/player/"
-- make a list of our files.
local files = {
	"Meta_TechnoDigger.png",
	"Meta_TechnoDiggera.png",
	"Meta_TechnoDigger_w.png",
	"Meta_TechnoDigger_w_broken.png",
	"Meta_TechnoDigger_broken.png",
	"Meta_TechnoDigger_ns.png",
	"Meta_TechnoDigger_h.png",
}
for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/".. file, mechPath .. file)
end
local a=ANIMS
	a.Meta_TechnoDigger =a.MechUnit:new{Image="units/player/Meta_TechnoDigger.png", PosX = -22, PosY = 4}
	a.Meta_TechnoDiggera = a.MechUnit:new{Image="units/player/Meta_TechnoDiggera.png",  PosX = -20, PosY = 4, NumFrames = 4 }
	a.Meta_TechnoDiggerw = a.MechUnit:new{Image="units/player/Meta_TechnoDigger_w.png", -22, PosY = 10}
	a.Meta_TechnoDigger_broken = a.MechUnit:new{Image="units/player/Meta_TechnoDigger_broken.png", PosX = -22, PosY = 4 }
	a.Meta_TechnoDiggerw_broken = a.MechUnit:new{Image="units/player/Meta_TechnoDigger_w_broken.png", PosX = -20, PosY = 10 }
	a.Meta_TechnoDigger_ns = a.MechIcon:new{Image="units/player/Meta_TechnoDigger_ns.png"}

-- make a list of our files.
local files = {
	"Meta_TechnoTumblebug.png",
	"Meta_TechnoTumblebuga.png",
	"Meta_TechnoTumblebug_w.png",
	"Meta_TechnoTumblebug_w_broken.png",
	"Meta_TechnoTumblebug_broken.png",
	"Meta_TechnoTumblebug_ns.png",
	"Meta_TechnoTumblebug_h.png",
}
for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/".. file, mechPath .. file)
end
local a=ANIMS
	a.Meta_TechnoTumblebug =	a.MechUnit:new{Image = "units/player/Meta_TechnoTumblebug.png", PosX = -21, PosY = -3}
	a.Meta_TechnoTumblebuga =	a.MechUnit:new{Image = "units/player/Meta_TechnoTumblebuga.png", PosX = -21, PosY = -3, NumFrames = 4 }
	a.Meta_TechnoTumblebugw =	a.MechUnit:new{Image = "units/player/Meta_TechnoTumblebug_w.png", PosX = -19, PosY = 6 }
	a.Meta_TechnoTumblebug_broken = a.MechUnit:new{Image="units/player/Meta_TechnoTumblebug_broken.png", PosX = -21, PosY = -3 }
	a.Meta_TechnoTumblebugw_broken = a.MechUnit:new{Image="units/player/Meta_TechnoTumblebug_w_broken.png", PosX = -19, PosY = 6 }
	a.Meta_TechnoTumblebug_ns = a.MechIcon:new{Image="units/player/Meta_TechnoTumblebug_ns.png"}

local files = {
	"Meta_TechnoMoth.png",
	"Meta_TechnoMotha.png",
	"Meta_TechnoMoth_w.png",
	"Meta_TechnoMoth_w_broken.png",
	"Meta_TechnoMoth_broken.png",
	"Meta_TechnoMoth_ns.png",
	"Meta_TechnoMoth_h.png",
}
for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/".. file, mechPath .. file)
end
local a = ANIMS
a.Meta_TechnoMoth = a.MechUnit:new{Image="units/player/Meta_TechnoMoth.png", PosX = -17, PosY = -19, Height = 3}
a.Meta_TechnoMotha = a.MechUnit:new{Image="units/player/Meta_TechnoMotha.png", PosX = -25, PosY = -22, NumFrames = 6 }
-- a.Meta_TechnoMothw = a.MechUnit:new{Image="unitsplayer/Meta_TechnoMoth_w.png", PosX = -24, PosY = 6 }
a.Meta_TechnoMoth_broken = a.MechUnit:new{Image="units/player/Meta_TechnoMoth_broken.png", PosX = -22, PosY = -10 }
a.Meta_TechnoMothw_broken = a.MechUnit:new{Image="units/player/Meta_TechnoMoth_w_broken.png", PosX = -22, PosY = 6}
a.Meta_TechnoMoth_ns = a.MechIcon:new{Image="units/player/Meta_TechnoMoth_ns.png"}

CreatePilot{
	Id = "Pilot_Meta_TechnoDigger",
	Personality = "Vek",
	Sex = SEX_VEK,
	Skill = "Survive_Death",
	Rarity = 0,
	Blacklist = {"Invulnerable", "Popular"},
}
CreatePilot{
	Id = "Pilot_Meta_TechnoTumblebug",
	Personality = "Vek",
	Sex = SEX_VEK,
	Skill = "Survive_Death",
	Rarity = 0,
	Blacklist = {"Invulnerable", "Popular"},
}
CreatePilot{
	Id = "Pilot_Meta_TechnoMoth",
	Personality = "Vek",
	Sex = SEX_VEK,
	Skill = "Survive_Death",
	Rarity = 0,
	Blacklist = {"Invulnerable", "Popular"},
}

-- we can make a mech based on another mech much like we did with weapons.
Meta_TechnoDigger = Pawn:new{
	Name = "Techno-Digger",

	Class = "TechnoVek",

	Health = 3,
	MoveSpeed = 4,
	Massive = true,
	Corpse = true,

	Image = "Meta_TechnoDigger",

	-- ImageOffset specifies which color scheme we will be using.
	-- (only apporpirate if you draw your mechs with Archive olive green colors)
	ImageOffset = 8,

	-- Any weapons this mech should start with goes in this table.
	SkillList = {"Meta_TechnoDiggerWeapon"},

	-- movement sounds.
	SoundLocation = "/enemy/leaper_2/",

	-- who will be controlling this unit.
	DefaultTeam = TEAM_PLAYER,

	-- impact sounds.
	ImpactMaterial = IMPACT_INSECT,

}
AddPawn("Meta_TechnoDigger")

Meta_TechnoTumblebug = Pawn:new{
	Name = "Techno-Tumblebug",
	Class = "TechnoVek",
	Health = 3,
	MoveSpeed = 4,
	Massive = true,
	Corpse = true,

	-- reference the animations we set up earlier.
	Image = "Meta_TechnoTumblebug",

	-- ImageOffset specifies which color scheme we will be using.
	-- (only apporpirate if you draw your mechs with Archive olive green colors)
	ImageOffset = 8,

	-- Any weapons this mech should start with goes in this table.
	SkillList = {"Meta_TechnoTumblebugWeapon"},

	-- movement sounds.
	SoundLocation = "/enemy/centipede_2/",

	-- who will be controlling this unit.
	DefaultTeam = TEAM_PLAYER,

	-- impact sounds.
	ImpactMaterial = IMPACT_INSECT,
}
AddPawn("Meta_TechnoTumblebug")

Meta_TechnoMoth = Pawn:new{
	Name = "Techno-Moth",
	Class = "TechnoVek",
	Health = 2,
	MoveSpeed = 3,
	Massive = true,
	Corpse = true,
    Flying=true,

	-- reference the animations we set up earlier.
	Image = "Meta_TechnoMoth",

	-- ImageOffset specifies which color scheme we will be using.
	-- (only apporpirate if you draw your mechs with Archive olive green colors)
	ImageOffset = 8,

	-- Any weapons this mech should start with goes in this table.
	SkillList = {"Meta_TechnoMothWeapon"},

	-- movement sounds.
	SoundLocation = "/enemy/jelly/",

	-- who will be controlling this unit.
	DefaultTeam = TEAM_PLAYER,

	-- impact sounds.
	ImpactMaterial = IMPACT_INSECT,

}
AddPawn("Meta_TechnoMoth")