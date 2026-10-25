# LATERAL-00 — prova lateral isolada

Entrega de 25/10/2026, para revisão em PR draft. Implementação provisória;
não representa migração completa, balanceamento aprovado ou homologação humana.

## Base e isolamento

- Branch: `codex/LATERAL-00-prototipo`.
- Base local/remota conferida duas vezes: `codex/P-02D-rng-streams`,
  `d7b867fcb13a7ad2c8b45a2d1563706aff9aa016`. Não avançou.
- Worktree Git separada: `C:/Users/Sarumano/Music/OSSUVAR-LATERAL00`.
- Main consultada: `e4fa19767d145e3023d161797a8eff6c8246470b`.
  Lidos README, decisões, estado, narrativa v0.4 e conciliação v0.4.1/pacto.
  Nenhum AGENTS.md encontrado no repositório/ancestrais consultados.
- Checkout original preservado em `codex/docs-historia-informacoes`,
  `7f65da6937a2096c958bcee82c19e1ef3057a12f`, com `.godot/` preexistente.
  Não houve reset, rebase ou merge. Outros worktrees foram preservados.
- A instrução explícita LATERAL-00 substitui a perspectiva somente nesta prova.
  Documentação antiga, narrativa e cena inicial da arena não foram reescritas.
  Odran, Maera, Edrin, Lysa e os quatro finais permanecem como na main;
  esta cena não implementa campanha ou outro roteiro.

## Executar e validar no Editor

Cena própria: `res://world/lateral/lateral.tscn`. Comando exato:

```powershell
& 'C:\Users\Sarumano\Music\godot-4.7.2\Godot_v4.7.2-stable_win64_console.exe' --path 'C:\Users\Sarumano\Music\OSSUVAR-LATERAL00' res://world/lateral/lateral.tscn
```

No Editor, abrir esse worktree, selecionar a cena lateral e usar F6.
**F5 continua abrindo a cena inicial isométrica preservada.**

1. A/D ou setas: andar; Espaço: pular. Soltar o direcional no ar interrompe
   o deslocamento horizontal. Sem pulo duplo, coyote time ou salto variável.
2. Saltar sobre a primeira plataforma; andar por sua parte inferior para
   conferir colisão unidirecional. Cair e aterrissar devem manter apoio nos pés.
3. J no chão: preparação, acerto e recuperação. O movimento fica comprometido
   durante o ataque. O esqueleto anuncia a preparação com marcador âmbar.
4. Enfrentar o esqueleto, testar morte do jogador e tentar andar/pular/atacar
   morto. R cria outra sessão; não cura ou ressuscita o Health anterior.
5. Colidir com o bloco, saltá-lo e atravessar a plataforma sobre o vão.
   Queda abaixo da área mata; R recomeça. Não há respawn automático.
6. Alcançar a porta sinalizada. A câmera acompanha horizontalmente e limita
   a área; a saída apresenta conclusão e permite R. Não exige matar o inimigo.

## Reaproveitamento e arquivos

| Arquivo novo | Responsabilidade |
| --- | --- |
| `data/lateral_rules.gd` | Resource com parâmetros provisórios e adapter mínimo para ArenaRules exigido pelo Stats existente |
| `combat/lateral_fighter.gd` | Fases de ataque e ledger por execução; chama Health.damage usando snapshot de Stats |
| `core/lateral_session.gd` | Instâncias independentes de Health/Stats e contexto criado pelo autoload Rng existente |
| `world/lateral/lateral_actor.gd` | CharacterBody2D, controles, gravidade, colisões, IA curta, alcance e desenho próprio |
| `world/lateral/lateral_stage.gd` | Percurso, plataformas, câmera, HUD horizontal, saída e substituição da sessão no reinício |
| `world/lateral/lateral.tscn` | Entrada independente da prova |
| `tests/test_lateral.gd` | Seis testes focados de combate, morte, salto/aterrissagem e reinício |
| `tests/lateral_playthrough.gd` | Percurso com input sintético/física real e capturas externas opcionais |
| `docs/LATERAL00_RELATORIO.md` | Este relatório |

Incluídos também os `.gd.uid` correspondentes. Não se alteraram HealthComponent,
StatsComponent, RngService/RngContext, ArenaRun, recursos da arena, InputMap,
project.godot, fixtures, checkpoints, testes anteriores ou addons. Metadados
`.import` regenerados localmente foram restaurados; não fazem parte do diff.

Health é a única autoridade de vida/morte de cada combatente. Stats é a única
autoridade de dano derivado. Seu construtor exige ArenaRules: o adapter fornece
somente dano básico e bônus de Giro zero, sem criar Stats alternativo nem copiar
ArenaRun. O contexto RNG pertence à sessão e não é retido globalmente; não há
sorteios na cena, pois mapa, comportamento e dano desta prova não os exigem.

