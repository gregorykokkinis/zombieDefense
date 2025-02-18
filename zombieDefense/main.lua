function love.load()
    -- Setting game window --
    love.window.setMode(1024, 1024)
    love.window.setTitle("Made by Gregory Kokkinis")

    -- Load a custom font
    customFont = love.graphics.newFont("fonts/killFont.ttf", 24)  -- Replace with your font path
    love.graphics.setFont(customFont)

    -- X and Y values --
    x = 380
    y = 280

    -- Random X and Y zombie values --
    zombiex = 526
    zombiey = 526

    -- Get middle of screen coords --
    screenx = love.graphics.getDimensions() / 2
    screeny = love.graphics.getDimensions() / 2

    -- Loading player sprites --
    playerLeft = love.graphics.newImage("sprites/player/playerleft.png")
    playerRight = love.graphics.newImage("sprites/player/playerright.png")
    playerUp = love.graphics.newImage("sprites/player/playerup.png")
    playerDown = love.graphics.newImage("sprites/player/playerdown.png")
    playerNE = love.graphics.newImage("sprites/player/playerNE.png")
    playerSE = love.graphics.newImage("sprites/player/playerSE.png")
    playerSW = love.graphics.newImage("sprites/player/playerSW.png")
    playerNW = love.graphics.newImage("sprites/player/playerNW.png")

    -- Loading background sprites --
    backgroundCicada = love.graphics.newImage("sprites/background/backgroundCicada.png")

    -- Load zombie sprites
    zombieSprites = {
        zombieRight = love.graphics.newImage("sprites/zombie/zombieright.png"),
        zombieLeft = love.graphics.newImage("sprites/zombie/zombieleft.png"),
        zombieUp = love.graphics.newImage("sprites/zombie/zombieup.png"),
        zombieDown = love.graphics.newImage("sprites/zombie/zombiedown.png"),
        zombieNE = love.graphics.newImage("sprites/zombie/zombieNE.png"),
        zombieSE = love.graphics.newImage("sprites/zombie/zombieSE.png"),
        zombieSW = love.graphics.newImage("sprites/zombie/zombieSW.png"),
        zombieNW = love.graphics.newImage("sprites/zombie/zombieNW.png")
    }

    -- Zombie variables
    zombies = {}  -- Table to store all zombies
    zombieScale = 0.7  -- Default scale for zombies
    maxZombies = 10  -- Maximum number of zombies to spawn

    -- Zombie spawn timer
    zombieSpawnTimer = 0
    zombieSpawnInterval = 2  -- Spawn a zombie every 2 seconds

    -- Spawn initial zombies
    for i = 1, maxZombies do
        spawnZombie()
    end

    -- Set the active sprite --
    activeSprite = playerUp
    playerDirection = "playerUp"  -- Track the player's direction as a string
    activeBackground = backgroundCicada

    -- Load title screen image and audio --
    titleScreen = love.graphics.newImage("sprites/title/titleScreen.png")
    titleAudio = love.audio.newSource("audio/zombieTitle.mp3", "stream")

    -- Load end screen image and audio --
    endScreen = love.graphics.newImage("sprites/end/endScreen.png")
    endAudio = love.audio.newSource("audio/zombieEnd.mp3", "stream")

    -- Zombie eat sound --
    zombieEat = love.audio.newSource("audio/zombieEat.mp3", "stream")

    -- Loading game music --
    gameMusic = love.audio.newSource("audio/gameMusic.ogg", "stream")

    -- Load wave sound effect
    waveNext = love.audio.newSource("audio/nextWave.wav", "stream")

    -- Set the muzzle flash sprite --
    muzzleFlash = love.graphics.newImage("sprites/weapon/muzzleFlash.png")

    -- Load weapon sound effects --
    reloadSound = love.audio.newSource("audio/reload.wav", "stream")
    shootSound = love.audio.newSource("audio/shoot.wav", "stream")

    -- Load loss sound effects --
    deathSound = love.audio.newSource("audio/death.mp3", "stream")
    lossSound = love.audio.newSource("audio/loss.wav", "stream")

    -- Load zombie death sound effects --
    zombieKillOne = love.audio.newSource("audio/zombieDeath/zombieDeathOne.ogg", "stream")
    zombieKillTwo = love.audio.newSource("audio/zombieDeath/zombieDeathTwo.ogg", "stream")
    zombieKillThree = love.audio.newSource("audio/zombieDeath/zombieDeathThree.ogg", "stream")  

    -- Title screen timer and state --
    showTitleScreen = true
    titleScreenTime = 0
    titleScreenDuration = 1.5
    titleAlpha = 0
    titleAudioStarted = false
    gameAudioStarted = false

    -- Button variables
    giveUpButton = {
        text = "Give Up",
        font = love.graphics.newFont("fonts/killFont.ttf", 65),  -- Font size 36
        width = 400,
        height = 100,
        x = 630,  -- 20px from the right edge
        y = 450,  -- 20px from the top
        color = {0.5, 0.5, 0.5, 1}  -- Gray color
    }

    bringItOnButton = {
        text = "Bring It On",
        font = love.graphics.newFont("fonts/killFont.ttf", 65),  -- Font size 36
        width = 200,
        height = 40,
        x = 585,  -- 20px from the right edge, next to "Give Up"
        y = 300,  -- 20px below "Give Up"
        color = {0.5, 0.5, 0.5, 1}  -- Gray color
    }

    -- Bar variables
    maxShots = 10  -- Maximum number of shots before the bar is full
    currentShots = 0  -- Current number of shots fired
    barWidth = 30  -- Width of the bar
    barHeight = 300  -- Height of the bar
    barX = love.graphics.getWidth() - barWidth - 20  -- X position of the bar (right side of the screen)
    barY = (love.graphics.getHeight() - barHeight) / 2  -- Y position of the bar (centered vertically)
    barCornerRadius = 20  -- Corner radius of the bar

    -- Reload variables
    isReloading = false  -- Track if the player is reloading
    reloadKey = "r"      -- Key to trigger reload
    depletionSpeed = 5   -- How many shots are depleted per second

    -- Screen shake variables
    screenShakeIntensity = 0  -- Current intensity of the screen shake
    screenShakeDuration = 0   -- Duration of the screen shake
    maxScreenShakeIntensity = 4  -- Maximum intensity of the screen shake
    screenShakeDecay = 5      -- How quickly the screen shake fades

    -- Muzzle flash offsets, rotation, and scale for each direction
    muzzleFlashOffsets = {
        playerUp = {x = 150, y = -25, rotation = math.rad(270), scaleX = 0.4, scaleY = 0.4},    -- Facing up
        playerDown = {x = 155, y = 338, rotation = math.rad(90), scaleX = 0.4, scaleY = 0.4}, -- Facing down
        playerLeft = {x = -25, y = 155, rotation = math.rad(180), scaleX = 0.4, scaleY = 0.4}, -- Facing left
        playerRight = {x = 337, y = 148, rotation = math.rad(360), scaleX = 0.4, scaleY = 0.4},  -- Facing right
        playerNE = {x = 305, y = 55, rotation = math.rad(315), scaleX = 0.4, scaleY = 0.4},   -- Facing northeast
        playerSE = {x = 243, y = 305, rotation = math.rad(45), scaleX = 0.4, scaleY = 0.4},   -- Facing southeast
        playerSW = {x = -6, y = 242, rotation = math.rad(135), scaleX = 0.4, scaleY = 0.4}, -- Facing southwest
        playerNW = {x = 55, y = -3, rotation = math.rad(225), scaleX = 0.4, scaleY = 0.4}  -- Facing northwest
    }

    -- Kill count --
    zombieKills = 0

    -- Initialise hover states --
    giveUpButton.hovered = false
    bringItOnButton.hovered = false

    -- Define kill counter background dimensions
    killCounterWidth = 200
    killCounterHeight = 40
    killCounterX = (love.graphics.getWidth() - killCounterWidth) / 2  -- Center horizontally
    killCounterY = 20  -- Position at the top

    -- Wave variables
    currentWave = 1  -- Current wave number
    zombiesKilledThisWave = 0  -- Zombies killed in the current wave
    zombiesToKillPerWave = 10  -- Number of zombies to kill to advance to the next wave
    zombieSpeedMultiplier = 1  -- Multiplier for zombie speed (increases with waves)
    zombieSpawnRateMultiplier = 1  -- Multiplier for zombie spawn rate (increases with waves)

    -- Wave bar variables
    waveCounterWidth = 150
    waveCounterHeight = 30
    waveCounterX = (love.graphics.getWidth() - waveCounterWidth) / 2  -- Center horizontally
    waveCounterY = killCounterY + killCounterHeight + 10  -- Position below the kills bar

    -- Load smaller font --
    waveFont = love.graphics.newFont("fonts/KillFont.ttf", 18)

    -- Game over state
    gameOver = false
    fadeAlpha = 0
    lossSoundPlayed = false

    -- Death screen variables
    fadeToBlackAlpha = 0  -- Alpha for fading to black
    fadeToEndScreenAlpha = 0  -- Alpha for fading to the end screen
    fadeSpeed = 0.5  -- Speed of the fade transitions
    deathScreenState = "fadeToBlack"  -- Current state of the death screen
