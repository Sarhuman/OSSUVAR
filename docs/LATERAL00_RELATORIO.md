# OSSUVAR — MVP lateral jogável

Atualizado em 25/10/2026. O responsável ampliou explicitamente LATERAL-00 para
**MVP lateral completo: início, percurso, combate, chefe e final, com arte provisória**.
Esta entrega fecha esse ciclo curto; a campanha dos quatro atos/quatro finais
continua fora deste MVP. Resumo de transferência solicitado será entregue no chat.

## Base, branch e preservação

- PR #9, mantido draft, sem merge; branch `codex/LATERAL-00-prototipo`.
- Base confirmada: `d7b867fcb13a7ad2c8b45a2d1563706aff9aa016`,
  `codex/P-02D-rng-streams`. Não avançou.
- Primeira entrega do PR: `6a4054ab9091259dc13e6096ad3bba5f74bc68e1`.
  A continuação acrescenta o MVP e corrige os três pontos da revisão.
- Main consultada, ainda atual na conferência final:
  `e4fa19767d145e3023d161797a8eff6c8246470b`.
- Worktree isolada: `C:/Users/Sarumano/Music/OSSUVAR-LATERAL00`.
- Checkout original preservado em `codex/docs-historia-informacoes`,
  `7f65da6937a2096c958bcee82c19e1ef3057a12f`, com `.godot/` preexistente.
- Nenhum reset, rebase ou merge. Nenhum AGENTS.md encontrado nos caminhos
  consultados. README/decisões/estado/narrativa/pacto da main foram consultados
  sem copiá-los sobre a árvore de código.
- Preservados Odran, Maera, Edrin, Lysa e os quatro finais. A sentinela deste
  percurso é um chefe técnico provisório, não um personagem canônico novo.
  O encerramento é o do MVP, não um quinto desfecho da campanha.

## Jogar

Godot **4.7.2 Standard**, Compatibility, GDScript tipado, exclusivamente 2D.
Cena própria: `res://world/lateral/lateral.tscn`.

```powershell
& 'C:\Users\Sarumano\Music\godot-4.7.2\Godot_v4.7.2-stable_win64_console.exe' --path 'C:\Users\Sarumano\Music\OSSUVAR-LATERAL00' res://world/lateral/lateral.tscn
```

No Editor: abrir o worktree, selecionar a cena lateral e usar F6. F5 continua
abrindo a cena inicial isométrica preservada. Há também um lançador local externo
`C:/Users/Sarumano/Music/OSSUVAR-LATERAL00-EVIDENCIAS/JOGAR_OSSUVAR_MVP.cmd`;
ele apenas executa o Godot instalado, não é exportação Windows.

1. Clicar **Iniciar** ou Enter. O menu inicial bloqueia as ações do personagem.
2. A/D/setas: andar; Espaço: pular; J: atacar no chão; R: voltar ao início com
   estado novo. A direção do ataque é a direção em que o personagem está olhando.
3. Percorrer plataformas, superar o bloco e atravessar o apoio sobre o vão.
4. Enfrentar o esqueleto e a sentinela maior, com preparação anunciada em âmbar.
5. Derrotar a sentinela e alcançar a porta. A saída muda de fechada para aberta;
   há tela de conclusão e botão/Enter para jogar novamente.
6. Morrer mostra a tela de derrota. Jogar novamente cria outra sessão; não cura
   nem ressuscita o componente morto anterior. Quedas fora da área também matam.

## Arquivos e reaproveitamento

| Arquivo | Responsabilidade |
| --- | --- |
| `data/lateral_rules.gd` | Parâmetros provisórios e adapter ArenaRules para o Stats existente |
| `combat/lateral_fighter.gd` | Health/Stats, fases, resolução temporal do ataque e ledger por execução |
| `core/lateral_session.gd` | Jogador/esqueleto/chefe independentes e contexto RNG próprio |
| `world/lateral/lateral_actor.gd` | CharacterBody2D, gravidade, pulo, controles, IA, obstrução e desenho próprio |
| `world/lateral/lateral_stage.gd` | Percurso, menu, HUD horizontal, câmera, chefe, derrota, saída e encerramento |
| `world/lateral/lateral.tscn` | Cena de entrada independente |
| `tests/test_lateral.gd` | Seis testes originais da prova; os testes físicos entram agora pelo menu/início |
| `tests/test_lateral_mvp.gd` | Cinco regressões novas para revisão e ciclo do MVP |
| `tests/lateral_playthrough.gd` | Roteiro gráfico reproduzível, física real e input sintético |
| `docs/LATERAL00_RELATORIO.md` | Este relatório atualizado |

Incluídos os UIDs correspondentes. HealthComponent, StatsComponent, RngService,
RngContext, ArenaRun, project.godot, main.tscn, addons e testes/fixtures legados
permanecem idênticos à base. Não foi copiado ArenaRun. Metadados `.import`
gerados localmente são restaurados antes do commit.

