package.path = package.path..";./?.lua;./?/init.lua;"

require 'names'
require 'config'
require "irc"
require 'markovDetect'

if not logToConsole then
	print = function() end
end

local namesHash = {}
for i, n in ipairs(names) do 
	namesHash[n] = true
end

local sleep = require "socket".sleep

local s = irc.new{nick = nick, username = username, realname = realname}
local lastUser = ''

s:hook("OnChat", function(user, channel, message)
	print(("[%s] %s: %s"):format(channel, user.nick, message))
	if message == ".prob" then
		s:sendChat(channel, string.format("Last user was %s: %g probability of being a bot. %g probability of a real user choosing this name and %g probability of a randomly generated one.", lastUser, bayes(lastUser, prior), math.exp(probability(lastUser)), math.exp(probFake(lastUser))))
	elseif message:match("%.prob%s(.*)") then
		local nick = message:match("%.prob%s(.*)")
		s:sendChat(channel, string.format("%s has %g probability of being a bot. %g probability of a real user choosing this name and %g probability of a randomly generated one.", nick, bayes(nick, prior), math.exp(probability(nick)), math.exp(probFake(nick))))
	end
end)

function markovDetect(user, channel)
	local nick = user.nick
	lastUser = nick
	local p = bayes(nick,prior)
	if ((p > threshold) and (not namesHash[nick])) then 
		s:sendChat((metaChannel or channel), string.format("%s is a bot! %g probabilty.", nick, p))
	else
		--s:setMode({target = channel, nick = user.nick, add = "+v"})
		s:send(("mode %s +v %s"):format(channel, nick))
		
	end
	print(string.format("Joined: %s. Bayes: %g, Probability Real: %g, Probability Fake: %g", nick, p, probability(nick), probFake(nick)))
	print(("username: %s, host: %s, realname: %s"):format(tostring(user.username), tostring(user.host), tostring(user.realname)))
end

s:hook("OnJoin", markovDetect)


s:connect(server)

for i, channel in ipairs(channels) do
	s:join(channel)
end
s:sendChat('NickServ', 'identify '..password)
while true do
	s:think()
	sleep(refeshRate)
end