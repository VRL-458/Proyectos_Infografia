local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create() 
local musicaFondo = audio.loadStream("audio/Defqwop - Awakening.mp3")
local musicaChannel


local nivel
local solucion
local piezas
local cw = display.safeActualContentWidth
local ch = display.safeActualContentHeight
local nivel_text



local piezas_obj = {}
--[[
arco = A
rueda = R
estrella = E
linea = L
]]--
img_path= {
    A = "imagenes/piezas/arco.png",
    R = "imagenes/piezas/rueda.png",
    E = "imagenes/piezas/estrella.png",
    L = "imagenes/piezas/linea.png"

}



function gotoMenu(event)
    if event.phase == "ended" then
        local options = {effect = "fade", time = 1000}
        composer.gotoScene( "menuPrinc")
    end
end

function gotoVictory(event)
    if event.phase == "ended" then
        local options = {effect = "fade", time = 1000}
        composer.gotoScene( "victory")
    end
end
function returnLevel(self, e) 
    if e.phase == "ended" then
        local options = {effect = "fade", time = 1000}
        composer.gotoScene( "menu")
    end
    return true
end

--function
function girarPieza(event)
    --si no se quiere usar eventos touch y gestion con eventos, usar el tap
    if event.phase == "ended" then
        local pieza = event.target
        --pieza:removeEventListener("touch", girarPieza)
        local pieza = event.target 
        pieza:rotate(90)
        print("rotacion: "..pieza.rotation)
        
        --[[ esto era del anterior, pero no es necesario, ya se usa event.phase = "ended"
        timer.performWithDelay( 500, function() 
            pieza:addEventListener("touch", girarPieza) 
        end)
        ]]--
    end
    return true  
end

function revisorResultado(event, solucion)
    if event.phase == "ended" then
        for i = 1, #piezas_obj do
            local pieza = piezas_obj[i]
            print("Rotación actual de la pieza: "..pieza.rotation)

            local solucionActual = solucion[i]

            -- Si la solución es una tabla con múltiples valores posibles
            if type(solucionActual) == "table" then
                -- Si la rotación de la pieza no es igual a ninguno de los dos valores posibles en la tabla
                if pieza.rotation % 360 ~= solucionActual[1] and pieza.rotation % 360 ~= solucionActual[2] then
                    print("No es correcto")
                    return false
                end
            elseif solucionActual ~= "i" then
                -- Si la solución no es un comodín ("i") y no coincide con la rotación
                if pieza.rotation % 360 ~= solucionActual and solucionActual ~= "i" then
                    print("No es correcto")
                    return false    
                end
            end
        end
        composer.removeScene("victory")
        
        gotoVictory(event)
    end
    return true
end


function randomgiro()
    for i = 1, #piezas_obj do
        local pieza = piezas_obj[i]
        local giro = math.random(1, 4) * 90 
        pieza:rotate(giro)
    end
end


function dibujarFiguras(screen, nivel1_piezas)
    local yInicio = 1000
    local yFin = yInicio + 1440

    local filas = #nivel1_piezas             
    local columnas = #nivel1_piezas[1]   

    local anchoPantalla = display.contentWidth
    local altoZona = yFin - yInicio

    local anchoCelda = anchoPantalla / columnas
    local altoCelda = altoZona / filas

    for fila = 1, filas do
        local cadena = nivel1_piezas[fila]
        for col = 1, #cadena do

            local tipo = cadena:sub(col, col)
            if tipo ~= "-" then
            
            local img = display.newImageRect(screen,img_path[tipo], anchoCelda, altoCelda)
            img.x = (col - 0.5) * anchoCelda
            img.y = yInicio + (fila - 0.5) * altoCelda
            --ajustar la imagen al tamano de la celda
            --img.width = anchoCelda
            --img.height = altoCelda 
            table.insert(piezas_obj, img) --aqui se guardan los objetos
            img:addEventListener("touch", girarPieza) -- Agregar el evento de toque a la imagen
            end
        end
    end
end


function scene:create(event)
    local sceneGroup = self.view

    local fondo = display.newImageRect(sceneGroup, "imagenes/fondojuego.jpg", cw, ch)
    nivel = event.params.nivel
    fondo.x = display.contentCenterX
    fondo.y = display.contentCenterY


    niveltext = display.newText(sceneGroup, "Nivel " .. nivel, cw / 2, ch / 2, native.systemFont, 150)
    niveltext:setFillColor(0) 
    niveltext.x = cw / 2
    niveltext.y = 200
    
end

-- scene:show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase
    local piezas = event.params.piezas  
    nivel = event.params.nivel 
    solucion = event.params.solucion
    

    if (phase == "will") then
        musicaChannel = audio.play(musicaFondo, { loops = -1 })

        -- Ajustar tamaño real de la pantalla incluyendo áreas seguras
        print(cw, ch)

        -- Usar el nombre correcto de la variable: 'niveltext'
        if niveltext then
            niveltext.text = "Nivel " .. nivel
        end
        local reinicio = display.newImageRect(sceneGroup, "imagenes/siguiente.png", 150, 150)
        reinicio.x = cw / 2 - 300
        reinicio.y = 500 
        reinicio:rotate(90)
        reinicio:addEventListener("touch", randomgiro)
        local btn_check = display.newImageRect(sceneGroup, "imagenes/btn_check.png", 150, 150)
        btn_check.x = cw / 2
        btn_check.y = 500

        -- Botón para volver al menú
        local btn_volver = display.newImageRect(sceneGroup, "imagenes/siguiente.png", 150, 150)
        btn_volver:rotate(180)
        btn_volver.x = cw / 2 + 300
        btn_volver.y = 500
        btn_volver:addEventListener("touch", gotoMenu)

        -- Función revisor con "función anónima" (closure)
        btn_check:addEventListener("touch", function(event)
            return revisorResultado(event, solucion)
        end)

        -- Dibujar contenido dinámico dependiendo del nivel
        dibujarFiguras(sceneGroup, piezas)
        randomgiro()

    elseif (phase == "did") then
        -- Aquí puedes agregar cualquier animación o lógica adicional después de que la escena esté completamente visible
    end
end

-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
      
        for i = #piezas_obj, 1, -1 do
            local pieza = piezas_obj[i]
            if pieza then
                pieza:removeSelf()
                piezas_obj[i] = nil
            end
        end
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