# 2runs
#### Video Demo:  <URL HERE>
#### Description:

### How to run the game (for Windows only)
- In order to run the game download all files in a desired directory
- Select everything > right click > send to > compressed (zip) folder
- Name the file however you like, but make sure to change extension '.zip' to '.love'
- Move that '.love' file into builder folder
- Once you are in builder folder, select '.love' file and drag it on top of build.bat file
- When that process is finished, you should see new '.zip' file
- Simply extract that file in a desired directory and run the '.exe' file
- **Important Note:** There is already `2runs.zip` in `builder` that you can extract and play the game immediately if you don't want to edit the code.

### Gameplay
2runs is a platformer in which you have to play 2 characters and complete 2 different levels simultaneously.
Your goal is to simply reach the end of the level as fast as you can with both characters. There are no any items/stars/points that you have to collect, only enemies that you can either shoot or avoid. Also make sure to avoid falling and hitting red tiles, as they will kill you as well. You only have 1 life, so if either character dies, you have to start everything over again.

#### Player controls and mechanics
Controls for first characters are:
- **a** - move left
- **d** - move right
- **c** - jump
- **w** - shoot

Controls for second characters are:
- **h** - move left
- **k** - move right
- **u** - jump
- **n** - shoot
As for mechanics there are only 2 things worth explaining:
1. Shooting. You have unlimited bullets, but you can only shoot once per second. Bullets are also very tiny so make sure to be accurate when shooting.
2. Wall-Jump. Wall-Jump is very important mechanic in this game. It allows you to jump one more time, but only when you are collided with any vertical wall. As you are walljumping make sure that you are collided with the wall by holding the movement key (e.g. if you the wall is on your left, hold left movement key as you are walljumping of of it).
It's important to note that it will only work if you jumped of the ground previously. If you accidentally fell from platform and try holding on to wall and walljumping, it won't work. This part wasn't planned when I was coding. I decided not to fix it as this serves as another way to punish players when they run of the platform, or fail to correctly time their jumps.

#### Enemy mechanics
There are 2 types of enemies:
- First type are simple enemies that only move left-right or up-down.
- Second type of enemies are shooters or turrets, however you like to call them. They are stationary, but they shoot bullets every 2 seconds. If either player gets hit by the bullet, both will die and the game will restart.
Same rules apply to both type of the enemies. If either player collides with them, game restarts. You can kill either of the enemies by shooting them only once, but there's a catch. They will respawn every 3 seconds, and it is impossible to kill them permanently. :)

### Code
In this part I will explain what each of the important files contains and does.

#### Entity.lua
Entity is a base class and everything else is pretty much built on top of it. It has **x**, **y**, **height**, **width**, **gravity** attributes and functions that deal with **collision**.
**Gravity** attribute allows player to jump.
```
self.gravity = self.gravity + self.weight * dt
self.y = self.y + self.gravity * dt
```
Each time player jumps he gets negative **gravity** value and fixed positive **weight** value. This causes players **y** attribute to increase. When player jumps, **gravity** value slowly increases based on **weight**. Once **gravity** reaches positive value, player will start to fall until he eventually hits the ground. Once he hits the ground **gravity** and **weight** values are set to 0 with this part of code (which I cover later in document):
```
self.y = e.y - self.height
    if self:is(Player) then
        self.gravity = 0
        self.weight = 0
    end
```
**Gravity** and **weight** values needs to be set to **0** in order to stop player from falling through platform.

**Collision** functions are used for checking if entities are collided with each other and in certain cases resolve that collision.
```
function Entity:checkCollision(e)
    return self.x < e.x + e.width
        and self.x + self.width > e.x
        and self.y < e.y + e.height
        and self.y + self.height > e.y
end
```
Easiest way to explain this is by giving an example. Lets imagine that **Entity** is a player and **e** is a tile. This function returns true if:
- If player's left side is further to the left than tile's right side
- If player's right side is further to the right than tile's left side
- If player's top side is further to the top than tile's bottom side
- If player's bottom side is further to the bottom from tile's top side

