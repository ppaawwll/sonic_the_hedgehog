SonicCharacterMod = RegisterMod("sonic_the_hedgehog", 1)

require("scripts.lib.jumplib").Init()

costumes = {
	SONIC_HEAD = Isaac.GetCostumeIdByPath("gfx/characters/costume_sonichead.anm2"),
	SONIC_2SPOOKY = Isaac.GetCostumeIdByPath("gfx/characters/sonic_2spooky.anm2")
}

SonicItems = {
	COLLECTIBLE_SONICJUMP = Isaac.GetItemIdByName("Spin Attack"),
	COLLECTIBLE_SONICSHOES = Isaac.GetItemIdByName("Speed Shoes")
}

local json = require("json")

local defaultSettings = {
	spindashAccessibility = false,
	sonicJumpSound = false -- false = sonic 1/2/3 true = sonic cd 
}

local settings = {
}

local function saveSettings()
	local jsonString = json.encode(settings)
	SonicCharacterMod:SaveData(jsonString)
end

local function initializeSettings() -- loads default settings in place of settings that aren't found
	for k,v in pairs(defaultSettings) do
		if not settings[k] then
			settings[k] = defaultSettings[k]
		end
	end
end

local function loadSettings()
	if not SonicCharacterMod:HasData() then return end
	
	local jsonString = SonicCharacterMod:LoadData()
	settings = json.decode(jsonString)
end

loadSettings()
initializeSettings()

local function modConfigMenuInit()
	if ModConfigMenu == nil then return end
	
	ModConfigMenu.RemoveCategory("Sonic INDEV")

	ModConfigMenu.AddSetting(
		"Sonic INDEV",
		"Settings",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return settings.spindashAccessibility
			end,
			Display = function()
				return "Spindash Mode: " .. (settings.spindashAccessibility and "Hold" or "Mash")
			end,
			OnChange = function(s)
				settings.spindashAccessibility = s
				saveSettings()
			end,
			Info = {
				"Whether charging a spindash requires buttonmashing or just holding the button.",
				"This is an accessibility option.",
			}
		}
	)

	ModConfigMenu.AddSetting(
		"Sonic INDEV",
		"Settings",
		{
			Type = ModConfigMenu.OptionType.BOOLEAN,
			CurrentSetting = function()
				return settings.sonicJumpSound
			end,
			Display = function()
				return "Jump Sound: " .. (settings.sonicJumpSound and "Sonic CD" or "Sonic 1/2/3")
			end,
			OnChange = function(s)
				settings.sonicJumpSound = s
				saveSettings()
			end,
			Info = {
				"The sound used for jumping.",
			}
		}
	)
end

SonicCharacterMod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, modConfigMenuInit)

function SonicCharacterMod:onCache(player, cacheFlag)
	local playerData = player:GetData()
	if player:GetName() == "Sonic" or player:HasCollectible(SonicItems.COLLECTIBLE_SONICSHOES) then -- Especially here!
		-- player.Damage = player.Damage + CartoonCry.DAMAGE
		-- if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
			-- player.ShotSpeed = player.ShotSpeed + Moonwalker.SHOTSPEED
		-- end
		-- if cacheFlag == CacheFlag.CACHE_RANGE then
			-- player.TearHeight = player.TearHeight - Moonwalker.TEARHEIGHT
			-- player.TearFallingSpeed = player.TearFallingSpeed + Moonwalker.TEARFALLINGSPEED
		-- end
		if cacheFlag == CacheFlag.CACHE_SPEED then
			local speedMult = player:GetCollectibleNum(SonicItems.COLLECTIBLE_SONICSHOES)
			if player:GetName() == "Sonic" then speedMult = speedMult + 1 end
			player.MoveSpeed = player.MoveSpeed + (0.75 * speedMult)
			print(player.MoveSpeed)
			-- store the uncapped speed
			playerData.UncappedSpeed = player.MoveSpeed
		end

		-- if player:HasCollectible(CollectibleType.COLLECTIBLE_2SPOOKY) then
		-- 	player:AddNullCostume(costumes.SONIC_2SPOOKY)
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

SonicCharacterMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, SonicCharacterMod.onCache)

local function onPlayerUpdate(_, player)
	local playerData = player:GetData()
	if player:GetName() == "Sonic" or player:HasCollectible(SonicItems.COLLECTIBLE_SONICSHOES) then -- Especially here!
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
	player = Isaac.GetPlayer()
	-- player:RenderBody(Isaac.WorldToScreen(player.Position) + Vector(30,0))
