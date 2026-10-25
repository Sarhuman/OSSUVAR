# P02-B — Health do jogador

Base conferida: codex/P-02A-health-inimigos em 5400272a0c6b4720c2460d582be92c604890cbe9, sem avanço. Main documental consultada: 667dc96476ad25e1652889ae4b9a57aa27ec55ec, incluindo README, DECISOES, NARRATIVA v0.4, ESTADO_PROJETO e IMPACTO_NARRATIVO_V04. A narrativa atual não altera Health como efeito colateral. Nenhum documento da main foi copiado sobre o código; nenhum PR anterior foi mesclado ou declarado homologado.

Branch codex/P-02B-health-jogador em worktree isolada. Checkout original, worktree P02-A e alterações locais preservados. Somente este recorte foi executado.

## Implementação e arquivos

- core/arena_run.gd: remove o float health, cria player_health com o HealthComponent existente e migra dano, poção, level-up e guardas de morte. Não mantém propriedade escalar de compatibilidade nem HP espelhado.
- core/prototype.gd, world/arena_view.gd, ui/arena_hud.gd: somente consumidores de vida/morte; barra consulta current/maximum do componente.
- tests/test_arena.gd e tests/test_arena_regression.gd: fixtures/acessos adaptados ao componente, sem remover assertions nem mudar expectativas.
- tests/test_player_health.gd e .uid: sete novas regressões de vida e integração.
- Este relatório. HealthComponent, tipos de impacto, fixture JSON, dados, RNG, addons, README e narrativa não alterados.

HealthComponent permanece a única autoridade de HP/máximo e rejeita cura após morte. Dano recebido utiliza Result.accepted para emitir feedback e Result.died_now para a notificação de morte. O windup de cada inimigo já é consumido uma vez; não foi adicionado ledger/cache. Impactos distintos continuam cumulativos enquanto vivo; após o letal, novos danos não repetem efeitos. Attack_enemy também rejeita novo comando com jogador morto.

A poção preserva 50% do máximo (60 no perfil legado de 120), sem consumo com vida cheia/sem carga/morto. Level-up preserva cura completa do vivo, sem consumir poção; o mesmo pedido de cura é rejeitado quando morto. Crédito tardio de um impacto já aceito continua podendo registrar XP/level, sem ressuscitar; não é autorização de um novo comando após morte. Recálculo de máximo mantém morto em zero. R cria outra ArenaRun e outro HealthComponent; o antigo continua morto. Nenhum método de ressurreição foi introduzido.

## Validação real

Versões: Godot 4.7.2.stable.official.ed1daf0bf; GUT 9.6.1; gdtoolkit 4.3.4. Comandos na raiz da worktree; godot abaixo corresponde ao executável Godot_v4.7.2-stable_win64_console.exe.

| Comando | Exit | Saída real final |
| --- | --- | --- |
| godot --headless --path . --editor --import | 0 | Importação concluída; nenhuma linha ERROR/WARNING/SCRIPT ERROR |
| gdlint core combat data ui world tests | 0 | Success: no problems found |
| godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit | 0 | Scripts 7; Tests 31; Passing Tests 30; Risky/Pending 1; Asserts 222; Time 0.767s |
| godot --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit | 0 | Scripts 7; Tests 31; Passing Tests 31; Asserts 227; Time 1.654s; All tests passed! |

Pending headless: test_click_and_automap_use_enemy_health, herdado de P02-A, exige ponteiro nativo; passou no display gráfico Windows/Compatibility. Nenhuma nova verificação foi marcada pending. Sete testes novos passaram em ambos os modos. Logs finais sem erro/aviso. Os 24 testes anteriores permanecem; a fixture arena_dff6ae1.json não mudou e os cinco checkpoints continuam idênticos em posições, HP, XP/kills/nível, custos/cooldowns, poções, inventário/drops e state RNG. Sem testes enfraquecidos.

## Editor e limites

F5 → entrar; receber golpes, observar barra e usar poção ferido/cheio; subir nível ferido e conferir cura completa; pausar/abrir inventário durante aviso inimigo e retomar; morrer e tentar ataque/skill/poção; R deve restaurar uma partida nova. Confirmar também clique e automapa herdados. Regressão gráfica automatizada não é homologação manual de ergonomia/combate. Stats, RNG, campanha e balanceamento P01 não iniciados/aprovados. Perguntas: nenhuma necessária para este recorte.