In case where player is collided with the tile, that collision needs to be resolved. In order to resolve collision correctly, first there needs to be a check wether the collision was horizontal or vertical.
```
function Entity:wasHorizontallyAligned(e)
    return self.last.y < e.y + e.height and self.last.y + self.height > e.y
end

function Entity:wasVerticallyAligned(e)
    return self.last.x < e.x + e.width and self.last.x + self.width > e.x
end
```
If entities were collided horizontally then wether the player is on the left or right side of the tile also needs checking. To determine that simply compare if player's origin is more to the right than tile's origin. If true then the player is on the right side, otherwise the player is on the left side. After that simply adjust player's **x** attribute.
Same thing is applied in case of vertical collision.
```
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
```
As you can notice, the code above also returns the collision direction which is important for walljump mechanic.


#### Main.lua
Main.lua file is needed in order for Löve to be able to execute. Main.lua contains main Löve components and few extra functions.

 `love.window.setMode(1280, 960)` is used to set window resolution

```
local state = {
    running = true,
    menu = false
}
```
State table is used for manipulating game 'scenes'. Since this is relatively short game, it only has 2 scenes: running(gameplay) and menu(end-screen).
Only one scene can be active at the time. What is displayed on screen is based on state status.

##### Walljump
In order to explain how Walljump works, I will go over standard jump mechanic first:
```
-- player.lua
function Player:jump()
    self.gravity = -300
    self.weight = 400
end

function Player:canJump()
    return self.y == self.last.y
end
```
Player can jump only when he is on the ground. This is check by comparing current **y** value and the value of **y** 1 frame before (in code it is **last.y**).
If those values are equal it means that the player is on the ground and if jump key is pressed player will jump.
```
function playerJump()
    function love.keypressed(key)
        for i,v in ipairs(players) do
            if key == v.hop then
                if v:canJump() or v.wallJump == true then
                    v:jump()
                    if v.wallJumpCounter then
                        v.wallJumpCounter = v.wallJumpCounter + 1
                        if v.wallJumpCounter == 2 then
                            v.wallJumpCounter = 0
                            v.wallJump = false
                        end
                    end
                end
            end
        end
    end
end
```
Player can also jump again when value of **wallJump** is true. 
```
for i,wall in ipairs(walls) do
    if player1:checkCollision(wall) then
        player1.collisionTimer = 0
        if wall.deadly == true then
            love.load()
        end
        player1:resolveCollision(wall)
        if player1:resolveCollision(wall) == "Left" or player1:resolveCollision(wall) == "Right" then
            player1.verticalCollision = true
        end
    else
        if player1.collisionTimer then -- check for nil value
            player1.collisionTimer = player1.collisionTimer + 1
        end
        -- If player runs off the platform give gravity so player can fall
        if player1:canJump() then
            player1.weight = 400
            player1.gravity = 50
        end
    end
end

if player1.verticalCollision then -- check for nil value
    if player1.collisionTimer < 1500 then
        if player1.wallJumpCounter == 1 then
            player1.wallJump = true
        end
    else
        player1.wallJump = false
    end
end
```
Value of **wallJump** can only be true when player is horizontally collided with the wall and when the value of **wallJumpCounter** is **1**. **wallJumpCounter** counts how many times player has jumped since he was on the ground last time. When that value is **> 1**, it is set back to **0** in order to prevent infinite walljumps.

`wall.deadly` is the attribute of wallOfDeath. WallOfDeath are red walls/tiles and whenever you touch them game restarts.

##### Collision with enemies
```
for i,enemy in ipairs(enemies1) do
    if player1:checkCollision(enemy) then
        love.load()
    end
end
```
If player collides with enemy or shooter game will restart.

##### Shooters and enemy bullets
```
for i, v in ipairs(shooters1) do
    if v.shoot == true then
        table.insert(listOfEnemyBullets1, EnemyBullet(v.x, v.y, v.r))
    end
end
```

```
-- shooter.lua
self.shootTimer = self.shootTimer + dt

if self.shoot == true then
    self.shootTimer = 0
    self.shoot = false
end

if self.shootTimer > 2 then
    self.shoot = true
end
```
Shooters will shoot bullets every 2 seconds. Every time **shooter.shoot** value is **true**, the bullet is fired and timer is restarted.
```
for i,bullet in ipairs(listOfEnemyBullets1) do
    if player1:checkCollision(bullet) then
        love.load()
    end
end
```
If players are collided with enemy bullets, game is restarted.

```
for i,wall in ipairs(walls) do
    for j,bullet in ipairs(listOfEnemyBullets1) do
        if bullet:checkCollision(wall) then
            table.remove(listOfEnemyBullets1, j)
        end
    end
end
```
Remove bullets each time they hit collide with wall.

