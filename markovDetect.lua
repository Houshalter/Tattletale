--we start with special characters representing the start of a name, end of name, and non-letters
local validChars = {string.char(0),string.char(1),string.char(2)}
local a,z = string.byte('a'),string.byte('z')
for i = a, z do table.insert(validChars, string.char(i)) end

local lowerCaseNames = 0
for i, n in ipairs(names) do
	if n == n:lower() then
		lowerCaseNames = lowerCaseNames+1
	end
end

percentNamesLower = lowerCaseNames/#names


--replace anything not a lower case letter with special character
--then appends starting and ending symbols to it.
function process(n)
	return string.char(0)..n:gsub('[^%l]', string.char(2))..string.char(1)
end


for i,v in ipairs(names) do
	names[i] = v:lower()
end

totalCharCount = 0
charCount = {}

--Here we build a table that represents how often each character occurs
for i, n in ipairs(names) do
	n = process(n)
	for i = 2, #n do
		totalCharCount = totalCharCount+1
		charCount[n:sub(i,i)] = (charCount[n:sub(i,i)] or 0)+1
	end
end

--this initializes a table that will represent how often each character occurs
--after every other character. It starts with a prior, as if it had seen each
--character combination once. Each combination is weighted by the frequency
--that chracter occurs.
local tableProbs = {}
for i,char in ipairs(validChars) do
	tableProbs[char] = {}
	for z = 2,#validChars do
		local char2 = validChars[z]
		tableProbs[char][char2] = (charCount[char2]+1)/(totalCharCount+26)*27
	end	
end

--and now we start counting how often each character pair actually occurs
for i,n in ipairs(names) do
	n = process(n)
	for i = 1, #n-1 do
		tableProbs[n:sub(i,i)][n:sub(i+1,i+1)] = tableProbs[n:sub(i,i)][n:sub(i+1,i+1)]+1
	end
end

--this calculates the probability of a name being produced by a real user
function probability(name)
	local n = process(name)
	local logProb = 0
	for i = 1, #n-1 do
		local nChar = tableProbs[n:sub(i,i)][n:sub(i+1,i+1)]
		local total = 0
		for c,num in pairs(tableProbs[n:sub(i,i)]) do
			total = total + num
		end
		logProb = logProb + math.log(nChar/total)
	end
	return logProb
end

--[[Olivia notes that in python this would be:
def probfake(n): if n.isalpha(): return math.log(1/26)*len(n)+math.log(1/14); else: return 0 - sys.maxint

I note that if I remembered how to regex this could be reduced about as much in just lua.

EDIT: much better : )  ]]
function probFake(n)
	--no non-lower-case letters
	if n:match('[^%l]') then return -math.huge end
	--this calculates the entropy of the the name. 26 letters and 14 possible lengths
	return math.log(1/26)*n:len()+math.log(1/14)
end

function bayes(n,p)
	--adjust prior for namees containing lowercase letters
	p = p/((1-p)*percentNamesLower+p)
	local r = math.exp(probability(n))
	local f = math.exp(probFake(n))
	--bayes theorem
	return f*p/(f*p+r*(1-p))
end