O ledger fica no ataque, não em Health: identifica alvos por instance_id,
rejeita impactos repetidos e é limpo ao encerrar/cancelar a execução. Não mantém
referências fortes aos alvos nem histórico crescente entre ataques. Alvos fora
de alcance/altura/direção não chegam a Health. A morte cancela o ataque atual;
ações e controle horizontal são bloqueados. Gravidade/queda continuam físicas.
R substitui sessão, atores, Health, Stats e contexto; referências antigas nos
testes continuam mortas/inalteradas. Sem método de ressurreição.

## Parâmetros provisórios

Centralizados em LateralRules, sem reutilizar alcance/dimensões isométricas:

| Parâmetro | Valor de inspeção |
| --- | --- |
| Velocidade jogador / inimigo | 230 / 95 px/s |
| Gravidade / impulso de salto | 1400 px/s² / -560 px/s |
| Cápsula física | 22×48 px; origem nos pés |
| Vida jogador / inimigo | 100 / 48 |
| Dano básico jogador / inimigo | 16 / 12, consultados por Stats |
| Alcance jogador / inimigo; tolerância vertical | 58 / 46 px; 34 px |
| Preparação jogador / inimigo | 0,16 / 0,55 s |
| Janela ativa | 0,10 s |
| Recuperação jogador / inimigo | 0,24 / 0,60 s |
| Aproximação; patrulha inicial | 320 px; X=450–590 |
| Limite de queda; seed do contexto | Y>810; 1314 |

Esses números tornam o teste curto e legível: três acertos derrotam o inimigo;
o anúncio mais longo permite observar a resposta. O salto tem altura balística
nominal de 112 px e duração ao mesmo nível de 0,8 s, cobrindo aproximadamente
184 px em velocidade máxima. Foram construídas plataformas compatíveis com
isso, sem transportar geometria isométrica. Não são contratos de campanha.

Geometria explícita em lateral_stage.gd: área 2400×720, chão em Y=620,
bloco de 70×60 e plataformas unidirecionais. Vão X=900–1170 com apoio
X=940–1090/Y=545; mais plataformas para inspeção. Sem navegação de plataformas
para a IA, invulnerabilidade, combos, inventário ou sistema de recompensas.

## FreeKnight e arte provisória

Inspecionado `C:/Users/Sarumano/Downloads/FreeKnight_v1.zip`, sem modificá-lo.
Não contém arquivo de licença/readme; há folhas PNG e GIFs de duas cores,
com/sem outline. Nenhum arquivo do ZIP foi colocado na árvore de código.

Inspeção de Colour1/Outline, células fixas 120×80:

| Animação disponível | Folha | Frames |
| --- | --- | --- |
| Idle / Run | 1200×80 cada | 10 / 10 |
| Jump / Fall | 360×80 cada | 3 / 3 |
| AttackNoMovement | 480×80 | 4 |
| DeathNoMovement | 1200×80 | 10 |

Idle ocupa X=44–64/Y=42–79 com alfa ≥128: 21×38 px, não 120×80.
O apoio visual fica aproximadamente em (55,80), deslocado do centro do canvas.
Run muda poses dentro do canvas; o ataque estende-se até X=105. Uma eventual
adaptação precisaria manter célula/origem fixa e validar flip nesse apoio,
sem recentralizar frames. O pivô é estimativa de inspeção, não metadado autoral.

