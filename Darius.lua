require('Inspired')

Config = scriptConfig("Darius", "Darius by Outbreak")
Config.addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
Config.addParam("W", "Use W", SCRIPT_PARAM_ONOFF, true)
Config.addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
Config.addParam("R", "Use R", SCRIPT_PARAM_ONOFF, true)

Config.addParam("Combo", "Combo", SCRIPT_PARAM_KEYDOWN, string.byte(" "))


OnLoop(function(myHero)
	
	
	if Config.Combo then
		local target = GetTarget(600)
		
		if Config.R and ValidTarget(target, 460)then
			local Truedmg = (160 + (90 * (GetCastLevel(myHero,_R) - 1)) + (GetBonusDmg(myHero) *  0.75) )
			local stacks = 0
			if not GetBuffCount(target,"dariushemo") == nil  then
				stacks = GetBuffCount(target,"dariushemo")
			end

			local Sdmg = (32 + (18 * stacks ) + (GetBonusDmg(myHero) *  0.15) ) 			
			local dmg = CalcDamage(myHero, target, Sdmg)
			local hp = GetCurrentHP(target)
			
			if (Truedmg + dmg) > hp then				
				CastTargetSpell(target, _R)
			end			
		end
		if Config.E and ValidTarget(target, 600)then
			local EPred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),math.huge,300,550,80,false,true)
			if CanUseSpell(myHero,_E) == READY and EPred.HitChance == 1 then				
				CastSkillShot(_E,EPred.PredPos.x,EPred.PredPos.y,EPred.PredPos.z)
			end
		end	
		
		if Config.Q and ValidTarget(target, 425) then			
			if CanUseSpell(myHero,_Q) == READY then
				CastTargetSpell(myHero, _Q)
			end
		end
		if Config.W and ValidTarget(target, 145) then			
			if CanUseSpell(myHero,_W) == READY then
				CastTargetSpell(myHero, _W)
			end
		end			
	end
	
end)
