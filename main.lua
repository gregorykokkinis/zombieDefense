bullets = {}

function love.update(dt)
  
  if showTitleScreen then
    if not titleAudioStarted then
        titleAudio:setVolume(0.5)
        titleAudio:play()
        titleAudioStarted = true
    end
  end
  
  if not showTitleScreen then
    gameMusic:setVolume(0.5)
    gameMusic:setLooping(true)
    gameMusic:play()
    gameAudioStarted = true
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
  else
    -- X movement --
    if love.keyboard.isDown("a") then
      x = x - 200 * dt
      activeSprite = playerLeft
    elseif love.keyboard.isDown("d") then
      x = x + 200 * dt
      activeSprite = playerRight
    end
  
    -- Y movement --
    if love.keyboard.isDown("w") then
      y = y - 200 * dt
      activeSprite = playerUp
    elseif love.keyboard.isDown("s") then
      y = y + 200 * dt
      activeSprite = playerDown
    end
    
    -- Diagonal movement --
    if love.keyboard.isDown("w") and love.keyboard.isDown("d") then
      activeSprite = playerNE
    elseif love.keyboard.isDown("d") and love.keyboard.isDown("s") then
      activeSprite = playerSE
    elseif love.keyboard.isDown("a") and love.keyboard.isDown("s") then
      activeSprite = playerSW
    elseif love.keyboard.isDown("a") and love.keyboard.isDown("w") then
      activeSprite = playerNW
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
  end
end

function love.draw()
    if showTitleScreen then
        -- Draw the title screen with fading
        love.graphics.setColor(1, 1, 1, titleAlpha)
        love.graphics.draw(titleScreen, 0, 0)
        love.graphics.setColor(1, 1, 1, 1)  -- Reset color to avoid affecting other drawings
    else
        -- Draw the game
        love.graphics.draw(activeBackground)
        love.graphics.draw(activeSprite, x, y)
        
        	love.graphics.setBackgroundColor(0,0,0)
        love.graphics.setColor (255,255,255)

    end
end

function love.load()
    -- Setting game window --
    love.window.setMode(1024, 1024)
    love.window.setTitle("Gregory Kokkinis")

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
    
    -- Loading zombie sprites --
    zombieRight = love.graphics.newImage("sprites/zombie/zombieright.png")
    zombieLeft = love.graphics.newImage("sprites/zombie/zombieleft.png")
    zombieUp = love.graphics.newImage("sprites/zombie/zombieup.png")
    zombieDown = love.graphics.newImage("sprites/zombie/zombiedown.png")
    zombieNE = love.graphics.newImage("sprites/zombie/zombieNE.png")
    zombieSE = love.graphics.newImage("sprites/zombie/zombieSE.png")
    zombieSW = love.graphics.newImage("sprites/zombie/zombieSW.png")
    zombieNW = love.graphics.newImage("sprites/zombie/zombieNW.png")

    -- Set the active sprite --
    activeSprite = playerUp
    activeBackground = backgroundCicada

    -- Load title screen image and audio --
    titleScreen = love.graphics.newImage("sprites/title/titleScreen.png")
    titleAudio = love.audio.newSource("audio/zombieTitle.mp3", "stream")
    
    -- Loading game music --
    gameMusic = love.audio.newSource("audio/gameMusic.ogg", "stream")
    
    -- Title screen timer and state --
    showTitleScreen = true
    titleScreenTime = 0
    titleScreenDuration = 1.5
    titleAlpha = 0
    titleAudioStarted = false
    gameAudioStarted = false
    
end
  