
CAI_10101 = class(CAIObject)
function CAI_10101:ctor(id, objid)
end
function CAI_10101:OnInteractive(uid, event)
	content = "";
	local eff = GetEff(uid);
	local numeff = GetCount(uid)+1;
	local cnt1 = GetContent("DEV/DragonSpirit/main.xml");
	local item1 = GetItemCount(uid,7614);
	if not item1 then item1 = 0; end
	local cnt2 = string.gsub(cnt1,"xdNUM1",numeff);
	local cnt3 = string.gsub(cnt2,"$_dItem1",item1);
	if event == "defaulttalk" then
		if eff == 15209 then
			return CenterMsg(uid,"Your Dragon Essence is max level!");
		else
			content = cnt3;
		end
	end
	for i=1,40 do
		if event == "UPDATE+"..i then
			local uptmp = 0;
			if eff == 0 then
			-- Zodiac_Update(objeff,uid,haveeff,toeff,reqitem1,reqitem2,amount1,amount2,rate)
				uptmp = Update(self.ObjID,uid,0,15170,7614,i*10,i);
			else
			-- Zodiac_Update(objeff,uid,haveeff,toeff,reqitem1,reqitem2,amount1,amount2,rate)
				uptmp = Update(self.ObjID,uid,eff,eff+1,7614,i*10,i); 
			end
			if uptmp == 0 then
				OutputLog(GetUserNameByObjId(uid).."Dragon Err tmp value = 0");
				uptmp = nil;
			elseif uptmp == 1 then 
				CenterMsg(uid,"You Dragon Essence gained another level");
				uptmp = nil;
			elseif uptmp == 2 then 
				CenterMsg(uid,"Not enough Dragonsoul ");
				uptmp = nil;
			elseif uptmp == 3 then 
				CenterMsg(uid,"can't take item ");
				uptmp = nil;
			elseif uptmp == 11 then 
				if i >= 9 then
					BroadcastMedia(str,"#cFF00A2 The strength of his spirit is incredible! "..(GetUserNameByObjId(uid)).." upgraded Dragon Essence to "..("Level "..i).." !",6); 
					CenterMsg(uid,"Your Dragon Essence gained another level");
					uptmp = nil;
			elseif i >= 19 then
					BroadcastMedia(str,"#cFF00A2 The strength of his spirit is incredible! "..(GetUserNameByObjId(uid)).." upgraded Dragon Essence to "..("Level "..i).." !",6); 
					CenterMsg(uid,"Your Dragon Essence gained another level");
					uptmp = nil;
			elseif i >= 29 then
					BroadcastMedia(str,"#cFF00A2 The strength of his spirit is incredible! "..(GetUserNameByObjId(uid)).." upgraded Dragon Essence to "..("Level "..i).." !",6); 
					CenterMsg(uid,"Your Dragon Essence gained another level");
					uptmp = nil;
			elseif i >= 39 then
					BroadcastMedia(str,"#cFF00A2 The strength of his spirit is incredible! "..(GetUserNameByObjId(uid)).." upgraded Dragon Essence to "..("Level "..i).." !",6); 
					CenterMsg(uid,"Your Dragon Essence gained another level");
					uptmp = nil;
			elseif i >= 49 then
					BroadcastMedia(str,"#cFF00A2 The strength of his spirit is incredible! "..(GetUserNameByObjId(uid)).." upgraded Dragon Essence to "..("Level "..i).." !",6); 
					CenterMsg(uid,"Your Dragon Essence gained another level");
					uptmp = nil;
					if i == 49 then return CenterMsg(uid,"Your Dragon Sirit is max level! "); end
				else
					CenterMsg(uid,"Your Dragon Essence gained another level");
					uptmp = nil;
				end
			elseif uptmp == 9 then 
				if i >= 9 then
					BroadcastMedia(str,"#216 #cFF00A2 Oops! "..(GetUserNameByObjId(uid)).." failed to level up Dragon Essence to "..("Level "..i).." !",6);
					CenterMsg(uid,"Your Dragon Essence failed");
					uptmp = nil;
			elseif i >= 19 then
					BroadcastMedia(str,"#216 #cFF00A2 Oops! "..(GetUserNameByObjId(uid)).." failed to level up Dragon Essence to "..("CLevel "..i).." !",6);
					CenterMsg(uid,"Your Dragon Essence failed");
					uptmp = nil;
			elseif i >= 29 then
					BroadcastMedia(str,"#216 #cFF00A2 Oops! "..(GetUserNameByObjId(uid)).." failed to level up Dragon Essence to "..("CLevel "..i).." !",6);
					CenterMsg(uid,"Your Dragon Essence failed");
					uptmp = nil;
			elseif i >= 39 then
					BroadcastMedia(str,"#216 #cFF00A2 Oops! "..(GetUserNameByObjId(uid)).." failed to level up Dragon Essence to "..("CLevel "..i).." !",6);
					CenterMsg(uid,"Your Dragon Essence failed");
					uptmp = nil;
			elseif i >= 49 then
					BroadcastMedia(str,"#216 #cFF00A2 Oops! "..(GetUserNameByObjId(uid)).." failed to level up Dragon Essence to "..("CLevel "..i).." !",6);
					CenterMsg(uid,"Your Dragon Essence failed");
					uptmp = nil;
				else
					CenterMsg(uid,"Oops, update failed");
					uptmp = nil;
				end
			end
		end
	end
	return content;
end

function GetEff(uid)
	for i=15170,15209 do
		if CreHasEff(uid, i) == 1 then
			return i
		end
	end
	return 0
end
function GetCount(uid)
	local count = 0;
	for i=15170,15209 do
		count = count+1;
		if CreHasEff(uid, i) == 1 then
			return count
		end
	end
	return 0
end
function Update(objeff,uid,haveeff,toeff,reqitem1,amount1)
	if haveeff == 0 then
		if GetItemCount(uid,reqitem1) >= amount1 then
			if RemoveItem(uid,reqitem1,amount1) then
				local rdn = math.random(1,100);
				OutputLog(" usn="..GetUserNameByObjId(uid).." rdn="..rdn.." toeff="..toeff);
				if rdn <= toeff then
					AddCreEff(uid, objeff, toeff);
					return 10
				else
					return 11
				end
			else
				return 3
			end
		else
			return 2
		end
	elseif CreHasEff(uid, haveeff) ~= 0 then
		if GetItemCount(uid,reqitem1) >= amount1 then
			if RemoveItem(uid,reqitem1,amount1) then
				local rdn = math.random(1,100);
				OutputLog(" usn="..GetUserNameByObjId(uid).." rdn="..rdn.." toeff="..toeff);
				if rdn <= toeff then
					RemoveEffect(uid, haveeff);
					AddCreEff(uid, objeff, toeff);
					return 10
				else
					return 11
				end
			else
				return 3
			end
		else
			return 2
		end
	else
		return 1
	end
end

