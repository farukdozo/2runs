Player = Entity:extend()


function Player:new(x, y, imgdir, left, right, jump, shoot)
    -- Get image directory and load images in table
    local files = love.filesystem.getDirectoryItems(imgdir)
    images = {}
    for i=1,#files do
        table.insert(images, love.graphics.newImage(imgdir .. "/" .. i .. ".png"))
    end

    -- Create Player
    Player.super.new(self, x, y, images, left, right, jump, shoot)
    self.speed = 220
    self.left = left
    self.right = right
    self.hop = jump
    self.shoot = shoot
    self.currentFrame = 1
    self.lastMovementKeyPressed = 1
    self.shootTimer = 0
    self.canFire = false
    self.fire = false
    self.done = false
    self.weight = 400
    self.wallJump = false
end

function Player:update(dt)
    Player.super.update(self, dt)

    -- Fix player falling through platform on respawn
    if self.y >= 440 then
        self.y = 400
        self.x = 100
    end

    -- Movement
    if love.keyboard.isDown(self.left) then
        self.x = self.x - self.speed * dt
        self.lastMovementKeyPressed = 4.01
        -- Animation
        self.currentFrame = self.currentFrame + 15 * dt
        if self.currentFrame >= 7 or self.currentFrame < 4.01 then
            self.currentFrame = 4.01
        end
    elseif love.keyboard.isDown(self.right) then
        self.x = self.x + self.speed * dt
        self.lastMovementKeyPressed = 1
        -- Animation
        self.currentFrame = self.currentFrame + 15 * dt
        if self.currentFrame >= 4 then
            self.currentFrame = 1
        end
    end

    -- Check whether or not the character is moving at the moment (used to fix standing still animation)
    if not love.keyboard.isDown(self.left) and not love.keyboard.isDown(self.right) then
        self.currentFrame = self.lastMovementKeyPressed
    end

    -- Shooting
    self.shootTimer = self.shootTimer + dt

    if self.shootTimer > 1 then
        self.canFire = true
    else
        self.canFire = false
        self.fire = false
    end
end


-- Shoot
function Player:shootBullets()
    if love.keyboard.isDown(self.shoot) then
        if self.canFire == true then
            self.shootTimer = 0
            self.fire = true
        end
    end
end


-- Jump
function Player:jump()
    self.gravity = -300
    self.weight = 400
end

function Player:canJump()
    return self.y == self.last.y
end


function Player:draw()
    love.graphics.draw(self.images[math.floor(self.currentFrame)], self.x, self.y)
end