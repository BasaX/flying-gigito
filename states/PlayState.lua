PlayState = Class{__includes = BaseState}


PIPE_SPEED = 60
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

CAT_WIDTH = 38
CAT_HEIGHT = 24

PIPE_GAP_MAX = 20
PIPE_GAP_MIN = -20

PIPE_SPAWN = math.random(1, 3)

function PlayState:init()
  self.cat = Cat()
  self.pipePairs = {}
  self.spawnTimer = 0
  self.lastY = -PIPE_HEIGHT + math.random(80) + 20
  self.score = 0
end

function PlayState:update(dt)
    self.spawnTimer = self.spawnTimer + dt

    if (self.spawnTimer > PIPE_SPAWN) then
      local y = math.max(-PIPE_HEIGHT + 10, math.min(self.lastY + math.random(PIPE_GAP_MAX, PIPE_GAP_MIN), VIRTUAL_HEIGHT - math.random(70, 90) - PIPE_HEIGHT))
      self.lastY = y

      table.insert(self.pipePairs, PipePair(y))

      self.spawnTimer = 0

      PIPE_SPAWN = math.random(1, 2)

      GAP_HEIGHT = math.random(80, 120)

      X_DISTANCE = math.random(25, 32) 

    end
    
    
    for k, pair in pairs(self.pipePairs) do

      if not pair.scored then
        if pair.x + PIPE_WIDTH < self.cat.x then
          self.score = self.score + 1
          pair.scored = true
          sounds['score']:play()
        end
      end

      pair:update(dt)
    end
    
    for k, pair in pairs(self.pipePairs) do
      if pair.remove then
        table.remove(self.pipePairs, k)
      end
    end
    
    self.cat:update(dt)

    for k, pair in pairs(self.pipePairs) do
      for l, pipe in pairs(pair.pipes) do
        if self.cat:collides(pipe) then
          sounds['explosion']:play()
          sounds['hurt']:play()

          gStateMachine:change('score', {
            score = self.score
          })
        end
      end
    end

    if self.cat.y > VIRTUAL_HEIGHT - 15 then
      sounds['explosion']:play()
      sounds['hurt']:play()

      gStateMachine:change('score', {
        score = self.score
      })
    end

end

function PlayState:render()
  for k, pair in pairs(self.pipePairs) do
      pair:render()
  end

  love.graphics.setFont(gameFont)
  love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

  self.cat:render()
end