end

function love.update(dt)
    if showTitleScreen then
        if not titleAudioStarted then
            titleAudio:setVolume(0.5)
            titleAudio:play()
            titleAudioStarted = true
        end
    end

    if not showTitleScreen and not gameOver then
        if not gameAudioStarted then
            gameMusic:setVolume(0.5)
            gameMusic:setLooping(true)
            gameMusic:play()
            gameAudioStarted = true
        end
    end

    if showTitleScreen then
        -- Update the title screen timer
        titleScreenTime = titleScreenTime + dt
        if titleScreenTime < 1 then  -- Fade in for 1 second
            titleAlpha = titleAlpha + dt
        elseif titleScreenTime > titleScreenDuration then  -- Start fading out after 3 seconds
            titleAlpha = titleAlpha - dt
        end

        if titleScreenTime > titleScreenDuration + 1 then  -- End title screen after fade out
            showTitleScreen = false
        end
    elseif gameOver then
        -- Handle the death screen states
        if deathScreenState == "fadeToBlack" then
            -- Fade to black
            fadeToBlackAlpha = math.min(fadeToBlackAlpha + fadeSpeed * dt, 1)

            -- Stop the game music and play the death sound
            if not lossSoundPlayed then
                gameMusic:stop()
                deathSound:play()
                lossSoundPlayed = true
            end

            -- Once fully black, transition to the end screen
            if fadeToBlackAlpha >= 1 then
                deathScreenState = "fadeToEndScreen"
            end
        elseif deathScreenState == "fadeToEndScreen" then
            -- Fade in the end screen
            fadeToEndScreenAlpha = math.min(fadeToEndScreenAlpha + fadeSpeed * dt, 1)

            -- Play the end audio once the fade starts
            if fadeToEndScreenAlpha > 0 and not endAudio:isPlaying() then
                endAudio:play()
            end
        end
    else
        -- X movement --
        if love.keyboard.isDown("a") then
            x = x - 200 * dt
            activeSprite = playerLeft
            playerDirection = "playerLeft"
        elseif love.keyboard.isDown("d") then
            x = x + 200 * dt
            activeSprite = playerRight
            playerDirection = "playerRight"
        end

    -- Get the mouse position
    local mouseX, mouseY = love.mouse.getPosition()

        -- Zombie code --
        for _, zombie in ipairs(zombies) do
            -- Example: Move zombies towards the player
            local dx = x - zombie.x
            local dy = y - zombie.y
            local distance = math.sqrt(dx * dx + dy * dy)

            if distance > 0 then
                zombie.x = zombie.x + (dx / distance) * 50 * dt * zombieSpeedMultiplier
                zombie.y = zombie.y + (dy / distance) * 50 * dt * zombieSpeedMultiplier
            end

            -- Update zombie direction based on movement (optional)
            if math.abs(dx) > math.abs(dy) then
                if dx > 0 then
                    zombie.direction = "right"
                    zombie.sprite = zombieSprites.zombieRight
                else
                    zombie.direction = "left"
                    zombie.sprite = zombieSprites.zombieLeft
                end
            else
                if dy > 0 then
                    zombie.direction = "down"
                    zombie.sprite = zombieSprites.zombieDown
                else
                    zombie.direction = "up"
                    zombie.sprite = zombieSprites.zombieUp
                end
            end

            -- Check if the player is touched by a zombie
            if distance < 70 then  -- Adjust hitbox size as needed
                if not gameOver then
                    gameOver = true
                    deathSound:play()
                    gameMusic:stop()
                end
            end
        end

        -- Zombie spawn timer --
        zombieSpawnTimer = zombieSpawnTimer + dt
        if zombieSpawnTimer >= zombieSpawnInterval / zombieSpawnRateMultiplier then
            spawnZombie()
            zombieSpawnTimer = 0
        end

        -- Y movement --
        if love.keyboard.isDown("w") then
            y = y - 200 * dt
            activeSprite = playerUp
            playerDirection = "playerUp"
        elseif love.keyboard.isDown("s") then
            y = y + 200 * dt
            activeSprite = playerDown
            playerDirection = "playerDown"
        end

        -- Diagonal movement --
        if love.keyboard.isDown("w") and love.keyboard.isDown("d") then
            activeSprite = playerNE
            playerDirection = "playerNE"
        elseif love.keyboard.isDown("d") and love.keyboard.isDown("s") then
            activeSprite = playerSE
            playerDirection = "playerSE"
        elseif love.keyboard.isDown("a") and love.keyboard.isDown("s") then
            activeSprite = playerSW
            playerDirection = "playerSW"
        elseif love.keyboard.isDown("a") and love.keyboard.isDown("w") then
            activeSprite = playerNW
            playerDirection = "playerNW"
        end

        -- Shoot mechanic --
        if love.keyboard.isDown("space") then
            if not muzzleFlashActive and not isReloading and currentShots < maxShots then
                muzzleFlashTime = 0.4  -- Set how long the muzzle flash stays
                muzzleFlashActive = true

                -- Play the shoot sound every time the spacebar is pressed
                shootSound:play()

                -- Increment the shot counter
                currentShots = currentShots + 1

                -- Trigger screen shake
                screenShakeIntensity = maxScreenShakeIntensity
                screenShakeDuration = 0.2  -- Duration of the screen shake in seconds

                -- Check for zombie hits
                for i = #zombies, 1, -1 do  -- Iterate backwards to safely remove zombies
                    local zombie = zombies[i]
                    if isZombieHit(zombie) then
                        table.remove(zombies, i)  -- Remove the zombie
                        zombieKills = zombieKills + 1  -- Increment the kill counter
                        zombiesKilledThisWave = zombiesKilledThisWave + 1  -- Increment wave kill counter
                        playRandomZombieKillSound()  -- Play a random zombie kill sound
                    end
                end
            end
        end

        -- Update screen shake
        if screenShakeDuration > 0 then
            screenShakeDuration = screenShakeDuration - dt
            screenShakeIntensity = screenShakeIntensity - screenShakeDecay * dt
            if screenShakeIntensity < 0 then
                screenShakeIntensity = 0
            end
        else
            screenShakeIntensity = 0  -- Reset intensity when the duration is over
        end

        -- Reload mechanic
        if love.keyboard.isDown(reloadKey) and currentShots > 0 and not isReloading then
            isReloading = true
            reloadSound:play()  -- Play the reload sound
        end

        -- Deplete the bar during reload
        if isReloading then
            currentShots = currentShots - depletionSpeed * dt  -- Gradually reduce currentShots
            if currentShots <= 0 then
                currentShots = 0  -- Ensure it doesn't go below 0
                isReloading = false  -- End reloading
            end
        end

        -- Decrease muzzle flash time
        if muzzleFlashActive then
            muzzleFlashTime = muzzleFlashTime - dt
            if muzzleFlashTime <= 0 then
                muzzleFlashActive = false
            end
        end

        -- Boundaries of left map --
        if x < -280 then
            x = 1100
        end

        -- Boundaries of right map --
        if x > 1100 then
            x = -280
        end

        -- Boundaries of up map --
        if y < -300 then
            y = 800
        end

        -- Boundaries of down map --
        if y > 850 then
            y = -300
        end

        -- Check if the current wave is complete
        if zombiesKilledThisWave >= zombiesToKillPerWave then
            currentWave = currentWave + 1  -- Advance to the next wave
            zombiesKilledThisWave = 0  -- Reset kills for the next wave
            zombiesToKillPerWave = zombiesToKillPerWave + 5  -- Increase zombies required for the next wave

            -- Stop and play the next wave sound
            waveNext:stop()  -- Stop the sound if it's already playing
            waveNext:setVolume(1.0) -- Set to full volume
            waveNext:play()  -- Play the sound for the new wave

            -- Increase zombie speed and spawn rate (capped at wave 10)
            if currentWave <= 10 then
                zombieSpeedMultiplier = 1 + (currentWave - 1) * 0.2  -- Increase speed by 20% per wave
                zombieSpawnRateMultiplier = 1 + (currentWave - 1) * 0.1  -- Increase spawn rate by 10% per wave
            end

            -- Spawn more zombies for the new wave
            for i = 1, currentWave do
                spawnZombie()
            end
        end
    end