end

local function onPlayerInit(_, player)
	local playerData = player:GetData()
	if player:GetName() == "Sonic" then
		-- player:AddCollectible(PawlExperimentItems.COLLECTIBLE_ADRENALINERUSH, 0, false)
		-- player:AddCollectible(PawlExperimentItems.COLLECTIBLE_TECHCRAFTER, 0, false, 2)	
		player:SetPocketActiveItem(SonicItems.COLLECTIBLE_SONICJUMP, ActiveSlot.SLOT_POCKET, false)
		-- player:AddNullCostume(costumes.SONIC_HEAD)
		-- player:AddNullCostume(costumes.CLEM_DOGHAIR)
		-- local itemConfig = Isaac.GetItemConfig()
		-- local itemConfigItem = itemConfig:GetCollectible(CollectibleType.COLLECTIBLE_PHD)
		-- player:RemoveCostume(itemConfigItem)
	end
end

local function onPlayerRender(_, player)
	local playerData = player:GetData()
	-- Isaac.DrawLine(Isaac.WorldToScreen(player.Position) + Vector(0,-10), Isaac.WorldToScreen(player.Position) + Vector(0,-100),KColor(1,0,0,1),KColor(1,0,0,1),1)
end

local function getGlobalSonicJumpConfig()
	return {
		Height = 10.2,
		Speed = 1.25,
		Tags = "SonicCharacterMod_SpinJump",
		Flags = JumpLib.Flags.DAMAGE_CUSTOM + JumpLib.Flags.NO_HURT_PITFALL
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
	if player:HasCollectible(SonicItems.COLLECTIBLE_SONICJUMP) and not playerData.SonicBallSprite then
		playerData.SonicBallSprite = Sprite()
		playerData.SonicBallSprite:Load("gfx/characters/sprite_sonic_ball.anm2")
		if player:GetName() == "Sonic" then
			playerData.SonicBallSprite:ReplaceSpritesheet(0, "gfx/characters/sonic_spinball_sonic.png")
			playerData.SonicBallSprite:LoadGraphics()
		end
		-- playerData.SonicBallSprite:Play("Idle", true)
		-- print("oenis")
	end
	if player:HasCollectible(SonicItems.COLLECTIBLE_SONICJUMP) and not playerData.SonicDustSprite then
		playerData.SonicDustSprite = Sprite()
		playerData.SonicDustSprite:Load("gfx/effect_spindashChargeDust.anm2")
		playerData.SonicDustSprite:Play("Idle", true)
		-- print("oenis")
	end
	if player:HasCollectible(SonicItems.COLLECTIBLE_SONICJUMP) and not playerData.SonicSpindashChargeSprite then
		playerData.SonicSpindashChargeSprite = Sprite()
		playerData.SonicSpindashChargeSprite:Load("gfx/chargebar_sonic.anm2")
	end
	local ballDirection = player:GetMovementDirection()
	if playerData.InSpindash or playerData.ChargingSpindash then
		ballDirection = playerData.SpindashDirection
	end
	if playerData.SonicBallSprite ~= nil and playerData.SonicDustSprite ~= nil then

		local animSuffix = ""

		if playerData.ChargingSpindash then animSuffix = "Spindash" end
		
		if ballDirection == playerData.prevMoveDirection then
		 -- look nothing
		elseif ballDirection == Direction.LEFT then
			playerData.SonicBallSprite:Play("Left"..animSuffix, true)
			playerData.SonicDustSprite.FlipX = true
			playerData.SonicDustSprite:Play("Idle", true)
		elseif ballDirection == Direction.RIGHT then
			playerData.SonicBallSprite:Play("Right"..animSuffix, true)
			playerData.SonicDustSprite.FlipX = false
			playerData.SonicDustSprite:Play("Idle", true)
		else
			playerData.SonicBallSprite:Play("Idle"..animSuffix, true)
			playerData.SonicDustSprite.FlipX = false
			playerData.SonicDustSprite:Play("Vertical", true)
		end

		playerData.SonicBallSprite.Scale = player.SpriteScale
		if playerData.sonicBallUpdate == nil then
		playerData.sonicBallUpdate = true
		end
		if playerData.sonicBallUpdate == true then
			playerData.sonicBallUpdate = false
			-- player:Update()
			playerData.SonicBallSprite:Update()
			playerData.SonicDustSprite:Update()
		else
			playerData.sonicBallUpdate = true
		end
		-- playerData.SonicBallSprite:Update()
	end
	
	playerData.prevMoveDirection = ballDirection
	-- player:Render(Vector(30,0))
	
	if playerData.alreadyFlying == nil then
		playerData.alreadyFlying = false
	end

	if player:GetName() == "Sonic" and not playerData.SonicDeathSprite then
		playerData.SonicDeathSprite = Sprite()
		playerData.SonicDeathSprite:Load("gfx/effect_sonicDeathSprite.anm2")
		playerData.SonicDeathSprite:Play("Idle")
		playerData.SonicDeathSpriteY = 0.0
		playerData.SonicDeathSpriteYVel = -7.0
		-- playerData.SonicBallSprite:Play("Idle", true)
		-- prin
	end

	if playerData.SonicDeathSprite ~= nil and player:GetSprite():GetAnimation() == "Death" then
		playerData.SonicDeathSpriteY = playerData.SonicDeathSpriteY + playerData.SonicDeathSpriteYVel
		playerData.SonicDeathSpriteYVel = playerData.SonicDeathSpriteYVel + 0.21875
	else
		playerData.SonicDeathSpriteY = 0.0
		playerData.SonicDeathSpriteYVel = -7.0
	end

	-- TODO: figure out how to prevent going down trapdoors while jumping
	if ((jumpData.Jumping and jumpData.Tags["SonicCharacterMod_SpinJump"]) or playerData.InSpindash) and player:GetSprite():GetAnimation() == "Trapdoor" then
	-- if playerData.InSpindash and player:GetSprite():GetAnimation() == "Trapdoor" then
		playerData.InSpindash = false
		JumpLib:QuitJump(player)
		-- jumpData.Height = 0
		-- jumpData.Jumping = false
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
			-- bigger hitsphere size so its funner to bounce on things (but also only when a little off the ground so you dont have big hitbox syndrome when you land)
			-- TODO: make this scale with size downs
			if jumpData.Height > 8 then
				player.Size = 22
			end
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
					if gridUnder:GetType() == GridEntityType.GRID_TNT then playerData.sonicBriefInvul = 10 end
				end
				-- print(gridUnder.State)
			end
		end
		
		if playerData.sonicBriefInvul ~= nil and playerData.sonicBriefInvul > 0 then
			playerData.sonicBriefInvul = playerData.sonicBriefInvul - 1
		end

		-- if not playerData.SpeedFuck then
		-- 	playerData.SpeedFuck = 1
		-- else
		-- 	playerData.SpeedFuck = playerData.SpeedFuck - 1
		-- 	if playerData.SpeedFuck <= 0 then
		-- 		if player.Velocity:Length() > 10 	then
		-- 			player:CreateAfterimage(10,player.Position)
		-- 		end
		-- 		playerData.SpeedFuck = 3
		-- 	end
		-- end

		-- player:CreateAfterimage(10,player.Position)

		if playerData.ChargingSpindash then
			local aimingEnough = (math.abs(player:GetAimDirection().X) >= 0.5) or (math.abs(player:GetAimDirection().Y) >= 0.5)
			-- if player:GetFireDirection() == -1 then
			-- if not aimingEnough then
			if not (aimingEnough and not settings.spindashAccessibility) and not (settings.spindashAccessibility and (aimingEnough and Input.GetActionValue(ButtonAction.ACTION_PILLCARD,1) > 0 )) then
				playerData.SpindashVector = Isaac.GetAxisAlignedUnitVectorFromDir(playerData.SpindashDirection)
				playerData.ChargingSpindash = false
				playerData.InSpindash = true
				player.Velocity = playerData.SpindashVector * Vector(playerData.SpindashSpeed,playerData.SpindashSpeed)
				playerData.prevMoveDirection = Vector(0,0)
				SFXManager():Play(Isaac.GetSoundIdByName("Sonic Spindash Launch"), 1)
				SFXManager():Stop(Isaac.GetSoundIdByName("Sonic Spindash Charge"))
			elseif player:GetMovementDirection() ~= -1 or playerData.SpindashSpeed < 5 then
			-- if (player:GetMovementDirection() ~= -1 and player:GetMovementDirection() ~= playerData.SpindashDirection) or playerData.SpindashSpeed < 0.1 then
				playerData.ChargingSpindash = false
			elseif (aimingEnough and not settings.spindashAccessibility) or (settings.spindashAccessibility and (aimingEnough and Input.GetActionValue(ButtonAction.ACTION_PILLCARD,1) > 0 )) then
				playerData.SpindashDirection = player:GetFireDirection()
				-- Isaac.RenderText(playerData.SpindashSpeed,100,150,1,1,1,1)
				-- Isaac.RenderText( 
				-- math.ceil((playerData.SpindashSpeed - 5) * 6.66)
				-- ,100,150,1,1,1,1)
				if settings.spindashAccessibility then
					playerData.SpindashSpeed = math.min(20,playerData.SpindashSpeed + (( 1.2 + ( 10 / (player.MaxFireDelay) )) / 15))
				else
					playerData.SpindashSpeed = playerData.SpindashSpeed - 0.1
				end
				-- Game():SpawnParticles(player.Position,EffectVariant.DARK_BALL_SMOKE_PARTICLE,1,50)
			end
		end

		if playerData.InSpindash then
			-- playerData.ChargingSpindash = false
			-- player:MultiplyFriction(1.11)
			-- player:MultiplyFriction(1.1)
			-- player:MultiplyFriction(1.05)
			-- player.Size = 20
			while player.Velocity:Length() < playerData.SpindashSpeed do
			-- if player.Velocity:Length() < 20 then
				-- player.Velocity = player.Velocity + playerData.SpindashVector * Vector(20 - player.Velocity:Length(),20 - player.Velocity:Length())
				player.Velocity = player.Velocity + playerData.SpindashVector
			end
			-- playerData.SpindashSpeed = playerData.SpindashSpeed - 0.11
			playerData.SpindashSpeed = playerData.SpindashSpeed - (40 / player.TearRange)
			-- player.Velocity = player:GetMovementInput() * Vector(10,10)
			-- if player:GetMovementDirection() ~= -1 and player:GetMovementDirection() ~= playerData.SpindashDirection then
			if player:GetMovementDirection() ~= -1 or playerData.SpindashSpeed < 5 then
			-- if (player:GetMovementDirection() ~= -1 and player:GetMovementDirection() ~= playerData.SpindashDirection) or playerData.SpindashSpeed < 0.1 then
				playerData.InSpindash = false
			end

			if player.TearFlags & TearFlags.TEAR_HOMING == TearFlags.TEAR_HOMING then
				-- local entitiesInDirection = {}
				local closest = nil
				local closestDistance = 160
				for i,e in ipairs(Isaac.GetRoomEntities()) do
					-- if player.Position:Distance(e.Position) <= 160 and
					if e:ToNPC() and e:ToNPC():IsVulnerableEnemy() and player.Position:Distance(e.Position) < closestDistance and
					((e.Position.X > player.Position.X and playerData.SpindashDirection == Direction.RIGHT)
					or (e.Position.Y > player.Position.Y and playerData.SpindashDirection == Direction.DOWN)
					or (e.Position.X < player.Position.X and playerData.SpindashDirection == Direction.LEFT)
					or (e.Position.Y < player.Position.Y and playerData.SpindashDirection == Direction.UP))
					then
						-- table.insert(entitiesInDirection,e)
						-- Isaac.DrawLine(Isaac.WorldToScreen(e.Position) + Vector(0,-10), Isaac.WorldToScreen(e.Position) + Vector(0,10),KColor(1,0,0,1),KColor(1,0,0,1),1)
						closest = e
						closestDistance = player.Position:Distance(e.Position)
					end
				end
				if closest ~= nil then
					-- TODO: Fix homing into wall crawlers bumping you into the wall
					local offset = (closest.Position - player.Position):Clamped(-playerData.SpindashSpeed,-playerData.SpindashSpeed,playerData.SpindashSpeed,playerData.SpindashSpeed)
					if playerData.SpindashDirection == Direction.RIGHT or playerData.SpindashDirection == Direction.LEFT then
						player.Position = player.Position + Vector(0,offset.Y)
					end
					if playerData.SpindashDirection == Direction.DOWN or playerData.SpindashDirection == Direction.UP then
						player.Position = player.Position + Vector(offset.X,0)
					end
				-- 	Isaac.DrawLine(Isaac.WorldToScreen(e.Position) + Vector(0,-10), Isaac.WorldToScreen(e.Position) + Vector(0,10),KColor(1,0,0,1),KColor(1,0,0,1),1)
					-- Isaac.DrawLine(Isaac.WorldToScreen(closest.Position) + Vector(0,-10), Isaac.WorldToScreen(closest.Position) + Vector(0,10),KColor(1,0,0,1),KColor(1,0,0,1),1)
				end
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
	-- player:GetSprite().Color:SetOffset(-1,0,0)
		-- if playerData.sonicJumpY ~= nil and playerData.sonicJumpY > 0 or playerData.sonicJumpVelocityY < 0 then
			-- return false
		-- end
	-- end
	
	-- player:Render(Vector(30,0))
	-- player:GetSprite():Render(Isaac.WorldToScreen(player.Position) + Vector(0,5))
	-- player:GetSprite():RenderLayer(1,Isaac.WorldToScreen(player.Position) + Vector(30,0))
	-- print(player:GetSprite():GetLayerCount())

	if player:GetName() == "Sonic" and player:GetSprite():GetAnimation() == "Death" then
		playerData.SonicDeathSprite:Render(Isaac.WorldToScreen(player.Position) + Vector(0,playerData.SonicDeathSpriteY))
		-- playerData.SonicDeathSprite:Render(Isaac.WorldToScreen(player.Position) + Vector(0,0))
		return false
	end

	-- playerData.SonicDeathSprite:Render(Isaac.WorldToScreen(player.Position) + Vector(0,0))

	-- if playerData.sonicJumpY ~= nil and playerData.sonicJumpY > 1 then
	-- TODO: make the ball sprite's tint match the base sprite's tint
	if (jumpData.Jumping and jumpData.Tags["SonicCharacterMod_SpinJump"]) or (playerData.InSpindash or playerData.ChargingSpindash) then
		-- playerData.SonicBallSprite:RenderLayer(0, Isaac.WorldToScreen(player.Position) - Vector(0,playerData.sonicJumpY))
		local BallDir = playerData.SpindashDirection
		if playerData.ChargingSpindash and playerData.SonicDustSprite ~= nil and BallDir == playerData.prevMoveDirection then
			-- look nothing
			elseif BallDir == Direction.LEFT then
				playerData.SonicDustSprite.FlipX = true
				playerData.SonicDustSprite:Play("Idle", true)
		    elseif BallDir == Direction.RIGHT then
				playerData.SonicDustSprite.FlipX = false
			  	playerData.SonicDustSprite:Play("Idle", true)
		    else
				playerData.SonicDustSprite.FlipX = false
			  	playerData.SonicDustSprite:Play("Vertical", true)
		end
		if playerData.ChargingSpindash and playerData.SonicDustSprite ~= nil then
			if BallDir == Direction.DOWN then
				playerData.SonicDustSprite:Render(Isaac.WorldToScreen(player.Position) + Vector(0,-8))
			elseif BallDir == Direction.UP then
			playerData.SonicDustSprite.FlipY = true
			-- playerData.SonicDustSprite:Render(Isaac.WorldToScreen(player.Position) + Vector(0,12),Vector(0,0),Vector(0,6))
			playerData.SonicDustSprite:Render(Isaac.WorldToScreen(player.Position) + Vector(0,-4))
			-- playerData.SonicBallSprite:Play("Right"..animSuffix, true)
			playerData.SonicDustSprite.FlipY = false
			end
		end
		playerData.SonicBallSprite:RenderLayer(0, Isaac.WorldToScreen(player.Position) - Vector(0,jumpData.Height))
		-- spindash chargebar
		if playerData.ChargingSpindash and playerData.SonicSpindashChargeSprite and Options.ChargeBars then
			playerData.SonicSpindashChargeSprite:SetFrame("Charging",
			-- range of 0-15 to pecentage
			math.ceil((playerData.SpindashSpeed - 5) * 6.66) + 1)
			playerData.SonicSpindashChargeSprite:Render(Isaac.WorldToScreen(player.Position) + Vector(17,-33))
		end
		if player:GetName() == "Sonic" then
			-- playerData.SonicBallSprite:RenderLayer(1, Isaac.WorldToScreen(player.Position) - Vector(0,playerData.sonicJumpY))
			playerData.SonicBallSprite:RenderLayer(1, Isaac.WorldToScreen(player.Position) - Vector(0,jumpData.Height))
		end
		if playerData.ChargingSpindash and playerData.SonicDustSprite ~= nil then

			if BallDir == Direction.LEFT then

				playerData.SonicDustSprite:Render(Isaac.WorldToScreen(player.Position) + Vector(2,2))
				-- playerData.SonicBallSprite:Play("Left"..animSuffix, true)
			elseif BallDir == Direction.RIGHT then
				playerData.SonicDustSprite:Render(Isaac.WorldToScreen(player.Position) + Vector(-2,2))
			end
		end
		return false
	end




	if player:GetName() == "Sonic" and player:HasCollectible(CollectibleType.COLLECTIBLE_2SPOOKY) then
		-- player:AddNullCostume(costumes.SONIC_2SPOOKY)
		local spookyCostumeVisible = false
		local alreadySonicSpooky = false
		for i,c in ipairs(player:GetCostumeSpriteDescs()) do
			if c:GetItemConfig().ID == 554 or c:GetSprite():GetFilename() == "gfx/characters/costume_sonichead.anm2" or c:GetSprite():GetFilename() == "gfx/characters/sonic_2spooky.anm2" then
			-- if c:GetItemConfig().ID == 554 then

				-- if c:GetSprite():GetFilename() == "gfx/characters/costume_sonichead.anm2" then
				-- 	c:GetSprite():Load("gfx/characters/sonic_2spooky.anm2", true)
				-- end
				if c:GetItemConfig().ID == 554 then spookyCostumeVisible = true end
				if c:GetSprite():GetFilename() == "gfx/characters/sonic_2spooky.anm2" then alreadySonicSpooky = true end
				-- if c:GetSprite():GetFilename() == "gfx/characters/costume_sonichead.anm2" then
				-- 	c:GetSprite().Color = Color(1,1,1,0)
				-- end
				-- c:GetSprite().Color:SetColorize(1,1,1,1)
				-- c:GetSprite().Color = Color(1,1,1,1)
			end
		end
		if spookyCostumeVisible and not alreadySonicSpooky then
			player:AddNullCostume(costumes.SONIC_2SPOOKY)
		elseif not spookyCostumeVisible then
			player:TryRemoveNullCostume(costumes.SONIC_2SPOOKY)
		end
		for i,c in ipairs(player:GetCostumeSpriteDescs()) do
			if c:GetItemConfig().ID == 554 or c:GetSprite():GetFilename() == "gfx/characters/costume_sonichead.anm2" or c:GetSprite():GetFilename() == "gfx/characters/sonic_2spooky.anm2" then

				-- if c:GetSprite():GetFilename() == "gfx/characters/costume_sonichead.anm2" then
				-- 	c:GetSprite():Load("gfx/characters/sonic_2spooky.anm2", true)
				-- end
				if c:GetSprite():GetFilename() == "gfx/characters/costume_sonichead.anm2" then
					if spookyCostumeVisible then
						c:GetSprite().Color:SetTint(1,1,1,0)
					else
						c:GetSprite().Color:SetTint(1,1,1,1)
					end
				else
					c:GetSprite().Color:SetOffset(0,0,0)
				end
				-- c:GetSprite().Color:SetColorize(1,1,1,1)
				-- c:GetSprite().Color = Color(1,1,1,1)
			end
		end
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

	local spinIncrease = ( 1.2 + ( 10 / (player.MaxFireDelay) ))
	-- local spinIncrease = 30 / (player.MaxFireDelay + 4)
	local maxSpindashSpeed = 20

	if not aimingEnough then
		playerData.InSpindash = false
		playerData.alreadyFlying = player:IsFlying()
		playerData.sonicJumpVelocityY = -5
		if settings.sonicJumpSound then
			SFXManager():Play(Isaac.GetSoundIdByName("Sonic Jump CD"), 1)
		else
			SFXManager():Play(Isaac.GetSoundIdByName("Sonic Jump"), 1)
		end
		local config = getGlobalSonicJumpConfig()
		JumpLib:Jump(player,config)
	elseif playerData.ChargingSpindash then
		-- playerData.SpindashSpeed = playerData.SpindashSpeed + 2
		playerData.SpindashSpeed = playerData.SpindashSpeed + spinIncrease
		-- print(spinIncrease)
		-- print(player.MaxFireDelay)
		if playerData.SpindashSpeed > maxSpindashSpeed then playerData.SpindashSpeed = maxSpindashSpeed end
		SFXManager():Play(Isaac.GetSoundIdByName("Sonic Spindash Charge"), 1, 0, false, 1 + ((playerData.SpindashSpeed - 10) / 20))
	elseif player:GetMovementDirection() == -1 and not playerData.InSpindash then
		playerData.ChargingSpindash = true
		playerData.SpindashDirection = player:GetFireDirection()
		playerData.SpindashVector = Isaac.GetAxisAlignedUnitVectorFromDir(playerData.SpindashDirection)
		playerData.SpindashSpeed = math.min(8 + spinIncrease, maxSpindashSpeed)
		-- SFXManager():Play(Isaac.GetSoundIdByName("Sonic Spindash Charge"), 1, 0, false, 1)
		SFXManager():Play(Isaac.GetSoundIdByName("Sonic Spindash Charge"), 1, 0, false, 1 + ((playerData.SpindashSpeed - 10) / 20))
		-- playerData.SpindashSoundTimer = 9
		-- -- playerData.SpindashSpeed = 10
		-- player.Velocity = playerData.SpindashVector * Vector(playerData.SpindashSpeed,playerData.SpindashSpeed)
		-- -- player:MultiplyFriction(2)
		-- playerData.InSpindash = true

		-- player.Friction = 2
	end

end

function SonicCharacterMod:onSonicHit(player,enemy,spindash)
	local playerData = player:GetData()
	local jumpData = JumpLib:GetData(player)

	if player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) or player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) then
		local explosionDamage = player.Damage
		if player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then
			explosionDamage = player.Damage * 10
			if explosionDamage > 60 then explosionDamage = (player.Damage * 5) + 30 end
		end
		Isaac.Explode(player.Position,player,explosionDamage)
	end

	local tearAngleArray = {}

	if player:HasCollectible(CollectibleType.COLLECTIBLE_PARASITE) then
		table.insert(tearAngleArray,45)
		table.insert(tearAngleArray,135)
		table.insert(tearAngleArray,225)
		table.insert(tearAngleArray,315)
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_CRICKETS_BODY) then
		table.insert(tearAngleArray,0)
		table.insert(tearAngleArray,90)
		table.insert(tearAngleArray,180)
		table.insert(tearAngleArray,270)
	end

	if tearAngleArray ~= {} then
		for i,angle in ipairs(tearAngleArray) do
			-- if player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS) then
			-- 	player:FireBomb(player.Position + (Vector(0,20):Rotated(angle)),Vector(0,7.5):Rotated(angle))
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
				player:FireBrimstone(Vector.FromAngle(angle))
			elseif player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY) then
				player:FireTechLaser(player.Position + (Vector(0,20):Rotated(angle)),4,Vector.FromAngle(angle))
			else
				local tear = player:FireTear(player.Position + (Vector(0,20):Rotated(angle)),Vector(0,7.5):Rotated(angle),true,true,false)
				tear.FallingAcceleration = 1.5
				if not spindash then
					tear.Height = jumpData.Height * -2
				end
			end
		end
	end
