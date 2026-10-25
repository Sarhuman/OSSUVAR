# OSSUVAR — Os Treze Sinos

> Você jurou guardar os mortos. Agora precisa descobrir quem os mantém presos.

Jogo de ação e exploração em **2D lateral com plataformas**, em Godot.
**Monster Boy and the Cursed Kingdom** é a referência de perspectiva, movimento
e legibilidade. OSSUVAR mantém mundo, personagens e narrativa próprios, com
fantasia sombria e HUD de barras horizontais.

**Estado:** protótipo lateral com ciclo completo no [PR #9](https://github.com/Sarhuman/OSSUVAR/pull/9),
em **draft, sem merge**. A validação manual no Editor está pendente.
A `main` contém documentação; o código jogável está na branch do PR.
A campanha completa e seus quatro desfechos continuam planejados.

## Implementado no protótipo e planejado para a campanha

| Frente | Estado e limite |
| --- | --- |
| Ciclo lateral do PR #9 | Tela inicial, movimento, salto, plataformas, esqueleto, chefe provisório, derrota, encerramento e nova partida |
| Combate lateral | Preparação, janela ativa, recuperação, dano único por alvo/ataque e bloqueio por obstáculos; valores provisórios |
| Componentes | Health, Stats ofensivos e contexto RNG existentes reutilizados; isso não conclui atributos, builds ou geração |
| Apresentação | Arte vetorial própria provisória, câmera e HUD horizontal; acabamento pendente |
| Narrativa | Cânone e novela documentados; missões, diálogos, alianças e quatro finais ainda não implementados |
| Progressão e conteúdo | Atributos completos, 12 skills, loot, inventário de campanha e mapas dependem de novos recortes e adaptação lateral |
| Persistência e distribuição | Sem save da campanha, áudio ou exportação Windows nesta entrega; lançador local não é executável exportado |
| Arena isométrica | Legado preservado nos PRs anteriores e na base do lateral; não é mais a direção dos novos cenários |

Estado do PR #9 conferido em **25/10/2026**, head
[`045c55a`](https://github.com/Sarhuman/OSSUVAR/commit/045c55a79cf7a8733b7d188d71e1fe1055353d36).
O encerramento do protótipo não representa um final da campanha nem acrescenta
um quinto desfecho. A sentinela é um chefe técnico provisório.

## Como jogar o protótipo lateral

Use a branch
[`codex/LATERAL-00-prototipo`](https://github.com/Sarhuman/OSSUVAR/tree/codex/LATERAL-00-prototipo)
no **Godot 4.7.2 Standard**, renderer **Compatibility**.

No Editor, abra `world/lateral/lateral.tscn` e pressione **F6**.
**F5 ainda abre a cena isométrica preservada**. Para executar por terminal,
na raiz do checkout da branch:

```sh
godot --path . res://world/lateral/lateral.tscn
```

O comando pressupõe o executável Godot disponível como `godot`; adapte o
caminho à instalação local. Não execute a partir da `main` documental.

| Controle | Ação |
| --- | --- |
| Iniciar / Enter | Começar; após o encerramento, jogar novamente |
| A/D ou setas | Andar |
| Espaço | Pular |
| J | Atacar no chão, na direção em que está olhando |
| R | Reiniciar com estado novo |

Atravesse as plataformas, enfrente o esqueleto e a sentinela e alcance a saída
após derrotar o chefe. Morrer permite começar outra partida.

## Validação e limites

O [relatório do PR #9](https://github.com/Sarhuman/OSSUVAR/blob/045c55a79cf7a8733b7d188d71e1fe1055353d36/docs/LATERAL00_RELATORIO.md)
registra **60/60 testes gráficos** e **59 aprovados + 1 pending legado**
no headless; importação e lint com exit 0. O percurso foi executado com input
sintético e física real. São resultados relatados pelo executor, não testes
reexecutados nesta atualização documental.

**Ainda falta validação humana no Editor:** sensação do salto, controle aéreo,
alcance visual, anúncio dos ataques, sobreposição, dificuldade e acabamento.
Os atores colidem com o mundo, mas podem se sobrepor entre si.
Sem navegação de plataformas da IA, knockback, salto variável, coyote time ou
transformações nesta prova. A referência Monster Boy não significa que todas
as mecânicas desse jogo foram adotadas.

## História

Por trezentos anos, Norvhal acreditou que os **Treze Sinos** de **Ossuvar**
conduziam os mortos ao descanso. Agora um **Décimo Quarto Sino** foi tocado,
os túmulos se abriram e algumas vozes repetem aquilo que ninguém quis ouvir.

Durante uma última vigília, chega uma carta de **Halric**, mestre do protagonista,
pedindo que ele vá à Cripta dos Pranteadores e desconfie da história oficial.
Você é um **Penitente da Ordem do Pó**. Buscar o mestre significa descobrir
para que seu juramento foi criado e o que os vivos escolheram esconder.

| Ato planejado | Região |
| --- | --- |
| I — Cinzas de Norvhal | Campos, bosque, Estrada dos Ossários, mosteiro e cripta |
| II — O Afogadouro | Ossário inundado, galerias e comportas sob a cidade |
| III — Os Dentes | Minas de ossos nas montanhas |
| IV — O Campanário | Cidade-catedral e seus níveis mais altos |

A **Vigília de Cal** reúne Dagna, Irmã Cael, Velho Tobbe e o Corvo Mudo.
As alianças influenciam quem chega ao final e como pode ajudar.
Nem todo morto encontrado é imediatamente hostil.

A pergunta central permanece: **os vivos têm o direito de decidir o que os
mortos devem esquecer?** Revelações e quatro desfechos alternativos ficam nos
documentos com aviso de spoilers. A mudança de perspectiva não muda o cânone.

## Direção e tecnologia

Godot **4.7.2 Standard**, GDScript tipado, **Compatibility**, exclusivamente 2D.
Movimento lateral, gravidade e plataformas substituem a projeção isométrica.
Tiles 64×32, oito direções e AStarGrid2D pertencem ao protótipo anterior;
não são requisitos dos novos cenários.

Preservar a separação entre apresentação/física e estado dos combatentes.
Reaproveitar Health, Stats e RNG sem duplicar autoridades.
Dimensões dos tiles laterais, geração, progressão, fórmulas e skills precisam
de contratos adequados à nova perspectiva.

Diablo II permanece referência anterior para atributos, builds e loot.
Project Diablo 2 e seus mapas ficam como pesquisa histórica de endgame,
a reavaliar se esse conteúdo voltar ao escopo. O objetivo imediato é consolidar
a experiência lateral; não presumir a implementação de dois jogos completos.

## Documentação

- [Direção lateral e critérios de validação](docs/DIRECAO_LATERAL.md).
- [Estado das branches e integração](docs/ESTADO_PROJETO.md).
- [Registro de decisões](docs/DECISOES.md).
- [História expandida](docs/NARRATIVA.md) — **contém spoilers completos**.
- [Novela adaptada ao cânone](docs/NOVELA_CANONICA.md) — **contém spoilers completos**.
- [Pacto e quatro desfechos](docs/PACTO_E_DESFECHOS.md) — **contém spoilers completos**.
- [Prólogo e missões do Ato I](docs/MISSOES_ATO_I.md) — **contém spoilers**.
- [Conciliação da novela](docs/INTEGRACAO_NOVELA.md).
- [Impacto narrativo v0.4](docs/IMPACTO_NARRATIVO_V04.md).
- [Documento Mestre v0.1](docs/DOCUMENTO_MESTRE.md) — histórico, **contém spoilers**; não define a perspectiva atual.

## Gestão e integração

**@Sarhuman** define prioridades e valida no Editor. **Claude** é a referência
de design e arquitetura; **Codex** executa recortes e relata resultados reais.
O PR #9 depende da cadeia técnica anterior e permanece em draft.
Atualização de documentos não integra código nem autoriza merges.

Próximo passo: validação manual do protótipo, correções delimitadas e revisão
de integração. Novos sistemas e arte final vêm por tarefas próprias.

## Licença

Licença do projeto a definir pelo responsável. A documentação não concede
licença aberta. Assets externos exigem condições compatíveis antes de inclusão.
OSSUVAR é independente, sem vínculo com os jogos usados como referência.
