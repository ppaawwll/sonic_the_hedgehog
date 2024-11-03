SonicCharacterMod = RegisterMod("sonic_the_hedgehog", 1)

require("scripts.lib.jumplib").Init()

costumes = {
	SONIC_HEAD = Isaac.GetCostumeIdByPath("gfx/characters/costume_sonichead.anm2")
}

PawlExperimentItems = {
	COLLECTIBLE_SONICJUMP = Isaac.GetItemIdByName("Spinjump")
}


function SonicCharacterMod:onCache(player, cacheFlag)
	local playerData = player:GetData()
	if player:GetName() == "Sonic" then -- Especially here!
		-- player.Damage = player.Damage + CartoonCry.DAMAGE
		-- if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
			-- player.ShotSpeed = player.ShotSpeed + Moonwalker.SHOTSPEED
		-- end
		-- if cacheFlag == CacheFlag.CACHE_RANGE then
			-- player.TearHeight = player.TearHeight - Moonwalker.TEARHEIGHT
			-- player.TearFallingSpeed = player.TearFallingSpeed + Moonwalker.TEARFALLINGSPEED
		-- end
		if cacheFlag == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + 0.75
			print(player.MoveSpeed)
			-- store the uncapped speed
			playerData.UncappedSpeed = player.MoveSpeed
		end
		-- if cacheFlag == CacheFlag.CACHE_LUCK then
			-- player.Luck = player.Luck + Moonwalker.LUCK
		-- end
		-- player.MaxFireDelay = player.MaxFireDelay + CartoonCry.FIREDELAY
		-- if cacheFlag == CacheFlag.CACHE_FLYING and Orcane.FLYING then
			-- player.CanFly = true
		-- end
		-- if cacheFlag == CacheFlag.CACHE_TEARFLAG then
			-- player.TearFlags = player.TearFlags | Orcane.TEARFLAG
		-- end
		-- if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
			-- player.TearColor = Orcane.TEARCOLOR
		-- end
	end
end

SonicCharacterMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, SonicCharacterMod.onCache)

local function onPlayerUpdate(_, player)
	local playerData = player:GetData()
	if player:GetName() == "Sonic" then -- Especially here!
		-- player.Damage = player.Damage + CartoonCry.DAMAGE
		-- if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
			-- player.ShotSpeed = player.ShotSpeed + Moonwalker.SHOTSPEED
		-- end
		-- if cacheFlag == CacheFlag.CACHE_RANGE then
			-- player.TearHeight = player.TearHeight - Moonwalker.TEARHEIGHT
			-- player.TearFallingSpeed = player.TearFallingSpeed + Moonwalker.TEARFALLINGSPEED
		-- end
		-- if cacheFlag == CacheFlag.CACHE_SPEED then
		if playerData.UncappedSpeed ~= nil then
			player.MoveSpeed = math.min(playerData.UncappedSpeed,2.5)
		end
		-- end
		-- if cacheFlag == CacheFlag.CACHE_LUCK then
			-- player.Luck = player.Luck + Moonwalker.LUCK
		-- end
		-- player.MaxFireDelay = player.MaxFireDelay + CartoonCry.FIREDELAY
		-- if cacheFlag == CacheFlag.CACHE_FLYING and Orcane.FLYING then
			-- player.CanFly = true
		-- end
		-- if cacheFlag == CacheFlag.CACHE_TEARFLAG then
			-- player.TearFlags = player.TearFlags | Orcane.TEARFLAG
		-- end
		-- if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
			-- player.TearColor = Orcane.TEARCOLOR
		-- end
	end
end

local function onRender()	

end

local function onPlayerInit(_, player)
	local playerData = player:GetData()
	if player:GetName() == "Sonic" then
		-- player:AddCollectible(PawlExperimentItems.COLLECTIBLE_ADRENALINERUSH, 0, false)
		-- player:AddCollectible(PawlExperimentItems.COLLECTIBLE_TECHCRAFTER, 0, false, 2)	
		player:SetPocketActiveItem(PawlExperimentItems.COLLECTIBLE_SONICJUMP, ActiveSlot.SLOT_POCKET, false)
		player:AddNullCostume(costumes.SONIC_HEAD)
		-- player:AddNullCostume(costumes.CLEM_DOGHAIR)
		-- local itemConfig = Isaac.GetItemConfig()
		-- local itemConfigItem = itemConfig:GetCollectible(CollectibleType.COLLECTIBLE_PHD)
		-- player:RemoveCostume(itemConfigItem)
	end
end

local function onPlayerRender(_, player)
	local playerData = player:GetData()
end

local function getGlobalSonicJumpConfig()
	return {
		Height = 10.2,
		Speed = 1.25,
		Tags = "SonicCharacterMod_SpinJump",
		Flags = JumpLib.Flags.DAMAGE_CUSTOM
	}
end


