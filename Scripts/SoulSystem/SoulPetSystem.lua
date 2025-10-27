
function SoulPetMain(uid)
	local xml = ""
	xml = xml .. XmlExt().. XmlExt_Img("SoulPetSystem","230,119","1") ..XmlExt("0");
	xml = xml..XmlTextSize("				Soul Companion","fcfcfc",18);
	xml = xml..XmlExt()..XmlExt_Text("  	")..NoUnderlineXML("[Gamble]","HatchEggGoMenu","13")..XmlExt(0)
	xml = xml..XmlExt()..XmlExt(0)
	return xml
end

function EvolveSoulPet1(uid)
	local xml = ""
	xml = xml .. XmlExt().. XmlExt_Img("EggIncubate","230,119","1") ..XmlExt("0");
	xml = xml..XmlTextSize("				Soul Companion","fcfcfc",18);
	xml = xml..XmlExt()..XmlExt_Text("  	")..NoUnderlineXML("[Gamble]","HatchEggGoMenu","13")..XmlExt(0)
	xml = xml..XmlExt()..XmlExt(0)
	xml = xml..XmlExt()..XmlExt_Text("   ")..XmlExt_Text("Incubate your egg to transform into Soul Companion[Hatchling]! Cost: 30x [Medium Soulstone] + Egg (item) Next levels will require the same amount of Soulstone + previous Egg (item).")..XmlExt(0)
	xml = xml..XmlExt()..XmlExt_Text("   ")..NoUnderlineXML("[Incubate]","IncubateEgg","15")..XmlExt(0)
	--xml = xml..XmlExt()..XmlExt_Text("                           	      	")..NoUnderlineXML("Back","defaulttalk","15")..XmlExt(0)
	xml = xml..XmlExt()..XmlExt(0)
	return xml
end
function HatchEggMenu(uid)
	local xml = ""
	xml = xml .. XmlExt().. XmlExt_Img("GambleEgg","230,119","1") ..XmlExt("0");
	xml = xml..XmlTextSize("				Soul Companion","fcfcfc",18);
	xml = xml..XmlExt()..XmlExt_Text("  	")..NoUnderlineXML("[Gamble]","HatchEggGoMenu","13")..XmlExt(0)
	--xml = xml .. XmlExt().. XmlExt_Img("levelup","256,131","1") ..XmlExt("0");
	xml = xml..XmlExt()..XmlExt_Text("   ")..XmlExt_Text("Gamble to get your Soul Companion[Egg]! Cost: 10x [Small Soulstone]")..XmlExt(0)
	xml = xml..XmlExt()..XmlExt_Text("   ")..NoUnderlineXML("[Gamble]","hatchEgg","15")..XmlExt(0)
	xml = xml..XmlExt()..XmlExt(0)
	return xml
end

function LevelUp(uid)
	local xml = ""
	xml = xml .. XmlExt().. XmlExt_Img("EvolveHatchling","230,119","1") ..XmlExt("0");
	xml = xml..XmlTextSize("				Soul Companion","fcfcfc",18);
	xml = xml..XmlExt()..XmlExt_Text("  	")..NoUnderlineXML("[Gamble]","HatchEggGoMenu","13")..XmlExt(0)
	--xml = xml .. XmlExt().. XmlExt_Img("levelup","256,131","1") ..XmlExt("0");
	xml = xml..XmlExt()..XmlExt_Text("   ")..XmlExt_Text("Train your Soul Companion[Hatchling] to make it even stronger!  Cost: 60x [Large Soulstone] + Hatchling (item). Next levels will require the same amount of Soulstone + previous Hatchling (item)")..XmlExt(0)
	xml = xml..XmlExt()..XmlExt_Text("   ")..NoUnderlineXML("[Train Hatchling]","LevelUpSoulPet","15")..XmlExt(0)
	xml = xml..XmlExt()..XmlExt(0)
	return xml
end

function Egg_GetEff(uid)
	for i=2873,2950 do
		if CreHasEff(uid, i) == 1 then
			return i
		end
	end
	return 0
end

