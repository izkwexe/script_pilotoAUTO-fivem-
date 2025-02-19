local destination = nil
local isAutoPilotActive = false
local showText = true -- Controla a exibição da caixa de texto
local vehicle = nil
local playerPed = nil

-- Lista de veículos permitidos (adapte os modelos conforme necessário)
local allowedVehicles = {
    "t20",  -- Exemplo de modelo
    "tesla_modelx",  -- Outro exemplo
    -- Adicione mais modelos conforme necessário
}

-- Função para verificar se o veículo está na lista permitida
function isVehicleAllowed(vehicleModel)
    for _, model in ipairs(allowedVehicles) do
        if vehicleModel == GetHashKey(model) then
            return true
        end
    end
    return false
end

-- Adiciona uma sugestão para o comando /p1auto
TriggerEvent('chat:addSuggestion', '/p1auto', 'Ativa o piloto automático para ir ao ponto marcado no mapa.')

-- Registra o comando /p1auto
RegisterCommand('p1auto', function(source, args, rawCommand)
    playerPed = GetPlayerPed(-1)
    vehicle = GetVehiclePedIsIn(playerPed, false)
    
    local vehicleModel = GetEntityModel(vehicle)
    
    if vehicle == 0 then
        TriggerEvent("Notify", "negado", "Você não está em um veículo.", 5000)
        return
    end
    
    if not isVehicleAllowed(vehicleModel) then
        TriggerEvent("Notify", "negado", "Este veículo não é permitido para piloto automático.", 5000)
        return
    end

    if isAutoPilotActive then
        -- Desativa o piloto automático
        isAutoPilotActive = false
        showText = true -- Mostra a caixa de texto com instruções
        ClearPedTasksImmediately(playerPed) -- Para todas as tarefas do ped
        TriggerEvent("Notify", "aviso", "Piloto automático desativado.", 5000)
    else
        local blip = GetFirstBlipInfoId(8) -- Obtém o blip de destino
        if blip ~= 0 then
            local blipCoords = GetBlipCoords(blip)
            if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                -- Se o jogador é o motorista do veículo
                destination = blipCoords
                isAutoPilotActive = true
                showText = false -- Esconde a caixa de texto com instruções e mostra a de desativar
                TriggerEvent("Notify", "sucesso", "Piloto automático ativado. O veículo está a caminho do destino.", 5000)
                -- Ignorar regras de trânsito e sinalizações
                TaskVehicleDriveToCoord(playerPed, vehicle, destination.x, destination.y, destination.z, 60.0, 0, GetEntityModel(vehicle), 786603, 1.0, true)
            else
                TriggerEvent("Notify", "negado", "Você não está dirigindo o veículo.", 5000)
            end
        else
            TriggerEvent("Notify", "negado", "Não há ponto de destino marcado no mapa.", 5000)
        end
    end
end)
-- Atualiza o veículo para ir até o ponto marcado quando o piloto automático está ativo
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if isAutoPilotActive then
            local playerPed = GetPlayerPed(-1)
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local vehicleModel = GetEntityModel(vehicle)
            if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed then
                if destination then
                    TaskVehicleDriveToCoord(playerPed, vehicle, destination.x, destination.y, destination.z, 60.0, 0, GetEntityModel(vehicle), 786603, 1.0, true) -- Ignora regras de trânsito e sinalizações
                end
            end
        end
    end
end)

-- Exibe caixas de texto com instruções dentro do veículo
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if vehicle ~= 0 then
            local vehicleModel = GetEntityModel(vehicle)
            
            if isVehicleAllowed(vehicleModel) then
                local vehicleCoords = GetEntityCoords(vehicle)
                local offset = vector3(0.0, 0.5, 0.5) -- Ajuste a posição da caixa de texto dentro do veículo
                local textCoords = vehicleCoords + offset

                if showText then
                    DrawText3Ds(textCoords.x, textCoords.y, textCoords.z, "Digite /p1auto e marque no mapa para ativar o piloto automático", 255, 255, 255)
                else
                    DrawText3Ds(textCoords.x, textCoords.y, textCoords.z, "Aperte a tecla E para desativar", 255, 255, 255)
                    if IsControlJustReleased(0, 38) then -- Tecla E
                        if isAutoPilotActive then
                            isAutoPilotActive = false
                            showText = true -- Mostra a caixa de texto com instruções
                            ClearPedTasksImmediately(playerPed) -- Para todas as tarefas do ped
                            TriggerEvent("Notify", "aviso", "Piloto automático desativado.", 5000)
                            -- Dá o controle do veículo de volta ao jogador
                            TaskWarpPedIntoVehicle(playerPed, vehicle, -1) -- Força o jogador a permanecer no banco do motorista
                        end
                    end
                end
            end
        end
    end
end)

-- Função para desenhar texto em 3D na tela
function DrawText3Ds(x, y, z, text, r, g, b)
    r = r or 255
    g = g or 255
    b = b or 255
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(r, g, b, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end