local function onPlayerUpdate2(_, player)
	local playerData = player:GetData()
	local jumpData = JumpLib:GetData(player)
	-- if playerData.superSpeed == nil then
		-- playerData.superSpeed = true
	-- end
	-- if playerData.superSpeed == true then
		-- playerData.superSpeed = false
		-- player:Update()
	-- else
		-- playerData.superSpeed = true
	-- end
	
	-- if the game's paused dont do shit!!
	-- TODO: put this in its own "evaluateSpinjumpSprite()" function
	if not playerData.SonicBallSprite then
		playerData.SonicBallSprite = Sprite()
		playerData.SonicBallSprite:Load("gfx/characters/sprite_sonic_ball.anm2")
		if player:GetName() == "Sonic" then
			playerData.SonicBallSprite:ReplaceSpritesheet(0, "gfx/characters/sonic_spinball_sonic.png")
			playerData.SonicBallSprite:LoadGraphics()
		end
		-- playerData.SonicBallSprite:Play("Idle", true)
		print("oenis")
	end
	
	if playerData.SonicBallSprite ~= nil then
		if player:GetMovementDirection() == playerData.prevMoveDirection then
		 -- look nothing
		elseif player:GetMovementDirection() == Direction.LEFT then
			playerData.SonicBallSprite:Play("Left", true)
		elseif player:GetMovementDirection() == Direction.RIGHT then
			playerData.SonicBallSprite:Play("Right", true)
		else
			playerData.SonicBallSprite:Play("Idle", true)
		end
		playerData.SonicBallSprite.Scale = player.SpriteScale
		if playerData.sonicBallUpdate == nil then
		playerData.sonicBallUpdate = true
		end
		if playerData.sonicBallUpdate == true then
			playerData.sonicBallUpdate = false
			-- player:Update()
			playerData.SonicBallSprite:Update()
		else
			playerData.sonicBallUpdate = true
		end
		-- playerData.SonicBallSprite:Update()
	end
	
	playerData.prevMoveDirection = player:GetMovementDirection()
	
	if playerData.alreadyFlying == nil then
		playerData.alreadyFlying = false
	end
	
	-- TODO: add horizontal spindashing (done by aiming and then using the spin jump/attack active item)
	
	if not Game():IsPaused() then
		if jumpData.Jumping then
			-- so we only collide with room walls like we're flying, and only with enemies to bounce on them
			-- if not playerData.alreadyFlying then
				-- player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			-- end
			player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
			-- bigger hitsphere size so its funner to bounce on things
			-- TODO: make this scale with size downs
			player.Size = 20
			
			-- gets the gridentity currently below the player
			local gridUnder = Game():GetRoom():GetGridEntityFromPos(player.Position)
			
			-- if there's something under us and it's poop (TODO: add bouncing on TNT as well) and it's destroyed (state 1000 for some reason), and we're low enough to bounce on it, do that
			if gridUnder ~= nil and (gridUnder:GetType() == GridEntityType.GRID_POOP and gridUnder.State < 1000) and jumpData.Height < 10 then
				gridUnder:Hurt(2)
				local config = getGlobalSonicJumpConfig()
				config.Height = 8.16
				JumpLib:Jump(player,config)
				SFXManager():Play(Isaac.GetSoundIdByName("Sonic Hit Enemy"), 1)
			end
		end
		
		if playerData.sonicBriefInvul ~= nil and playerData.sonicBriefInvul > 0 then
			playerData.sonicBriefInvul = playerData.sonicBriefInvul - 1
		end
	end
end

local function prePlayerRender(_, player, offset)
	-- if not Game():IsPaused() then
	local playerData = player:GetData()
	local jumpData = JumpLib:GetData(player)
		-- if playerData.sonicJumpY ~= nil and playerData.sonicJumpY > 0 or playerData.sonicJumpVelocityY < 0 then
			-- return false
		-- end
	-- end
	
	-- if playerData.sonicJumpY ~= nil and playerData.sonicJumpY > 1 then
	-- TODO: make the ball sprite's tint match the base sprite's tint
	if jumpData.Jumping then
		-- playerData.SonicBallSprite:RenderLayer(0, Isaac.WorldToScreen(player.Position) - Vector(0,playerData.sonicJumpY))
		playerData.SonicBallSprite:RenderLayer(0, Isaac.WorldToScreen(player.Position) - Vector(0,jumpData.Height))
		if player:GetName() == "Sonic" then
			-- playerData.SonicBallSprite:RenderLayer(1, Isaac.WorldToScreen(player.Position) - Vector(0,playerData.sonicJumpY))
			playerData.SonicBallSprite:RenderLayer(1, Isaac.WorldToScreen(player.Position) - Vector(0,jumpData.Height))
		end
		return false
	end
	
	-- if playerData.sonicJumpY ~= nil and playerData.sonicJumpY <= 1 then
		-- -- player:GetSprite().Color = Color(1,1,1,0.00000001)
		-- -- player:GetSprite().Color = Color(1,1,1,1)
	-- end
	
	-- player:RenderHead(player.Position + Vector(10,0))
	-- end
