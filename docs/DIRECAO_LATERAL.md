# Direção lateral de OSSUVAR

Decisão do responsável em 25/10/2026: **visão lateral com plataformas**,
com Monster Boy and the Cursed Kingdom como referência. Esta orientação
substitui a perspectiva isométrica dos documentos e protótipos anteriores.

## Estado concreto

**Protótipo lateral com ciclo completo; validação manual no Editor pendente.**
O código está no [PR #9](https://github.com/Sarhuman/OSSUVAR/pull/9),
branch `codex/LATERAL-00-prototipo`, head
`045c55a79cf7a8733b7d188d71e1fe1055353d36`, em draft e sem merge.
A base é `codex/P-02D-rng-streams`,
`d7b867fcb13a7ad2c8b45a2d1563706aff9aa016`.

O ciclo inclui início, movimento, salto, plataformas, esqueleto, chefe técnico,
derrota, encerramento e nova partida. A sentinela não integra automaticamente
o elenco da campanha. O encerramento não é um quinto final.

## O que preservar e o que recontratar

| Tema | Direção |
| --- | --- |
| História e regiões | Preservar cânone, novela, quatro atos e quatro finais; perspectiva não altera identidades e motivações |
| Health, Stats e RNG | Reutilizados pelo lateral; não duplicar HP/dano nem alterar interfaces por causa da câmera |
| Física e apresentação | CharacterBody2D, gravidade, salto, câmera lateral e colisões com o mundo na prova |
| HUD | Barras horizontais preservadas; não afirmar que todos os recursos planejados já funcionam |
| Isometria | 64×32, oito direções, Y-sort e AStarGrid2D ficam como legado, sem obrigação de migração para os novos mapas |
| Atributos, loot e skills | Planejados; adaptar alcances, efeitos, números e interação com plataformas por contratos próprios |
| Mapas | Percurso fixo do protótipo; geração procedural, tamanhos de tiles laterais e layouts da campanha ainda não aprovados |
| Arte | Vetores próprios provisórios; FreeKnight, Lords of Pain e Meshy não são dependências da prova |
| Endgame | Pesquisa anterior, não compromisso de reproduzir agora o sistema de mapas de Diablo II/Project Diablo 2 |
| Transformações e navegação | Monster Boy é referência, não autorização automática de transformações, pulo duplo ou IA de plataformas |

ARTE-00/ARTE-01A permanecem testes externos da fase isométrica.
A escala da lápide e a direção de render não são padrões para assets laterais.
A mudança pode reduzir produção direcional de sprites; não é uma estimativa
comprovada de economia total ou dispensa de revisão dos mapas e do combate.

## Evidência técnica e seu alcance

O [relatório versionado](https://github.com/Sarhuman/OSSUVAR/blob/045c55a79cf7a8733b7d188d71e1fe1055353d36/docs/LATERAL00_RELATORIO.md)
registra importação e lint com exit 0, GUT gráfico **60/60** e headless
**59 aprovados + 1 pending legado de ponteiro nativo**, com 686 e 681 asserts,
respectivamente. Também descreve percurso com input sintético e física real.

As correções de oponentes removidos, obstrução de golpes e janela ACTIVE em
passos grandes têm código e testes específicos no PR. A cobertura temporal
de ataque não equivale a varredura contínua de hitbox em deltas arbitrários.
Esses resultados foram consultados no relatório, não reexecutados nesta
revisão documental. O GIF e os logs locais não foram visualizados aqui.

## Roteiro de validação manual

Na branch do PR, abrir `world/lateral/lateral.tscn` e usar F6;
F5 conserva a cena inicial isométrica. Alternativa: na raiz do checkout,
`godot --path . res://world/lateral/lateral.tscn`.

1. Iniciar pelo menu e conferir que ações não acontecem antes do início.
2. Andar e saltar por todas as plataformas; avaliar resposta, aterrissagem,
   controle aéreo e câmera nos limites.
3. Atacar dos dois lados, próximo de obstáculos e nos limites visuais;
   conferir anúncio, acerto e recuperação.
4. Enfrentar esqueleto e sentinela; avaliar dificuldade e sobreposição dos
   corpos. Colisão entre combatentes não está implementada.
5. Tentar a saída antes/depois de vencer; conferir encerramento.
6. Morrer, reiniciar e jogar novamente; conferir vida e estado novos.

Registrar observado, resultado esperado e problemas reproduzíveis.
Homologação depende da observação humana do responsável, não apenas de testes.

## Fora da entrega e integração

Sem campanha jogável, quatro finais executáveis, inventário/loot completos,
árvore de skills, save, áudio, exportação Windows ou arte final.
O lançador CMD local executa Godot instalado e não é build exportada.

Main permanece documental. A arena anterior, fixtures e checkpoints são
preservados na cadeia técnica. Não mesclar, rebasear, encerrar ou trocar a
base de PRs como efeito desta decisão documental. Integração exige seu recorte
e conciliação dos READMEs antigos sem perder o cânone atual.
