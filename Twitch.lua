require('Inspired')

Config = scriptConfig("Twitch", "Twitch by Outbreak")
Config.addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E", "Use E to finish target", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E2", "Use E at 6 stacks", SCRIPT_PARAM_ONOFF, false)
Config.addParam("Combo", "Combo", SCRIPT_PARAM_KEYDOWN, string.byte(" "))

function TickDamage()
	local level = GetLevel(GetMyHero())
	if level > 4 and level <= 8 then
		return 3
	end
	if level > 8 and level <= 12 then
		return 4
	end
	if level > 12 and level <= 16 then
		return 5
	end
	if level > 16  then
		return 6
	end
	return 2
end
OnLoop(function(myHero)
	if Config.Combo then
		local target = GetTarget(950)
		if Config.W and ValidTarget(target, 950) then			
			local WPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1400,250,950,275,false,true)
			
			if CanUseSpell(myHero,_W) == READY and WPred.HitChance == 1 then				
				CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
			end
		end
		if Config.E and ValidTarget(target, 1200)then
		
			local Elevel = GetCastLevel(myHero,_E)
			local TDmg = GetBonusDmg(myHero)+GetBaseDamage(myHero)			
			
			for _,unit in pairs(GetEnemyHeroes()) do			
				local stacks = GotBuff(unit,"twitchdeadlyvenom")
				local stackDamage = (stacks * 5) + 10 + (0.2 * stacks) + (TDmg * (0.25 * stacks)) + TickDamage()
				local hp = GetCurrentHP(unit)
				if stackDamage >= hp then			
					CastTargetSpell(myHero, _E) 
				end
			end	
		end
		if Config.E2 and ValidTarget(target,1200) and not Config.E then
			local stacks = GotBuff(target,"twitchdeadlyvenom")
			if stacks == 6 then
				CastTargetSpell(myHero, _E)
			end
		end
	end
	
end)
