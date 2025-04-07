local composer = require( "composer" )
 
local scene = composer.newScene()


--musica parametros
local musicaFondo = audio.loadStream("audio/intro.mp3")
local musicaChannel

local cw = display.safeActualContentWidth
local ch = display.safeActualContentHeight
function goToMenu() 
    local options = {effect = "fade", time = 500}
    composer.gotoScene( "menu", options)
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local fondo = display.newImageRect( sceneGroup,"imagenes/fondomenu.jpeg", cw,ch)
    fondo.x = display.contentCenterX
    fondo.y = display.contentCenterY

    --texto bienvenida
    local textPrinc = display.newText(sceneGroup, "LOOP GAME", display.contentWidth / 2, 500, native.systemFont, 220)
    
    --bnt nivel
    local btn_level = display.newImageRect(sceneGroup, "imagenes/btn_level.png", 400, 400)
    btn_level.y = ch /2
    btn_level.x = cw / 2
    btn_level:addEventListener("touch", goToMenu) 

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        musicaChannel = audio.play(musicaFondo, {loops = -1, fadein = 2000})
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        musicaChannel = audio.stop(musicaChannel)
        -- Code here runs immediately after the scene goes entirely off screen
        
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene