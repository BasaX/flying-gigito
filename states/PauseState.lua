PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
  self.score = params.score
end

function PauseState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
      PAUSE = false
      gStateMachine:change('play')
  end
end

function PauseState:render()
  love.graphics.setFont(gameFont)
  love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(mediumFont)
  love.graphics.printf('You can do it!!', 0, 100, VIRTUAL_WIDTH, 'center')

  love.graphics.printf('Press Enter to return the game!', 0, 160, VIRTUAL_WIDTH, 'center')
end