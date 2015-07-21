local validChars = {string.char(0),string.char(1),string.char(2)}
--for i = 65, 122 do table.insert(validChars, string.char(i)) end
for i = 97, 122 do table.insert(validChars, string.char(i)) end
local tableProbs = {}

local names = {"kuudes","ppk","zzubzzub","Namegduf","drg","@JBeshir|Exploded","Acty","feepbot","nickenchuggets","@PatrickRobotham","Sigyn","foamz","djcb","milkmaid","complex","yviwp","Guest35670","lzhang","vikram___","Rastus_Vernon","niko","feignt","cluelesscoder","srijan4","peloverde","baxibillion","Houshalter","lizzie","ndrei","DUNS_SCROTUS","shminux","u_","Gyrodiot","cptwillard","sephiap","derfj_","snkcld","tazjin","M132T003C","Blazinghand_","neona","OneFixt","gilch","sceaduwe","SDr","SoundLogic_","makoLine","TheCowboy","Beatzebub","yrrebaer","MoALTz","kiba_","tuningmind","EnLilaSko","mavhc","Bright","catsup","drewbot","@nshepperd","Pimster","@namespace","@saturn2","nisstyre","@Qfwfq","hh","daemian1","c0rw|zZz","Pent","espes__","Sheva","Broolucks","Deadhand","KD9AUS","havok88","GnuYawk","strangewarp","@gwern","DarthShader","kini","belcher","@Burninate","Quashie_","DEA7TH","djeimsyxuis","torchic","fadeway_","glass|","keypusher","sef","Raccoon","graehl","jzk","uber","Jesin","vikraman","Micromus","cpopell5","aloril","bildramer","lexande","keroberos","pookie__","SN4T14","lahwran","@quanticle","tomphreek","clsr","ParahSailin_","[mbm]","MPR","seanBE","ErikBjare","edwinjarvis","Cory","hugaraxia","grubles","wasp__","neptunepink","key_","luxvigilis","dualbus","cpopell","kilohelo","stasku","alekst_","cwillu","DrPete_","ToyKeeper","MicaiahC","clemux","keko_","hollywood","CoJaBo","Soft","FracV","Tachyon","dx","rola","tiki","soapes","kniffler","acchan","zb","rsaarelm","dh","helleshin","dv-_","glutton_","BobaMa_","jastiC","feep","eno789","Kavec","Cradamy","calamityx0","iamarandomtoday","Khoth","ivan\\","sirtaj","ephess","corby","@sh","capisce","@Betawolf","amphibious","sgentle","ByronJohnson","hkjn","ahel","ArvinJA","moshez","xarquid","loz--","Oddity","dec","redlum","quintopia","vivi","normod","inara","nanotube","technomad","jiriki","BrightyCar","BrightyMigrate","blue_feint","tomzx","TRManderson","orionstein","introspectr","jrayhawk","Lynear","gattuso","sohum","efm_","GJORD","mst","Jello_Raptor","Logos01","midnightmagic","yorick","tekacs","Coornail","Zebranky","hylleddin","iamfishhead","filius","cyberRodent","pkkm","mspier","ben-","supersoju","thommey","Twey","Vetinari","rileyjshaw","rray","Baughn_","lassulus","indeo","otoburb","Urchin","StathisA","Peng","abuss","bets","mobrat4","mortehu","nullpunkt","roxton","Bakkot","kanzure","vzctl","apoc","bydo","Afforess","um","sirius_","brand0","TheTeapot","codehotter","mjr","hamnox","slowriot","siavashg","Tene","RiversHaveWings","robsen","catern","bcoburn","fxhnd","Veltzeh","Ycros","amoebius","Tiktalik"}

for i,v in ipairs(names) do
	names[i] = v:lower()
end

for i,char in ipairs(validChars) do
	tableProbs[char] = {}
	for _,char2 in ipairs(validChars) do
		tableProbs[char][char2] = 1
	end	
end

function process(n)
	local result = ''
	for i = 1, #n do
		local c = n:sub(i,i)
		if (c:byte() < 97) or (c:byte() > 122) then
			c = string.char(2)
		end
		result = result..c
	end
	return string.char(0)..result..string.char(1)
end

for i,n in ipairs(names) do
	n = process(n)
	for i = 1, n:len()-1 do
		tableProbs[n:sub(i,i)][n:sub(i+1,i+1)] = tableProbs[n:sub(i,i)][n:sub(i+1,i+1)]+1
	end
end

function probability(name)
	local n = process(name)
	local logProb = 0
	for i = 1, #n-1 do
		local nChar = tableProbs[n:sub(i,i)][n:sub(i+1,i+1)]
		local total = 0
		for c,num in pairs(tableProbs[n:sub(i,i)]) do
			total = total + num
		end
		--print(n:sub(i+1,i+1), nChar, total)
		logProb = logProb + math.log(nChar/total)
	end
	return logProb
end

function probFake(n)
	for i = 1, #n do
		if (string.byte(n:sub(i,i)) < 97) or (string.byte(n:sub(i,i)) > 122) then
			return -math.huge
		end
	end
	return math.log(1/26)*n:len()+math.log(1/14)
end

function bayes(n,p)
	local r = math.exp(probability(n))
	local f = math.exp(probFake(n))
	--return math.exp(f+math.log(p)-math.log(math.exp(r)))
	return f*p/(f*p+r*(1-p))
end