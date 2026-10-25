# P02-D — Contextos RNG por partida e stream

Base conferida: codex/P-02C-stats-ofensivos em d4a1d10dbe4ae99cd9b24b8fba83a18fb559a4c6, sem avanço antes da edição. Contrato T3 lido em 3210b26; main de coordenação 667dc96 consultada sem copiar documentação sobre o código. Branch codex/P-02D-rng-streams em worktree isolada; checkout original/.godot preexistente e worktrees anteriores preservados. Sem merges ou homologação manual presumida.

## Interfaces, propriedade e limites

RngService.create_context(run_id, seed_value, generation=1, version=1, profile=versioned_v1) retorna RngContext ou null para entrada inválida. O autoload Rng existente é somente fábrica, sem registro de partidas, referências fortes, contador ou reset global. RngContext é RefCounted; possui seu cache de geradores e não referencia ArenaRun/serviço. Libera-se quando os donos o soltam (teste com WeakRef). run_id() é metadado, não entra na seed; ArenaRun usa ID local da instância para distinguir partidas, sem promessa de persistência.

context.stream(zone_id, stream_name) retorna o mesmo RandomNumberGenerator canônico já avançado na reconsulta, ou null para entrada inválida. Zonas distintas e streams world/combat/loot têm objetos separados, sem compartilhar estado entre contextos. A cache pertence somente ao contexto e não retém outras partidas. Nomes de stream são case-sensitive e limitados a world/combat/loot. IDs de zona/run aceitam String/StringName com 1–128 bytes ASCII visíveis (33–126); isso valida sintaxe, não implementa catálogo de zonas. Seeds são inteiros em 0..2^63−1; versões inteiras positivas em 1..2^63−1. Float, bool, string numérica e não finitos não são convertidos silenciosamente.

RngSeed.derive(run_seed, zone_id, generator_version, rng_version, stream_name) retorna int >=0 ou -1 para rejeição. Serializa cada campo em decimal canônico/texto UTF-8, precedido do comprimento em bytes e dois-pontos, terminado por vírgula; concatena na ordem T3, sem espaços extras. SHA-256; usa os primeiros oito bytes big-endian. O primeiro byte sofre &0x7f antes de qualquer shift, logo a construção nunca precisa representar um valor assinado de 64 bits com o bit superior ligado. Não usa hash() do runtime.

arena_legacy_v1 fornece seed direta rules.seed_value ao combat (inclusive customizações/extremos), não uma constante 1314. World/loot continuam derivados por T3. ArenaRun possui rng_context e run.rng é referência ao MESMO gerador combat; assert explícito rejeita configuração de arena com seed fora do contrato. Não há sorteio novo no mapa fixo/drop determinístico. Reinício cria outro contexto; a partida anterior referenciada continua avançada e intacta. Não há save/load nem promessa de sequência idêntica em versões diferentes da engine; reprodução dos geradores foi verificada somente no Godot 4.7.2.

Arquivos: core/rng.gd, core/rng/{seed_derivation,rng_context}.gd/.uid, adaptação mínima em core/arena_run.gd; tests/test_rng_streams.gd/.uid, tests/rng_seed_reference.py e tests/fixtures/rng_t3_vectors.json; este relatório. Health, Stats, UI, dados, narrativa, README, addons, testes/fixture legados não alterados.

## Vetores fixos independentes

Python 3.12.14, hashlib.sha256, int.from_bytes(..., big) & ((1<<63)-1). Executado python tests/rng_seed_reference.py, exit 0; referência reproduziu 7/7 linhas da fixture. Nenhuma expectativa foi gerada pela função GDScript sob teste. Valores numéricos na fixture JSON são strings decimais para preservar int64.

| Tupla (seed, zona, generator_version, rng_version, stream) | Seed derivada |
| --- | --- |
| 0, arena, 1, 1, combat | 6567023524373212735 |
| 1314, arena, 1, 1, combat | 6959293208357955664 |
| 1314, arena, 1, 1, loot | 396782420844484323 |
| 1314, arena, 1, 1, world | 5901436575425267977 |
| 9223372036854775807, act1_fields, 1, 1, combat | 8834454756463446666 |
| 1, zone:a,1, 2, 3, world | 2359939523170281349 |
| 123456789, act1_fields, 9223372036854775807, 9223372036854775807, loot | 4936700960168145176 |

## Verificações reais

Godot 4.7.2.stable.official.ed1daf0bf, GUT 9.6.1, gdtoolkit 4.3.4. Comandos na raiz da worktree; godot representa Godot_v4.7.2-stable_win64_console.exe.

| Comando | Exit | Saída real final |
| --- | --- | --- |
| godot --headless --path . --editor --import | 0 | Importação concluída, sem ERROR/WARNING/SCRIPT ERROR |
| gdlint core combat data ui world tests | 0 | Success: no problems found |
| godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit | 0 | Scripts 10; Tests 49; Passing Tests 48; Risky/Pending 1; Asserts 577; Time 0.803s |
| godot --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit | 0 | Scripts 10; Tests 49; Passing Tests 49; Asserts 582; Time 1.306s; All tests passed! |

O pending headless herdado exige ponteiro nativo (clique/automapa); passou graficamente. Oito testes novos passaram em ambos os modos. Cobrem vetores, extremos válidos/inválidos, versões e run_id, reconsulta sem reset, 100 sorteios de loot/world sem alterar combate, partidas simultâneas, seeds diretas customizadas em ArenaRun, liberação do contexto e reinício preservando partida anterior. Logs finais sem erros/avisos; diff --check aprovado. Os 41 testes anteriores e os cinco checkpoints da fixture arena_dff6ae1.json permanecem intactos, inclusive state RNG, danos, custos/cooldowns, XP e drops.

## Editor e pendências

F5 → entrar; executar combate, skill, poção e coleta, depois R e repetir a seed; clique/automapa continuam disponíveis. No depurador, duas runs devem ter contextos/geradores distintos, e reconsulta do stream deve preservar sua state. A execução gráfica automatizada não é homologação manual de combate. Nenhuma tarefa de mapas, atributos, loot aleatório, RNG cosmético ou persistência iniciada. Perguntas: nenhuma necessária para este recorte.
