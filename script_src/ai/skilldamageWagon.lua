require('SkillTypes')

function GetMeleeDamageToMob( ownerID, targetMobID )
	local damage = RAND(15,20)
	return damage
end

function GetMeleeDamageToPlayer( ownerID, targetPlayerID )
	local damage = RAND(15,20)
	return damage
end


function GetSkillDamageToMob( skillID, ownerID, targetMobID )
	local damage = RAND(8,11)
	
    if skillID==SKILLID_FORCE_FIELD then
        damage = damage * 2
        
    elseif skillID==SKILLID_ARROW_POSITION or skillID==SKILLID_LIGHTNING_ARROW_POSITION then
        damage = 1
        
    elseif skillID==SKILLID_SOULLINK then
		local ownerMob = mgr:GetMob(ownerID)
		if ownerMob ~= nil then
			local targetMob = mgr:GetMob(targetMobID)
			if targetMob ~= nil and ownerMob:GetMonsterType()==targetMob:GetMonsterType() then
				damage = -RAND(17,20)
			end
		end
	end
	
	return damage
end

function GetSkillSplashDamageToMob( skillID, ownerID, targetMobID )
	local damage = GetSkillDamageToMob(skillID, ownerID, targetMobID )
    local splashDamage = damage * 0.4 + RAND(0,2)
	return splashDamage
end

function GetSkillDamageToPlayer( skillID, ownerID, targetPlayerID )
	local damage = RAND(8,11)
	
	if skillID==SKILLID_BODY_ATTACK then
		damge = RAND(19,25)
    elseif skillID==SKILLID_FORCE_FIELD then
        damage = damage * 2
    end
    
    return damage
end

function GetSkillSplashDamageToPlayer( skillID, ownerID, targetPlayerID )
	local damage = GetSkillDamageToPlayer(skillID, ownerID, targetPlayerID )
    local splashDamage = damage * 0.4 + RAND(0,2)
    return splashDamage
end