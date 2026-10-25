# P02-C — Stats ofensivos legados

Base conferida: codex/P-02B-health-jogador, fd16ae864a8275255c6840b9af06cad9b7c3fd42, sem avanço antes da edição. Main de coordenação: 667dc96476ad25e1652889ae4b9a57aa27ec55ec (ESTADO_PROJETO/DECISOES v0.4 consultados); nenhuma narrativa foi aplicada como mudança de código. Branch codex/P-02C-stats-ofensivos em worktree isolada, sem merges nem homologação implícita.

## Arquivos e decisões

- combat/components/stats_component.gd/.uid: RefCounted limitado a dano básico e Giro. Definição-base permanece em cópia privada de ArenaRules, capturada na construção; não há fontes/estado do personagem no Resource compartilhado. Fontes planas identificadas por StringName não vazio, aplicáveis somente ao básico, ficam no componente. Reaplicar substitui; remover recalcula sem resíduos. Não há sistema universal de atributos/efeitos nem cache derivado acumulativo.
- data/arena_rules.gd: equipment_damage_bonus=6 e skill_damage_bonus=8 explícitos, com player_damage=16 preservado. O .tres existente usa esses defaults e não precisou mudar.
- core/arena_run.gd: player_stats novo por partida; ataque básico/Giro consultam snapshot; equipar registra a fonte estável equipment:ferro_funerario antes de mudar o estado de equipamento. equipped permanece flag de apresentação, não calcula dano. Aviso de equipamento usa o valor validado do Resource, mantendo o texto +6 legado.
- tests/test_stats_component.gd e tests/test_player_offense.gd/.uid: dez novos testes. Este relatório. Testes/fixture anteriores não foram alterados.

Snapshot contém apenas dois inteiros numa instância nova; o consumidor pode editar sua cópia sem alterar Stats ou snapshots anteriores. Não são devolvidas referências para fontes/Resource. Valores devem ser int >=0, sem coerção de float/NaN/Inf/string/bool; totais devem caber no int64 positivo (limite técnico, não balanceamento). Validação de substituição/overflow ocorre antes da escrita. Definição nula, negativa ou com soma inválida gera componente inerte (is_valid=false, snapshot zero); não aceita fontes. Remover fonte ausente retorna false sem mutação.

Danos preservados: básico 16 sem item, 22 equipado; Giro 24 com ou sem item. Teste de combate real mede HP 20/14 após básico e HP 12/12 após Giro, contra o mesmo HP inicial 36; compara RNG, mana e cooldowns. Repetir equip cinco vezes mantém 22. Testes adicionais cobrem campos customizados em fixture isolada, Resource compartilhado, instâncias independentes, snapshot, substituição, remoção, overflow e reinício com Stats novo sem fontes antigas.

## Validação real

Godot 4.7.2.stable.official.ed1daf0bf, GUT 9.6.1, gdtoolkit 4.3.4. Comandos na raiz da worktree; godot representa Godot_v4.7.2-stable_win64_console.exe.

| Comando | Exit | Resultado real final |
| --- | --- | --- |
| godot --headless --path . --editor --import | 0 | Importação concluída, sem ERROR/WARNING/SCRIPT ERROR |
| gdlint core combat data ui world tests | 0 | Success: no problems found |
| godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit | 0 | Scripts 9; Tests 41; Passing Tests 40; Risky/Pending 1; Asserts 330; Time 0.827s |
| godot --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit | 0 | Scripts 9; Tests 41; Passing Tests 41; Asserts 335; Time 1.231s; All tests passed! |

Pending headless herdado: test_click_and_automap_use_enemy_health exige ponteiro nativo; passou graficamente. Dez testes novos passaram nos dois modos. Os 31 testes anteriores e a fixture arena_dff6ae1.json foram preservados, sem mudar expectativas: cinco checkpoints legados continuam iguais, incluindo HP, posições, XP/drops, custos/cooldowns e sequência RNG. Logs finais sem mensagens de erro/aviso; diff --check aprovado.

## Editor e limites

F5 → entrar; comparar básico antes/depois de recolher E e equipar F; repetir F sem crescimento adicional; usar Giro e conferir dano inalterado pelo equipamento; R deve restaurar básico sem bônus. Homologação manual/ergonomia continuam pendentes; execução gráfica foi automatizada. Health, UI, RNG, atributos, narrativa, README, addons e balanceamento de campanha intactos. Checkout original, .godot/ preexistente e worktrees anteriores preservados. Perguntas: nenhuma necessária para este recorte. Nenhum trabalho seguinte iniciado.
