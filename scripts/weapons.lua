-- To do:
-- o fix Moth preview images
-- o Digger shouldn't burrow if on water

--------
--Moth--
--------
local resourcePath = mod_loader.mods[modApi.currentMod].resourcePath
modApi:appendAsset("img/weapons/ranged_mothweapon.png", resourcePath.."img/weapons/ranged_mothweapon.png")
modApi:appendAsset("img/effects/upshot_bombrock.png", resourcePath.."img/effects/upshot_bombrock.png")

Meta_TechnoMothWeapon = LineArtillery:new{
	Name = "Repulsive Pellets",
	Description = "Launch an artillery attack. The Moth's wings also push everything adjacent to it.",
	Class = "TechnoVek",
	Icon = "weapons/ranged_mothweapon.png",
	Rarity = 3,
	UpShot = "effects/shotup_crab1.png",
	BuildingDamage = true,
	PowerCost = 0, --AE Change
	Damage = 1,
	Upgrades = 2,
	UpgradeCost = {2,3},
	UpgradeList = { "Reposition", "+2 Damage"  },
	ImpactSound = "/enemy/moth_1/attack_impact",
	LaunchSound = "/enemy/moth_1/attack_launch",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		--Fire = Point(2,2),
		Enemy2 = Point(2,4),
		--Enemy3 = Point(2,1),
		Target = Point(2,1),
		Mountain = Point(2,2),
		CustomPawn = "Meta_TechnoMoth"
	}
}

--get target area1: if twoclick, is limited to movespeed, second target area is normal artillery that starts from p2

function Meta_TechnoMothWeapon:GetTargetArea(point)
	local ret = PointList()
	if self.TwoClick then
		ret:push_back(point)
		for dir = DIR_START, DIR_END do
			for k = 3, Board:GetPawn(point):GetMoveSpeed() do
				local curr = point + DIR_VECTORS[dir] * k
				if not Board:IsBlocked(curr,PATH_PROJECTILE) then ret:push_back(curr) end
			end
		end
	else
		for dir = DIR_START, DIR_END do
			for i = 2, 8 do
				local curr = Point(point + DIR_VECTORS[dir] * i)
				if not Board:IsValid(curr) then break end
				ret:push_back(curr)
			end
		end
	end
	return ret
end

function Meta_TechnoMothWeapon:GetSecondTargetArea(p1, p2)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		for i = 2, 8 do
			local curr = Point(p2 + DIR_VECTORS[dir] * i)
			if not Board:IsValid(curr) then break end
			ret:push_back(curr)
		end
	end
	return ret
end

function Meta_TechnoMothWeapon:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	
	ret:AddBounce(p1, 1)

	local damage = SpaceDamage(p2,self.Damage)
	damage.sAnimation = "ExploArt2"
	ret:AddArtillery(damage, self.UpShot)
	
	for dir = DIR_START, DIR_END do
		damage = SpaceDamage(p1 + DIR_VECTORS[dir], 0, dir)
		damage.sAnimation = "airpush_"..dir
		ret:AddDamage(damage)
	end
	ret:AddBounce(p2, 2)
	
	return ret
end

function Meta_TechnoMothWeapon:GetFinalEffect(p1,p2,p3)
	local ret = SkillEffect()
	if p1 ~= p2 then
		for dir = DIR_START, DIR_END do
			damage = SpaceDamage(p1 + DIR_VECTORS[dir], 0, dir)
			damage.sAnimation = "airpush_"..dir
			ret:AddDamage(damage)
		end
		local move = PointList()
		move:push_back(p1)
		move:push_back(p2)
		ret:AddBounce(p1, 1)
		ret:AddLeap(move,FULL_DELAY)
	end
	for dir = DIR_START, DIR_END do
		damage = SpaceDamage(p2 + DIR_VECTORS[dir], 0, dir)
		damage.sAnimation = "airpush_"..dir
		ret:AddDamage(damage)
	end
	local damage = SpaceDamage(p3,self.Damage)
	damage.sAnimation = "ExploArt2"
	ret:AddArtillery(p2, damage, self.UpShot)
	
	
	ret:AddBounce(p3, 2)
	
	return ret
