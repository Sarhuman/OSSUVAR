# Protótipo — Vigília de Cal

## Escopo e autorização

Em 24/10/2026, o responsável solicitou criar o jogo e imagens a partir das duas
referências do Project Diablo 2 e selecionou **Conduza o protótipo**, autorizando
execução das etapas e decisões técnicas dentro do escopo existente. Este recorte
reaproveita o bootstrap `codex/T-001`, sem modificar o PR #2 nem fazer merges.

A entrega é uma arena experimental, revisável em PR draft. O trabalho ultrapassa
o alvo de 400 linhas porque reúne o primeiro ciclo jogável autorizado; não libera
automaticamente a campanha, os marcos ou a arte definitiva.

## Fronteiras

- Entrada e composição: `core/prototype.gd`.
- Estado e regras de uma partida: `core/arena_run.gd`, sem Node ou cena.
- Balanceamento provisório: `data/arena_rules.gd` e `.tres`.
- Projeção: `world/iso_math.gd`, independente da apresentação.
- Apresentação: `world/arena_view.gd`, TileMapLayer e ordenação por profundidade.
- Interface: `ui/arena_hud.gd`, isolada da simulação.
- Testes: regras, recursos, alinhamento do piso e fluxo menu/pausa/inventário/reinício.

Esta arena não substitui a arquitetura final de componentes e dados do GDD.
O estado de inimigos e drops ainda usa dicionários locais; o RNG é da partida
experimental. Não conecta os autoloads vazios nem introduz serviços globais.
Antes de ampliar o conteúdo, extrair entidades tipadas, Health/Stats/SkillCaster,
integrar o serviço RNG e completar CombatMath e seu contrato de bordas.

## Conferência prática

1. Abrir com F5; confirmar título, ilustração e botão de entrada.
2. Caminhar e clicar atrás das três pedras alinhadas: o caminho deve contornar.
3. Clicar no esqueleto: aproximar, alternar acertos/erros e receber XP uma vez.
4. Usar o botão direito próximo e longe: dano somente no raio; mana e cooldown respeitados.
5. Recolher com E, abrir I, equipar com F e verificar o bônus no ataque básico.
6. Testar poção com vida cheia, ferido e sem cargas; não pode ressuscitar.
7. Abrir inventário e pausar: a simulação deve parar. R deve reiniciar tudo.
8. Eliminar os dez inimigos e confirmar conclusão; morrer e reiniciar.

Ainda requer playtest humano no Windows para sensação do combate e ergonomia.
Não há benchmark de hardware real nem validação da campanha. Nenhum progresso
é persistido ao fechar. Não exportado como executável.
