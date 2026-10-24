# OSSUVAR — Os Treze Sinos

> Um sino tocou onde não devia. Agora os mortos de Ossuvar não descansam, e você é o último coveiro de uma ordem que já não existe.

ARPG de fantasia sombria, inteiramente **2D**, com visão isométrica 2:1, combate com peso, progressão de personagem e loot como recompensa.

**Estado:** planejamento inicial. As funcionalidades abaixo representam o escopo previsto, não entregas implementadas.

## História

O reino de **Norvhal** foi erguido sobre o ossário de um deus que morreu antes dos homens. No centro dele fica **Ossuvar**, a cidade-catedral. Seus **Treze Sinos** eram tocados a cada morte para guiar os mortos ao descanso. Foi assim por trezentos anos.

**Irrik Vael**, o Sineiro-Mor, perdeu a esposa e mandou fundir um **Décimo Quarto Sino** com ossos do deus sepultado. Ao tocá-lo, ela voltou. Os outros mortos também. Agora ninguém parte: os mortos sobem, a terra apodrece, e a cidade tocou o próprio fim.

O jogador é um **Penitente**, último jurado da **Ordem do Pó**, formada por coveiros-guerreiros que enterravam e selavam os mortos inquietos. Seu mestre, **Halric**, desceu à **Cripta dos Pranteadores** para investigar o sino e voltou respondendo a ele. Você parte atrás de Halric e descobre, ato a ato, que o sino revela algo maior.

### Atos planejados

| Ato | Nome | Ambientação | Chefe |
| --- | --- | --- | --- |
| I | Cinzas de Norvhal | Vigília de Cal, Campos Calcinados, Bosque dos Enforcados, Mosteiro Sem Voz e Cripta dos Pranteadores | Mãe Orwyn, a Pranteadora |
| II | O Afogadouro | Ossário inundado sob a cidade; maldições e afogados | A definir |
| III | Os Dentes | Mina de ossos nas montanhas; construtos e ferreiros mortos | A definir |
| IV | O Campanário | Subida final até o Décimo Quarto Sino | Irrik Vael |

<details>
<summary>Spoilers — reviravolta e finais em esboço</summary>

Os Treze Sinos nunca guiaram os mortos: eles prendiam o deus sepultado, e o Décimo Quarto o acordou.

O final prevê duas escolhas: silenciar todos os sinos, permitindo que os mortos descansem, mas despertando o deus; ou tocar o último sino sob seu controle, contendo o deus e transformando o Penitente no novo Sineiro-Mor.

Este esboço será detalhado no marco M4.

</details>

### Personagens do acampamento

- **Dagna:** ferreira de cabeça raspada que conserta e vende armas.
- **Irmã Cael:** curandeira que perdeu a fé e vende poções.
- **Velho Tobbe:** mercador e jogador de dados que oferece itens misteriosos.
- **O Corvo Mudo:** guardião do baú compartilhado e dos Marcos de Cal.

### Bestiário do Ato I

Esqueleto Calcinado (corpo a corpo), Enforcado (rápido e frágil), Cão-de-Cinza (ataca em bando), Carpideiro (conjurador que cura aliados) e Sacristão (invocador).

## Pilares de design

1. **Combate com peso:** duração, compromisso e recuperação em cada ação; chance de acertar, bloqueio e resistências relevantes.
2. **Build importa:** atributos, árvore de skills com sinergias e equipamentos que alteram o estilo de jogo.
3. **Loot é a recompensa:** raridades, afixos, sockets, itens únicos e Palavras de Sino.
4. **Mundo hostil e legível:** poucas palavras; história transmitida por itens, chefes e ambientes.
5. **Rejogabilidade:** áreas procedurais por semente, ciclos de dificuldade e chefes repetíveis.

## Escopo previsto

O MVP contempla uma classe, o **Penitente**, o **Ato I completo**, loot completo e **12 skills**. A arquitetura prevê três ciclos de dificuldade.

| Árvore do Penitente | Skills |
| --- | --- |
| Ferro — ataque | Golpe Contundente, Giro Ceifador, Investida do Penitente, Estilhaçar |
| Cal — defesa e auras | Escudo de Cal, Aura de Resolução, Postura Inabalável, Grito Funerário |
| Cinza — fogo e maldições | Chama do Réquiem, Marca da Cinza, Pira, Sopro de Cinzas |

- **Recursos:** Vida, Mana e Vigor.
- **Atributos:** Força, Destreza, Vitalidade e Energia; cada nível concede cinco pontos de atributo e um ponto de skill.
- **Itens:** Normal, Mágico, Raro, Único e Conjunto; afixos, requisitos, durabilidade e sockets para Selos. Combinações ordenadas formam Palavras de Sino.
- **Inventário:** grade de itens; baú compartilhado previsto para M4.
- **Mundo:** geração por semente com salas especiais fixas, Marcos de Cal e Fresta para retorno ao acampamento.
- **Combate:** tick fixo a 25 Hz, recuperação de acerto e chefes com fases e aviso visual antes dos golpes.

### Controles planejados para PC

| Entrada | Ação |
| --- | --- |
| Botão esquerdo | Mover, atacar ou usar a skill esquerda |
| Shift | Atacar parado |
| Botão direito | Skill direita |
| Teclas 1–4 | Poções do cinto |
| Tab | Automapa |
| I / C / S | Inventário / atributos / skills |

## Diretrizes técnicas

Conforme o documento mestre, a stack definida é **Godot 4.7.2**, renderer **Compatibility** e **GDScript tipado**. O projeto é exclusivamente 2D, com tiles **64×32**, oito direções e nenhuma cena ou asset 3D.

A arquitetura prevê lógica pura separada de cenas, composição por componentes, dados em Resources, comunicação por sinais e EventBus, IsoMath para conversões isométricas, AStarGrid2D para caminhos, RNG central com sementes e save JSON versionado.

Testes headless com **GUT**, lint e formatação com **gdtoolkit** e CI no GitHub Actions estão previstos. Placeholders serão usados até M3; metas numéricas de desempenho dependem do benchmark em M1.

## Marcos planejados

| Marco | Entrega | Critério de conclusão |
| --- | --- | --- |
| M0 — Fundação | Projeto, CI e CombatMath testado | Testes verdes no CI; projeto abre sem erros |
| M1 — Combate core | Arena: andar, atacar, morrer e subir de nível | Combate aprovado em jogo e benchmark realizado |
| M2 — Loot | Itens, afixos, inventário e equipamentos | Drops funcionam e alteram atributos |
| M3 — Skills | As 12 skills do Penitente e primeira arte real | Skills em dados, custos e cooldowns corretos |
| M4 — Ato I | Mapas, acampamento, NPCs, chefe e save | Ato I jogável do começo ao fim |
| M5 — Polimento | Ciclos II e III, Ato II e balanceamento | A definir após M4 |

## Gestão e documentação

**Claude é o Tech Lead e Product Owner:** gerencia o projeto, decide design e arquitetura e homologa as entregas. **Codex atua como executor de tarefas explicitamente delimitadas**, uma por vez, em PR draft e sem merge automático. A validação prática ocorre no Editor pelo responsável pelo projeto.

O [Documento Mestre v0.1](docs/DOCUMENTO_MESTRE.txt), de 24/10/2026, preserva o material recebido: história, fórmulas, arquitetura, regras de trabalho, backlog T-001 a T-012 e decisões abertas. Sua inclusão é documental; não inicia o bootstrap T-001.

As decisões registradas como abertas no documento — HUD, aprovação formal do nome e premissa, e início da T-001 — permanecem sob gestão do Claude e aprovação do responsável pelo projeto.