function hatchEggRoll(uid)
	local eff = Egg_GetEff(uid);
	if eff == 0 then	
		if GetItemCount(uid,7852) < 10 or GetItemCount(uid,7885) == 1 or GetItemCount(uid,7900) == 1 or GetItemCount(uid,7915) == 1 or GetItemCount(uid,7930) == 1 or GetItemCount(uid,7945) == 1 or eff == 1 then
			CenterMsg(uid,"Not enough Soulstones or you already have a Soul Compaion!")
		elseif GetItemCount(uid,7852) >= 10  then
			local rad = math.random(1,10) 
			if (rad <= 9) then
			RemoveItem(uid,7852,10)
			CenterMsg(uid,"You failed to get Soul Companion!") 
			else
			return hatchEggWin(uid)
			end
		end
		return HatchEggMenu(uid)
	else
		CenterMsg(uid,"Not enough Soulstones or you already have a Soul Compaion!")
		return HatchEggMenu(uid)
	end
end


function hatchEggWin(uid)
	local iParty = GetUserParty(uid);
    if GetItemCount(uid,7852) >= 10 then
		RemoveItem(uid,7852,10)
		if iParty == 0 then             
				--AddEffect(uid, 15772)   --wizz
				AddItem(uid,7930,0,14,2)
			elseif iParty == 1 then
				--AddEffect(uid, 15757)	--monk
				AddItem(uid,7900,0,14,2)
			elseif iParty == 2 then
				--AddEffect(uid, 15742)	--sin
				AddItem(uid,7885,0,14,2)
			elseif iParty == 3 then     
				--AddEffect(uid, 15787)   --fay
				AddItem(uid,7915,0,14,2)
			elseif iParty == 4 then     
				--AddEffect(uid, 15727)   --tamer
				AddItem(uid,7945,0,14,2)
		end
		CenterMsg(uid,"You received an Egg!")	
		return ReceiveEgg(uid)
    end
	
end

function ReceiveEgg(uid)
	local xml = ""
	xml = xml .. XmlExt().. XmlExt_Img("ItlogSystem","236,236","1") ..XmlExt("0");
	xml = xml..XmlTextSize("   		You received an egg!","d834eb",18);
	xml = xml..XmlExt()..XmlExt(0)
	return xml
end

