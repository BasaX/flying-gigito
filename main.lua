push = require 'push'

Class = require 'class'

require('Cat')

require('Pipe')

require('PipePair')

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/CountdownState'
require 'states/TitleScreenState'
require 'states/PauseState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

local GROUND_LOOPING_POINT = 514

local scrolling = true

gPause = false

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Flying Gigito')

    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('gameFont.ttf', 14)
    gameFont = love.graphics.newFont('gameFont.ttf', 28)
    hugeFont = love.graphics.newFont('gameFont.ttf', 56)
    love.graphics.setFont(gameFont)

    sounds = {
      ['jump'] = love.audio.newSource('jump.wav', 'static'),
      ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
      ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
      ['score'] = love.audio.newSource('score.wav', 'static'),
      ['music'] = love.audio.newSource('marios_way.mp3', 'static')
  }

  sounds['music']:setLooping(true)
  sounds['music']:play()

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
      ['title'] = function() return TitleScreenState() end,
      ['countdown'] = function() return CountdownState() end,
      ['play'] = function() return PlayState() end,
      ['score'] = function() return ScoreState() end,
      ['pause'] = function() return PauseState() end,
    }
    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
        % GROUND_LOOPING_POINT

    gStateMachine:update(dt)
    
    love.keyboard.keysPressed = {}
end

function love.keypressed(key, unicode)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end

    if key == 'p' then gPause = not gPause end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
      return true
    else
      return false
    end
end

function love.draw()

    if gPause then
      push:start()
      love.graphics.draw(background, -backgroundScroll, 0)  
      love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
      love.graphics.setFont(gameFont)
      love.graphics.printf("Game Paused", 0, 64, VIRTUAL_WIDTH, 'center') 
      love.graphics.printf('Press P to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
      push:finish()
      return 
    end
  
    push:start()
  
    love.graphics.draw(background, -backgroundScroll, 0)
  
    gStateMachine:render()
  
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
  
    push:finish()
end