end

function love.draw()
    -- Calculate screen shake offset
    local offsetX = (math.random() * 2 - 1) * screenShakeIntensity  -- Random X offset
    local offsetY = (math.random() * 2 - 1) * screenShakeIntensity  -- Random Y offset

    -- Apply the offset to all drawing operations
    love.graphics.push()
    love.graphics.translate(offsetX, offsetY)

    if showTitleScreen then
        -- Draw the title screen with fading
        love.graphics.setColor(1, 1, 1, titleAlpha)
        love.graphics.draw(titleScreen, 0, 0)
        love.graphics.setColor(1, 1, 1, 1)  -- Reset color to avoid affecting other drawings
    else
        -- Draw the game
        love.graphics.draw(activeBackground)
        love.graphics.draw(activeSprite, x, y)

        -- Draw all zombies
        for _, zombie in ipairs(zombies) do
            love.graphics.draw(zombie.sprite, zombie.x, zombie.y, 0, zombie.scale, zombie.scale)
        end

        -- Draw the muzzle flash if active
        if muzzleFlashActive then
            love.graphics.setColor(1, 1, 1, 1)  -- Full opacity for muzzle flash
            local offset = muzzleFlashOffsets[playerDirection] or {x = 0, y = 0, rotation = 0, scaleX = 1, scaleY = 1}
            love.graphics.draw(
                muzzleFlash,
                x + offset.x,
                y + offset.y,
                offset.rotation,
                offset.scaleX,
                offset.scaleY,
                muzzleFlash:getWidth() / 2,
                muzzleFlash:getHeight() / 2
            )
        end

        -- Draw the vertical bar
        if not gameOver then
            love.graphics.setColor(0.2, 0.2, 0.2)  -- Background color of the bar
            love.graphics.rectangle("fill", barX, barY, barWidth, barHeight, barCornerRadius, barCornerRadius)

            -- Calculate the height of the filled portion of the bar
            local fillHeight = (currentShots / maxShots) * barHeight

            -- Only draw the filled portion if there are shots
            if currentShots > 0 then
                -- Calculate the gradient color based on the fill percentage
                local fillPercentage = currentShots / maxShots
                local r = fillPercentage  -- Red increases as the bar fills
                local g = 1 - fillPercentage  -- Green decreases as the bar fills
                local b = 0  -- No blue component

                -- Set the gradient color
                love.graphics.setColor(r, g, b)

                -- Draw the filled portion of the bar
                love.graphics.rectangle("fill", barX, barY + barHeight - fillHeight, barWidth, fillHeight, barCornerRadius, barCornerRadius)
            end

            -- Draw the outline of the bar
            love.graphics.setColor(1, 1, 1)  -- Outline color of the bar (white)
            love.graphics.rectangle("line", barX, barY, barWidth, barHeight, barCornerRadius, barCornerRadius)
        end

        -- Draw the kill counter background
        if not gameOver then
            love.graphics.setColor(0.2, 0.2, 0.2)  -- Gray color
            love.graphics.rectangle("fill", killCounterX, killCounterY, killCounterWidth, killCounterHeight, 10, 10)  -- Rounded corners

            -- Draw the kill counter text
            love.graphics.setColor(1, 1, 1)  -- White text
            local killsText = "Kills: " .. zombieKills
            local textWidth = customFont:getWidth(killsText)
            local textX = killCounterX + (killCounterWidth - textWidth) / 2  -- Center text horizontally
            local textY = killCounterY + (killCounterHeight - customFont:getHeight()) / 2  -- Center text vertically
            love.graphics.print(killsText, textX, textY)

            -- Draw the white border around the kills bar
            love.graphics.setColor(1, 1, 1)  -- White color for the border
            love.graphics.rectangle("line", killCounterX, killCounterY, killCounterWidth, killCounterHeight, 10, 10)
        end

    -- Draw the wave counter background
    if not gameOver then
        love.graphics.setColor(0.2, 0.2, 0.2)  -- Gray color
        love.graphics.rectangle("fill", waveCounterX, waveCounterY, waveCounterWidth, waveCounterHeight, 5, 5)  -- Rounded corners

        -- Draw the wave counter text
        love.graphics.setColor(1, 1, 1)  -- White text
        love.graphics.setFont(waveFont)  -- Use the smaller font
        local waveText = "Wave: " .. currentWave
        local textWidth = waveFont:getWidth(waveText)  -- Use waveFont for width calculation
        local textHeight = waveFont:getHeight()  -- Use waveFont for height calculation
        local textX = waveCounterX + (waveCounterWidth - textWidth) / 2  -- Center text horizontally
        local textY = waveCounterY + (waveCounterHeight - textHeight) / 2  -- Center text vertically
        love.graphics.print(waveText, textX, textY)

        -- Draw the white border around the wave counter
        love.graphics.setColor(1, 1, 1)  -- White color for the border
        love.graphics.rectangle("line", waveCounterX, waveCounterY, waveCounterWidth, waveCounterHeight, 5, 5)
    end

        -- Draw game over screen
        if gameOver then
            -- Fade to black
            love.graphics.setColor(1, 0, 0, fadeAlpha)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

            -- Draw "You Lost" text
            love.graphics.setColor(1, 1, 1, fadeAlpha)
            local lostText = "You Died"
            local lostFont = love.graphics.newFont("fonts/killFont.ttf", 200)
            love.graphics.setFont(lostFont)
            local textWidth = lostFont:getWidth(lostText)
            local textHeight = lostFont:getHeight()
            love.graphics.print(lostText, (love.graphics.getWidth() - textWidth) / 2, (love.graphics.getHeight() - textHeight) / 2 - 50)

            -- Draw restart button
            love.graphics.setColor(0.5, 0.5, 0.5, fadeAlpha)  -- Gray color for the button
            local buttonWidth = 300
            local buttonHeight = 80
            local buttonX = (love.graphics.getWidth() - buttonWidth) / 2
            local buttonY = (love.graphics.getHeight() - textHeight) / 2 + 50
            love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight, 10, 10)
            love.graphics.setColor(1, 1, 1, fadeAlpha)
            local buttonText = "Restart"
            local buttonTextWidth = customFont:getWidth(buttonText)
            local buttonTextHeight = customFont:getHeight()
            love.graphics.print(buttonText, buttonX + (buttonWidth - buttonTextWidth) / 2, buttonY + (buttonHeight - textHeight) / 2)
        end

        -- Draw the death screen
        if gameOver then
            -- Fade to black
            if deathScreenState == "fadeToBlack" then
                love.graphics.setColor(0, 0, 0, fadeToBlackAlpha)
                love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            end

            -- Fade in the end screen
            if deathScreenState == "fadeToEndScreen" then
                love.graphics.setColor(0, 0, 0, 1)
                love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

                -- Fade in end screen
                love.graphics.setColor(1, 1, 1, fadeToEndScreenAlpha)
                love.graphics.draw(endScreen, 0, 0)

                -- Draw the buttons on the end screen
                if fadeToEndScreenAlpha > 0 then
                    -- "Give Up" button
                    love.graphics.setColor(1, 1, 1, fadeToEndScreenAlpha)
                    love.graphics.setFont(giveUpButton.font)
                    local textWidth = giveUpButton.font:getWidth(giveUpButton.text)
                    love.graphics.print(giveUpButton.text, giveUpButton.x, giveUpButton.y)

                    -- "Bring It On" button
                    love.graphics.setColor(1, 1, 1, fadeToEndScreenAlpha)
                    love.graphics.setFont(bringItOnButton.font)
                    textWidth = bringItOnButton.font:getWidth(bringItOnButton.text)
                    textHeight = bringItOnButton.font:getHeight()
                    love.graphics.print(bringItOnButton.text, bringItOnButton.x, bringItOnButton.y)
                end
            end
        end

        if gameOver and deathScreenState == "fadeToEndScreen" then
            -- Draw the "Give Up" button
            if giveUpButton.hovered then
                love.graphics.setColor(1, 0, 0, fadeToEndScreenAlpha)  -- Red when hovered
            else
                love.graphics.setColor(1, 1, 1, fadeToEndScreenAlpha)  -- White when not hovered
            end
            love.graphics.setFont(giveUpButton.font)
            love.graphics.print(giveUpButton.text, giveUpButton.x, giveUpButton.y)
    
            -- Draw the "Bring It On" button
            if bringItOnButton.hovered then
                love.graphics.setColor(1, 0, 0, fadeToEndScreenAlpha)  -- Red when hovered
            else
                love.graphics.setColor(1, 1, 1, fadeToEndScreenAlpha)  -- White when not hovered
            end
            love.graphics.setFont(bringItOnButton.font)
            love.graphics.print(bringItOnButton.text, bringItOnButton.x, bringItOnButton.y)
        end
    end

    -- Reset the font to the default for other text
    love.graphics.setFont(customFont)

    -- Reset the drawing transformation
    love.graphics.pop()
