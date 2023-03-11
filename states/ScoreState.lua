ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
  self.score = params.score
end

function ScoreState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
      gStateMachine:change('countdown')
  end
end

function ScoreState:render()
  love.graphics.setFont(gameFont)
  love.graphics.printf('Buuu! You lose! Gigito is sad T-T', 0, 64, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(mediumFont)
  love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
  if (self.score > 3) then 
    love.graphics.draw(bronceCup, VIRTUAL_HEIGHT - 48, 122)
  end
  if (self.score > 6) then 
    love.graphics.draw(silverCup, VIRTUAL_HEIGHT - 48, 122)
  end
  if (self.score > 9) then 
    love.graphics.draw(goldCup, VIRTUAL_HEIGHT - 48, 122)
  end

  love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end