end

Meta_TechnoMothWeapon_A = Meta_TechnoMothWeapon:new{
	TwoClick = true,
	UpgradeDescription = "Before firing, can also reposition to another tile, pushing things from both starting and landing tile.",
	TipImage = {
		Unit = Point(1,3),
		Target = Point(3,3),
		Mountain = Point(3,2),
		Enemy = Point(3,0),
		Second_Click = Point(3,0),
		-- Second_Target = Point(3,0),
		CustomPawn = "Meta_TechnoMoth",
	}
}

Meta_TechnoMothWeapon_B = Meta_TechnoMothWeapon:new{
	Damage = 3,
	UpgradeDescription = "Increases damage by 2.",
}
			
Meta_TechnoMothWeapon_AB = Meta_TechnoMothWeapon:new{
	Damage = 3,
	TwoClick = true,
	TipImage = {
		Unit = Point(1,3),
		Target = Point(3,3),
		Mountain = Point(3,2),
		Enemy = Point(3,0),
		Second_Click = Point(3,0),
		-- Second_Target = Point(3,0),
		CustomPawn = "Meta_TechnoMoth",
	}
}

----------
--Digger--
----------

Meta_TechnoDiggerWeapon = Skill:new{
	Name = "Digging Tusks",
	Description = "Dig up rocks on all adjacent empty tiles. Strike nonempty tiles for 1 damage. Buildings are safe.",
	Class = "TechnoVek",
	Icon = "weapons/enemy_rocker1.png",
	Rarity = 3,
	PowerCost = 0, --AE Change
	Damage = 1,
	Range  = 1,
	Upgrades = 2,
	UpgradeCost = {1,2},
	UpgradeList = { "Hard Rocks", "Shrapnel"  },
	ToSpawn = "Wall",
	Shrapnel = false,
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Enemy2 = Point(2,3),
		Enemy3 = Point(1,1),
		Enemy4 = Point(1,0),
		Target = Point(2,1),
		Water = Point(3,2),
		Building = Point(1,2),
		CustomEnemy = "Wall",
		CustomPawn = "Meta_TechnoDigger"
	}
}

function Meta_TechnoDiggerWeapon:GetTargetArea(point)
	local ret = PointList()
	ret:push_back(point)
	for i = DIR_START, DIR_END do
		ret:push_back(DIR_VECTORS[i] + point)
	end
	return ret
end

function Meta_TechnoDiggerWeapon:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	
	for dir = DIR_START, DIR_END do
		local curr = p1 + DIR_VECTORS[dir]
		local damage = SpaceDamage(curr)
		if not Board:IsBlocked(curr,PATH_PROJECTILE) and Board:GetTerrain(curr) ~= TERRAIN_WATER and not Board:IsPod(curr) then
			
			damage.sPawn = self.ToSpawn
			-- damage.sSound = "/enemy/"..self.SoundId.."/attack_queued"
			ret:AddDamage(damage)
		elseif Board:GetTerrain(curr) ~= TERRAIN_BUILDING then 
			damage.iDamage = self.Damage
			damage.sAnimation = "explorocker_"..dir
			-- damage.sSound = "/enemy/"..self.SoundId.."/attack"
			ret:AddDamage(damage)
		end
		
		
	end	
	if not self.Shrapnel then return ret end
	-- ret:AddDelay(0.25)
	--check for rocks and do shrapnel
	for dir = DIR_START, DIR_END do
		local curr = p1 + DIR_VECTORS[dir]
		if Board:GetPawn(curr) and _G[Board:GetPawn(curr):GetType()].ImpactMaterial == IMPACT_ROCK and (curr == p2 or p1 == p2) then
		--we only fire shrapnel if the rock is targeted or the Digger is targeted
			for dir2 = DIR_START, DIR_END do
				if curr + DIR_VECTORS[dir2] ~= p1 then ret:AddDamage(SpaceDamage(curr + DIR_VECTORS[dir2], 2)) end
				--needs an animation but that will do for now
			end
		end
	end
	return ret