end

function love.mousepressed(x, y, button)
    if gameOver and button == 1 then
        -- Check if the restart button is clicked
        local buttonWidth = 200
        local buttonHeight = 50
        local buttonX = (love.graphics.getWidth() - buttonWidth) / 2
        local buttonY = (love.graphics.getHeight() - customFont:getHeight()) / 2 + 100
        if x >= buttonX and x <= buttonX + buttonWidth and y >= buttonY and y <= buttonY + buttonHeight then
            restartGame()
        end
    end
end

function restartGame()
    -- Reset game state (unchanged)
    gameOver = false
    fadeAlpha = 0
    lossSoundPlayed = false
    zombies = {}
    currentShots = 0
    zombieKills = 0
    x = 380
    y = 280
    showTitleScreen = false
    titleAudioStarted = false
    gameAudioStarted = false

    -- Reset wave state (unchanged)
    currentWave = 1
    zombiesKilledThisWave = 0
    zombiesToKillPerWave = 10
    zombieSpeedMultiplier = 1
    zombieSpawnRateMultiplier = 1

    -- Spawn initial zombies (unchanged)
    for i = 1, maxZombies do
        spawnZombie()
    end

    -- Restart game music (unchanged)
    gameMusic:play()

    -- Reset death screen variables
    fadeToBlackAlpha = 0
    fadeToEndScreenAlpha = 0
    deathScreenState = "fadeToBlack"

    -- Reset the custom font (unchanged)
    love.graphics.setFont(customFont)