##### Enemy respawn
Enemies and shooters in this game will respawn every 3 seconds.
```
for i, bullet in ipairs(listOfPlayerBullets1) do
    for j, enemy in ipairs(enemies1) do
        if bullet:checkCollision(enemy) then
            enemy.isAlive = false
            table.insert(deadEnemies1, enemy)
            table.remove(enemies1, j)
            table.remove(listOfPlayerBullets1, i)
        end
    end
end
for i,v in ipairs(deadEnemies1) do
    v:update(dt)
end
for i,enemy in ipairs(deadEnemies1) do
    if enemy.isAlive == true then
        table.insert(enemies1, enemy)
        table.remove(deadEnemies1, i)
    end
end
```
```
-- enemy.lua
if self.deathTimer > 3 then
    self.isAlive = true
end
if self.isAlive == false then
    self.deathTimer = self.deathTimer + dt
else
    self.deathTimer = 0
end
```
When enemies die, they are added to **deadEnemies** table. After 3 seconds they become alive again and are removed from **deadEnemies** table.

##### Flag / Ending
```
if player1:checkCollision(flag) then
    player1.done = true
end
if player2:checkCollision(flag) then
    player2.done = true
end

if player1.done == true and player2.done == true then
    state.running = false
    state.menu = true
end
```
When both players touch the flag, game will end and **state** is switched to **menu**.

##### Camera
```
cam:lookAt(player1.x + 16, 480)
local scrWidth = love.graphics.getWidth()

if cam.x < scrWidth/2 then
    cam.x = scrWidth/2
end
```
Camera is set to only follow 1st character. That is set on purpose, so the player is forced to play both characters at the same time.

##### Player animation
```
-- player.lua
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
```
For character animation I used 6 pictures in total. 3 picutres are used to create animation when player is moving to the left and the other 3 are used when player is moving to the right. In order to create animation **currentFrame** player attribute is constantly changing value when player is moving and has fixed values when no movement keys are held.
```
function Player:draw()
    love.graphics.draw(self.images[math.floor(self.currentFrame)], self.x, self.y)
end
```

##### function love.draw()
Whenever love.graphics is used to draw something, it is drawn on a canvas. The canvas is an object, and it is possible to create multiple canvas objects. New canvas is created in *love.load()*
```
screenCanvas = love.graphics.newCanvas(1280, 480)
```
`love.graphics.setCanvas(screenCanvas)` is used to set new **screenCanvas** as the canvas that will be drawn on. In order for this canvas to be drawn onto the default canvas, default canvas needs to be set first: `love.graphics.setCanvas()`. After that **screenCanvas** can be drawn onto the main canvas using `love.graphics.draw(screenCanvas)`

`love.graphics.clear()` is used to clear the canvas and it needs to be used before drawing the game, as every moving object would otherwise leave the trail behind it. We only need to display the current frame of the game, therefore everything else is cleared before it. Everything is drawn on to the canvas using the *drawGame* function:
```
function drawGame(player, map, enemies, shooters, enemyBullets, playerBullets)
    cam:attach()
        player:draw()
        for i,v in ipairs(enemies) do
            v:draw()
        end
        for i,v in ipairs(shooters) do
            v:draw()
        end
        for i,v in ipairs(enemyBullets) do
            v:draw()
        end
        for i,v in ipairs(playerBullets) do
            v:draw()
        end
        for i,v in ipairs(map) do
            v:draw()
        end
        flag:draw()
    cam:detach()
end
```

When game is completed the menu(end screen) is displayed. Variable **count** is used to display the time it took to complete the game:
```
while count > 60 do
    minutes = minutes + 1
    count = count - 60
end
local seconds = string.format("%.3f", count)

local runTime = tostring(minutes) .. " : " .. tostring(seconds)
```
Function *love.mousepressed* is used to make buttons clickable and is active only when **state.running** is **false**:
```
function love.mousepressed(x, y, button)
    if state.running == false then
        if button == 1 then
            if (x >= 357 and x <= 495) and (y >= 540 and y <= 600) then
                state.menu = false
                state.running = true
                love.load()
            elseif (x >= 783 and x <= 923) and (y >= 540 and y <= 600) then
                love.event.quit()
            end
        end
    end
end
```