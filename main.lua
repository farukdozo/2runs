---@diagnostic disable: param-type-mismatch
if arg[2] == "debug" then
    require("lldebugger").start()
end


love.window.setMode(1280, 960)


local state = {
    running = true,
    menu = false
}


function love.load()
    -- Time Counter
    count = 0
    minutes = 0

    if state.running == true then
        Object = require "classic"

        Camera = require "camera"
        cam = Camera()

        require "entity"
        require "player"
        require "wall"
        require "wallOfDeath"
        require "enemy"
        require "shooter"
        require "enemyBullet"
        require "playerBullet"
        require "flag"

        -- Split Screen
        screenCanvas = love.graphics.newCanvas(1280, 480)


        -- Enemies
        enemies1 = {}
        deadEnemies1 = {}
        enemies2 = {}
        deadEnemies2 = {}

        enemy0 = Enemy(420, 125, 508, 125)
        enemy1 = Enemy(1120, 205, 1247, 205)
        enemy2 = Enemy(1240, 165, 1407, 165)
        enemy3 = Enemy(1361, 205, 1567, 205)
        enemy4 = Enemy(1521, 165, 1767, 165)
        enemy5 = Enemy(1841, 165, 2127, 165)
        enemy6 = Enemy(2324, 41, 2324, 407)
        enemy7 = Enemy(2564, 41, 2564, 407)
        enemy8 = Enemy(2884, 41, 2884, 407)
        enemy9 = Enemy(1804, 201, 1804, 287)
        enemy10 = Enemy(2444, 41, 2444, 167)

        table.insert(enemies1, enemy0)
        table.insert(enemies1, enemy1)
        table.insert(enemies1, enemy2)
        table.insert(enemies1, enemy3)
        table.insert(enemies1, enemy4)
        table.insert(enemies1, enemy5)
        table.insert(enemies1, enemy6)
        table.insert(enemies1, enemy7)
        table.insert(enemies1, enemy8)
        table.insert(enemies1, enemy9)
        table.insert(enemies1, enemy10)

        enemy11 = Enemy(900, 125, 1020, 125)
        enemy12 = Enemy(1284, 201, 1284, 327)
        enemy13 = Enemy(1364, 121, 1364, 327)
        enemy14 = Enemy(1201, 125, 1327, 125)
        enemy15 = Enemy(2764, 41, 2764, 327)

        table.insert(enemies2, enemy11)
        table.insert(enemies2, enemy12)
        table.insert(enemies2, enemy13)
        table.insert(enemies2, enemy14)
        table.insert(enemies2, enemy15)

        -- Shooters
        shooters1 = {}
        shooters2 = {}
        deadShooters1 = {}
        deadShooters2 = {}

        shooter1 = Shooter(118, 44, 90)
        shooter2 = Shooter(278, 284, 90)
        shooter3 = Shooter(838, 124, 90)
        shooter4 = Shooter(2010, 324, 270)
        shooter5 = Shooter(3010, 364, 270)
        shooter6 = Shooter(2010, 244, 270)
        shooter7 = Shooter(2198, 124, 90)

        table.insert(shooters1, shooter1)
        table.insert(shooters1, shooter2)
        table.insert(shooters1, shooter3)
        table.insert(shooters1, shooter4)
        table.insert(shooters1, shooter5)
        table.insert(shooters1, shooter6)
        table.insert(shooters1, shooter7)

        shooter10 = Shooter(118, 44, 90)
        shooter11 = Shooter(1210, 284, 270)
        shooter12 = Shooter(1198, 44, 90)
        shooter13 = Shooter(3010, 284, 270)
        shooter14 = Shooter(3010, 204, 270)
        shooter15 = Shooter(958, 204, 90)

        table.insert(shooters2, shooter10)
        table.insert(shooters2, shooter11)
        table.insert(shooters2, shooter12)
        table.insert(shooters2, shooter13)
        table.insert(shooters2, shooter14)
        table.insert(shooters2, shooter15)

        listOfEnemyBullets1 = {}
        listOfEnemyBullets2 = {}

        -- Maps
        walls = {}

        map = {
            {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        }

        for i,v in ipairs(map) do
            for j,w in ipairs(v) do
                if w == 1 then
                    table.insert(walls, Wall((j - 1) * 40, (i - 1) * 40))
                elseif w == 2 then
                    table.insert(walls, WallOfDeath((j - 1) * 40, (i - 1) * 40))
                end
            end
        end

        walls2 = {}

        map2 = {
            {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
            {1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        }

        for i,v in ipairs(map2) do
            for j,w in ipairs(v) do
                if w == 1 then
                    table.insert(walls2, Wall((j - 1) * 40, (i -1 ) * 40))
                elseif w == 2 then
                    table.insert(walls2, WallOfDeath((j - 1) * 40, (i -1 ) * 40))
                end
            end
        end

        -- Flag
        flag = Flag(3614, 360)

        -- Players
        players = {}

        player1 = Player(100, 360, "Character1", "a", "d", "c", "w")
        player2 = Player(100, 360, "Character2", "h", "k", "n", "u")

        table.insert(players, player1)
        table.insert(players, player2)

        listOfPlayerBullets1 = {}
        listOfPlayerBullets2 = {}
    end
end


function love.update(dt)
    if state.running == true then
        -- Count time in seconds
        count = count + dt

        for i,v in ipairs(players) do
            v:update(dt)
        end

        for i,v in ipairs(enemies1) do
            v:update(dt)
        end

        for i,v in ipairs(enemies2) do
            v:update(dt)
        end

        for i,v in ipairs(shooters1) do
            v:update(dt)
        end

        for i,v in ipairs(listOfEnemyBullets1) do
            v:update(dt)
        end

        for i,v in ipairs(shooters2) do
            v:update(dt)
        end

        for i,v in ipairs(listOfEnemyBullets2) do
            v:update(dt)
        end

        for i,v in ipairs(listOfPlayerBullets1) do
            v:update(dt)
        end

        for i,v in ipairs(listOfPlayerBullets2) do
            v:update(dt)
        end

        playerJump()

        -- Used for tracking the players ability to wall jump. Resets every time player is on ground
        if player1:canJump() then
            player1.wallJumpCounter = 0
        end
        if player2:canJump() then
            player2.wallJumpCounter = 0
        end

        -- Resolve collision
        for i,wall in ipairs(walls) do
            if player1:checkCollision(wall) then
                player1.collisionTimer = 0
                if wall.deadly == true then
                    love.load()
                end
                player1:resolveCollision(wall)
                if player1:resolveCollision(wall) == "Left" or player1:resolveCollision(wall) == "Right" then
                    player1.horizontalCollision = true
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

        for i,wall in ipairs(walls2) do
            if player2:checkCollision(wall) then
                player2.collisionTimer = 0
                if wall.deadly == true then
                    love.load()
                end
                player2:resolveCollision(wall)
                if player2:resolveCollision(wall) == "Left" or player2:resolveCollision(wall) == "Right" then
                    player2.horizontalCollision = true
                end
            else
                if player2.collisionTimer then -- check for nil value
                    player2.collisionTimer = player2.collisionTimer + 1
                end
                -- If player runs off the platform give gravity so player can fall
                if player2:canJump() then
                    player2.weight = 400
                    player2.gravity = 50
                end
            end
        end

        if player1.horizontalCollision then -- check for nil value
            if player1.collisionTimer < 1500 then
                if player1.wallJumpCounter == 1 then
                    player1.wallJump = true
                end
            else
                player1.wallJump = false
            end
        end

        if player2.horizontalCollision then -- check for nil value
            if player2.collisionTimer < 1500 then
                if player2.wallJumpCounter == 1 then
                    player2.wallJump = true
                end
            else
                player2.wallJump = false
            end
        end


        -- Collision with enemies
        for i,enemy in ipairs(enemies1) do
            if player1:checkCollision(enemy) then
                love.load()
            end
        end

        for i,enemy in ipairs(enemies2) do
            if player2:checkCollision(enemy) then
                love.load()
            end
        end

        -- Shooter bullets
        for i, v in ipairs(shooters1) do
            if v.shoot == true then
                table.insert(listOfEnemyBullets1, EnemyBullet(v.x, v.y, v.r))
            end
        end

        for i, v in ipairs(shooters2) do
            if v.shoot == true then
                table.insert(listOfEnemyBullets2, EnemyBullet(v.x, v.y, v.r))
            end
        end

        -- Collision with shooters
        for i,shooter in ipairs(shooters1) do
            if player1:checkCollision(shooter) then
                love.load()
            end
        end

        for i,shooter in ipairs(shooters2) do
            if player2:checkCollision(shooter) then
                love.load()
            end
        end

        -- Collision with shooter bullets
        for i,bullet in ipairs(listOfEnemyBullets1) do
            if player1:checkCollision(bullet) then
                love.load()
            end
        end

        for i,bullet in ipairs(listOfEnemyBullets2) do
            if player2:checkCollision(bullet) then
                love.load()
            end
        end

        -- Remove shooter bullets when they hit a wall
        for i,wall in ipairs(walls) do
            for j,bullet in ipairs(listOfEnemyBullets1) do
                if bullet:checkCollision(wall) then
                    table.remove(listOfEnemyBullets1, j)
                end
            end
        end

        for i,wall in ipairs(walls2) do
            for j,bullet in ipairs(listOfEnemyBullets2) do
                if bullet:checkCollision(wall) then
                    table.remove(listOfEnemyBullets2, j)
                end
            end
        end


        -- Player bullets
        for i,v in ipairs(players) do
            v:shootBullets()
        end
        -- Fire bullets
        if player1.fire == true then
            table.insert(listOfPlayerBullets1, PlayerBullet(player1.x, player1.y, player1.currentFrame))
        end
        if player2.fire == true then
            table.insert(listOfPlayerBullets2, PlayerBullet(player2.x, player2.y, player2.currentFrame))
        end

        -- Remove bullets when they hit a wall
        for i,wall in ipairs(walls) do
            for j,bullet in ipairs(listOfPlayerBullets1) do
                if bullet:checkCollision(wall) then
                    table.remove(listOfPlayerBullets1, j)
                end
            end
        end
        for i,wall in ipairs(walls2) do
            for j,bullet in ipairs(listOfPlayerBullets2) do
                if bullet:checkCollision(wall) then
                    table.remove(listOfPlayerBullets2, j)
                end
            end
        end

    -- Enemy Respawn
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

        for i, bullet in ipairs(listOfPlayerBullets2) do
            for j, enemy in ipairs(enemies2) do
                if bullet:checkCollision(enemy) then
                    enemy.isAlive = false
                    table.insert(deadEnemies2, enemy)
                    table.remove(enemies2, j)
                    table.remove(listOfPlayerBullets2, i)
                end
            end
        end
        for i,v in ipairs(deadEnemies2) do
            v:update(dt)
        end
        for i,enemy in ipairs(deadEnemies2) do
            if enemy.isAlive == true then
                table.insert(enemies2, enemy)
                table.remove(deadEnemies2, i)
            end
        end

        -- Respawn Shooters
        for i, bullet in ipairs(listOfPlayerBullets1) do
            for j, enemy in ipairs(shooters1) do
                if bullet:checkCollision(enemy) then
                    enemy.isAlive = false
                    table.insert(deadShooters1, enemy)
                    table.remove(shooters1, j)
                    table.remove(listOfPlayerBullets1, i)
                end
            end
        end
        for i,v in ipairs(deadShooters1) do
            v:update(dt)
        end
        for i,enemy in ipairs(deadShooters1) do
            if enemy.isAlive == true then
                table.insert(shooters1, enemy)
                table.remove(deadShooters1, i)
            end
        end

        for i, bullet in ipairs(listOfPlayerBullets2) do
            for j, enemy in ipairs(shooters2) do
                if bullet:checkCollision(enemy) then
                    enemy.isAlive = false
                    table.insert(deadShooters2, enemy)
                    table.remove(shooters2, j)
                    table.remove(listOfPlayerBullets2, i)
                end
            end
        end
        for i,v in ipairs(deadShooters2) do
            v:update(dt)
        end
        for i,enemy in ipairs(deadShooters2) do
            if enemy.isAlive == true then
                table.insert(shooters2, enemy)
                table.remove(deadShooters2, i)
            end
        end

        -- Player-flag collision
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

        -- Camera
        cam:lookAt(player1.x + 16, 480)
        local scrWidth = love.graphics.getWidth()

        if cam.x < scrWidth/2 then
            cam.x = scrWidth/2
        end
    end

end

function love.draw()
    if state.running == true then
        love.graphics.setCanvas(screenCanvas)
            love.graphics.clear()
            drawGame(player1, walls, enemies1, shooters1, listOfEnemyBullets1, listOfPlayerBullets1)

        love.graphics.setCanvas()
        love.graphics.draw(screenCanvas)

        love.graphics.setCanvas(screenCanvas)
            love.graphics.clear()
            drawGame(player2, walls2, enemies2, shooters2, listOfEnemyBullets2, listOfPlayerBullets2)
        love.graphics.setCanvas()
        love.graphics.draw(screenCanvas, 0, 480)

    elseif state.running == false and state.menu == true then

        while count > 60 do
            minutes = minutes + 1
            count = count - 60
        end
        local seconds = string.format("%.3f", count)

        local runTime = tostring(minutes) .. " : " .. tostring(seconds)

        love.graphics.setColor(0.4, 0.4, 0.5, 1)
        love.graphics.rectangle("fill", 356.6, 540, 140, 60)
        love.graphics.rectangle("fill", 783.3, 540, 140, 60)
        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.print("THE END", love.graphics.newFont(60), 509, 330)
        love.graphics.print("Your Time: " .. runTime, 572, 450)

        love.graphics.print("PLAY AGAIN", love.graphics.newFont(20), 369, 558)
        love.graphics.print("QUIT", love.graphics.newFont(20), 830, 558)


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
    end
end

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


function playerJump()
    function love.keypressed(key)
        for i,v in ipairs(players) do
            if key == v.hop then
                if v:canJump() or v.wallJump == true then
                    v:jump()
                    if v.wallJumpCounter then -- check for nil value
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


---@diagnostic disable-next-line: undefined-field
local love_errorhandler = love.errhand

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end