Health continua sendo a única autoridade de vida/morte; dano vem de
`StatsComponent.snapshot().basic_damage`. Cada combatente tem seus componentes;
nenhum HP paralelo no ator/HUD. Stats exige ArenaRules, portanto o adapter
fornece dano básico e bônus de Giro zero. Não há implementação alternativa
nem mudança da interface dos componentes reaproveitados.

Cada sessão recebe contexto do autoload Rng existente, sem registro crescente
ou reset global. A cena não precisa de sorteios; não foram introduzidos. R e
jogar novamente substituem sessão/atores/Health/Stats/contexto. Referências antigas
retidas nos testes preservam seus estados, incluindo morte e RNG state.

## Três pontos da revisão — corrigidos e testados

**Oponente removido:** o adapter verifica `is_instance_valid`, presença na árvore
 e exclusão enfileirada antes de consultar o oponente. A cena filtra referências
válidas antes de formar arrays tipados; o teste inclui remoção, free e mais frames
com a referência antiga. Sem acesso a nó liberado.

**Obstrução:** antes de oferecer o alvo ao ataque, verifica direção, alcance,
altura e um raycast entre os pontos de ataque, na camada de colisão do mundo.
Paredes/bloco impedem a chamada a `try_hit`. Os atores usam camada distinta e não
obstruem esse raycast. Testado nos dois sentidos com o bloco entre os atores e
alcance artificialmente suficiente: não há dano nem entrada no ledger; remover
geometricamente a obstrução durante a janela permite um único acerto.

**Janela ACTIVE:** `advance(delta, target)` detecta se o intervalo temporal do
passo atravessa ACTIVE, resolve `try_hit` antes de encerrar/limpar a execução e
então atualiza a fase. Não depende de o instante final cair em ACTIVE. O alvo é
selecionado pela geometria do passo; não há oportunidade guardada para acertar
muito depois de uma parede desaparecer. Passos 1/60, 0,1, 0,3, 0,5 e 1 segundo
produzem exatamente um dano; morte e janela bloqueada não geram acerto tardio.
Isso não é varredura contínua de hitbox ou física garantida para delta de 1 s:
a cobertura grande é do relógio do ataque, com geometria amostrada no passo.

O ledger continua fora de Health, limitado à execução e identificado por
instance_id. É descartado ao encerrar/cancelar; não duplica histórico global.
Preparação/recuperação, morte, novo ataque e dois alvos continuam cobertos.

## Parâmetros provisórios e limites

Centralizados em LateralRules; todos são valores do MVP, não balanceamento da campanha.

| Parâmetro | Jogador / esqueleto / chefe |
| --- | --- |
| Vida | 100 / 48 / 128 |
| Dano | 16 / 12 / 18 |
| Alcance | 58 / 46 / 76 px |
| Preparação | 0,16 / 0,55 / 0,75 s |
| Recuperação | 0,24 / 0,60 / 0,80 s |
| Janela ativa | 0,10 s |
| Cápsula | 22×48 px / 22×48 px / 48×88 px |

Velocidade jogador 230 px/s, inimigos 95 px/s; gravidade 1400 px/s²,
impulso -560 px/s, tolerância vertical de acerto 34 px, aproximação 320 px,
patrulha inicial X=450–590, queda letal Y>810. Salto nominal de 112 px de altura,
0,8 s ao mesmo nível e alcance de cerca de 184 px. Seed de contexto 1314.
Três acertos derrotam o esqueleto, oito derrotam o chefe. Os valores maiores
 e a preparação mais lenta tornam o chefe distinguível para avaliar o ciclo.

Área 2400×720, chão em Y=620, bloco de 70×60 e plataformas unidirecionais;
a câmera acompanha horizontalmente e respeita os limites. Menu, derrota,
conclusão, HUD e barras são separados do estado dos combatentes.

Colisão dos atores com o mundo; os combatentes podem se sobrepor entre si.
Sem knockback, navegação de plataformas da IA, pulo duplo, coyote time, salto
variável, transformação, escalada, árvore de habilidades, inventário novo,
loot, campanha completa, geração procedural, save, áudio ou exportação.
Esses limites são visíveis e não se apresentam como equivalência ao acabamento
ou ao movimento completo de Monster Boy and the Cursed Kingdom.

## Arte e licença

Arte vetorial própria e provisória, sem traçar ou copiar personagens/cenários
de referência. FreeKnight e Lords of Pain não são dependências da cena.
Nenhuma chamada Meshy, compra, geração de imagem ou instalação de ferramenta.

`C:/Users/Sarumano/Downloads/FreeKnight_v1.zip` foi inspecionado e preservado:
folhas 120×80 por célula, Idle/Run 10 frames cada, Jump/Fall 3 cada,
AttackNoMovement 4 e DeathNoMovement 10. Idle relevante ocupa 21×38 px;
pivô de apoio estimado perto de (55,80), deslocado do centro do canvas.
O ataque alcança X=105. Não seriam corretos recortes/recentragens por frame.

