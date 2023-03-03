PlayState = Class{__includes = BaseState}


PIPE_SPEED = 60
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

CAT_WIDTH = 38
CAT_HEIGHT = 24

function PlayState:init()
  self.cat = Cat()
  self.pipePairs = {}
  self.spawnTimer = 0
  self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    self.spawnTimer = self.spawnTimer + dt

    if (self.spawnTimer > 2) then
      local y = math.max(-PIPE_HEIGHT + 10, math.min(self.lastY + math.random(20, -20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
      self.lastY = y

      table.insert(self.pipePairs, PipePair(y))

      self.spawnTimer = 0
    end
    
    
    for k, pair in pairs(self.pipePairs) do
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
          gStateMachine:change('title')
        end
      end
    end

    if self.cat.y > VIRTUAL_HEIGHT - 15 then
      gStateMachine:change('title')
    end

  --     if pair.x < -PIPE_WIDTH then
  --       pair.remove = true
  --     end
  --   end

  -- end
end

function PlayState:render()
  for k, pair in pairs(self.pipePairs) do
      pair:render()
  end

  self.cat:render()
end