end

function playRandomZombieKillSound()
    zombiesKilledThisWave = zombiesKilledThisWave + 1  -- Increment kills for the current wave
    zombieKills = zombieKills + 1  -- Increment total kills

    local randomSound = math.random(1, 3)
    if randomSound == 1 then
        zombieKillOne:play()
    elseif randomSound == 2 then
        zombieKillTwo:play()
    else
        zombieKillThree:play()
    end
end

function spawnZombie()
    local side = math.random(1, 4)  -- Randomly choose a side (1: top, 2: right, 3: bottom, 4: left)
    local zombie = {
        scale = zombieScale,
        direction = "down",
        sprite = zombieSprites.zombieDown
    }

    -- Spawn zombies outside the visible window based on the chosen side
    if side == 1 then
        -- Top side (above the screen)
        zombie.x = math.random(-280, 1100)  -- Random X within map boundaries
        zombie.y = math.random(-600, -400)  -- Y position above the screen
    elseif side == 2 then
        -- Right side (to the right of the screen)
        zombie.x = math.random(1200, 1400)  -- X position to the right of the screen
        zombie.y = math.random(-300, 850)   -- Random Y within map boundaries
    elseif side == 3 then
        -- Bottom side (below the screen)
        zombie.x = math.random(-280, 1100)  -- Random X within map boundaries
        zombie.y = math.random(900, 1100)   -- Y position below the screen
    elseif side == 4 then
        -- Left side (to the left of the screen)
        zombie.x = math.random(-500, -400)  -- X position to the left of the screen
        zombie.y = math.random(-300, 850)   -- Random Y within map boundaries
    end

    table.insert(zombies, zombie)  -- Add the zombie to the zombies table
