require "irc"
require 'fixRequire'
require 'markovDetect'
local sleep = require "socket".sleep

local s = irc.new{nick = "AuditBot"}

s:hook("OnChat", function(user, channel, message)
	print(("[%s] %s: %s"):format(channel, user.nick, message))
end)

function markovDetect(user, channel)
	local nick = user.nick
	local p = bayes(nick,1/10)
	if p > 0.5 then 
		s:sendChat(channel, string.format("%s is a bot! %g probabilty.", nick, p))
	end
	print(string.format("Joined: %s. Bayes: %g, Probability Real: %g, Probability Fake: %g", nick, p, probability(nick), probFake(nick)))
	print(("username: %s, host: %s, realname: %s"):format(user.username, user.host, user.realname))
end

s:hook("OnJoin", markovDetect)


s:connect("chat.freenode.net")
--s:join("#lesswrong")
s:join("#lw-bots")

while true do
	s:think()
	sleep(0.1)
end