end

Meta_TechnoDiggerWeapon_A = Meta_TechnoDiggerWeapon:new{
	ToSpawn = "Wall2",
	UpgradeDescription = "Digs harder rocks. They  have one more HP and deal 2 more damage when tossed by the Tumblebug."
}

Meta_TechnoDiggerWeapon_B = Meta_TechnoDiggerWeapon:new{
	Shrapnel = true,
	UpgradeDescription = "Hitting rocks damages them and adjacent things. Can either affect a single rock or all adjacent rocks."
}
			
Meta_TechnoDiggerWeapon_AB = Meta_TechnoDiggerWeapon:new{
	ToSpawn = "Wall2",
	Shrapnel = true,
}

Wall2 = 
	{
		Name = "Rock",
		Health = 2,
		Neutral = true,
		MoveSpeed = 0,
		IsPortrait = false,
		Image = "rock1",
		SoundLocation = "/support/rock/",
		DefaultTeam = TEAM_NONE,
		ImpactMaterial = IMPACT_ROCK
	}
AddPawn("Wall2") 

--Tumblebug artillery: 
--You can target things beyond something so it's not a two-click and it instead auto-selects the first thing in the line, so to speak
--This deals one damage to the rock, it acts like the rock artillery, pushing sides
--Wall1 deals 2, Wall2 deals 4, BombRock deals 5

-------------
--Tumblebug--
-------------

Meta_TechnoTumblebugWeapon = Skill:new{
	Name = "Mineral Prize",
	Self = "Meta_TechnoTumblebugWeapon",
	Description = "Dig up a rock, then toss an adjacent target.",
	Class = "TechnoVek",
	Icon = "weapons/prime_rock.png",	--unused sprite afaict
	Rarity = 3,
	UpShot = "effects/shotup_ignite_fireball.png",
	PowerCost = 0, --AE Change
	Damage = 1,
	Range = 3,
	TwoClick = true,
	Upgrades = 2,
	UpgradeCost = {1,2},
	UpgradeList = { "Explosive Rocks", "Free Throw"  },
	ToSpawn = "Wall",
	LaunchSound = "/weapons/fireball",
	ImpactSound = "/props/fire_damage",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Target = Point(3,3),
		Second_Click = Point(2,0),
		Mountain = Point(2,1),
		CustomPawn = "Meta_TechnoTumblebug",
	}
}

function Meta_TechnoTumblebugWeapon:GetTargetArea(point)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		local curr = point + DIR_VECTORS[i]
		if not Board:IsBlocked(curr, PATH_GROUND) then ret:push_back(curr) end	
		if not Board:IsBlocked(curr, PATH_GROUND) or (Board:GetPawn(curr) and not Board:GetPawn(curr):IsGuarding()) then
			for k = 2, 7 do
				local curr2 = point + DIR_VECTORS[i] * k
				if not Board:IsValid(curr2) then break end
				if Board:GetPawn(curr) or not Board:IsBlocked(curr, PATH_GROUND) then
					if not Board:IsBlocked(curr, PATH_GROUND) or _G[Board:GetPawn(curr):GetType()].ImpactMaterial == IMPACT_ROCK then
						ret:push_back(curr2)
						--we can toss rocks on things as well, damaging them
						--second condition is because we'd spawn a rock on a ground tile, then toss it
					else
						if not Board:IsBlocked(curr2, PATH_PROJECTILE) then ret:push_back(curr2) end
						--we can toss pawns on empty tiles only
					end
				end
			end
		end
	end
	--can target adjacent spaces if empty&passable or pawn
	--can target spaces in a line 3+ tiles away if first thing is a pawn or empty
	
	return ret
end

