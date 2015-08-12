require 'torch'   -- torch
require 'os'   --
require 'nn'      -- provides a normalization operator
-- require 'cunn'
require 'xlua'    -- xlua provides useful tools, like progress bars
require 'optim'   -- an optimization package, for online and batch methods
require "libhtktoth"

if not (opt) then
    cmd = torch.CmdLine()
    cmd:text()
    cmd:text('Speaker Verification with CNN')
    cmd:text()
    cmd:text('Options:')
    -- filelist:
    cmd:option('-featfile', '', 'name a file storing all the filenames of data')
    cmd:option('-maxrows', 4000, 'max number of rows to be read from fbank file each time')
    cmd:option('-scpfile', '', 'name a file storing all the filenames of train or test data')
    cmd:option('-filenum', 20, 'max nb of fbank file each time')
    cmd:option('-labelfile', '', 'name a file storing the labels for each file in scp')
    cmd:option('-cvscpfile', '', 'name a file storing all the filenames of cv data')
    cmd:option('-globalnorm', '', 'normalization file contains the means and variances')
    cmd:option('-tensorList', 'tensorList', 'data stored as torch tensor format')
    -- global:
    cmd:option('-seed', 1, 'fixed input seed for repeatable experiments')
    cmd:option('-threads', 4, 'number of threads')
    -- data:
    cmd:option('-size', 'full', 'how many samples do we load: small | full | extra')
    -- model:
    cmd:option('-model', 'convnet', 'type of model to construct: linear | mlp | convnet | deepneunet')
    cmd:option('-ldmodel', 'model.net', 'name of the model to be loaded')
    cmd:option('-modelPara', '', 'model file which stores pretrained weights and bias format as DNN fintune')
    cmd:option('-hidlaynb', 0, 'nb of hidden layers')
    -- loss:
    cmd:option('-loss', 'nll', 'type of loss function to minimize: nll | mse | margin')
    -- training:
    cmd:option('-save', 'results', 'subdirectory to save/log experiments in')
    cmd:option('-plot', false, 'live plot')
    cmd:option('-optimization', 'SGD', 'optimization method: SGD | ASGD | CG | LBFGS')
    cmd:option('-learningRate', 1e-1, 'learning rate at t=0')
    cmd:option('-batchSize', 10, 'mini-batch size (1 = pure stochastic)')
    cmd:option('-weightDecay', 0, 'weight decay (SGD only)')
    cmd:option('-momentum', 0.7, 'momentum (SGD only)')
    cmd:option('-t0', 1, 'start averaging at t0 (ASGD only), in nb of epochs')
    cmd:option('-maxIter', 2, 'maximum nb of iterations for CG and LBFGS')
    cmd:option('-type', 'double', 'type: double | float | cuda')
    cmd:option('-crossvalid', 0, 'use test for cross validaton set which do not extract bottleneck feature and compute the accuracy,0 is false, 1 is true')
    -- testing:
    cmd:option('-featOut', '', 'the location of the output feature')
    cmd:option('-frameExt', 5, 'frame extension')
    cmd:text()
    opt = cmd:parse(arg or {})
end
print '==> processing options'
-- nb of threads and fixed seed (for repeatable experiments)
if opt.type == 'float' then
   print('==> switching to floats')
   torch.setdefaulttensortype('torch.FloatTensor')
elseif opt.type == 'cuda' then
   print('==> switching to CUDA')
   require 'cunn'
   torch.setdefaulttensortype('torch.FloatTensor')
end
torch.setnumthreads(opt.threads)
torch.manualSeed(opt.seed)

print '==> define parameters'
-- hidden units (for creating new model or loading model from binary)
nstates = {128,256,1024,1024}
filtsizew = 11
filtsizeh = 3
poolsize = 2
-- number of units in output layer, but meaningless in loading model from binary file
noutputs = 203
-- number of frame extension to each direction
frameExt = opt.frameExt
-- [Number of incorelated features], [Width and Height for each feature map(height is the extended frame)], [Number of units in input layer] (for creating new model only)
nfeats = 3
width = 40 
height = 2*frameExt+1
ninputs = nfeats*width*height
-- number of hidden units (for MLP only):
nhiddens = ninputs / 2
-- number of hidden units for the output of Convolution and pooling layers(2 convolutional and pooling layers)
height2 = math.floor((math.floor((height-filtsizeh+1)/poolsize)-filtsizeh+1)/poolsize)
width2 = math.floor((math.floor((width-filtsizew+1)/poolsize)-filtsizew+1)/poolsize)

-- load data from torch format
local filename = paths.concat(opt.save, opt.tensorList)
tensorList = io.open(filename)
if (tnesorList) then
    print("find tensor list in "..filename)
    tensorList:close()
    readData = torch.load(filename)
    tensorList = readData.list
    cvind = readData.cvind
else
    print("can not find tensor list in "..filename)
    tensorList = {}
end

print("learning rate = "..opt.learningRate, "frame extension = "..opt.frameExt)
