local validChars = {string.char(0),string.char(1),string.char(2)}
--for i = 65, 122 do table.insert(validChars, string.char(i)) end
local a,z = string.byte('a'),string.byte('z')
for i = a, z do table.insert(validChars, string.char(i)) end
local tableProbs = {}


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
		if (c:byte() < a) or (c:byte() > z) then
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

--[[Olivia notes that in python this would be:
def probfake(n): if n.isalpha(): return math.log(1/26)*len(n)+math.log(1/14); else: return 0 - sys.maxint

I note that if I remembered how to regex this could be reduced about as much in just lua.]]
function probFake(n)
	for i = 1, #n do
		if (string.byte(n:sub(i,i)) < a) or (string.byte(n:sub(i,i)) > z) then
			return -math.huge
		end
	end
	return math.log(1/26)*n:len()+math.log(1/14)
end

function bayes(n,p)
	local r = math.exp(probability(n))
	local f = math.exp(probFake(n))
	--return math.exp(f+math.log(p)-math.log(math.exp(r)))
	
	--bayes theorem
	return f*p/(f*p+r*(1-p))
end