function Meta_TechnoTumblebugWeapon:GetSecondTargetArea(p1, p2)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		local curr = p1 + DIR_VECTORS[i]
		if not Board:IsBlocked(curr, PATH_GROUND) then ret:push_back(curr) end
		if Board:GetPawn(curr) and not Board:GetPawn(curr):IsGuarding() then --and _G[Board:GetPawn(curr):GetType()].ImpactMaterial == IMPACT_ROCK then
			for j = 2, 7 do
				local curr2 = p1 + DIR_VECTORS[i] * j
				if _G[Board:GetPawn(curr):GetType()].ImpactMaterial == IMPACT_ROCK or not Board:IsBlocked(curr2, PATH_PROJECTILE) then ret:push_back(curr2) end
			end
		end
	end
	return ret
end

function Meta_TechnoTumblebugWeapon:IsTwoClickException(p1,p2)
	-- if p1:Manhattan(p2) > 1 then return true end	--if first click is a toss, we can't do anything else
	local direction = GetDirection(p2-p1)
	if self.FreeThrow and Board:GetPawn(p1 + DIR_VECTORS[direction]) and _G[Board:GetPawn(p1 + DIR_VECTORS[direction]):GetType()].ImpactMaterial == IMPACT_ROCK then return false end
	-- if not Board:IsBlocked(p2, PATH_PROJECTILE) then return false end	--we only do two click weapon stuff if there is a pawn in p2
	if p1:Manhattan(p2) > 1 then return true end
	return false
end

