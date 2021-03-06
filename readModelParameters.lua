function parseLayer(lines,layernum)
   -- print("parsing lines")
   local cur_line = 1
   local ninput,noutput,k
   -- num of nodes
   if (string.sub(lines[cur_line],1,1)=="m") then
      k = lines[cur_line]:split(' ')
      for v=1,#k do
         if (v==2) then
            noutput = tonumber(k[v])
         elseif (v==3) then
            ninput = tonumber(k[v])
         end
      end
      cur_line = cur_line + 1
   else
      print("ERROR: try to find the number of input and output layer but failed with line "..cur_line..' of total '..#lines..' in layer '..layernum)
      os.exit()
   end
   -- print(ninput,noutput)
   -- weights
   local weight = {}
   for i=1,noutput do
      weight[i] = {}
      k = lines[cur_line]:split(' ')
      for v = 1,#k do
         weight[i][v] = tonumber(k[v])
      end
      if (#weight[i]<ninput) then
         print("ERROR: number of weight["..i.."] is less than required "..ninput..' in layer '..layernum)
         os.exit()
      end
      cur_line = cur_line + 1
   end
   -- bias
   if (cur_line>=#lines) then
      print("ERROR: can not find any bias in layer "..layernum)
      os.exit()
   end
   local bias = {}
   local nbias
   k = lines[cur_line]:split(' ')
   for v = 1,#k do
      if (v==2) then
         nbias = tonumber(k[v])
      end
   end
   cur_line = cur_line + 1
   k = lines[cur_line]:split(' ')
   for v = 1,#k do
      bias[#bias+1] = tonumber(k[v])
   end
   cur_line = cur_line+1
   if (nbias<noutput) then
      print("ERROR: nbias is less than output layer nodes line "..cur_line..' of total '..#lines..' in layer '..layernum)
      os.exit()
   end
   -- activation
   local activation
   if (cur_line==#lines) then
      k = lines[cur_line]:split(' ')
      activation = string.sub(k[1],2,#k[1]-1)
   else
      print("Warning: cannot find the activation layer in line "..cur_line..' of total '..#lines..' in layer '..layernum)
   end
   -- print(#weight,#bias,activation)
   return weight, bias, activation
end

function readModelPara(filename)
   local weights,bias,activation
   weights = {} bias = {} activation = {}
   local fin = io.open(filename,'r')
   local nline,lines,line,layernum
   layernum = 1
   line = fin:read()
   while (line~=nil) do
      lines = {}
      if (string.sub(line,1,17)=="<biasedlinearity>") then
         line = string.sub(line,19)
         s,e = string.find(line, "%S*")
         nline = tonumber(string.sub(line,s,e))
      else
         print("Cannot find <biasedlinearity> in layer "..layernumand.." the line is "..string.sub(line,1,40).."...")
      end
      for i=1,nline+4 do
         line = fin:read()
         lines[#lines+1] = line
      end
      weights[#weights+1],bias[#bias+1],activation[#activation+1] = parseLayer(lines,layernum)
      line = fin:read()
      layernum = layernum+1
   end
   fin:close()
   if (#weights~=#bias) then
      print("ERROR: number of parameters is not compatible")
      return
   else
      -- print(#weights,#bias,#activation)
      return weights,bias,activation
   end
end

-- readfile(arg[1])
