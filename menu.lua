local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------


local musicaFondo = audio.loadStream("audio/intro.mp3")
local musicaChannel
  -- Repite indefinidamente con un desvanecimiento al iniciar

local cw = display.safeActualContentWidth
local ch = display.safeActualContentHeight
local indice = 1  -- Inicializamos el índice en 1 para la escena actual

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
        composer.removeScene("juego")

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

-- Función para actualizar el nivel
function niveles(event)
    -- Deshabilitar el botón para evitar múltiples clics
    siguiente:removeEventListener("touch", niveles)
    -- Incrementar el nivel
    if indice > 2 then
        indice = 1  -- Si el nivel es mayor que 3, se reinicia a 1
    else
        indice = indice + 1  -- Si no, se incrementa el nivel
    end

    -- Actualizar el texto
    nivel_text.text = "Nivel " .. indice  

    -- Volver a habilitar el botón después de un breve retraso para el siguiente clic
    timer.performWithDelay( 500, function() 
        siguiente:addEventListener("touch", niveles) 
    end)
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
    nivel_text:setFillColor(0) -- Color del texto
    -- Crear botón "Siguiente"
    siguiente = display.newImageRect(sceneGroup, "imagenes/siguiente.png", 250, 250)
    siguiente.y = ch /2 
    siguiente.x = (display.contentWidth / 2) + 400
 
    -- Asignar el evento al botón "Siguiente"
    siguiente:addEventListener("touch", niveles)  -- Ahora el evento se asigna correctamente

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
