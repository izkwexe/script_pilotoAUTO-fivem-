# Piloto Automático para FiveM

Este script permite que os jogadores ativem um piloto automático para dirigir seus veículos até um ponto de destino marcado no mapa. O piloto automático pode ser ativado ou desativado facilmente com o comando `/p1auto` dentro do jogo.

## Funcionalidades

- **Ativação do Piloto Automático**: Permite que o veículo dirija até um destino marcado no mapa automaticamente.
- **Desativação do Piloto Automático**: O piloto automático pode ser desativado pressionando a tecla `E` enquanto estiver no veículo.
- **Mensagem de Instrução**: O script exibe caixas de texto com instruções no interior do veículo, mostrando como ativar o piloto automático e como desativá-lo.
- **Verificação de Veículos Permitidos**: O script permite apenas veículos específicos a usarem o piloto automático.
- **Desvio de Regras de Trânsito**: O veículo vai automaticamente até o destino, ignorando semáforos e limites de velocidade.
- **Comando de Chat `/p1auto`**: Ativa o piloto automático ao ser utilizado, caso o jogador esteja dentro de um veículo permitido e o destino esteja marcado.

## Requisitos

- **FiveM**: Este script é projetado para ser executado em servidores FiveM.
- **vRPex Framework**: Embora não seja obrigatório, pode ser integrado com o framework vRPex.

## Instalação

1. **Baixe o Script**:
   - Faça o download do script e coloque na pasta de recursos do seu servidor FiveM.

2. **Configuração**:
   - Adapte a lista de veículos permitidos na variável `allowedVehicles` com os modelos de veículos que você deseja permitir para o piloto automático.
   - Adicione ou remova os modelos de veículos conforme necessário, usando o nome correto do modelo (ex: `"t20"`, `"tesla_modelx"`).

3. **Configuração do `fxmanifest.lua`**:
   - Inclua o script no seu arquivo `fxmanifest.lua` para que ele seja carregado corretamente:
   
   ```lua
   fx_version 'cerulean'
   game 'gta5'

   server_script 'server.lua'
   client_script 'client.lua'
