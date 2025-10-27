function LMS_FunRmvEff(effid,obj,effid2)
	local Fist_Uid_tp = 1074790400;
	local count = 1;
	while (count <= 100) do
		for i=Fist_Uid_tp,Fist_Uid_tp+1999 do
			if GetCreLev(i) ~= 0 then
				if IsUser(i) == 1 then
					if CreHasEff(i, effid) == 1 then
						IfCreRideThenUnRide(i)
						RemoveEffect(i, effid);
						RemoveEffect(i, effid2);
						AddCreEff(i, obj, effid2);
					end
				end
			end
		end
		Fist_Uid_tp = Fist_Uid_tp+1048576;
	count = count + 1;
	end
end
function GetContent(pathfilename)
	local readfile = io.open(pathfilename,"r+");
	local data = readfile:read("*all");
	readfile:close()
	return data
end
function sslinetalk(msgline)
	return "<Line><Items><Item type=\"TEXT\" text=\""..msgline.."\" color=\"#ff00ff80\"/></Items></Line>";
end
function linelink(msg,event)
	return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" hlink=\"String:NpcDialog:"..event.."?npc=$NPC_OBJID\" underline=\"true\"/></Items></Line>";
end

CAI_10059 = class(CAIObject)
function CAI_10059:ctor(id, objid)
	LMS_Dow = 0;
	LMS_Time = 300; --Time Register Per Second
	LMS_Mess = 0;
	EndRegister = 0;
	fb14_Trigger = "";
end
function CAI_10059:OnUpdate(dwNow)
	local DayOfWeek = GetServerDayOfWeek();
	local Hour = GetServerHour();
	if GetContent("DEV/LMStanding/FLAG.ini") == "ON" then
		if GetContent("DEV/LMStanding/Test.ini") == "1" then -- Time test// after you test and its working / gets?
			--if Hour == 20 then -- Time Event
			if LMS_Mess == 0 then
				SendMedia(" Last Man Standing Register Open , Location at Stone City  "..LMS_Time.."s ", 7);
				Bulletin(" Last Man Standing Register Open , Location at Stone City  "..LMS_Time.."s ");
				LMS_Mess = 1;
				LMS_Dow = 1;
				EndRegister = dwNow + LMS_Time;
			end
			
			if dwNow == EndRegister then
				LMS_FunRmvEff(15722, self.ObjID, 15723);
				LMS_Dow = 2;
				fb14_Trigger = "START";
			end
		end
		if fb14_Trigger == "" and Hour == 0 then 
		-- if fb14_Trigger == "" and Hour ~= 22 then 
			LMS_Dow = 0;
			LMS_Mess = 0;
			EndRegister = 0;
		end
	end
end
function CAI_10059:OnInteractive(uid, event)
	if fb14_Trigger == "" and LMS_Dow == 1 then
		local content = "";
		if event == "defaulttalk" then
			content = linelink("Last Man Standing Register!","LMS_REGISTER");
		elseif event == "LMS_REGISTER" then
			if CreHasEff(uid, 15722) ~= 1 then
				AddCreEff(uid, self.ObjID, 15722);
				content = content..sslinetalk("Register done, Wait until the event start!");
			end
		end
		return content;
	end
end