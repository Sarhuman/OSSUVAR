# P02-A — Health dos inimigos

Base de código: dff6ae1; contrato: 3210b26; main consultada: 7ccf335. Referências não haviam avançado no início. Branch codex/P-02A-health-inimigos; sem merges. Checkout original e .godot/ preexistente preservados; trabalho em worktree separada.

## Alterações e fronteira

HealthComponent (RefCounted) é dono exclusivo de HP/máximo; morto é derivado de HP=0. Result tipado informa accepted, damage_applied, antes/depois, máximos e died_now. Dano/cura aceitam finitos >=0; máximo exige finito >0. Dano excessivo satura em zero; cura satura no máximo sem overflow. Alterar máximo conserva HP absoluto/clamp; nunca revive. Inicialização inválida nasce inerte (HP=0, máximo seguro=1), sem armazenar NaN/Inf. Zero é no-op aceito em vivo, sem sinal changed.

ArenaRun consome EnemyHit uma única vez antes de chamar Health, inclusive para impactos não letais. O token representa um impacto em um alvo; criar outro token representa outro impacto. Não há cache/ledger global, histórico crescente ou deduplicação por tick. Repetir o mesmo token é rejeitado; a transição died_now do componente é a única condição para kills/XP/drop. Health não deduplica comandos por ID: a fronteira de replay é ArenaRun/EnemyHit; rede/save estão fora do escopo.

Inimigos mantêm demais campos em Dictionary, sem chave hp. ArenaView lê Health. Ampliação autorizada pelo usuário: exclusivamente a leitura de seleção por clique em core/prototype.gd e a leitura de vivos no automapa em ui/arena_hud.gd. Sem outra refatoração nesses arquivos; jogador, Stats, RNG, números e addons intactos.

## Validação real

Godot 4.7.2.stable.official.ed1daf0bf; GUT 9.6.1; gdtoolkit 4.3.4. Comandos na raiz desta worktree (godot = executável console Windows):

| Comando | Exit | Resultado real final |
| --- | --- | --- |
| godot --headless --path . --editor --import | 0 | Sem linhas ERROR/WARNING/SCRIPT ERROR no log final |
| gdlint core combat data ui world tests | 0 | Success: no problems found |
| godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit | 0 | Scripts 6; Tests 24; Passing Tests 23; Risky/Pending 1; Asserts 158; Time 0.574s |
| godot --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit | 0 | Scripts 6; Tests 24; Passing Tests 24; Asserts 163; Time 1.023s; All tests passed! |

O teste de clique/automapa é pendente somente em headless, cujo ponteiro não respondeu à injeção; passou com display gráfico Windows/Compatibility (AMD Radeon RX 580 2048SP), inclusive sinal draw. As 16 regressões anteriores permanecem, adaptando apenas acesso/fixture de HP. Novas verificações cobrem zero, negativos, NaN/Inf, excesso, cura, máximo, morte única, replay não letal/letal e ausência de ressurreição.

Fixture tests/fixtures/arena_dff6ae1.json capturada executando a mesma sequência capture_trace em extração temporária de dff6ae1, usando somente o accessor antigo enemy.hp no capturador; exit 0, BASELINE_TRACE_POINTS=5. A regressão nova compara os cinco snapshots completos: posições, vida, mana/vigor, nível/XP/kills, poções, cooldowns, inventário/equipamento/drops e state RNG. Custos/dano/seed e cura de level-up legados não foram migrados para propostas P01.

## Editor e limites

F5 → entrar; selecionar esqueleto vivo por clique; causar dano e observar barra; matar e confirmar uma recompensa/drop; abrir Tab e confirmar ausência do morto; I/F, poção, pausa e R. A regressão gráfica foi automatizada; sensação de combate e homologação manual pelo responsável continuam pendentes. P02-B, Health do jogador, Stats e RNG não iniciados. Perguntas: nenhuma decisão adicional necessária para este recorte.