end

local function onNPCCollision(_, npc, collider, low)
	-- only do this shit with players
	if collider.Type ~= EntityType.ENTITY_PLAYER then return nil end
	local playerData = collider:GetData()
	local jumpData = JumpLib:GetData(collider)

	if ((jumpData.Height < npc.Size * 3 or (jumpData.Height < npc.Size * 4 and playerData.UncappedSpeed > 2.2)) and (jumpData.Jumping and jumpData.Tags["SonicCharacterMod_SpinJump"])) then
		-- take damage with a multiplier based on the player's velocity
		-- npc:TakeDamage(collider:ToPlayer().Damage * (2 + collider.Velocity:Length() / 8),0,EntityRef(collider),10)
		print(npc.HitPoints)
		local damageDealt = collider:ToPlayer().Damage * (2 + math.max(((collider.Velocity:Length() - 6) / 1.1),0))
		npc:TakeDamage(damageDealt,0,EntityRef(collider),10)
		-- bounce away
		-- this syntax is fucking stupid.
		collider.Velocity = Vector(0,0).Clamped(((collider.Position - npc.Position):Normalized() * (npc.Size / 2)),-10,-10,10,10)
		-- brief invincibility so enemies that explode arent fucking annoying and kill you
		playerData.sonicBriefInvul = 7
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

		SonicCharacterMod:onSonicHit(collider:ToPlayer(),npc,false)
		
		return false -- collide without damage
	elseif jumpData.Jumping and jumpData.Tags["SonicCharacterMod_SpinJump"] then
		return true -- no collide
	elseif playerData.InSpindash then
		-- TakeDamage() returns if the entity was damaged
		local damaged = npc:TakeDamage(collider:ToPlayer().Damage *
		(-3 + math.max(((collider.Velocity:Length() - 3) / 1.1),0))
		,64,EntityRef(collider),10)
		-- npc:TakeDamage(collider:ToPlayer().Damage * 2,0,EntityRef(collider),10)
		playerData.sonicBriefInvul = 7
		if damaged then SonicCharacterMod:onSonicHit(collider:ToPlayer(),npc,true) end
		return true -- no collide
	end
	