function Meta_TechnoTumblebugWeapon:TossStuff(ret, p1, p2)
	local direction = GetDirection(p2-p1)
	if p1:Manhattan(p2) == 1 and not Board:GetPawn(p2) then	
	--just spawning a rock
		local damage = SpaceDamage(p2, 0)
		damage.sPawn = self.ToSpawn
		ret:AddMelee(p1,damage)
		ret:AddDelay(0.5)
	elseif Board:GetPawn(p1 + DIR_VECTORS[direction]) and not _G[Board:GetPawn(p1 + DIR_VECTORS[direction]):GetType()].ImpactMaterial == IMPACT_ROCK then
	--yeeting a non-rock pawn
		local fake_punch = SpaceDamage(p1 + DIR_VECTORS[direction],0)
		ret:AddMelee(p1,fake_punch)
		local move = PointList()
		move:push_back(p1+DIR_VECTORS[direction])
		move:push_back(p2)
		ret:AddLeap(move, FULL_DELAY)
		ret:AddDamage(SpaceDamage(p2, 1))
	elseif Board:GetPawn(p1 + DIR_VECTORS[direction]) then
	--yeeting an existing rock
		local fake_punch = SpaceDamage(p1 + DIR_VECTORS[direction],0)
		ret:AddMelee(p1,fake_punch)
		if not Board:IsBlocked(p2, PATH_PROJECTILE) then
			local move = PointList()
			move:push_back(p1+DIR_VECTORS[direction])
			move:push_back(p2)
			ret:AddLeap(move, FULL_DELAY)
			ret:AddDamage(SpaceDamage(p2, 1))
		else
			local rockID = Board:GetPawn(p1 + DIR_VECTORS[direction]):GetId()
			local damage = SpaceDamage(p2, Board:GetPawn(rockID):GetMaxHealth() * 2)
			if Board:GetPawn(rockID):IsFire() then damage.iFire = EFFECT_CREATE end
			if Board:GetPawn(rockID):IsAcid() then damage.iAcid = EFFECT_CREATE end
			ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(Point(-1, -1))", Point(p1 + DIR_VECTORS[direction]):GetString()))
			if _G[Board:GetPawn(rockID):GetType()].Explodes then
				damage.iDamage = damage.iDamage + 1 
				damage.sAnimation = "rock2d" 
				ret:AddArtillery(p1 + DIR_VECTORS[direction],damage,"effects/upshot_bombrock.png")
				ret:AddDelay(0.1)
				for dir = DIR_START, DIR_END do
					local exploDamage = SpaceDamage(p2 + DIR_VECTORS[dir], 1)
					exploDamage.sAnimation = "exploout2_"..dir --(dir+2)%4
					ret:AddDamage(exploDamage)
				end
			else
				damage.sAnimation = "rock1d" 
				ret:AddArtillery(p1 + DIR_VECTORS[direction],damage,"effects/shotdown_rock.png")
			end
		end
		ret:AddBounce(p2,3)
		ret:AddDamage(SpaceDamage(p2 + DIR_VECTORS[(direction + 1)%4], 0, (direction + 1)%4))
		ret:AddDamage(SpaceDamage(p2 + DIR_VECTORS[(direction + 3)%4], 0, (direction + 3)%4))
	else
	--spawning and yeeting a rock
		local fake_punch = SpaceDamage(p1 + DIR_VECTORS[direction],0)
		fake_punch.sPawn = self.ToSpawn 
		ret:AddMelee(p1,fake_punch)
		ret:AddDelay(0.5)
		if not Board:IsBlocked(p2, PATH_PROJECTILE) then
			local move = PointList()
			move:push_back(p1+DIR_VECTORS[direction])
			move:push_back(p2)
			ret:AddLeap(move, FULL_DELAY)
			ret:AddDamage(SpaceDamage(p2, 1))
		else
			local damage = SpaceDamage(p2, 2)
			if Board:IsFire(p1 + DIR_VECTORS[direction]) then damage.iFire = EFFECT_CREATE end
			if Board:IsAcid(p1 + DIR_VECTORS[direction]) then damage.iAcid = EFFECT_CREATE end
			ret:AddScript(string.format("Board:GetPawn(%s):SetSpace(Point(-1, -1))", Point(p1 + DIR_VECTORS[direction]):GetString()))
			if self.ToSpawn == "BombRock" then
				damage.iDamage = damage.iDamage + 1 
				damage.sAnimation = "rock2d" 
				ret:AddArtillery(p1 + DIR_VECTORS[direction],damage,"effects/upshot_bombrock.png")
				ret:AddDelay(0.1)
				for dir = DIR_START, DIR_END do
					local exploDamage = SpaceDamage(p2 + DIR_VECTORS[dir], 1)
					exploDamage.sAnimation = "exploout2_"..dir --(dir+2)%4
					ret:AddDamage(exploDamage)
				end
			else
				damage.sAnimation = "rock1d" 
				ret:AddArtillery(p1 + DIR_VECTORS[direction],damage,"effects/shotdown_rock.png")
			end
		end
		ret:AddBounce(p2,3)
		ret:AddDamage(SpaceDamage(p2 + DIR_VECTORS[(direction + 1)%4], 0, (direction + 1)%4))
		ret:AddDamage(SpaceDamage(p2 + DIR_VECTORS[(direction + 3)%4], 0, (direction + 3)%4))
	end
	return ret
end



function Meta_TechnoTumblebugWeapon:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	self:TossStuff(ret, p1, p2)
	return ret
end

function Meta_TechnoTumblebugWeapon:GetFinalEffect(p1,p2,p3)
	local ret = SkillEffect()
	self:TossStuff(ret, p1, p2)
	self:TossStuff(ret, p1, p3)
	return ret
end

Meta_TechnoTumblebugWeapon_A = Meta_TechnoTumblebugWeapon:new{
	ToSpawn = "BombRock",
	UpgradeDescription = "Digs up explosive rocks. They deal extra damage if thrown on top of units.",
	Self = "Meta_TechnoTumblebugWeapon_A",
}

Meta_TechnoTumblebugWeapon_B = Meta_TechnoTumblebugWeapon:new{
	FreeThrow = true,
	UpgradeDescription = "If the target is an existing rock, a secondary target can be selected.",
	Self = "Meta_TechnoTumblebugWeapon_B",
}
			
Meta_TechnoTumblebugWeapon_AB = Meta_TechnoTumblebugWeapon:new{
	ToSpawn = "BombRock",
	FreeThrow = true,
	Self = "Meta_TechnoTumblebugWeapon_AB",
}