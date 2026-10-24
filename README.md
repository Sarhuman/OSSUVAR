# OSSUVAR — Os Treze Sinos

> Um sino tocou onde não devia. Agora os mortos de Ossuvar não descansam, e você é o último coveiro de uma ordem que já não existe.

ARPG de fantasia sombria em **2D isométrico**, com **Diablo II como referência
central de experiência** e Project Diablo 2 como referência adicional para mapas
de endgame. OSSUVAR terá mundo, personagens, narrativa e assets próprios.

**Estado:** pré-produção com documentação na `main` e um protótipo experimental
em branch separada. A campanha completa ainda é planejada. PRs e testes locais
não significam integração ou homologação no Editor.

## Estado do projeto

| Frente | Estado e localização |
| --- | --- |
| Página principal e narrativa | Documentação nesta branch; versão editorial v0.2, revisão do Claude pendente |
| Proposta documental original | [PR #1](https://github.com/Sarhuman/OSSUVAR/pull/1); conciliar com a documentação atual antes de integrar |
| Bootstrap Godot, GUT e CI | [PR #2](https://github.com/Sarhuman/OSSUVAR/pull/2), em revisão |
| Arena experimental | [PR #3](https://github.com/Sarhuman/OSSUVAR/pull/3), baseado na branch do PR #2 |
| Ato I, catálogo de skills, loot completo e save | Planejados; a arena não conclui esses sistemas |
| Executável Windows distribuído | Ainda não entregue |

Status conferido em 24/10/2026. Consulte os PRs para mudanças posteriores.
Esta atualização altera somente documentação e não integra o código dos PRs.

## O jogo

Exploração de áreas conectadas, combate com compromisso, atributos que importam,
árvores de habilidades com sinergias e equipamentos que mudam a build. Mapas
procedurais e desafios repetíveis sustentam a progressão, com um mundo sombrio
cuja história aparece em ambientes, itens e encontros.

Os mapas da campanha e os mapas de endgame são frentes diferentes. A campanha
constrói a jornada por Norvhal; o endgame acrescentará instâncias modificadas,
tiers e objetivos próprios depois de suas regras serem definidas.

## História

O reino de **Norvhal** cresceu ao redor de **Ossuvar**, a cidade-catedral. Por
trezentos anos, seus **Treze Sinos** acompanharam os funerais e a promessa de
descanso. Então um **Décimo Quarto Sino** foi fundido e tocado. Os mortos
começaram a responder, e as estradas deixaram de levar a lugares seguros.

Você é um **Penitente**, último jurado vivo da **Ordem do Pó**, formada por
coveiros-guerreiros que enterravam e selavam os mortos inquietos. As últimas
notícias de seu mestre, **Halric**, levam à Cripta dos Pranteadores. Procurá-lo
significa descobrir o que sua ordem protegeu e o que escolheu esconder.

| Ato planejado | Região |
| --- | --- |
| I — Cinzas de Norvhal | Arredores da cidade, bosque, rota dos ossários, mosteiro e cripta |
| II — O Afogadouro | Ossário inundado sob a cidade |
| III — Os Dentes | Minas de ossos nas montanhas |
| IV — O Campanário | A cidade-catedral e seus níveis mais altos |

O acampamento **Vigília de Cal** reúne Dagna, Irmã Cael, Velho Tobbe e o Corvo
Mudo. Cada sobrevivente oferece um modo diferente de enfrentar o que restou.
Revelações, chefes posteriores e finais ficam nos documentos com aviso de spoilers.

## Pilares de design

1. **Combate com peso:** duração, compromisso, recuperação e leitura dos ataques.
2. **Build importa:** atributos, skills, sinergias e equipamento têm efeito real.
3. **Loot como recompensa:** raridades, afixos, sockets, únicos e conjuntos.
4. **Mundo hostil e legível:** atmosfera sem esconder perigos e objetivos essenciais.
5. **Rejogabilidade:** seeds, ciclos de dificuldade e conteúdo repetível.

## Escopo planejado do primeiro recorte completo

- Uma classe, o **Penitente**, com **12 skills** nas árvores Ferro, Cal e Cinza.
- **Um hub + quatro áreas hostis + uma masmorra + um chefe principal** no Ato I.
- Áreas: Campos Calcinados, Bosque dos Enforcados, **Estrada dos Ossários** e
  Mosteiro Sem Voz; masmorra: Cripta dos Pranteadores. A estrada completa a
  contagem na revisão narrativa v0.2, ainda sujeita à revisão editorial.
- Força, Destreza, Vitalidade e Energia; Vida, Mana, Vigor e XP com **barras horizontais**.
- Itens, inventário em grade, equipamento, afixos, Selos e Palavras de Sino.
- Geração por seed, Marcos de Cal, Fresta, progressão e save versionado.
- Três ciclos previstos na arquitetura; mapas de endgame como expansão posterior.

Esses itens são planejamento, não uma lista de funcionalidades concluídas.
Níveis, dimensões de mapas, fórmulas finais e parâmetros das skills dependem dos
contratos de gameplay; a revisão da história não define esses números.

## Tecnologia e arquitetura

Godot **4.7.2 Standard**, GDScript tipado, renderer **Compatibility**, isometria
2:1, tiles **64×32** e oito direções. Projeto exclusivamente 2D.

Diretrizes: lógica pura separada de cenas, composição por componentes, dados em
Resources, sinais/EventBus, RNG por run/zona, geração testável e save validado e
versionado. Testes com GUT e lint com gdtoolkit. Metas de desempenho dependem
de benchmark; o protótipo ainda não substitui a arquitetura final.

## Como experimentar o protótipo

A `main` contém documentação; importe o projeto da branch
[`codex/prototipo-vigilia`](https://github.com/Sarhuman/OSSUVAR/tree/codex/prototipo-vigilia)
no **Godot 4.7.2**, pressione **F5** e selecione **Entrar na Vigília**.
As instruções e os comandos de teste estão no README daquela branch.

A arena contém movimento por clique, dez esqueletos, Giro Ceifador, poções,
XP, loot demonstrativo, inventário simples e HUD horizontal. Usa cenário e
personagens provisórios; não contém a campanha completa nem o pipeline final
de combate. Nenhum executável é distribuído por esta atualização documental.

## Documentação

- [Estado das branches e integração](docs/ESTADO_PROJETO.md).
- [Registro de decisões](docs/DECISOES.md).
- [Documento Mestre v0.1](docs/DOCUMENTO_MESTRE.md) — histórico de design, arquitetura e backlog; **contém spoilers**.
- [Bíblia narrativa v0.2](docs/NARRATIVA.md) — regras do mundo, personagens, atos e finais; **contém spoilers completos**.
- [Missões do Ato I](docs/MISSOES_ATO_I.md) — objetivos, pistas e critérios narrativos; **contém spoilers do Ato I**.

## Gestão e próximos passos

**@Sarhuman** define prioridades, aprova decisões e valida no Editor. **Claude**
é a referência de design e arquitetura. O **Codex executor** implementa tarefas
delimitadas e reporta testes reais. Revisões editoriais não são homologações
de gameplay. Trabalho de história e trabalho de código avançam em frentes separadas.

Próximos passos: conciliar os PRs com a documentação atual, preservar o fluxo da
arena e evoluir componentes, atributos, skills, loot e zonas por tarefas pequenas.
Não usar o merge de documentação como autorização implícita para mesclar código.

## Licença e contribuições

Licença a definir pelo responsável; não há concessão de licença aberta nesta
página. O fluxo de contribuições externas ainda não está definido. OSSUVAR é
um projeto independente, sem vínculo com Diablo II ou Project Diablo 2.
