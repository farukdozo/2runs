Entity = Object:extend()


function Entity:new(x, y, images)
    self.x = x
    self.y = y
    self.images = images
    self.width = self.images[1]:getWidth()
    self.height = self.images[1]:getHeight()

    self.last = {}
    self.last.x = self.x
    self.last.y = self.y

    self.gravity = 0
    self.weight = 0
end


function Entity:update(dt)
    self.last.x = self.x
    self.last.y = self.y
    -- Gravity
    self.gravity = self.gravity + self.weight * dt
    self.y = self.y + self.gravity * dt
end

-- Collision
function Entity:checkCollision(e)
    return self.x < e.x + e.width
        and self.x + self.width > e.x
        and self.y < e.y + e.height
        and self.y + self.height > e.y
end

function Entity:wasHorizontallyAligned(e)
    return self.last.y < e.y + e.height and self.last.y + self.height > e.y
end

function Entity:wasVerticallyAligned(e)
    return self.last.x < e.x + e.width and self.last.x + self.width > e.x
end

function Entity:resolveCollision(e)
    -- Collision Direction
    if self:wasHorizontallyAligned(e) then
        if self.x + self.width / 2 > e.x + e.width / 2 then
            -- Right Collision
            self.x = e.x + e.width
            return "Right"
        else
            -- Left Collision
            self.x = e.x - self.width
            return "Left"
        end
    elseif self:wasVerticallyAligned(e) then
        if self.y > e.y then
            -- Bottom collision
            self.y = e.y + e.height
            return "Bottom"
        else
            -- Top collision
            self.y = e.y - self.height
            if self:is(Player) then
                self.gravity = 0
                self.weight = 0
            end
            return "Top"
        end
    end
end