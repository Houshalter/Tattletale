package.path = "./?.lua;./?/init.lua"
require 'names'

print("This is a script to process names for the name list.")
print("copy and paste the names here, then type \"exit\"")
rawNames = ''
while true do
	local input = io.read()
	if input == "exit" then break end
	rawNames = rawNames..'\n'..input
end

nameHash = {}
newNames = {}
for i,name in ipairs(names) do
	nameHash[name] = true
	table.insert(newNames, string.format('%q',name))
end

for n in rawNames:gmatch('[^%s%+@%*:#]+') do
	if not nameHash[n] then
		print(string.format('%q',n))
		table.insert(newNames,string.format('%q',n))
	end
	nameHash[n] = true
end
--print('\n\n\n')
--print(string.format("{%s}", table.concat(newNames,",")))
function save(filename, data)
	local file = assert(io.open(filename, "w"))
	file:write(data)
	file:close()
end
local namesText = 'names = '..string.format("{%s}", table.concat(newNames,","))
save("C:\\Users\\Daniel\\documents\\programming\\tattletale\\names.lua", namesText)