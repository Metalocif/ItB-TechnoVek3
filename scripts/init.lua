local mod = {
	id = "Meta_TechnoVek3",
	name = "Secret Squad III",
	version = "1.0.0",
	requirements = {},
	dependencies = { --This requests modApiExt from the mod loader
		modApiExt = "1.17", --We can get this by using the variable `modapiext`
	},
	modApiVersion = "2.8.3",
	icon = "img/mod_icon.png"
}

function mod:init()
	require(self.scriptPath .."weapons")
	require(self.scriptPath .."pawns")
end

function mod:load( options, version)
	modApi:addSquad(
		{
			"Secret Squad III",		-- title
			"Meta_TechnoDigger",	-- mech #1
			"Meta_TechnoTumblebug",-- mech #2
			"Meta_TechnoMoth",	-- mech #3
			id="Meta_TechnoVek3"
		},
		"Secret Squad III",
		"The third known attempt to combine Vek and machines. In a desperate bid to protect civilians, these cyborgs raise the earth itself as a makeshift shield.",
		self.resourcePath .."img/mod_icon.png"
	)
end

return mod