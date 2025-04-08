local composer = require( "composer" )
 
local scene = composer.newScene()
local cw = display.safeActualContentWidth
local ch = display.safeActualContentHeight
function goToMenu() 
    local options = {effect = "fade", time = 500}
    composer.gotoScene( "menuPrinc", options)
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view

    --revisar si poner animaciones


    -- Code here runs when the scene is first created but has not yet appeared on screen
    local fondo = display.newImageRect( sceneGroup,"imagenes/fondomenu.jpeg", cw,ch)
    fondo.x = display.contentCenterX
    fondo.y = display.contentCenterY


    local text_inicio = display.newText(sceneGroup, "LEO STUDIO", cw / 2, ch/2, native.systemFont, 220) 
    text_inicio:setFillColor(0) --color del texto
    timer.performWithDelay(4000, goToMenu)

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
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