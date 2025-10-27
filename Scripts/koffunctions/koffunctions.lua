-- SceneCreateNpc(SceneObj, int nNpcId, int x, int y, int nDir)
-- GetNpcIdByTypeIdThroughScene(SceneObj, int nNpcTypeId);

function Split(szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
		while true do
		   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
		   if not nFindLastIndex then
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
			break
		   end
		   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
		   nFindStartIndex = nFindLastIndex + string.len(szSeparator)
		   nSplitIndex = nSplitIndex + 1
		end
	return nSplitArray
end

function PutContent(pathfilename,content)
	local writefile = io.open(pathfilename,"w+");
	if writefile then
		writefile:write(content);
		writefile:close();
		return true
	else 
		return false 
	end
end



function AddContent(pathfilename,content)
	local writefile = io.open(pathfilename,"a+");
	if writefile then
		writefile:write(content);
		writefile:close();
		return true
	else return false end
end


function HaveChar(tbl, val)
	for i, v in ipairs(tbl) do
		if v == val then
			return false
		end
	end
	return true
end
function SoSanhTable( a, b )
    return table.concat(a) == table.concat(b)
end
function GetUserOnline(x)
	local tbl = {};
	local count = 1;
	local FistUid = 1074790400;
	while (count <= tonumber(x)) do
		for i=FistUid,(FistUid + 1999) do
			if IsUser(i) == 1 then
				if not UserIsGM(i) then  
					table.insert(tbl,GetUserNameByObjId(i));
				end
			end
		end
		FistUid = FistUid+1048576;
	count = count + 1;
	end
	return tbl;
end

function file_exists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end

function tablecount(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
function sslinetalk(msgline)
	return "<Line><Items><Item type=\"TEXT\" text=\""..msgline.."\" color=\"#ff00ff80\"/></Items></Line>";
end
function erlinetalk(msgline)
	return "<Line><Items><Item type=\"TEXT\" text=\""..msgline.."\" color=\"#ffff4da6\"/></Items></Line>";
end
function xlinetalk(msgline,cl)
	return "<Line><Items><Item type=\"TEXT\" text=\""..msgline.."\" color=\"#"..cl.."\"/></Items></Line>";
end

function linelink(msg,event)
	return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" font=\"title\" fontsize=\"17\" hlink=\"String:NpcDialog:"..event.."?npc=$NPC_OBJID\" underline=\"true\"/></Items></Line>";
end



function ColorMedia(ct,cl)
	return "#c"..cl..""..ct.."#n";
end
function ServerTimeConverHMSDMY() --Get Time
	local uNixTime = GetServerTime();
	return(os.date("[%H:%M:%S %d-%m-%Y]", uNixTime));
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
function XmlLink(msg,event,size)
	if size then
		return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" font=\"title\" fontsize=\""..size.."\" hlink=\"String:NpcDialog:"..event.."?npc=$NPC_OBJID\" underline=\"true\"/></Items></Line><Line/>";
	else
		return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" font=\"title\" fontsize=\"16\" hlink=\"String:NpcDialog:"..event.."?npc=$NPC_OBJID\" underline=\"true\"/></Items></Line><Line/>";
	end
end
function XmlLinkTrafic(msg,event,size)
	if size then
		return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\"  hlink=\"String:NpcDialog:"..event.."?npc=$NPC_OBJID\" underline=\"true\"/></Items></Line>";
	else
		return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\"  hlink=\"String:NpcDialog:"..event.."?npc=$NPC_OBJID\" underline=\"true\"/></Items></Line>";
	end
end
function XmlTrafic(str1,str2,str3,color)
	return "<Line><Items><Item type=\"TEXT\" text=\""..str1.."\" color=\"#fff2f2f2\" /><Item type=\"IMAGE\"><Image File=\""..str2.."\" Transparency=\"1\"/></Item><Item type=\"TEXT\" text=\""..str3.."\" color=\"#ff"..color.."\" /></Items></Line>";
end
function Mtrim(s)
   return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end
function ParseCSVLine(line,header,sep) 
	local res = {}
	local pos = 1
	local h = 1
	sep = sep or ','
	while true do 
		local c = string.sub(line,pos,pos)
		if (c == "") then break end
		local index = header[h];
		if index == nil or Mtrim(index) == "" then index = h end
		if (c == '"') then
			local txt = ""
			repeat
				local startp,endp = string.find(line,'^%b""',pos)
				txt = txt..string.sub(line,startp+1,endp-1)
				pos = endp + 1
				c = string.sub(line,pos,pos) 
				if (c == '"') then txt = txt..'"' end 
			until (c ~= '"')
			res[h] = txt
			res[index] = txt
			assert(c == sep or c == "")
			pos = pos + 1
		else	
			local startp,endp = string.find(line,sep,pos)
			if (startp) then 
				res[h] = string.sub(line,pos,startp-1)
				res[index] = string.sub(line,pos,startp-1)
				pos = endp + 1
			else
				res[h] = string.sub(line,pos)
				res[index] = string.sub(line,pos)
				break
			end 
		end
		h = h+1;
	end
	return res
end
function CSVGetTable(file)
	local dataTable = {}
	local header = {}
	local i,j = 1,1;
	for line in io.lines(file) do
		if(line ~= "") then
			if i == 1 then  
				header = ParseCSVLine(line, {}, ",");
			elseif i > 1 then
					dataTable[j] = ParseCSVLine(line, header, ",");
					j = j + 1
			end
			i = i + 1
		end
	end
	return dataTable;
end
function Manual_Traffic(data,uid)
	local content = "";
	local ag = "ic_ag";
	content = content..XmlTextSize("Di chuy¬n","fc7633",18);
	for k, d in data do
		local gold = tonumber(d.Gold)/100;
		content = content..XmlLinkTrafic(d.Name,d.ID);
		if GetCreLev(uid) >= tonumber(d.Level) then
			content = content..XmlTrafic("  C¥n: "..gold,ag,"   C¤p ðµ "..d.Level,"f2f2f2");
		else
			content = content..XmlTrafic("  C¥n: "..gold,ag,"   C¤p ðµ "..d.Level,"c91213");
		end
	end
	return content;
end



function DiceRandom()
	math.randomseed( os.time() ) 
	local  function my_random (t,from, to)
		local num = math.random (from, to)
		if t[num] then  num = my_random (t, from, to)   end
		t[num]=num 
		return num
	end

	local t = {};
	local h = {}
	for i =1, 2 do
		h[i] = my_random (t, 1, 6);
	end 
	return h;
end

function CheckTimeFull(tbl)
	local DayOfWeek = GetServerDayOfWeek();
	local Hour = GetServerHour();
	local tmp = false;
	local tmp2 = false;
	for i =1,table.getn(tbl.Week) do
		if tonumber(tbl.Week[i]) == DayOfWeek then
			tmp = true;
		end
	end
	for i =1,table.getn(tbl.Hour) do
		if tonumber(tbl.Hour[i]) == Hour then
			tmp2 = true;
		end
	end
	if tmp and tmp2 then
		return true
	else
		return false
	end
end


function CreateNpcRandom(obj,ID,num,rmv)
	if num > 0 then
		for i=1,num do
			CreateNpcAtMyPos(obj, ID);
		end
	end
end

function FindIdxSceneByID(id)
	for i=1,table.getn(Mgr_SceneObj) do
		if tonumber(Mgr_SceneObj[i].ID) == tonumber(id) then
			return i
		end
	end
	return 0
end

function AddItem2UserName(name,itemid,amount,bind,str1,str2)
	local uid = GetUserObjId(name);
	if uid ~= 0 then
		local item = 0;
		for i=1,amount do
			if AddItem(uid, tonumber(itemid), 0, 0, tonumber(bind)) > 0 then
				item = item + 1;
			else
				break
			end
		end
		if item == amount then
			local txt = "["..str1.."] "..str2;
			ReceiveMsg(uid, txt,7);
		else
			local count = amount - item;
			if count > 0 then
				ReceiveMsg(uid, L("msg_npcshop_fullbag"), 7);
				local txt = "v=1;s=1|i="..itemid..";%="..count..";b="..bind;
				CreateCodeItemAddMailByName(name, 11112,txt, str1, str2);
			end
		end
	else
		local txtbind = "";
		if bind ~= 0 then txtbind = ";b="..bind; end
		local txtamount = "";
		if amount > 1 then txtamount = ";%="..amount; end
		local maintxt = "i="..itemid..txtamount..txtbind;
		local txt = "v=1;s=1|"..maintxt;
		CreateCodeItemAddMailByName(name, 11112,txt, str1, str2);
	end
end


function MoveAtrib_01(uid)
    local reti=GetVarInt("figd2 "..uid);
    local msgs={"Chuy¬n ð±i thuµc tính Ma ThÕch Siêu C¤p thành công","Không tìm th¤y ðÕo cø ho£c ðÕo cø møc tiêu ðßþc chuy¬n","Các ðÕo cø ho£c ðÕo cø møc tiêu ðßþc chuy¬n không phäi là v§t ph¦m có th¬ ðßþc tân trang lÕi","Các ðÕo cø và ðÕo cø møc tiêu ðßþc chuy¬n không phäi là các bµ ph§n thiªt b¸ gi¯ng nhau","Không th¬ d¸ch chuy¬n thuµc tính"};
    return XmlText(msgs[reti+1]);
end
function MoveGem_01(uid)
    local reti=GetVarInt("figd "..uid);
    local msgs={"Chuy¬n ð±i thuµc tính Bäo ThÕch thành công","Không tìm th¤y ðÕo cø ho£c ðÕo cø møc tiêu ðßþc chuy¬n","Các ðÕo cø ho£c ðÕo cø møc tiêu ðßþc chuy¬n không phäi là ðÕo cø tinh th¥n","Các ðÕo cø và ðÕo cø møc tiêu ðßþc chuy¬n không phäi là các bµ ph§n thiªt b¸ gi¯ng nhau","Ð¬ chuy¬n thiªt b¸ mÑc nång lßþng tâm linh không cao h½n thiªt b¸ møc tiêu"};
    return XmlText(msgs[reti+1]);
end
function SubGdint(uid,xx)
GetVarInt("point_sub "..uid.." "..xx);
end
function AddGdint(uid,xx)
GetVarInt("point_add "..uid.." "..xx);
end
function GetGdint(uid)
return GetVarInt("point_get "..uid.." 0")
end

function XmlLink(msg,event,size)
    if size then
        return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" font=\"title\" fontsize=\""..size.."\" hlink=\"String:NpcDialog:"..event.."?npc=$NPC_OBJID\" underline=\"true\"/></Items></Line><Line/>";
    else
        return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" font=\"title\" fontsize=\"16\" hlink=\"String:NpcDialog:"..event.."?npc=$NPC_OBJID\" underline=\"true\"/></Items></Line><Line/>";
    end
end

function XmlText(msg, cl)
    if cl then
        return "<Item type=\"TEXT\" text=\"" .. msg .. "\" color=\"#ff" .. cl .. "\"/>";
    else
        return "<Item type=\"TEXT\" text=\"" .. msg .. "\" color=\"#ffa6a845\" />";
    end
end

function PromoContent()
    local xml = "";
    xml = xml..XmlText("");
    xml = xml..XmlText("");
    xml = xml..XmlText("Welcome to Promobead Exchanger: How lucky you are to get the new pet in our new promo lotto?","er");
    return ""..xml
end

function XmlExt(txt,cl) 
    if cl then
        if cl == "er" then
            return "<Line><Items><Item type=\"TEXT\" text=\""..txt.."\" color=\"#ffffff66\"/></Items></Line>";
        else
            return "<Line><Items><Item type=\"TEXT\" text=\""..txt.."\" color=\"#ff"..cl.."\"/></Items></Line>";
        end
    else
        return "<Line><Items><Item type=\"TEXT\" text=\""..txt.."\" color=\"#ffa6a845\"/></Items></Line>";
    
    end
end
function XmlExt_Text(msg, color)
    if color then
        return "<Item type=\"TEXT\" text=\"" .. msg .. "\" color=\"#ff" .. color .. "\"/>";
    else
        return "<Item type=\"TEXT\" text=\"" .. msg .. "\" color=\"#ffa6a845\" />";
    end
end


function CSVGetTable(file)
    local dataTable = {}
    local header = {}
    local i,j = 1,1;
    for line in io.lines(file) do
        if(line ~= "") then
            if i == 1 then  
                header = ParseCSVLine(line, {}, ",");
            elseif i > 1 then
                    dataTable[j] = ParseCSVLine(line, header, ",");
                    j = j + 1
            end
            i = i + 1
        end
    end
    return dataTable;
end


function Mtrim(s)
   return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end
function ParseCSVLine(line,header,sep) 
    local res = {}
    local pos = 1
    local h = 1
    sep = sep or ','
    while true do 
        local c = string.sub(line,pos,pos)
        if (c == "") then break end
        local index = header[h];
        if index == nil or Mtrim(index) == "" then index = h end
        if (c == '"') then
            local txt = ""
            repeat
                local startp,endp = string.find(line,'^%b""',pos)
                txt = txt..string.sub(line,startp+1,endp-1)
                pos = endp + 1
                c = string.sub(line,pos,pos) 
                if (c == '"') then txt = txt..'"' end 
            until (c ~= '"')
            res[h] = txt
            res[index] = txt
            assert(c == sep or c == "")
            pos = pos + 1
        else    
            local startp,endp = string.find(line,sep,pos)
            if (startp) then 
                res[h] = string.sub(line,pos,startp-1)
                res[index] = string.sub(line,pos,startp-1)
                pos = endp + 1
            else
                res[h] = string.sub(line,pos)
                res[index] = string.sub(line,pos)
                break
            end 
        end
        h = h+1;
    end
    return res
end

function MSplit(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
        if(szFullString == "" or szFullString == nil) then return nSplitArray end
    local nFullStringLen = string.len(szFullString)
    local nSeparatorLen = string.len(szSeparator)
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFullStringLen)
            break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + nSeparatorLen
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end

function MFilePutContent(file, Content, Mode)
    --Mode: a+ | w+
    local f = io.open(file, Mode);
    f:write(Content);
    f:close();
    return Content;
end

function GetContent(pathfilename)
    local readfile = io.open(pathfilename,"r+");
    local data = readfile:read("*all");
    readfile:close()
    return data
end

function GetObjByName(username, content)
    local contentArr = MSplit(content, "\n");
    for index, element in contentArr do
        if string.find(element, "|"..username.."|") then
            local dataLine = MSplit(element, "|");
            if dataLine[1] ~= nil then dataLine[1] = tonumber(dataLine[1]) end
            if dataLine[4] ~= nil then dataLine[4] = tonumber(dataLine[4]) end
            return dataLine;
        end
    end
    return nil;
end


function setFile(file_name,sj)
  local f = assert(io.open(file_name, 'w'))
  f:write(sj)
  f:close()
end


function Model2Array(str)
    if tonumber(str) ~= nil then
        return str
    elseif string.find(str, ";", 1) then
        local rowArr = Split(str, ";");
        for i = 1, table.getn(rowArr) do
            if not rowArr[i] then
                return 0;
            end
        end
        return rowArr
    end
    return 0;
end

function Shop_ShowInfo(uid, type, idshop, x)
    if CheckTypeAndID(type, idshop) then
        local content = "";
        local txt = string.format(L("msg_npcshop_hello"), GetUserNameByObjId(uid));
        for k, d in ShopData do
            if tonumber(d.ID) == idshop then
                content = content .. XmlExt() .. XmlExt_Img(d.ItemIcon, "32") .. XmlExt_Text(" " .. d.ItemName, "33cc33") .. XmlExt("0");
                content = content .. XmlText(" ");
                content = content .. XmlText(d.ItemInfo);
                content = content .. XmlText(" ");
                if tonumber(d.ItemBind) ~= 0 then
                    content = content .. XmlExt() .. XmlExt_Text(L("msg_npcshop_itembind")).. XmlExt("0");
                end
                if tonumber(d.ItemColor) ~= 0 then
                    local colorx = {"green","blue","golden","goldenplus","greenplus","blueplus","whiteplus"};
                    local str = string.format(L("msg_npcshop_itemcolor"), colorx[tonumber(d.ItemColor)]);
                    content = content .. XmlExt() .. XmlExt_Text(str).. XmlExt("0")
                end
                if tonumber(d.SmithingLev) ~= 0 then
                    local str = string.format(L("msg_npcshop_smithinglev"), tostring(d.SmithingLev));
                    content = content .. XmlExt() .. XmlExt_Text(str).. XmlExt("0")
                end
                if tonumber(d.LimitTime) ~= 0 then
                    local lmtime = math.ceil(tostring(d.LimitTime)/60);
                    local str = string.format(L("msg_npcshop_limittime"), lmtime);
                    content = content .. XmlExt() .. XmlExt_Text(str).. XmlExt("0");
                end
                if tonumber(d.Updatelev) ~= 0 then
                    local str = string.format(L("msg_npcshop_updatelev"), tostring(d.Updatelev));
                    content = content .. XmlExt() .. XmlExt_Text(str).. XmlExt("0");
                end
                if tonumber(d.AttributeId) ~= 0 then
                    content = content .. XmlExt() .. XmlExt_Text(L("msg_npcshop_attributeid")).. XmlExt("0");
                end
                content = content .. XmlText(" ");
                content = content .. XmlExt() .. XmlExt_Text(L("msg_npcshop_price")) .. XmlExt_Text("[" .. d.Price .. "]", "ff0000") .. XmlExt_Img("mcash1") .. XmlExt("0");
                content = content .. XmlText(" ");
                if x then
                    if tonumber(d.IsRide) == 1 and tonumber(d.Model) == 0 then
                        content = content .. XmlLink(L("msg_npcshop_show"), "ShowRide_Type_" .. type .. "_ID_" .. d.ID);
                        content = content .. XmlText(" ");
                    end
                    if tonumber(d.Model) ~= 0 then
                        content = content .. XmlLink(L("msg_npcshop_show"), "ShowModel_Type_" .. type .. "_ID_" .. d.ID);
                        content = content .. XmlText(" ");
                    end
                end
                content = content .. XmlLink(L("msg_npcshop_buybtn"), "ShopBuy_Type_" .. type .. "_ID_" .. d.ID);
                content = content .. XmlText(" ");
                content = content .. XmlLink(L("msg_npcshop_back"), "ShopType_" .. type);
                content = content .. XmlText(" ");
            end
        end
        return content;
    end

end


function CheckTypeAndID(Type, ID)
    if tonumber(Type) < 1 and tonumber(Type) > 7 then
        return false
    end
    if not ID then
        return false
    else
        for k, d in ShopData do
            if tonumber(d.ID) == tonumber(ID) then
                return true
            end
        end
        return false
    end
    return false
end

function ShopType(uid, num)
    local content = "";
    local txt = string.format(L("msg_npcshop_hello"), GetUserNameByObjId(uid));
    content = content .. XmlExt() .. XmlExt_Text(txt) ..XmlExt("0");
    content = content .. XmlExt().. XmlExt_Text(L("msg_npcshop_mcash")).. XmlExt_Text("[" .. GetVarInt("point_get " .. uid .. " 0") .. "]", "ff0000") .. XmlExt_Img("mcash1") ..XmlExt("0");
    content = content .. XmlLink(L("msg_npcshop_back"), "defaulttalk");
    if num >= 1 and num <= 7 then
        local count = 0;
        for k, d in ShopData do
            if tonumber(d.Type) == num then
                if count <= 80 then
                    local itemName = d.ItemName;
                    if string.len(itemName) > 27 then
                        itemName = string.sub(itemName, 1, 24);
                        itemName = itemName .. " ..";
                    end
                    content = content .. XmlExt() .. XmlExt_Text("  ") .. XmlExt_Img(d.ItemIcon, "32") ..XmlExt_Text(" ").. XmlExt_Link(itemName, "ShopInfo_Type_" .. num .. "_ID_" .. d.ID)..XmlExt("0");
                    content = content .. XmlExt() .. XmlExt_Text("              ")..XmlExt_Text(L("msg_npcshop_price"))..XmlExt_Text(d.Price, "ff0000") .. XmlExt_Img("mcash1")..XmlExt("0");
                    content = content .. XmlText(" ");
                    count = count + 1;
                else break end
            end
        end
    end
    content = content .. XmlLink(L("msg_npcshop_back"), "defaulttalk");
    return content
end

function XmlExt(num)
    if num then
        return "</Items></Line>";
    end
    return "<Line><Items>";
end
function XmlExt_Text(msg, color)
    if color then
        return "<Item type=\"TEXT\" text=\"" .. msg .. "\" color=\"#ff" .. color .. "\"/>";
    else
        return "<Item type=\"TEXT\" text=\"" .. msg .. "\" color=\"#ffa6a845\" />";
    end
end
function XmlExt_Link(msg, link, size, color)
    if size then
        size = "font=\"title\" fontsize=\"" .. size .. "\"";
    else
        size = "";
    end
    if not color then
        color = "a6a845";
    end
    return "<Item type=\"TEXT\" text=\"" .. msg .. "\" " .. size .. " hlink=\"String:NpcDialog:" .. link ..
               "?npc=$NPC_OBJID\" underline=\"true\" color=\"#ff" .. color .. "\" />"
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


-----------------

function AddItem2UserName(name,itemid,amount,bind,str1,str2)
    local uid = GetUserObjId(name);
    if uid ~= 0 then
        local item = 0;
        for i=1,amount do
            if AddItem(uid, tonumber(itemid), 0, 0, tonumber(bind)) > 0 then
                item = item + 1;
            else
                break
            end
        end
        if item == amount then
            local txt = "["..str1.."] "..str2;
            ReceiveMsg(uid, txt,7);
        else
            local count = amount - item;
            if count > 0 then
                ReceiveMsg(uid, L("msg_npcshop_fullbag"), 7);
                local txt = "v=1;s=1|i="..itemid..";%="..count..";b="..bind;
                CreateCodeItemAddMailByName(name, 11112,txt, str1, str2);
            end
        end
    else
        local txtbind = "";
        if bind ~= 0 then txtbind = ";b="..bind; end
        local txtamount = "";
        if amount > 1 then txtamount = ";%="..amount; end
        local maintxt = "i="..itemid..txtamount..txtbind;
        local txt = "v=1;s=1|"..maintxt;
        CreateCodeItemAddMailByName(name, 11112,txt, str1, str2);
    end
end


function linetalkex(msgline,color)
    return "<Line><Items><Item type=\"TEXT\" text=\""..msgline.."\" color=\""..color.."\"/></Items></Line>";
end
function XMLtsint(uid,msgline,re)
    return "<Line><Items><Item type=\"TEXT\" text=\""..msgline.."\"/></Items></Line><Line><Items><Item type=\"TEXT\" text=\"[Quay LÕi]\" hlink=\"String:NpcDialog:"..re.."?npc=$NPC_OBJID\" /></Items></Line>";
end

function int2arrint(val)
    local hex_ling = string.format("%08x",val);

    local iarr={};
    local num = 0;

    for i=1,8
    do
        num=string.byte(hex_ling,i,i)-48;
        if num>9 then
            num=num-39;
        end
        iarr[i]=num;
    end

    return iarr;
end

function arr2intint(arr)
    local hex_s = "0x";
    for i=1,8
    do
        if(arr[i]<=9) then
            hex_s=hex_s..string.char(arr[i]+48);
        else
            hex_s=hex_s..string.char(arr[i]+48+39);
        end
    end

    return tonumber(hex_s);
end

function GemZq(uid,num)
    local ling=GetVarInt("fige "..uid);
    local intarr=int2arrint(ling);
    -- st sl st1 sl1 .. ..
    
    if intarr[1] == 15 then
        return XMLtsint(uid,"Không tìm th¤y ðá quý trong v§t ph¦m tÕi ô thÑ 1 trong hòm ð° cüa bÕn.","GemZq_Xml")
    end


    local item_t = intarr[1];
    local did=0;
    
    for i=1,3 do
        local stonelev = intarr[4+(i-1)*2];
        if stonelev>0 then
            local stonetype=intarr[3+(i-1)*2];
            intarr[4+(i-1)*2]=0;
            intarr[3+(i-1)*2]=1;
            --Add gems:
            did=1;
            if AddItem(uid,18011+(stonetype-1)*10+(stonelev-1),0,0,0) == 0 then
                Mail(uid, L("msg_school27"), L("msg_npcshop_fullbag"), L("msg_school29"), "i="..18011+(stonetype-1)*10+(stonelev-1), 0);
            end
        end 
    end 
    
    if did==0 then
        return XMLtsint(uid,"Không tìm th¤y ðá quý trong v§t ph¦m tÕi ô thÑ 1 trong hòm ð° cüa bÕn.","GemZq_Xml")
    end
    
    GetVarInt("fide "..uid.." "..arr2intint(intarr));
    return XMLtsint(uid,"Tháo ðá quý thành công!","GemZq_Xml");
    
end
function linetalk_rf(msgline)
    return "<Line><Items><Item type=\"TEXT\" text=\""..msgline.."\"/></Items></Line>";
end
function linelink_rf(msg,event)
    return "<Line><Items><Item type=\"TEXT\" text=\""..msg.."\" font=\"title\" fontsize=\"17\" hlink=\"String:NpcDialog:"..event.."?npc=$NPC_OBJID\" underline=\"true\"/></Items></Line>";
end
function int2arr_rf(val)
    local hex_ling = string.format("%08x",val);

    local iarr={};
    local num = 0;

    for i=1,8
    do
        num=string.byte(hex_ling,i,i)-48;
        if num>9 then
            num=num-39;
        end
        iarr[i]=num;
    end


    return iarr;
end
function zblh1_do(uid)
    --lh_12,13 -- tinh luyen ma thach
    lh_01 = {40,60,100,150,250,330,570};
    lh_02 = {1,5,12,18,30,50,85};
    lh_03 = {20,40,90,150,250,380,550};
    lh_04 = {1,1,1,1,3,5,0};
    lh_05 = {1,3,5,7,12,18,27};
    lh_06 = {1,5,12,18,30,50,85};
    lh_11 = {1,5,12,18,30,50,85};
    lh_12 = {1,2,2,3,3,5,0};
    lh_13 = {1,2,2,3,3,5,0};
    
    
    local lh_all={
        lh_01,lh_01,lh_01,lh_01,lh_01,
        lh_02,lh_02,lh_02,lh_02,
        lh_03,lh_04,lh_05,lh_06,
        lh_11,lh_11,lh_11,lh_11,lh_11,
        lh_12,lh_12,lh_12,lh_12,lh_12,
        lh_13,lh_13,lh_13,lh_13,lh_13
        };

    local at_desc_list={
        "+ %d Kháng Thüy", "+ %d Kháng Höa", "+ %d Kháng Ðµc", "+ %d Kháng Lôi", "+ %d Kháng Ph§t", 
        "+ %d V§t Lý ST", "+ %d SÑc MÕnh", "+ %d Trí Tu®", "+ %d Nhanh Nh©n", 
        "+ %d Khí Huyªt", "+ %d%% Khí Huyªt", 
        "+ %d H¤p Thø ST", "+ %d Sát Thß½ng", 
        "+ %d Thüy Sát Thß½ng", "+ %d Höa Sát Thß½ng", "+ %d Ðµc Sát Thß½ng", "+ %d Lôi Sát Thß½ng", "+ %d Ph§t Sát Thß½ng", 
        "+ %d%% Thüy Sát Thß½ng", "+ %d%% Höa Sát Thß½ng", "+ %d%% Ðµc Sát Thß½ng", "+ %d%% Lôi Sát Thß½ng", "+ %d%% Ph§t Sát Thß½ng", 
        "+ %d%% Thüy Sát Thß½ng BÕo Kích", "+ %d%% Höa Sát Thß½ng BÕo Kích", "+ %d%% Ðµc Sát Thß½ng BÕo Kích", "+ %d%% Lôi Sát Thß½ng BÕo Kích","+ %d%% Ph§t Sát Thß½ng BÕo Kích"
        };



    local reti1=GetVarInt("add_getatt "..uid);
    local reti2=0;
    if reti1 == 1 then
        return XmlText("Không th¬ l¤y thông tin v§t ph¦m, vui lòng ki¬m tra lÕi");
    end
    reti2 = GetVarInt("add_newatt "..uid);
    if reti2 == 1 then
        return XmlText("Không th¬ thay thª thuµc tính");
    end

    local a1a = int2arr_rf(reti1);
    local a2a = int2arr_rf(reti2);

    --display info
    local XML = XmlText("Màu ðö là thuµc tính hi®n tÕi cüa trang b¸. Màu xanh là thuµc tính m¾i. Nªu bÕn không thích thuµc tính này có th¬ b¤m Tinh Luy®n M¾i","DDDD22");
    XML = XML..XmlLink("Tinh Luy®n M¾i","zblh1");
    local XML1 = XmlText("Thuµc Tính Cû : ");
    local XML2 = XmlText("Thuµc Tính M¾i : ");
    for i=1,4 do
        local a1 = a1a[i*2-1]*16+a1a[i*2];
        local a2 = a2a[i*2-1]*16+a2a[i*2];
        
        local a_t_1 = math.floor(a1/8);
        local a_l_1 = a1-math.floor(a1/8)*8;
        local a_t_2 = math.floor(a2/8);
        local a_l_2 = a2-math.floor(a2/8)*8;

        if a_t_1>0 and a_l_1>0 then
            local txt = string.format(at_desc_list[a_t_1],lh_all[a_t_1][a_l_1]);
            XML1 = XML1..XmlText(txt,"FFFFFF");
        end
        
        
        if a_t_2>0 and a_l_2>0 then
            local txt = string.format(at_desc_list[a_t_2],lh_all[a_t_2][a_l_2]);
            XML2 = XML2..XmlText(txt,"00FF00");
        end
        
    end
    XML = XML..XML1;
    XML = XML..XmlText(" ");
    XML = XML..XML2;
    XML = XML..XmlText(" ");
    XML = XML..XmlLink("SØ Døng Thuµc Tính M¾i","zblh2");

    return XML;
end


function ColorMedia(ct,cl)
    return " #c"..tostring(cl).." "..tostring(ct).." #n ";
end
function GetContent(pathfilename)
    local readfile = io.open(pathfilename,"r+");
    local data = readfile:read("*all");
    readfile:close()
    return data
end
function erlinetalk(msgline)
    return "<Line><Items><Item type=\"TEXT\" text=\""..msgline.."\" color=\"#ffff4da6\"/></Items></Line>";
end

function RanTable(tbl) -- suffles numeric indices
    local len, random = tablecount(tbl), math.random ;
    for i = len, 2, -1 do
        local j = random( 1, i );
        tbl[i], tbl[j] = tbl[j], tbl[i];
    end
    return tbl;
end