O ZIP não inclui licença. A [página oficial](https://aamatniekss.itch.io/fantasy-knight-free-pixelart-animated-character)
foi lida em 25/10/2026: a condição relativa a “AI creations” não foi esclarecida
para este uso. Nenhum asset do pacote foi usado/publicado, nem fontes ou
executáveis de ZIP. Uma eventual autorização do autor seria revisão separada.

## Validação real

Godot Standard **4.7.2.stable.official.ed1daf0bf**, Compatibility/OpenGL na
AMD Radeon RX 580 2048SP; GUT **9.6.1**; gdlint **4.3.4**.
Nos comandos, `godot` é o executável absoluto mostrado na seção Jogar;
`gdlint` está em `C:/Users/Sarumano/Music/ossuvar-tools/Scripts/gdlint.exe`.
Comandos executados na raiz do worktree:

| Comando | Exit | Saída real final |
| --- | --- | --- |
| `godot --headless --path . --editor --import` | 0 | Importação concluída sem ERROR/WARNING/SCRIPT ERROR |
| `gdlint data/lateral_rules.gd combat/lateral_fighter.gd core/lateral_session.gd world/lateral tests/test_lateral.gd tests/test_lateral_mvp.gd tests/lateral_playthrough.gd` | 0 | Success: no problems found |
| `godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit` | 0 | 12 scripts, 60 testes, 59 passando, 1 pending, 681 asserts, 2,908 s |
| `godot --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit` | 0 | 12 scripts, 60/60 passando, 686 asserts, 3,6 s; All tests passed! |
| `godot --path . --script res://tests/lateral_playthrough.gd -- --evidence=C:/Users/Sarumano/Music/OSSUVAR-LATERAL00-EVIDENCIAS/mvp-definitivo` | 0 | Percurso completo, três golpes no esqueleto, oito no chefe, vitória, derrota/retry separados e reinício novo; 110 frames capturados |

O pending headless é o teste legado de ponteiro nativo em test_enemy_health.gd.
Na entrega anterior houve oscilação gráfica nesse teste, preservada nos logs;
esta rodada final passou 60/60. Não foi removida ou enfraquecida sua verificação.
Os cinco checkpoints legados, incluindo RNG state, continuam passando intactos.

Os 11 testes laterais cobrem: dano único por ataque, Stats como fonte de dano,
preparação/recuperação, morte/cancelamento sem repetição, entrada bloqueada,
salto/aterrissagem, reinício independente, ledger limitado, nós removidos,
parede nos dois sentidos, passos grandes, ausência de acerto tardio, menu,
chefe como condição da saída e nova partida após conclusão.

## Evidências, inspeção e pendências

Pasta externa `C:/Users/Sarumano/Music/OSSUVAR-LATERAL00-EVIDENCIAS/`:

- Logs finais: mvp_import.log, mvp_lint.log, mvp_headless.log,
  mvp_graphical.log e mvp_playthrough_final.log.
- `mvp-definitivo/00_menu.png`, `01_inicio.png`, `02_salto.png`,
  `03_plataforma.png`, `04_combate_*.png`, `05_obstaculo_solido.png`,
  `06_plataforma_sobre_vao.png`, `07_chefe_*.png`, `08_chefe_derrotado.png`
  e `09_encerramento.png`: viewport real 1280×720.
- `OSSUVAR_MVP_lateral.gif`: 23,41 s, 1280×720, 930196 bytes;
  110 capturas mais abertura/encerramento mantidos, codificados em 97 quadros.
  Duração pelos frames físicos/60 Hz, arredondada para 10 ms. Paleta de 256 cores;
  PNGs são a referência de cor. `mvp_gif_result.json` contém a releitura do GIF.
- `10_derrota_forcada.png` e `11_jogar_novamente.png`: prova separada da UI,
  depois de vencer. Somente nessa prova a morte é acionada diretamente por
  Health.damage para inspecionar a tela/retry. Não integra o GIF do percurso;
  não foi usada para derrotar inimigos, aumentar dano ou completar o jogo.

Input do roteiro é sintético, com física real, sem teleporte ou remoção de
colisões para vencer. O script posiciona-se usando os controles, espera a
recuperação e verifica dano exato de 16 por golpe. Restaura movimento sintético
quando o SO muda o foco e força render antes de salvar capturas. Tentativas
anteriores do roteiro falharam; a execução final acima concluiu sem erros.

Foram inspecionadas visualmente as capturas de início, combate, chefe,
encerramento e derrota, além das plataformas/colisões. Isso é inspeção das
imagens renderizadas; o roteiro automatizado não é homologação humana.
Ainda validar no Editor sensação de movimento, controle aéreo, anúncio,
alcance visual, sobreposição dos atores, dificuldade e acabamento da arte.

## Resumo para continuidade

MVP funcional fechado no escopo aprovado. Revisar primeiro os arquivos Fighter,
Rules, Actor, testes e este relatório no PR #9. Conservar os componentes da base
 e a arena. Qualquer expansão para quatro atos, quatro finais, sistemas de
progressão ou assets finais exige seu recorte próprio. Nenhum merge foi feito.