CAI_9416 = class(CAIObject)
function CAI_9416:ctor(id, objid)
end
function CAI_9416:OnInteractive(uid, event)
	
	local ListEffect = {
		15732,15733,15734,15735,15736,15737,15738,15739,15740,15741,15747,15748,15749,15750,15751,15752,15753,15754,15755,15756,
		15762,15763,15764,15765,15766,15767,15768,15769,15770,15771,15777,15778,15779,15780,15781,15782,15783,15784,15785,15786,
		15792,15793,15794,15795,15796,15797,15798,15799,15800,15801
		}; 
	local xml = ""
	if event == "defaulttalk" then
		return SoulPetMain(uid)
	end
	if event == "evolvesoul" then
		return EvolveSoulPet1(uid)
	end
	if event=="hatchEgg" then
		return hatchEggRoll(uid)
	end
	if event=="LevelUpPet" then
		return LevelUp(uid)
	end
	if event=="HatchEggGoMenu" then
		return HatchEggMenu(uid)
	end
	
			if event == "IncubateEgg" then
					local iParty = GetUserParty(uid);
					if iParty == 0 then
							if CreHasEff(uid,15772) == 1 and GetItemCount(uid,7930) == 1 and GetItemCount(uid,7856) >= 30 then
								RemoveEffect(uid,15772)
								AddEffect(uid, 15773)
								RemoveItem(uid,7930,1)
								RemoveItem(uid,7856,30)
								AddItem(uid,7931,0,0,2)
								CenterMsg(uid,"Egg Resistance: 80%")
							elseif CreHasEff (uid,15773) == 1 and GetItemCount(uid,7931) == 1 and GetItemCount(uid,7856) >= 30 then
								RemoveEffect(uid,15773)
								AddEffect(uid, 15774)
								RemoveItem(uid,7931,1)
								RemoveItem(uid,7856,30)
								AddItem(uid,7932,0,0,2)
								CenterMsg(uid,"Egg Resistance: 60%")
							elseif CreHasEff (uid,15774) == 1 and GetItemCount(uid,7932) == 1 and GetItemCount(uid,7856) >= 30 then
								RemoveEffect(uid,15774)
								AddEffect(uid, 15775)
								RemoveItem(uid,7932,1)
								RemoveItem(uid,7856,30)
								AddItem(uid,7933,0,0,2)
								CenterMsg(uid,"Egg Resistance: 40%")
							elseif CreHasEff (uid,15775) == 1 and GetItemCount(uid,7933) == 1 and GetItemCount(uid,7856) >= 30 then
								RemoveEffect(uid,15775)
								AddEffect(uid, 15776)
								RemoveItem(uid,7933,1)
								RemoveItem(uid,7856,30)
								AddItem(uid,7934,0,0,2)
								CenterMsg(uid,"Egg Resistance: 20%")
							elseif CreHasEff (uid,15776) == 1 and GetItemCount(uid,7934) == 1 and GetItemCount(uid,7856) >= 30 then
								RemoveEffect(uid,15776)
								AddEffect(uid, 15777)
								RemoveItem(uid,7934,1)
								RemoveItem(uid,7856,30)
								AddItem(uid,7935,0,0,2)
								CenterMsg(uid,"Hatch Successful!")
								SendMedia("Congratulations to  "..(GetUserNameByObjId(uid)).."  for hatching his first egg! ",7); 
							
							else
							CenterMsg(uid,"Requirements not met!")
							end
					elseif iParty == 1 then
							if CreHasEff(uid,15757) == 1  then
						  		RemoveEffect(uid,15757)
								AddEffect(uid, 15758)
							elseif CreHasEff (uid,15758) == 1  then
								RemoveEffect(uid,15758)
								AddEffect(uid, 15759)
							elseif CreHasEff (uid,15759) == 1  then
								RemoveEffect(uid,15759)
								AddEffect(uid, 15760)
							elseif CreHasEff (uid,15760) == 1  then
								RemoveEffect(uid,15760)
								AddEffect(uid, 15761)
							elseif CreHasEff (uid,15761) == 1  then
								RemoveEffect(uid,15761)
								AddEffect(uid, 15762)
								SendMedia("Congratulations to  "..(GetUserNameByObjId(uid)).."  for hatching his first egg! ",7); 
							
							else
							CenterMsg(uid,"Requirements not met!")
							end
					elseif iParty == 2 then 		--sin
							if CreHasEff(uid,15742) == 1  then
						  		RemoveEffect(uid,15742)
								AddEffect(uid, 15743)
							elseif CreHasEff (uid,15743) == 1  then
								RemoveEffect(uid,15743)
								AddEffect(uid, 15744)
							elseif CreHasEff (uid,15744) == 1  then
								RemoveEffect(uid,15744)
								AddEffect(uid, 15745)
							elseif CreHasEff (uid,15745) == 1  then
								RemoveEffect(uid,15745)
								AddEffect(uid, 15746)
							elseif CreHasEff (uid,15746) == 1  then
								RemoveEffect(uid,15746)
								AddEffect(uid, 15747)
								SendMedia("Congratulations to  "..(GetUserNameByObjId(uid)).."  for hatching his first egg! ",7); 
							
							else
							CenterMsg(uid,"Requirements not met!")
							end
					elseif iParty == 3 then
							if CreHasEff(uid,15787) == 1  then
						  		RemoveEffect(uid,15787)
								AddEffect(uid, 15788)
							elseif CreHasEff (uid,15788) == 1  then
								RemoveEffect(uid,15788)
								AddEffect(uid, 15789)
							elseif CreHasEff (uid,15789) == 1  then
								RemoveEffect(uid,15789)
								AddEffect(uid, 15790)
							elseif CreHasEff (uid,15790) == 1  then
								RemoveEffect(uid,15790)
								AddEffect(uid, 15791)
							elseif CreHasEff (uid,15791) == 1  then
								RemoveEffect(uid,15791)
								AddEffect(uid, 15792)
								SendMedia("Congratulations to  "..(GetUserNameByObjId(uid)).."  for hatching his first egg! ",7); 
							
							else
							CenterMsg(uid,"Requirements not met!")

							end
					elseif iParty == 4 then   --tamer
							if CreHasEff(uid,15727) == 1  then
						  		RemoveEffect(uid,15727)
								AddEffect(uid, 15728)
							elseif CreHasEff (uid,15728) == 1  then
								RemoveEffect(uid,15728)
								AddEffect(uid, 15729)
							elseif CreHasEff (uid,15729) == 1  then
								RemoveEffect(uid,15729)
								AddEffect(uid, 15730)
							elseif CreHasEff (uid,15730) == 1  then
								RemoveEffect(uid,15730)
								AddEffect(uid, 15731)
							elseif CreHasEff (uid,15731) == 1  then
								RemoveEffect(uid,15731)
								AddEffect(uid, 15732)
								SendMedia("Congratulations to  "..(GetUserNameByObjId(uid)).."  for hatching his first egg! ",7); 
							else
							CenterMsg(uid,"Requirements not met!")
							end
					end
					return EvolveSoulPet1(uid)
			end
			if event == "LevelUpSoulPet" then
				local iParty = GetUserParty(uid);
					if iParty == 0 then
							if CreHasEff(uid,15777) == 1 and GetItemCount(uid,7935) == 1 and GetItemCount(uid,7860) < 60 then
						  		 RemoveEffect(uid,15777)
								 AddEffect(uid, 15778)
								 RemoveItem(uid,7935,1)
								 RemoveItem(uid,7860,60)
								 AddItem(uid,7936,0,0,2)
								 CenterMsg(uid,"Hatchling Energy: 20%")
							elseif CreHasEff (uid,15778) == 1 and GetItemCount(uid,7936) == 1 and GetItemCount(uid,7860) < 60 then
								RemoveEffect(uid,15778)
								AddEffect(uid, 15779)
								RemoveItem(uid,7936,1)
								RemoveItem(uid,7860,60)
								AddItem(uid,7937,0,0,2)
								CenterMsg(uid,"Hatchling Energy: 40%")
							elseif CreHasEff (uid,15779) == 1 and GetItemCount(uid,7937) == 1 and GetItemCount(uid,7860) < 60 then
								RemoveEffect(uid,15779)
								AddEffect(uid, 15780)
								RemoveItem(uid,7937,1)
								RemoveItem(uid,7860,60)
								AddItem(uid,7938,0,0,2)
								CenterMsg(uid,"Hatchling Energy: 60%")
							elseif CreHasEff (uid,15780) == 1 and GetItemCount(uid,7938) == 1 and GetItemCount(uid,7860) < 60 then
								RemoveEffect(uid,15780)
								AddEffect(uid, 15781)
								RemoveItem(uid,7938,1)
								RemoveItem(uid,7860,60)
								AddItem(uid,7939,0,0,2)
								CenterMsg(uid,"Hatchling Energy: 80%")
							elseif CreHasEff (uid,15781) == 1 and GetItemCount(uid,7939) == 1 and GetItemCount(uid,7860) < 60 then
								RemoveEffect(uid,15781)
								AddEffect(uid, 15782)
								RemoveItem(uid,7939,1)
								RemoveItem(uid,7860,60)
								AddItem(uid,7940,0,0,2)
								CenterMsg(uid,"Hatchling Evolved to Fledling!")
								SendMedia("Congratulations to  "..(GetUserNameByObjId(uid)).."  for evolving his soul companion to Fledling! ",7); 
							else
							CenterMsg(uid,"Requirements not met!")
							end
					elseif iParty == 1 then
							if CreHasEff(uid,15762) == 1  then
						  		 RemoveEffect(uid,15762)
								 AddEffect(uid, 15763)
							elseif CreHasEff (uid,15763) == 1  then
								RemoveEffect(uid,15763)
								AddEffect(uid, 15764)
							elseif CreHasEff (uid,15764) == 1  then
								RemoveEffect(uid,15764)
								AddEffect(uid, 15765)
							elseif CreHasEff (uid,15765) == 1  then
								RemoveEffect(uid,15765)
								AddEffect(uid, 15766)
							elseif CreHasEff (uid,15766) == 1  then
								RemoveEffect(uid,15766)
								AddEffect(uid, 15767)
								SendMedia("Congratulations to  "..(GetUserNameByObjId(uid)).."  for evolving his soul companion to Fledling! ",7); 
							else
							CenterMsg(uid,"Requirements not met!")
							end
					elseif iParty == 2 then 		--sin
							if CreHasEff(uid,15747) == 1  then
						  		 RemoveEffect(uid,15747)
								 AddEffect(uid, 15748)
							elseif CreHasEff (uid,15748) == 1  then
								RemoveEffect(uid,15748)
								AddEffect(uid, 15749)
							elseif CreHasEff (uid,15749) == 1  then
								RemoveEffect(uid,15749)
								AddEffect(uid, 15750)
							elseif CreHasEff (uid,15750) == 1  then
								RemoveEffect(uid,15750)
								AddEffect(uid, 15751)
							elseif CreHasEff (uid,15751) == 1  then
								RemoveEffect(uid,15751)
								AddEffect(uid, 15752)
								SendMedia("Congratulations to  "..(GetUserNameByObjId(uid)).."  for evolving his soul companion to Fledling! ",7); 
							else
							CenterMsg(uid,"Requirements not met!")
							end
					elseif iParty == 3 then
							if CreHasEff(uid,15792) == 1  then
						  		 RemoveEffect(uid,15792)
								 AddEffect(uid, 15793)
							elseif CreHasEff (uid,15793) == 1  then
								RemoveEffect(uid,15793)
								AddEffect(uid, 15794)
							elseif CreHasEff (uid,15794) == 1  then
								RemoveEffect(uid,15794)
								AddEffect(uid, 15795)
							elseif CreHasEff (uid,15795) == 1  then
								RemoveEffect(uid,15795)
								AddEffect(uid, 15796)
							elseif CreHasEff (uid,15796) == 1  then
								RemoveEffect(uid,15796)
								AddEffect(uid, 15797)
								SendMedia("Congratulations to  "..(GetUserNameByObjId(uid)).."  for evolving his soul companion to Fledling! ",7); 
							else
							CenterMsg(uid,"Requirements not met!")

							end
					elseif iParty == 4 then   --tamer
							if CreHasEff(uid,15732) == 1  then
						  		 RemoveEffect(uid,15732)
								 AddEffect(uid, 15733)
							elseif CreHasEff (uid,15733) == 1  then
								RemoveEffect(uid,15733)
								AddEffect(uid, 15734)
							elseif CreHasEff (uid,15734) == 1  then
								RemoveEffect(uid,15734)
								AddEffect(uid, 15735)
							elseif CreHasEff (uid,15735) == 1  then
								RemoveEffect(uid,15735)
								AddEffect(uid, 15736)
							elseif CreHasEff (uid,15736) == 1  then
								RemoveEffect(uid,15736)
								AddEffect(uid, 15737)
								SendMedia("Congratulations to  "..(GetUserNameByObjId(uid)).."  for evolving his soul companion to Fledling! ",7); 
							else
							CenterMsg(uid,"Requirements not met!")
							end
					end
					return LevelUp(uid)
			end
