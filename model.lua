----------------------------------------------------------------------

local weights,bias,activations
if (opt.modelPara~='') then
   print("Reading parameters from "..opt.modelPara)
   weights,bias,activations = readModelPara(opt.modelPara)
   model = nn.Sequential()
   for i=1,#weights do
      if (i==1) then
         model:add(nn.Linear(ninputs,#weights[1]))
      else
         model:add(nn.Linear(#weights[i-1],#weights[i]))
      end
      model:get(2*i-1).bias = torch.Tensor(bias[i])
      model:get(2*i-1).weight = torch.Tensor(weights[i])
      model:add(nn.ReLU())
   end
   model:add(nn.Linear(#weights[#weights],noutputs))
   model:add(nn.LogSoftMax())
end
if (model==nil) then
   print '==> load model'

   local filename = paths.concat(opt.save, opt.ldmodel)
   model = io.open(filename, 'rb')

   if (model) then
      print ('find model '..filename)
      model:close()
      model = torch.load(filename)
   else
      print ('==> model in '..filename..' is not found')
      print '==> construct model'

      if opt.model == 'linear' then

         -- Simple linear model
         model = nn.Sequential()
         model:add(nn.Reshape(ninputs))
         model:add(nn.Linear(ninputs,noutputs))

      elseif opt.model == 'mlp' then

         -- Simple 2-layer neural network, with tanh hidden units
         model = nn.Sequential()
         model:add(nn.Reshape(ninputs))
         model:add(nn.Linear(ninputs,nhiddens))
         model:add(nn.Tanh())
         model:add(nn.Linear(nhiddens,noutputs))

      elseif opt.model == 'convnet' then

         if opt.type == 'cuda' then
            -- a typical modern convolution network (conv+relu+pool)
            local curState=1
            model = nn.Sequential()

            -- stage 1 : filter bank -> squashing -> L2 pooling -> normalization
            model:add(nn.SpatialConvolutionMM(nfeats, nstates[curState], filtsize, filtsize))
            curState = curState+1
            model:add(nn.ReLU())
            model:add(nn.SpatialMaxPooling(poolsize,poolsize,poolsize,poolsize))

            -- stage 2 : filter bank -> squashing -> L2 pooling -> normalization
            -- model:add(nn.SpatialConvolutionMM(nstates[curState-1], nstates[curState], filtsize, filtsize))
            -- curState = curState+1
            -- model:add(nn.ReLU())
            -- model:add(nn.SpatialMaxPooling(poolsize,poolsize,poolsize,poolsize))

            -- stage 3 : standard 2-layer neural network
            -- model:add(nn.View(nstates[2]*filtsize*filtsize))
            -- model:add(nn.Dropout(0.5))
            for i = curState,#nstates-1 do
               model:add(nn.Linear(nstates[i], nstates[i+1]))
               model:add(nn.PReLU())
               -- model:add(nn.BatchNormalization(nstates[i+1]))
            end
            model:add(nn.Linear(nstates[#nstates], noutputs))
            model:add(nn.LogSoftMax())

         else
            -- a typical convolutional network, with locally-normalized hidden
            -- units, and L2-pooling

            -- Note: the architecture of this convnet is loosely based on Pierre Sermanet's
            -- work on this dataset (http://arxiv.org/abs/1204.3968). In particular
            -- the use of LP-pooling (with P=2) has a very positive impact on
            -- generalization. Normalization is not done exactly as proposed in
            -- the paper, and low-level (first layer) features are not fed to
            -- the classifier.

            local curState=1
            model = nn.Sequential()

            -- stage 1 : filter bank -> squashing -> L2 pooling -> normalization
            model:add(nn.SpatialConvolutionMM(nfeats, nstates[curState], filtsize, filtsize))
            curState = curState+1
            model:add(nn.Tanh())
            model:add(nn.SpatialMaxPooling(poolsize,poolsize,poolsize,poolsize))

            -- stage 2 : filter bank -> squashing -> L2 pooling -> normalization
            model:add(nn.SpatialConvolutionMM(nstates[curState-1], nstates[curState], filtsize, filtsize))
            curState = curState+1
            model:add(nn.Tanh())
            model:add(nn.SpatialMaxPooling(poolsize,poolsize,poolsize,poolsize))

            -- stage 3 : standard 2-layer neural network
            -- model:add(nn.View(nstates[2]*filtsize*filtsize))
            -- model:add(nn.Dropout(0.5))
            for i = curState,#nstates-1 do
               model:add(nn.Linear(nstates[i], nstates[i+1]))
               model:add(nn.PReLU())
               model:add(nn.BatchNormalization(nstates[i+1]))
            end
            model:add(nn.Linear(nstates[#nstates], noutputs))
            model:add(nn.LogSoftMax())
         end
      elseif opt.model == 'deepneunet' then
         model = nn.Sequential()
         model:add(nn.Linear(ninputs,nstates[1]))
         model:add(nn.PReLU())
         for i = 1,#nstates-1 do
            model:add(nn.Linear(nstates[i], nstates[i+1]))
            model:add(nn.PReLU())
            model:add(nn.BatchNormalization(nstates[i+1]))
         end
         model:add(nn.Linear(nstates[#nstates], noutputs))
         model:add(nn.LogSoftMax())
      else

         error('unknown -model')

      end
   end
end
----------------------------------------------------------------------
print '==> here is the model:'
print(model)

----------------------------------------------------------------------
-- Visualization is quite easy, using itorch.image().

if opt.visualize then
   if opt.model == 'convnet' then
      if itorch then
     print '==> visualizing ConvNet filters'
     print('Layer 1 filters:')
     itorch.image(model:get(1).weight)
     print('Layer 2 filters:')
     itorch.image(model:get(5).weight)
      else
     print '==> To visualize filters, start the script in itorch notebook'
      end
   end
end
