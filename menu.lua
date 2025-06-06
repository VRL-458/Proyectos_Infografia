local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------


local musicaFondo = audio.loadStream("audio/intro.mp3")
local musicaChannel


local cw = display.safeActualContentWidth
local ch = display.safeActualContentHeight
local indice = 1  

local siguiente
local nivel_text


local nivel1_piezas = {
    "RR",
    "AA"
}
local nivel2_piezas = {
    "RAR",
    "AER",
    "RA-"
}   
local nivel3_piezas = {
    "-RRLR",
    "AAR-R",
    "L-AAL",
    "ALLEA",
    "---AR"
}
local solucion1 = {180,180,90,0}
local solucion2 = {180,180,270,90,"i",270,90,0}
local solucion3 = {180,90,{0,180}, 270,180,0,180,180,{270,90},90,270,{270,90}, 90,{0,180},{0,180},"i",0,90,270}
-- create()
function goToLevel(self, e)
    if e.phase == "ended" then
        --composer.removeScene("juego")
        print("indice pasar: "..indice)
        local params = {}
        if indice == 1 then
            params = {
                nivel = 1,
                piezas = nivel1_piezas,
                solucion = solucion1
            }
        elseif indice == 2 then
            params = {
                nivel = 2,
                piezas = nivel2_piezas,
                solucion = solucion2
            }
        elseif indice == 3 then
            params = {
                nivel = 3,
                piezas = nivel3_piezas,
                solucion = solucion3
            }
        end

        local options = {
            effect = "fade",
            time = 1000,
            params = params
        }

        composer.gotoScene("juego", options)
    end
    return true
end

function niveles(event)
    local btn_accion = event.target

    if event.phase == "ended" then
        if btn_accion.name == "siguiente" then
            indice = indice + 1
            if indice > 3 then
                indice = 1
            end
        elseif btn_accion.name == "anterior" then
            indice = indice - 1
            if indice < 1 then
                indice = 3
            end
        end
        print("niveles: "..indice)
        nivel_text.text = "Nivel " .. indice
    end

    return true
end


function scene:create( event )
    local sceneGroup = self.view

    -- Crear fondo de la escena
    local fondo = display.newImageRect(sceneGroup, "imagenes/fondomenu.jpeg", cw, ch)
    fondo.x = display.contentCenterX
    fondo.y = display.contentCenterY


    -- Crear botón "Play"
    local btn_play = display.newImageRect(sceneGroup, "imagenes/btn_play.png", 350, 350)
    btn_play.y = ch/2 
    btn_play.x = display.contentWidth / 2

    btn_play.touch = goToLevel
    btn_play:addEventListener("touch", btn_play)

    -- Mostrar el texto del nivel
    nivel_text = display.newText(sceneGroup, "Nivel " .. indice, cw/2 , ch/2-400, native.systemFont, 200)  
    nivel_text:setFillColor(1) -- Color del texto
    -- Crear botón "Siguiente"
    siguiente = display.newImageRect(sceneGroup, "imagenes/siguiente.png", 250, 250)
    siguiente.y = ch /2 
    siguiente.x = (display.contentWidth / 2) + 400
    
    -- Crear botón "Anterior" 
    anterior = display.newImageRect(sceneGroup, "imagenes/siguiente.png", 250, 250)
    anterior.name = "anterior"
    anterior:rotate(180)
    anterior.y = ch /2 
    anterior.x = (display.contentWidth / 2) - 400  
    


    -- Asignar el evento al botón "Siguiente"
    siguiente.name = "siguiente"
    siguiente:addEventListener("touch", niveles) --siguente nivel
    anterior:addEventListener("touch", niveles) --nivel anterior

end

-- show()
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
           print("indice:  "..indice)
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
        audio.stop(musicaChannel)
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
