require 'nn'

nn.config = {}
nn.config.prettyPrint = true

function nn.Container:prettyPrint(status)
   if status == nil then
      nn.config.prettyPrint = not nn.config.prettyPrint
   else
      nn.config.prettyPrint = status
   end
end

function nn.Sequential:__tostring__()
   local b = function(s) -- BLUE
      if nn.config.prettyPrint then return '\27[0;34m' .. s .. '\27[0m' end
      return s
   end
   local tab = '  '
   local line = '\n'
   local next = b ' -> '
   local str = b 'nn.Sequential'
   str = str .. b ' {' .. line .. tab .. b '[input'
   for i=1,#self.modules do
      str = str .. next .. b '(' .. i .. b ')'
   end
   str = str .. next .. b 'output]'
   for i=1,#self.modules do
      str = str .. line .. tab .. b '(' .. i .. b '): ' .. tostring(self.modules[i]):gsub(line, line .. tab)
   end
   str = str .. line .. b '}'
   return str
end

--------------------------------------------------------------------------------
-- Concat
--------------------------------------------------------------------------------

function nn.Concat:__tostring__()
   local r = function(s) -- RED
      if nn.config.prettyPrint then return '\27[0;31m' .. s .. '\27[0m' end
      return s
   end
   local tab = '  '
   local line = '\n'
   local next = r '  |`-> '
   local lastNext = r '   `-> '
   local ext = r '  |    '
   local extlast = '       '
   local last = r '   ... -> '
   local str = r(torch.type(self))
   str = str .. r ' {' .. line .. tab .. r 'input'
   for i=1,#self.modules do
      if i == #self.modules then
         str = str .. line .. tab .. lastNext .. r '(' .. i .. r '): ' .. tostring(self.modules[i]):gsub(line, line .. tab .. extlast)
      else
         str = str .. line .. tab .. next .. r '(' .. i .. r '): ' .. tostring(self.modules[i]):gsub(line, line .. tab .. ext)
      end
   end
   str = str .. line .. tab .. last .. r 'output'
   str = str .. line .. r '}'
   return str
end

nn.ConcatTable.__tostring__ = nn.Concat.__tostring__

function nn.Parallel:__tostring__()
   local g = function(s) -- GREEN
      if nn.config.prettyPrint then return '\27[0;32m' .. s .. '\27[0m' end
      return s
   end
   local tab = '  '
   local line = '\n'
   local next = g '  |`-> '
   local ext = g '  |    '
   local extlast = '       '
   local last = g '   ... -> '
   local str = g(torch.type(self))
   str = str .. g ' {' .. line .. tab .. g 'input'
   for i=1,#self.modules do
      if i == #self.modules then
         str = str .. line .. tab .. next .. g '(' .. i .. g '): ' .. tostring(self.modules[i]):gsub(line, line .. tab .. extlast)
      else
         str = str .. line .. tab .. next .. g '(' .. i .. g '): ' .. tostring(self.modules[i]):gsub(line, line .. tab .. ext)
      end
   end
   str = str .. line .. tab .. last .. g 'output'
   str = str .. line .. g '}'
   return str
end
