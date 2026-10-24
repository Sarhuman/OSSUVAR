> **Contém spoilers da história.** Status: v0.1, proposta do Tech Lead. Itens não aprovados estão listados em DECISOES.md.

# Documento Mestre v0.1 — OSSUVAR

> **Contém spoilers da história.** Documento original de planejamento de 24/10/2026. As classificações de status e decisões posteriores são mantidas em [DECISOES.md](DECISOES.md), que prevalece em caso de divergência. As funcionalidades e tarefas descritas abaixo ainda são planejadas. O HUD foi definido como barras horizontais em F-04; a antiga D-01 ao final é um registro histórico.

O texto original é preservado integralmente abaixo.

```text
OSSUVAR — Documento Mestre
GDD + arquitetura técnica + backlog para o Codex · v0.1 · 24/10/2026 · Tech Lead e PO: Claude · Executor: Codex
1. Decisões fechadas
Tema
Decisão
Nome
OSSUVAR (subtítulo: Os Treze Sinos). Fiz duas buscas rápidas e não achei jogo com esse nome exato; o registro de marca é com você.
Engine
Godot 4.7.2, GDScript tipado, somente 2D. Proibido qualquer Node3D, malha ou asset 3D no repositório.
Visão
Isométrica 2:1 (tiles 64×32), estilo ARPG clássico, 8 direções.
Escopo do MVP
1 classe (Penitente), Ato I completo (acampamento, 4 áreas, 1 masmorra, 1 chefe), loot completo, 12 skills, 3 ciclos de dificuldade previstos na arquitetura.
Papéis
Claude decide design e arquitetura e homologa. Codex executa uma tarefa por vez, em PR draft, sem decidir design.
Arte
Placeholders (formas simples) até o marco M3. Arte final nunca bloqueia código.
Por que 2D resolve o problema do Codex
Cenas são texto (.tscn), a lógica roda em testes headless sem GPU e não existe pipeline de importação 3D (FBX, rig, materiais), que era onde ele se perdia.
2. Pitch e pilares
Pitch: Um sino tocou onde não devia. Agora os mortos de Ossuvar não descansam, e você é o último coveiro de uma ordem que já não existe.
Pilares de design, em ordem de prioridade:
1. Combate com peso. Toda ação tem duração, compromisso e recuperação. Chance de acertar, bloqueio e resistências importam.
2. Build importa. Pontos de atributo, árvore de skills com sinergias, equipamento que muda o estilo de jogo.
3. Loot é a recompensa. Raridades, afixos, sockets, itens únicos, palavras de sino (equivalente a runewords).
4. Mundo hostil e legível. Fantasia sombria, poucas palavras, lore contada por itens, chefes e ambientes.
5. Rejogabilidade. Áreas procedurais por semente, ciclos de dificuldade, chefes repetíveis.
3. História
Mundo
O reino de Norvhal foi erguido sobre o ossário de um deus que morreu antes dos homens. No centro dele fica Ossuvar, a cidade-catedral. Seus Treze Sinos eram tocados a cada morte para guiar os mortos ao descanso. Foi assim por trezentos anos.
Premissa
Irrik Vael, o Sineiro-Mor, perdeu a esposa e mandou fundir um Décimo Quarto Sino com ossos do deus sepultado. Ao tocá-lo, ela voltou. Os outros mortos também. Agora ninguém parte: os mortos sobem, a terra apodrece, e a cidade tocou o próprio fim.
Protagonista
O jogador é um Penitente, último jurado da Ordem do Pó, coveiros-guerreiros que enterravam e selavam os mortos inquietos. Seu mestre, Halric, desceu à Cripta dos Pranteadores para investigar o sino e voltou respondendo a ele. Você parte atrás de Halric e descobre, ato a ato, que o sino revela algo maior.
Estrutura em atos
Ato
Nome
Resumo
Chefe
I
Cinzas de Norvhal
Acampamento Vigília de Cal, Campos Calcinados, Bosque dos Enforcados, Mosteiro Sem Voz, Cripta dos Pranteadores.
Mãe Orwyn, a Pranteadora
II
O Afogadouro
Ossário inundado sob a cidade; maldições e afogados.
A definir
III
Os Dentes
Mina de ossos nas montanhas; construtos e ferreiros mortos.
A definir
IV
O Campanário
Subida final até o Décimo Quarto Sino.
Irrik Vael
Reviravolta e final (esboço, a detalhar no M4)
Os Treze Sinos nunca guiaram os mortos: eles prendiam o deus sepultado, e o Décimo Quarto o acordou. Final: silenciar todos os sinos (os mortos descansam, mas o deus desperta) ou tocar o último sino sob seu controle (o deus é contido, mas o Penitente passa a ser o Sineiro-Mor).
Personagens do acampamento (Ato I)
• Dagna, ferreira de cabeça raspada que conserta e vende armas.
• Irmã Cael, curandeira que perdeu a fé e vende poções.
• Velho Tobbe, mercador e jogador de dados (itens misteriosos).
• O Corvo Mudo, guardião do baú compartilhado e dos Marcos de Cal (waypoints).
Bestiário do Ato I
Esqueleto Calcinado (corpo a corpo), Enforcado (rápido, frágil), Cão-de-Cinza (ataca em bando), Carpideiro (conjurador que cura aliados), Sacristão (invocador).
4. Combate: especificação mecânica
O objetivo é a sensação do ARPG clássico de referência. Copiamos mecânicas (que não são protegidas), não nomes, texto ou arte.
4.1 Controles
• Botão esquerdo: mover, atacar ou usar a skill esquerda. Shift: atacar parado.
• Botão direito: skill direita. Troca rápida de skills por teclas.
• Teclas 1 a 4: poções do cinto. Tab: automapa. I, C, S: inventário, atributos, skills.
• Segurar o botão continua andando ou atacando.
4.2 Recursos e atributos
• Vida, Mana e Vigor (Vigor gasto ao correr).
• Atributos: Força, Destreza, Vitalidade, Energia. Cada nível dá 5 pontos de atributo e 1 ponto de skill.
• Vitalidade aumenta Vida e Vigor; Energia aumenta Mana; Força e Destreza exigem equipamento e afetam dano, defesa e bloqueio.
4.3 Fórmulas (implementadas em CombatMath, funções puras e testadas)
• Chance de acertar = clamp( 2 × AR / (AR + DEF) × NívelAtacante / (NívelAtacante + NívelAlvo), 5%, 95% ).
• Dano = sorteio(min, max) × (1 + %dano) + dano fixo. Golpe Mortal causa o dobro; Golpe Esmagador remove uma fração da vida atual do alvo (não vale contra chefes).
• Resistências: Fogo, Gelo, Raio e Peste, com limite de 75%. Dano físico usa defesa e redução percentual. Ciclo II aplica −40 e o Ciclo III aplica −100 às resistências do jogador.
• Bloqueio: só com escudo e fora de estados de recuperação. Chance = base do escudo × (Destreza − 15) / (nível × 2), com limite de 75%.
• Velocidade de ação (ataque, conjuração, recuperação de acerto): eficaz = floor(120 × bônus / (120 + bônus)) e frames = max(4, ceil(base_frames × 100 / (100 + eficaz))). Isso gera os "breakpoints" de velocidade; a tabela de cada arma fica em dados.
• Recuperação de acerto: ao ser atingido, a entidade entra em estado de recuperação por N frames; monstros também.
• Tick de combate fixo a 25 Hz, desacoplado da renderização, para as durações em frames serem determinísticas.
4.4 Monstros e chefes
• Monstros comuns em bandos com 1 líder. Raros (Campeão, Único) ganham afixos sorteados: Rápido, Encantado de Fogo, Aura Gélida, Teleportador, Vampírico.
• Chefes têm fases e telegraph claro (aviso visual antes do golpe), e podem ser repetidos.
4.5 Itens e loot
• Raridades: Normal, Mágico (1 a 2 afixos), Raro (3 a 6), Único e Conjunto.
• Sockets recebem Selos (gemas). Combinações em ordem exata formam Palavras de Sino (equivalente a runewords).
• Chance de loot raro modificada por Fortuna (equivalente a magic find). Itens têm nível, requisitos de força/destreza e durabilidade.
• Inventário em grade; baú compartilhado fica para o M4.
4.6 Penitente: 12 skills do MVP
Aba
Skills
Ferro (ataque)
Golpe Contundente, Giro Ceifador (área), Investida do Penitente, Estilhaçar
Cal (defesa e auras)
Escudo de Cal, Aura de Resolução, Postura Inabalável (passiva), Grito Funerário (enfraquece)
Cinza (fogo e maldições)
Chama do Réquiem (projétil), Marca da Cinza (maldição), Pira (área), Sopro de Cinzas (passiva)
Cada skill é um SkillData (.tres) com custo, alvo, animação, efeito e sinergias. Nenhum efeito é hardcoded em cena.
4.7 Mundo e progressão
• Áreas procedurais por semente (salas e corredores via BSP) com salas especiais fixas.
• Marcos de Cal (waypoints) e Fresta (portal de retorno ao acampamento).
• 3 Ciclos de dificuldade, com mais vida, dano, resistências e melhor loot.
5. Arquitetura técnica (contrato com o Codex)
5.1 Stack
• Godot 4.7.2, renderer Compatibility (2D, máxima compatibilidade com hardware modesto).
• GDScript com tipagem estática em todo o código. Formatação e lint com gdtoolkit.
• Testes com GUT, executados em modo headless. CI no GitHub Actions rodando os testes a cada PR.
• Meta numérica de FPS só depois de um benchmark no M1.
5.2 Estrutura de pastas
res://
  core/        # autoloads: EventBus, GameState, SaveService, DataRegistry, Rng
  combat/      # CombatMath, components, hitbox/hurtbox, damage pipeline
  entities/    # player/, monsters/, npcs/
  items/       # data, affixes, generator, inventory
  skills/      # SkillData, SkillCaster, effects
  world/       # maps, generator, tiles, minimap, waypoints
  ui/          # hud, inventory, skill tree, menus
  data/        # .tres: items, affixes, skills, monsters, loot tables, zones
  tests/       # GUT
  docs/        # decisões e relatórios
5.3 Regras de arquitetura
1. Lógica pura separada de cenas. Fórmulas e geradores são scripts sem Node (class_name, funções estáticas) e totalmente testáveis. Cenas só montam e conectam.
2. Composição por componentes: HealthComponent, StatsComponent, HurtboxComponent, HitboxComponent, SkillCaster, StateMachine. Estados do jogador e dos monstros: idle, move, attack, cast, hit_recovery, dead.
3. Dados em Resource (.tres): ItemBase, Affix, SkillData, MonsterData, LootTable, ZoneData. Nada de números de balanceamento no código.
4. Comunicação por sinais e EventBus. Proibido get_node("../..") entre cenas distintas.
5. Isometria: tiles 64×32 em TileMapLayer com Y-sort. Lógica de movimento em um único módulo IsoMath (conversões grade, mundo e tela). Pathfinding com AStarGrid2D sobre o grid lógico gerado.
6. Determinismo: um Rng central com semente por run e por zona; testes usam sementes fixas.
7. Save em JSON com save_version e função de migração por versão.
8. Pooling para projéteis, números de dano e efeitos.
6. Regras de trabalho do Codex (para ele não se perder)
1. Uma tarefa = um PR pequeno (alvo de até ~400 linhas), branch codex/T-XXX, PR em draft, sem merge automático.
2. Toda tarefa tem: Contexto, Escopo, Fora de escopo, Arquivos permitidos, Critérios de aceite, Testes, Entrega. O que não está em Escopo não se faz.
3. Proibido: 3D, trocar arquitetura, adicionar addons ou dependências sem aprovação, refatorar fora do escopo.
4. Alterações em .tscn e .tres devem ser mínimas e legíveis; nunca regenerar uma cena inteira para mudar um nó.
5. Rodar os testes headless e colar a saída real. Se não conseguiu rodar algo, dizer exatamente o quê, sem declarar sucesso.
6. Dúvida de design = escrever em "Perguntas" no PR e parar naquele ponto; nunca inventar regra.
7. Relatório final padrão: arquivos modificados, testes executados, o que depende de validação no Editor.
8. Homologação: você roda no Godot e aprova; só então libero a próxima tarefa dependente.
7. Roadmap e marcos
Marco
Entrega
Critério de pronto
M0 Fundação
Projeto, CI, CombatMath testado
Testes verdes no CI; projeto abre sem erros
M1 Combate core
Arena: andar, atacar, morrer, subir de nível
Você luta contra bandos e a sensação de peso é aprovada; benchmark feito
M2 Loot
Itens, afixos, inventário, equipar
Drops funcionam e alteram atributos de verdade
M3 Skills
Árvore do Penitente com 12 skills
Todas as skills em dados, cooldown e mana corretos; arte placeholder substituída pela primeira arte real
M4 Ato I
Mapas procedurais, acampamento, NPCs, chefe, save
Ato I jogável do começo ao fim
M5 Polimento
Ciclos II e III, Ato II, balanceamento
A definir após M4
8. Backlog dos Sprints 0 e 1
Sprint 0 (Fundação): T-001 e T-002. Sprint 1 (primeiro encontro jogável, marco G1): T-003 a T-007. Portão G1: você abre a cena de arena, clica no esqueleto, luta, ele morre e você ganha XP.
ID
Tarefa
Depende de
Critério de aceite resumido
T-001
Bootstrap do projeto
nenhuma
Projeto abre, estrutura de pastas, autoloads vazios, InputMap, GUT e CI rodando, README
T-002
CombatMath puro + testes
T-001
Chance de acertar, dano, resistência, bloqueio e frames com testes cobrindo bordas e limites
T-003
Jogador + click-to-move + câmera
T-001
Clicar no chão move o jogador por AStarGrid2D; 8 direções; câmera segue
T-004
Mapa isométrico de teste
T-003
TileMapLayer 64×32 com tiles placeholder, Y-sort correto, obstáculos bloqueiam caminho
T-005
Componentes de combate
T-002
Health, Stats, Hurtbox e Hitbox com sinais e testes
T-006
Ataque básico do jogador
T-003, T-005
Clicar em monstro: aproximar, atacar, usar chance de acertar e frames de ataque
T-007
Esqueleto Calcinado
T-004, T-005
IA idle, aggro, perseguir, atacar, morrer, carregada de MonsterData
T-008
HUD mínimo
T-005
Vida, Mana, Vigor, XP e cinto de poções ligados aos componentes
T-009
Recuperação de acerto, morte e XP
T-006, T-007
Estados corretos, XP concedido, level up com pontos de atributo
T-010
Sistema de skills + Giro Ceifador
T-009
SkillData + SkillCaster, botão direito, custo de mana
T-011
Loot v0 e inventário em grade
T-009
Item cai, é pego, ocupa a grade, pode ser equipado
T-012
Save/Load versionado v0
T-011
Personagem e inventário persistem; arquivo traz save_version
Prompt pronto da T-001 (entregar ao Codex)
Você é o executor desta tarefa. Não tome decisões de design nem de arquitetura.

PROJETO: OSSUVAR, ARPG 2D isométrico (tiles 64x32) em Godot 4.7.2, GDScript tipado.
REGRA ABSOLUTA: nada de 3D (sem Node3D, malhas ou assets 3D).

TAREFA T-001: Bootstrap do projeto.

ESCOPO
1. Criar project.godot (renderer Compatibility, janela 1280x720, stretch canvas_items).
2. Criar a estrutura de pastas: core, combat, entities (player, monsters, npcs), items, skills, world, ui, data, tests, docs.
3. Criar autoloads VAZIOS e tipados: EventBus, GameState, SaveService, DataRegistry, Rng (somente esqueleto: class_name, comentário de propósito, sem lógica).
4. Configurar o InputMap: move_click (botão esquerdo), skill_right (botão direito), stand_attack (Shift), potion_1..4 (teclas 1-4), open_inventory (I), open_character (C), open_skills (S), toggle_map (Tab).
5. Instalar o addon GUT em addons/gut e criar um teste de fumaça em tests/ que passa.
6. Criar scene principal res://main.tscn (Node2D vazio com um Label "OSSUVAR") definida como cena inicial.
7. Adicionar .gitignore para Godot 4, .gdlintrc, README.md (como abrir, como rodar testes) e docs/ARCHITECTURE.md copiando as regras da seção 5 do Documento Mestre.
8. Criar workflow GitHub Actions que roda os testes GUT em modo headless e o gdlint.

FORA DE ESCOPO
Qualquer gameplay, sprite, cena de jogador, mapa, UI ou fórmula.

ENTREGA
- Branch codex/T-001, PR em DRAFT, sem merge.
- Relatório: arquivos criados, saída REAL do teste GUT e do gdlint, e o que precisa ser validado abrindo o projeto no Editor.
- Dúvidas vão na seção "Perguntas" do PR. Não invente nada que não esteja acima.

CRITÉRIOS DE ACEITE
- O projeto abre no Godot 4.7.2 sem erros ou avisos de importação.
- Teste de fumaça passa em modo headless.
- Nenhum arquivo fora das pastas descritas, exceto raiz do repositório e addons/gut.
9. Decisões abertas para o PO
- **D-01 (fechada em 24/10/2026)**: o HUD usa barras horizontais de Vida, Mana e Vigor, mais a barra de XP. O HUD fica isolado em ui/hud.
• D-02: Aprovar o nome OSSUVAR e a premissa da história.
• D-03: Autorização formal para iniciar a T-001. Até lá, nenhum código é pedido ao Codex.
```