end

---------------------------------------------------------------------------------------------------


function NoUnderlineXML(msg, link, size, color)
    if size then
        size = "font=\"title\" fontsize=\"" .. size .. "\"";
    else
        size = "";
    end
    if not color then
        color = "a6a845";
    end
    return "<Item type=\"TEXT\" text=\"" .. msg .. "\" " .. size .. " hlink=\"String:NpcDialog:" .. link ..
            "?npc=$NPC_OBJID\" underline=\"false\" color=\"#ff" .. color .. "\" />"
                           
end


function XmlExt(num)
    if num then
        return "</Items></Line>";
    end
    return "<Line><Items>";
end

function XmlText(msg,cl)
	if cl then
		if cl == "er" then
			return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" color=\"#ffff4da6\"/></Items></Line>";
		elseif cl == "ss" then
			return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" color=\"#ff00ff80\"/></Items></Line>";
		else
			return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" color=\"#ff"..cl.."\"/></Items></Line>";
		end
	else
		return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" color=\"#ffa6a845\"/></Items></Line>";
	end
end
function XmlTextSize(msg,cl,size)
	if cl then
		if cl == "er" then
			return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" font=\"title\" fontsize=\""..size.."\" color=\"#ffff4da6\"/></Items></Line>";
		elseif cl == "ss" then
			return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" font=\"title\" fontsize=\""..size.."\" color=\"#ff00ff80\"/></Items></Line>";
		else
			return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" font=\"title\" fontsize=\""..size.."\" color=\"#ff"..cl.."\"/></Items></Line>";
		end
	else
		return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" font=\"title\" fontsize=\""..size.."\" color=\"#ffa6a845\"/></Items></Line>";
	end
end

function XmlExt_Text(msg, color)
    if color then
        return "<Item type=\"TEXT\" text=\"" .. msg .. "\" color=\"#ff" .. color .. "\"/>";
    else
        return "<Item type=\"TEXT\" text=\"" .. msg .. "\" color=\"#ffa6a845\" />";
    end
end

function XmlExt_Img(img, size, tran)
    if not size then
        size = "";
    else
        size = "Source=\"0,0," .. size .. "," .. size .. "\"";
    end
    if not tran then
        tran = "0.5";
    end
    return "<Item type=\"IMAGE\"><Image File=\"" .. img .. "\" Transparency=\"" .. tran .. "\" " .. size .. " /></Item>";
end