end

function SonicCharacterMod:useSonicJump(item, RNG, player, useflags, slot)
	local playerData = player:GetData()
	-- only jump if on the ground
	-- if playerData.sonicJumpY > 0 then return end
	if not JumpLib:CanJump(player) then return end
	playerData.alreadyFlying = player:IsFlying()
	playerData.sonicJumpVelocityY = -5
	SFXManager():Play(Isaac.GetSoundIdByName("Sonic Jump"), 1)
	local config = getGlobalSonicJumpConfig()
	JumpLib:Jump(player,config)

end

local function onNPCCollision(_, npc, collider, low)
	-- only do this shit with players
	if collider.Type ~= EntityType.ENTITY_PLAYER then return nil end
	local playerData = collider:GetData()
	local jumpData = JumpLib:GetData(collider)

	if (jumpData.Height < npc.Size * 2.5 and jumpData.Jumping) then
		-- take damage with a multiplier based on the player's velocity
		-- npc:TakeDamage(collider:ToPlayer().Damage * (2 + collider.Velocity:Length() / 8),0,EntityRef(collider),10)
		npc:TakeDamage(collider:ToPlayer().Damage *
		(2 + math.max(((collider.Velocity:Length() - 6) / 1.25),0))
		,0,EntityRef(collider),10)
		-- bounce away
		-- this syntax is fucking stupid.
		collider.Velocity = Vector(0,0).Clamped(((collider.Position - npc.Position):Normalized() * (npc.Size / 2)),-10,-10,10,10)
		-- brief invincibility so enemies that explode arent fucking annoying and kill you
		playerData.sonicBriefInvul = 5
		-- bounce lower if a boss
		local config = getGlobalSonicJumpConfig()
		if npc:IsBoss() == false then
			JumpLib:Jump(collider,config)
		else
			config.Height = 6.12
			JumpLib:Jump(collider,config)
		end
		
		if npc:HasMortalDamage() then
			SFXManager():Play(Isaac.GetSoundIdByName("Sonic Kill"), 1)
		else
			if npc:IsBoss() then
				SFXManager():Play(Isaac.GetSoundIdByName("Sonic Hit Boss"), 1)
			else
				SFXManager():Play(Isaac.GetSoundIdByName("Sonic Hit Enemy"), 1)
			end
		end
		
		return false -- collide without damage
	elseif jumpData.Jumping then
		return true -- no collide
	end
	
end

-- TODO: make jumping on non-movable tnt damage it
-- TODO: make jumping over damaging gridentities without taking damage possible
-- TODO: same with brimstone lasers
-- TODO: make ball size match player size

local function onPlayerTakeDmg(_, player, amount, flags, source, countdown)
	local playerData = player:GetData()
	if playerData.sonicBriefInvul ~= nil and playerData.sonicBriefInvul > 0 then
		return false
	end
end

local function sonicFuckWillows(_, entityType, variant, subType, position, velocity, spawner, seed)
	-- print(entityType)
	-- replaces unkillable (as sonic) willows with lv. 2 willows which CAN be killed (by sonic) except for in the min min fight cause they don't follow you
	if entityType == EntityType.ENTITY_WILLO then
		if spawner == nil then
			return {EntityType.ENTITY_WILLO_L2, 0, 0, seed}
		elseif spawner.Type == EntityType.ENTITY_MIN_MIN then
			return
		else
			return {EntityType.ENTITY_WILLO_L2, 0, 0, seed}
		end
	end
end

local function onTearCollision(_, tear, collider, low)
	-- if collider.Type ~= EntityType.ENTITY_PLAYER then return end
	-- print(tear.Height)
	-- return true
end

-- TODO: make tears hit sonic while hes jumping if its high enough

SonicCharacterMod:AddCallback(ModCallbacks.MC_POST_RENDER, onRender)
SonicCharacterMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, onPlayerUpdate)
SonicCharacterMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, onPlayerUpdate2)
SonicCharacterMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, onPlayerInit)
SonicCharacterMod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, onPlayerRender)
SonicCharacterMod:AddCallback(ModCallbacks.MC_USE_ITEM, SonicCharacterMod.useSonicJump, PawlExperimentItems.COLLECTIBLE_SONICJUMP)
SonicCharacterMod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, onNPCCollision)
SonicCharacterMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, onPlayerTakeDmg, EntityType.ENTITY_PLAYER)
SonicCharacterMod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, sonicFuckWillows)
SonicCharacterMod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, onTearCollision)
SonicCharacterMod:AddCallback(ModCallbacks.MC_PRE_PLAYER_RENDER, prePlayerRender)