end

function isZombieHit(zombie)
    local leeway = 100  -- How much leeway to give for the line of sight
    local range = 2000   -- How far the player can "shoot"

    -- Get the player's position and direction
    local playerX, playerY = x, y

    -- Define the hit area based on the player's direction
    if playerDirection == "playerUp" then
        -- Check if the zombie is above the player and within the leeway
        if zombie.y < playerY and zombie.y > playerY - range and
           math.abs(zombie.x - playerX) < leeway then
            return true
        end
    elseif playerDirection == "playerDown" then
        -- Check if the zombie is below the player and within the leeway
        if zombie.y > playerY and zombie.y < playerY + range and
           math.abs(zombie.x - playerX) < leeway then
            return true
        end
    elseif playerDirection == "playerLeft" then
        -- Check if the zombie is to the left of the player and within the leeway
        if zombie.x < playerX and zombie.x > playerX - range and
           math.abs(zombie.y - playerY) < leeway then
            return true
        end
    elseif playerDirection == "playerRight" then
        -- Check if the zombie is to the right of the player and within the leeway
        if zombie.x > playerX and zombie.x < playerX + range and
           math.abs(zombie.y - playerY) < leeway then
            return true
        end
    elseif playerDirection == "playerNE" then
        -- Check if the zombie is in the northeast diagonal area
        local dx = zombie.x - playerX
        local dy = playerY - zombie.y  -- Y is inverted (up is negative)
        if dx > 0 and dy > 0 and dx + dy < range and math.abs(dx - dy) < leeway then
            return true
        end
    elseif playerDirection == "playerSE" then
        -- Check if the zombie is in the southeast diagonal area
        local dx = zombie.x - playerX
        local dy = zombie.y - playerY
        if dx > 0 and dy > 0 and dx + dy < range and math.abs(dx - dy) < leeway then
            return true
        end
    elseif playerDirection == "playerSW" then
        -- Check if the zombie is in the southwest diagonal area
        local dx = playerX - zombie.x
        local dy = zombie.y - playerY
        if dx > 0 and dy > 0 and dx + dy < range and math.abs(dx - dy) < leeway then
            return true
        end
    elseif playerDirection == "playerNW" then
        -- Check if the zombie is in the northwest diagonal area
        local dx = playerX - zombie.x
        local dy = playerY - zombie.y  -- Y is inverted (up is negative)
        if dx > 0 and dy > 0 and dx + dy < range and math.abs(dx - dy) < leeway then
            return true
        end
    end

    return false
end

function love.mousepressed(x, y, button)
    if gameOver and deathScreenState == "fadeToEndScreen" and button == 1 then
        -- Check if the "Give Up" button is clicked
        local giveUpTextWidth = giveUpButton.font:getWidth(giveUpButton.text)
        local giveUpTextHeight = giveUpButton.font:getHeight()
        if x >= giveUpButton.x and x <= giveUpButton.x + giveUpTextWidth and
           y >= giveUpButton.y and y <= giveUpButton.y + giveUpTextHeight then
            love.event.quit()  -- Exit the game
        end
        -- Reset the cursor to the default after clicking
        love.mouse.setCursor(love.mouse.getSystemCursor("arrow"))

        -- Check if the "Bring It On" button is clicked
        local bringItOnTextWidth = bringItOnButton.font:getWidth(bringItOnButton.text)
        local bringItOnTextHeight = bringItOnButton.font:getHeight()
        if x >= bringItOnButton.x and x <= bringItOnButton.x + bringItOnTextWidth and
           y >= bringItOnButton.y and y <= bringItOnButton.y + bringItOnTextHeight then
            restartGame()  -- Restart the game
        end
    end
end