end

-- TODO: make jumping on non-movable tnt damage it
-- TODO: make jumping over damaging gridentities without taking damage possible
-- TODO: same with brimstone lasers
-- TODO: make ball size match player size

local function onPlayerTakeDmg(_, player, amount, flags, source, countdown)
	local playerData = player:GetData()
	local jumpData = JumpLib:GetData(player)
	-- print(flags & DamageFlag.DAMAGE_ACID == DamageFlag.DAMAGE_ACID)
	if playerData.sonicBriefInvul ~= nil and playerData.sonicBriefInvul > 0 then
		return false
	end
	-- can spindash over creep
	if (flags & DamageFlag.DAMAGE_ACID == DamageFlag.DAMAGE_ACID) and playerData.InSpindash then
		return false
	end
	-- can jump over red poop
	-- TODO: make you consistently take damage when landing on red poop or make you not take damage when you land right next to a red poop
	-- if (flags & DamageFlag.DAMAGE_POOP == DamageFlag.DAMAGE_POOP) and jumpData.Height >= 10 then
	if (flags & DamageFlag.DAMAGE_POOP == DamageFlag.DAMAGE_POOP) and jumpData.Jumping then
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

local function preProjectileCollision(_, projectile, collider, low)
	if collider:ToPlayer() then
		local playerData = player:GetData()
		if playerData.InSpindash and not projectile:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then
			local awayVector = (projectile.Position - collider.Position):Normalized()
			print(awayVector)
			projectile:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER)
			projectile.Velocity = (awayVector * Vector(10,10)) + collider.Velocity
			return true
		end
	end
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

				if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
					local brimLaser = player:FireBrimstone(player.Velocity,player)
					-- local brimLaser = player:FireDelayedBrimstone(player.Velocity:GetAngleDegrees(),nil)
					-- brimLaser.Parent = nil
					brimLaser:GetData().SonicIsBrimLaser = true
					brimLaser:GetData().SonicBrimLaserStaticPos = brimLaser.Position
					brimLaser:GetData().SonicBrimLaserStaticOffset = Vector(0,0)
					-- centers it when horizontal
					if playerData.SpindashDirection == Direction.LEFT or playerData.SpindashDirection == Direction.RIGHT then
						brimLaser:GetData().SonicBrimLaserStaticOffset = Vector(0,-15)
					end
					brimLaser.PositionOffset = brimLaser:GetData().SonicBrimLaserStaticOffset
					-- brimLaser:AddTearFlags(player.TearFlags)
					-- brimLaser.TearFlags = player.TearFlags
				end
			end
			return
		end
		-- so you can dash through explosives
		if gridEntity:GetType() == GridEntityType.GRID_TNT or gridEntity:GetType() == GridEntityType.GRID_ROCK_BOMB then
			playerData.sonicBriefInvul = 5
		end
		-- if gridEntity:GetType() == GridEntityType.GRID_TRAPDOOR then print("A") end
		gridEntity:Destroy(false)
		return true
	end
end

-- TODO: make tears hit sonic while hes jumping if its high enough

local function onLaserUpdate(_, lasere)
	if lasere:GetData().SonicIsBrimLaser then
		lasere.Position = lasere:GetData().SonicBrimLaserStaticPos
		-- both of these to keep the fucking thing still
		lasere.ParentOffset = lasere:GetData().SonicBrimLaserStaticPos - lasere.Parent.Position
		lasere.PositionOffset = lasere:GetData().SonicBrimLaserStaticOffset
	end
end

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
SonicCharacterMod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, preProjectileCollision)
SonicCharacterMod:AddCallback(ModCallbacks.MC_POST_LASER_RENDER, onLaserUpdate)