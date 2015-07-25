package.path = "./?.lua;./?/init.lua"
require 'names'
require 'markovDetect'
require 'config'

for i,n in ipairs(arg) do
	local b = bayes(n, prior)
	print(("%s has %g prob, %g real and %g fake. %s"):format(n, b, probability(n), probFake(n), ((b>threshold and 'Would be filtered') or 'would not be filtered')))
end