Na [página oficial](https://aamatniekss.itch.io/fantasy-knight-free-pixelart-animated-character),
consultada em 25/10/2026, há permissões para projetos e restrição a “AI creations”.
Há também resposta autorizando repositório de projeto com crédito/link, mas
isso não esclarece a condição de IA para este trabalho. Não se presumiu licença
suficiente para uso aqui. FreeKnight não é usado nem mesmo como dependência
local da cena; permissão explícita do autor seria necessária para reavaliar.

Jogador, esqueleto e ambiente são desenhos vetoriais provisórios próprios.
Não foram traçados ou derivados do FreeKnight/Monster Boy. O Lords of Pain
isométrico não foi usado. Monster Boy orienta a intenção de movimento/legibilidade,
não uma alegação de acabamento equivalente. Sem imagens geradas, compras,
Meshy, fontes/executáveis de ZIP ou dependência de pacotes externos.

## Comandos e resultados reais

Executados no worktree com Godot Standard **4.7.2.stable.official.ed1daf0bf**,
Compatibility/OpenGL na AMD Radeon RX 580 2048SP; GUT **9.6.1** e gdlint **4.3.4**.
Nos comandos abaixo, `godot` representa o executável absoluto mostrado acima;
`gdlint` está em `C:/Users/Sarumano/Music/ossuvar-tools/Scripts/gdlint.exe`.

| Comando | Exit | Resultado real final |
| --- | --- | --- |
| `godot --headless --path . --editor --import` | 0 | Importação concluída, sem ERROR/WARNING/SCRIPT ERROR |
| `gdlint data/lateral_rules.gd combat/lateral_fighter.gd core/lateral_session.gd world/lateral tests/test_lateral.gd tests/lateral_playthrough.gd` | 0 | `Success: no problems found` |
| `godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit` | 0 | 11 scripts; 55 testes; 54 passando; 1 pending; 630 asserts; 2,661 s |
| `godot --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit` | 0 | 11 scripts; 55/55 passando; 635 asserts; 3,193 s; `All tests passed!` |
| `godot --path . res://world/lateral/lateral.tscn --quit-after 90` | 0 | Cena própria abre com display, sem erros |
| `godot --path . --script res://tests/lateral_playthrough.gd -- --evidence=C:/Users/Sarumano/Music/OSSUVAR-LATERAL00-EVIDENCIAS/playthrough-approved` | 0 | Percurso concluído; 94 capturas, saída e reinício verificados |

O pending headless é o teste **herdado** de ponteiro nativo em
`test_enemy_health.gd`. Duas execuções gráficas intermediárias falharam na
linha 63 desse mesmo teste (`target=-1`, esperado 0); houve também execução
anterior com 55/55. A última execução voltou a passar 55/55, sem alterar ou
enfraquecer qualquer teste legado. Isso evidencia instabilidade ambiental;
foco/ponteiro é hipótese, não causa demonstrada. Conferir clique/automapa da
arena no Editor. Logs de falha e resultado final foram preservados externamente.

Os seis testes novos passaram em todos os runs da suíte: dano uma vez por
execução, novo ataque independente, preparação/recuperação sem acerto,
dano consultando Stats, morte/cancelamento sem repetição, cura sem ressurreição,
entrada bloqueada após morte, reinício independente de vida/Stats/RNG, salto
somente no chão, aterrissagem e descarte do ledger. Fixture e cinco checkpoints
legados, inclusive RNG state, passaram sem alteração de expectativas.

O driver gráfico usa input sintético com física real, sem teleporte/remoção
de colisões para completar o trajeto. Mantém o movimento solicitado quando o
SO libera teclas por mudança de foco; força render antes das capturas para não
aguardar indefinidamente um frame de janela ocluída. Tentativas anteriores do
driver expiraram/falharam; o registro final acima é o percurso concluído com
logs sem erros, não resultado inferido de uma execução parcial.

```text
LATERAL_PLAYTHROUGH_OK: esquerda/direita, salto, duas plataformas, aterrissagens,
obstaculo solido, 3 ataques, esqueleto morto, camera limitada, saida e R.
CAPTURES=94; input sintetico / fisica real; nao homologacao manual.
```

## Evidências e limites visuais

Pasta externa: `C:/Users/Sarumano/Music/OSSUVAR-LATERAL00-EVIDENCIAS/`.
Logs: import.log, lint.log, gut_headless.log, gut_graphical.log,
gut_graphical_pointer_failure.log, scene_launch.log e playthrough_approved.log.

Capturas 1280×720 em `playthrough-approved/`: `01_inicio.png`, `02_salto.png`,
`03_plataforma.png`, `04_combate_0.png` a `04_combate_2.png`,
`05_obstaculo_solido.png`, `06_plataforma_sobre_vao.png`, `07_saida.png`.
O sufixo de pasta identifica o run técnico final, não homologação do responsável.
`LATERAL00_percurso.gif`: 1280×720, 16,57 s, 94 imagens de origem codificadas
em 77 quadros após combinação dos idênticos. Duração por frames físicos/60 Hz,
arredondada a 10 ms; paleta reduzida a 256 cores. Sem instalar ferramentas.

Inspeção visual do executor: capturas reais de início, salto, aterrissagem,
anúncio de ataque, combate, bloco, plataforma sobre o vão, câmera deslocada e
saída. HUD corrigido após a primeira captura. O roteiro verifica movimento,
colisões e conclusão automaticamente; não é controle humano nem substitui
observação contínua no Editor. Ajuste fino de sensação, animação, colisão e
acabamento continua pendente do responsável. Não se declara equivalência ao
movimento/acabamento de Monster Boy nem aprovação estética das silhuetas.

## Perguntas / revisão necessária

- Validar sensação do salto, controle aéreo, legibilidade e compromisso do ataque
  no Editor antes de autorizar migração maior.
- Se FreeKnight for desejado, esclarecer a condição de IA com o autor;
  a cena entregue funciona integralmente sem ele.
- Reproduzir o teste de clique/automapa nativo da arena devido à oscilação
  registrada; ele não foi descartado ou marcado pending no display gráfico.

Nenhum sistema de campanha, inventário, skills, geração procedural, save,
áudio ou exportação Windows foi iniciado. Nenhum PR foi mesclado.
