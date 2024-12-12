SonicCharacterMod = RegisterMod("sonic_the_hedgehog", 1)

require("scripts.lib.jumplib").Init()

costumes = {
	SONIC_HEAD = Isaac.GetCostumeIdByPath("gfx/characters/costume_sonichead.anm2")
}

SonicItems = {
	COLLECTIBLE_SONICJUMP = Isaac.GetItemIdByName("Spin Attack")
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
		player:SetPocketActiveItem(SonicItems.COLLECTIBLE_SONICJUMP, ActiveSlot.SLOT_POCKET, false)
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
---@diagnostic disable-next-line: missing-parameter
		playerData.SonicBallSprite:Load("gfx/characters/sprite_sonic_ball.anm2")
		if player:GetName() == "Sonic" then
			playerData.SonicBallSprite:ReplaceSpritesheet(0, "gfx/characters/sonic_spinball_sonic.png")
			playerData.SonicBallSprite:LoadGraphics()
		end
		-- playerData.SonicBallSprite:Play("Idle", true)
		print("oenis")
	end
	local ballDirection = player:GetMovementDirection()
	if playerData.InSpindash or playerData.CharginsSpindash then
		ballDirection = playerData.SpindashDirection
	end
	if playerData.SonicBallSprite ~= nil then
		
		if ballDirection == playerData.prevMoveDirection then
		 -- look nothing
		elseif ballDirection == Direction.LEFT then
			playerData.SonicBallSprite:Play("Left", true)
		elseif ballDirection == Direction.RIGHT then
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
	
	playerData.prevMoveDirection = ballDirection
	
	if playerData.alreadyFlying == nil then
		playerData.alreadyFlying = false
	end
	
	-- TODO: add horizontal spindashing (done by aiming and then using the spin jump/attack active item)
	-- player:MultiplyFriction(1.1)
	if not Game():IsPaused() then
		if jumpData.Jumping and jumpData.Tags["SonicCharacterMod_SpinJump"] then
			-- so we only collide with room walls like we're flying, and only with enemies to bounce on them
			-- if not playerData.alreadyFlying then
				-- player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			-- end
			player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
			-- bigger hitsphere size so its funner to bounce on things
			-- TODO: make this scale with size downs
			player.Size = 20
			player:SetShadowSize(0.225)
			-- player:MultiplyFriction(1.02)
			-- gets the gridentity currently below the player
			local gridUnder = Game():GetRoom():GetGridEntityFromPos(player.Position)
			
			-- if there's something under us and it's poop or tnt and it's not destroyed (less than state 1000 for poop for some reason, <4 for tnt), and we're low enough to bounce on it, do that
			if gridUnder ~= nil and jumpData.Height < 10 then
			-- poop
				-- local bonkedSomething = false
				if (gridUnder:GetType() == GridEntityType.GRID_POOP and gridUnder.State < 1000) or (gridUnder:GetType() == GridEntityType.GRID_TNT and gridUnder.State < 4) then
					gridUnder:Hurt(2)
					local config = getGlobalSonicJumpConfig()
					config.Height = 8.16
					JumpLib:Jump(player,config)
					SFXManager():Play(Isaac.GetSoundIdByName("Sonic Hit Enemy"), 1)
				end
				-- print(gridUnder.State)
			end
		end
		
		if playerData.sonicBriefInvul ~= nil and playerData.sonicBriefInvul > 0 then
			playerData.sonicBriefInvul = playerData.sonicBriefInvul - 1
		end

		if playerData.CharginsSpindash then
			local aimingEnough = (math.abs(player:GetAimDirection().X) >= 0.5) or (math.abs(player:GetAimDirection().Y) >= 0.5)
			-- if player:GetFireDirection() == -1 then
			if not aimingEnough then
				playerData.SpindashVector = Isaac.GetAxisAlignedUnitVectorFromDir(playerData.SpindashDirection)
				playerData.CharginsSpindash = false
				playerData.InSpindash = true
				player.Velocity = playerData.SpindashVector * Vector(playerData.SpindashSpeed,playerData.SpindashSpeed)
				SFXManager():Play(Isaac.GetSoundIdByName("Sonic Spindash Launch"), 1)
				SFXManager():Stop(Isaac.GetSoundIdByName("Sonic Spindash Charge"))
			elseif player:GetMovementDirection() ~= -1 or playerData.SpindashSpeed < 5 then
			-- if (player:GetMovementDirection() ~= -1 and player:GetMovementDirection() ~= playerData.SpindashDirection) or playerData.SpindashSpeed < 0.1 then
				playerData.CharginsSpindash = false
			elseif aimingEnough then
				playerData.SpindashDirection = player:GetFireDirection()
				-- Isaac.RenderText(playerData.SpindashSpeed,100,150,1,1,1,1)
				playerData.SpindashSpeed = playerData.SpindashSpeed - 0.1
			end
		end

		if playerData.InSpindash then
			-- player:MultiplyFriction(1.11)
			-- player:MultiplyFriction(1.1)
			-- player:MultiplyFriction(1.05)
			-- player.Size = 20
			while player.Velocity:Length() < playerData.SpindashSpeed do
			-- if player.Velocity:Length() < 20 then
				-- player.Velocity = player.Velocity + playerData.SpindashVector * Vector(20 - player.Velocity:Length(),20 - player.Velocity:Length())
				player.Velocity = player.Velocity + playerData.SpindashVector
			end
			playerData.SpindashSpeed = playerData.SpindashSpeed - 0.11
			-- player.Velocity = player:GetMovementInput() * Vector(10,10)
			-- if player:GetMovementDirection() ~= -1 and player:GetMovementDirection() ~= playerData.SpindashDirection then
			if player:GetMovementDirection() ~= -1 or playerData.SpindashSpeed < 5 then
			-- if (player:GetMovementDirection() ~= -1 and player:GetMovementDirection() ~= playerData.SpindashDirection) or playerData.SpindashSpeed < 0.1 then
				playerData.InSpindash = false
			end
		end
		
		-- local moveInputAngle = player:GetMovementInput():GetAngleDegrees()
		-- local velocityAngle = player.Velocity:GetAngleDegrees()
		-- -- Isaac.RenderText((player:GetMovementInput() + player.Velocity):Length()	,100,150,1,1,1,1)
		-- Isaac.RenderText((player.Velocity):Length()	,100,150,1,1,1,1)
		-- -- if player.Velocity:Length() > 1 and () then
		-- if  player.Velocity:Length() > 5.5 and (player:GetMovementInput() + player.Velocity:Normalized()):Length() < 0.1 then
			-- SFXManager():Play(Isaac.GetSoundIdByName("Sonic Skid"), 1,2)
		-- end
		
		-- if playerData.SpindashSoundTimer > 0 then
			-- playerData.SpindashSoundTimer = playerData.SpindashSoundTimer - 1
		-- end
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
	if (jumpData.Jumping and jumpData.Tags["SonicCharacterMod_SpinJump"]) or (playerData.InSpindash or playerData.CharginsSpindash) then
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

-- local function initiateSpindash (_, player, speed, direction)

-- end

-- local function sonicSpinSound(_, player, pitch)

function SonicCharacterMod:useSonicJump(item, RNG, player, useflags, slot)
	local playerData = player:GetData()
	local aimingEnough = (math.abs(player:GetAimDirection().X) >= 0.5) or (math.abs(player:GetAimDirection().Y) >= 0.5)
	-- only jump if on the ground
	-- if playerData.sonicJumpY > 0 then return end
	if not JumpLib:CanJump(player) then return end
	-- print(tostring(player:GetFireDirection()))
	-- print(aimingEnough)
	-- print(tostring(player:GetAimDirection())
	-- .. " " .. tostring(
	-- math.abs(player:GetAimDirection().X) >= 0.5
	-- )
	-- .. " " .. tostring(
	-- math.abs(player:GetAimDirection().Y) >= 0.5
	-- ))
	if not aimingEnough then
		playerData.InSpindash = false
		playerData.alreadyFlying = player:IsFlying()
		playerData.sonicJumpVelocityY = -5
		SFXManager():Play(Isaac.GetSoundIdByName("Sonic Jump"), 1)
		local config = getGlobalSonicJumpConfig()
		JumpLib:Jump(player,config)
	elseif playerData.CharginsSpindash then
		local maxSpindashSpeed = 20
		playerData.SpindashSpeed = playerData.SpindashSpeed + 2
		if playerData.SpindashSpeed > maxSpindashSpeed then playerData.SpindashSpeed = maxSpindashSpeed end
		SFXManager():Play(Isaac.GetSoundIdByName("Sonic Spindash Charge"), 1, 0, false, 1 + ((playerData.SpindashSpeed - 10) / 20))
	elseif player:GetMovementDirection() == -1 and not playerData.InSpindash then
		playerData.CharginsSpindash = true
		playerData.SpindashDirection = player:GetFireDirection()
		playerData.SpindashVector = Isaac.GetAxisAlignedUnitVectorFromDir(playerData.SpindashDirection)
		playerData.SpindashSpeed = 10
		SFXManager():Play(Isaac.GetSoundIdByName("Sonic Spindash Charge"), 1, 0, false, 1)
		-- playerData.SpindashSoundTimer = 9
		-- -- playerData.SpindashSpeed = 10
		-- player.Velocity = playerData.SpindashVector * Vector(playerData.SpindashSpeed,playerData.SpindashSpeed)
		-- -- player:MultiplyFriction(2)
		-- playerData.InSpindash = true

		-- player.Friction = 2
	end

end

local function onNPCCollision(_, npc, collider, low)
	-- only do this shit with players
	if collider.Type ~= EntityType.ENTITY_PLAYER then return nil end
	local playerData = collider:GetData()
	local jumpData = JumpLib:GetData(collider)

	if ((jumpData.Height < npc.Size * 2.5 or (jumpData.Height < npc.Size * 3 and playerData.UncappedSpeed > 2.2)) and (jumpData.Jumping and jumpData.Tags["SonicCharacterMod_SpinJump"])) then
		-- take damage with a multiplier based on the player's velocity
		-- npc:TakeDamage(collider:ToPlayer().Damage * (2 + collider.Velocity:Length() / 8),0,EntityRef(collider),10)
		print(npc.HitPoints)
		local damageDealt = collider:ToPlayer().Damage * (2 + math.max(((collider.Velocity:Length() - 6) / 1.1),0))
		npc:TakeDamage(damageDealt,0,EntityRef(collider),10)
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
		
		if npc:HasMortalDamage() and not npc.Type == EntityType.ENTITY_FIREPLACE then
		-- if npc.HitPoints - damageDealt <= 0 then
			SFXManager():Play(Isaac.GetSoundIdByName("Sonic Kill"), 1)
		else
			if npc:IsBoss() then
				SFXManager():Play(Isaac.GetSoundIdByName("Sonic Hit Boss"), 1)
			else
				SFXManager():Play(Isaac.GetSoundIdByName("Sonic Hit Enemy"), 1)
			end
		end
		
		return false -- collide without damage
	elseif jumpData.Jumping and jumpData.Tags["SonicCharacterMod_SpinJump"] then
		return true -- no collide
	elseif playerData.InSpindash then
		npc:TakeDamage(collider:ToPlayer().Damage *
		(-3 + math.max(((collider.Velocity:Length() - 3) / 1.1),0))
		,64,EntityRef(collider),10)
		-- npc:TakeDamage(collider:ToPlayer().Damage * 2,0,EntityRef(collider),10)
		playerData.sonicBriefInvul = 5
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

local function preGridCollision(_, player, gridIndex, gridEntity)
	local playerData = player:GetData()
	local jumpData = JumpLib:GetData(player)
	-- if player:GetName() == "ppaawwll" and gridEntity:GetType() == GridEntityType.GRID_POOP then
		-- touchedGross(player)
	-- end
	-- if not Game():IsPaused() then
	-- if jumpData.Jumping and jumpData.Tags["SonicCharacterMod_SpinJump"] then
		-- -- gets the gridentity currently below the player
		-- -- local gridUnder = Game():GetRoom():GetGridEntityFromPos(player.Position)
		
		-- -- if there's something under us and it's poop (TODO: add bouncing on TNT as well) and it's destroyed (state 1000 for some reason), and we're low enough to bounce on it, do that
		-- -- if gridUnder ~= nil and (gridUnder:GetType() == GridEntityType.GRID_POOP and gridUnder.State < 1000) and jumpData.Height < 10 then
		-- if gridEntity ~= nil and (gridEntity:GetType() == GridEntityType.GRID_POOP and gridEntity.State < 1000) and jumpData.Height < 10 then
			-- gridEntity:Hurt(2)
			-- local config = getGlobalSonicJumpConfig()
			-- config.Height = 8.16
			-- JumpLib:Jump(player,config)
			-- SFXManager():Play(Isaac.GetSoundIdByName("Sonic Hit Enemy"), 1)
		-- end
	-- end
	-- print(gridEntity:GetType())
	-- if playerData.InSpindash and gridEntity ~= nil and playerData.SpindashSpeed > 8 then
	if playerData.InSpindash and gridEntity ~= nil then
		if gridEntity:GetType() == GridEntityType.GRID_WALL or gridEntity:GetType() == GridEntityType.GRID_PIT or gridEntity:GetType() == GridEntityType.GRID_ROCKB or gridEntity:GetType() == GridEntityType.GRID_LOCK or playerData.SpindashSpeed < 8 then
			playerData.InSpindash = false
			-- if (gridEntity:GetType() == GridEntityType.GRID_WALL or gridEntity:GetType() == GridEntityType.GRID_ROCKB) and playerData.SpindashSpeed > 8 then
			if (gridEntity:GetType() == GridEntityType.GRID_WALL or gridEntity:GetType() == GridEntityType.GRID_ROCKB or gridEntity:GetType() == GridEntityType.GRID_LOCK) then
				local bonkVelocity = playerData.SpindashSpeed / 1.5
				player.Velocity = Isaac.GetAxisAlignedUnitVectorFromDir(playerData.SpindashDirection) * Vector(-bonkVelocity,-bonkVelocity)
				local config = getGlobalSonicJumpConfig()
				-- config.Height = 8.16
				config.Height = playerData.SpindashSpeed / 2
				-- config.Speed = 2
				JumpLib:Jump(player,config)
				if playerData.SpindashSpeed > 16 then
					SFXManager():Play(Isaac.GetSoundIdByName("Sonic Hit Boss"), 1)
					-- Game():ShakeScreen(10)
				else
					SFXManager():Play(Isaac.GetSoundIdByName("Sonic Hit Enemy"), 1)
				end
			end
			return
		end
		gridEntity:Destroy(false)
		return true
	end
end

-- TODO: make tears hit sonic while hes jumping if its high enough

SonicCharacterMod:AddCallback(ModCallbacks.MC_POST_RENDER, onRender)
SonicCharacterMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, onPlayerUpdate)
SonicCharacterMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, onPlayerUpdate2)
SonicCharacterMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, onPlayerInit)
SonicCharacterMod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, onPlayerRender)
SonicCharacterMod:AddCallback(ModCallbacks.MC_USE_ITEM, SonicCharacterMod.useSonicJump, SonicItems.COLLECTIBLE_SONICJUMP)
SonicCharacterMod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, onNPCCollision)
SonicCharacterMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, onPlayerTakeDmg, EntityType.ENTITY_PLAYER)
SonicCharacterMod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, sonicFuckWillows)
SonicCharacterMod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, onTearCollision)
SonicCharacterMod:AddCallback(ModCallbacks.MC_PRE_PLAYER_RENDER, prePlayerRender)
SonicCharacterMod:AddCallback(ModCallbacks.MC_PRE_PLAYER_GRID_COLLISION, preGridCollision)