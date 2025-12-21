require('SkillTypes')

g_SkillCalc = 
{
[SKILLID_MELEEATTACK]			= function(ownerID, targetID) return RAND(35,40) end,	-- 칼 공격
[SKILLID_MELEEATTACK_CHARGE]	= function(ownerID, targetID) return RAND(95,110) end,	-- 칼 Charge 공격
[SKILLID_SWORD_THROW_HORIZONTAL]= function(ownerID, targetID) return RAND(120,120) end,	-- 칼 가로 던지기
[SKILLID_SWORD_THROW_VERTICAL]	= function(ownerID, targetID) return RAND(125,125) end,	-- 칼 세로 던지기
[SKILLID_SWORD_THROW_CIRCURLAR]	= function(ownerID, targetID) return RAND(130,130) end,	-- 칼 사방 회전 던지기
							
[SKILLID_ARROW_POSITION]		= function(ownerID, targetID) return RAND(2,3) end,	-- 그냥 땅으로 쏘는 화살
[SKILLID_ARROW]					= function(ownerID, targetID) return RAND(8,13) end,	-- 적당히 조준된 화살. 이 데미지에 추가로 accuracy값이 적용됨
[SKILLID_POWER_ARROW]			= function(ownerID, targetID) return RAND(45,53) end,	-- 완전히 조준된 화살
[SKILLID_ARROW_MULTISHOT]		= function(ownerID, targetID) return RAND(60,70) end,	-- 활 멀티샷
[SKILLID_FORCE_FIELD]			= function(ownerID, targetID) return RAND(130,130) end,	-- 활 사방 공격 + 반사 스킬      

[SKILLID_FIRE_SMASH]			= function(ownerID, targetID) return RAND(190,195) end,	-- 앞으로 쏘는 fire smash
[SKILLID_TAIL_SPLASH]			= function(ownerID, targetID) return RAND(110,115) end,	-- 꼬리에서 나가는 tail splash
[SKILLID_TAIL_SPLASH2]			= function(ownerID, targetID) return RAND(150,165) end,	-- 꼬리에서 나가는 tail splash2(BIG)
[SKILLID_FIRE_BREATH]			= function(ownerID, targetID) return RAND(300,320) end,	-- 뒤로 돌아쏘는 브레쓰
[SKILLID_TAIL_SPLASH_REFLECT]	= function(ownerID, targetID) return RAND(70,80) end,	-- tail splash 반사
[SKILLID_TAIL_SPLASH2_REFLECT]	= function(ownerID, targetID) return RAND(100,110) end,	-- tail splash2 반사(BIG)
}


function GetMeleeDamageToMob( ownerID, targetMobID )
	local damage = RAND(15,20)
	return damage
end

function GetMeleeDamageToPlayer( ownerID, targetPlayerID )
	local damage = RAND(15,20)
	return damage
end


function GetSkillDamageToMob( skillID, ownerID, targetMobID )
	local damage
	
	if g_SkillCalc[skillID] then
		damage = g_SkillCalc[skillID](ownerID, targetMobID)
	else
		damage = RAND(80,110)
	end
	
    if skillID==SKILLID_LIGHTNING_ARROW_POSITION then
        damage = RAND(5,10)
        
    elseif skillID==SKILLID_SOULLINK then
		local ownerMob = mgr:GetMob(ownerID)
		if ownerMob ~= nil then
			local targetMob = mgr:GetMob(targetMobID)
			if targetMob ~= nil and ownerMob:GetMonsterType()==targetMob:GetMonsterType() then
				damage = -RAND(170,200)
			end
		end
		
	elseif skillID==SKILLID_CHARGEATTACK then
		damage = RAND(12,15)
	elseif skillID==SKILLID_CHARGESIDE then
		damage = RAND(7,10)
	elseif skillID==SKILLID_CHARGEJUMP then
		damage = RAND(7,10)
	end
	
	return damage
end

function GetSkillSplashDamageToMob( skillID, ownerID, targetMobID )
	local damage = GetSkillDamageToMob(skillID, ownerID, targetMobID )
    local splashDamage = damage * 0.4 + RAND(0,20)
	return splashDamage
end

function GetSkillDamageToPlayer( skillID, ownerID, targetPlayerID )
	local damage
	
	if g_SkillCalc[skillID] then
		damage = g_SkillCalc[skillID](ownerID, targetMobID)
		--print('skillcalc = '..skillID..'\n')
	else
		--print('no skillcalc = '..skillID..'\n')
		damage = RAND(80,110)
	end
	
	if skillID==SKILLID_LIGHTNING_ARROW_POSITION then
        damage = RAND(5,10)
        
	elseif skillID==SKILLID_BODY_ATTACK then
		damage = RAND(190,250)
	elseif skillID==SKILLID_BODY_PRESS then
		damage = RAND(880,1050)    
    elseif skillID==SKILLID_HEAL_OTHER then
		damage = -RAND(170, 200)
    elseif skillID==SKILLID_HEAL_SELF then
		damage = -RAND(100, 120)
    
    elseif skillID==SKILLID_MELEEATTACK then
		local player = mgr:GetPlayer(ownerID)
		if player ~= nil then			
			local modify = player:GetVelocity() * 0.02777
			modify = RANGE( 0.3, modify, 2 )			
			damage = damage * modify
		end
    elseif skillID==SKILLID_CHARGEATTACK then
		damage = RAND(12,15)
	elseif skillID==SKILLID_CHARGESIDE then
		damage = RAND(7,10)
	elseif skillID==SKILLID_CHARGEJUMP then
		damage = RAND(7,10)
	end
    
    
    return damage
end

function GetSkillSplashDamageToPlayer( skillID, ownerID, targetPlayerID )
	local damage = GetSkillDamageToPlayer(skillID, ownerID, targetPlayerID )
    local splashDamage = damage --* 0.4 + RAND(0,20)
    return splashDamage
end