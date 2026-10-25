# Estado do projeto e coordenação das branches

Snapshot dos PRs conferido em 25/10/2026. Este texto não substitui os metadados atuais
dos PRs e não presume que outras sessões pararam de trabalhar.

## Separação de frentes

| Frente | Conteúdo | Efeito desta atualização |
| --- | --- | --- |
| main | Apresentação, decisões, cânone v0.4 e novela adaptada v0.4.1 | Somente arquivos Markdown adicionados/atualizados |
| PR #1 / codex/docs-historia-informacoes | Proposta documental anterior | Preservada; conciliar ou retirar mudanças superadas antes de eventual merge |
| PR #2 / codex/T-001 | Bootstrap e testes | Nenhum arquivo, commit ou configuração alterado por esta frente |
| PR #3 / codex/prototipo-vigilia | Arena experimental sobre codex/T-001 | Nenhum arquivo, commit ou configuração alterado por esta frente |
| PR #4 / codex/P-01-contratos-gameplay | Propostas de gameplay escritas sobre a v0.2 | Preservadas na branch; pontos narrativos precisam de conciliação, sem invalidar Health/Stats/RNG |
| PR #5 / codex/P-02A-health-inimigos | Health dos inimigos, sobre o PR #3 | Draft aberto; branch preservada |
| PR #6 / codex/P-02B-health-jogador | Health do jogador, sobre o PR #5 | Draft aberto; branch preservada |
| PR #7 / codex/P-02C-stats-ofensivos | Stats ofensivos, sobre o PR #6 | Draft aberto; branch preservada |
| PR #8 / codex/P-02D-rng-streams | Streams RNG, sobre o PR #7 | Draft aberto; branch preservada |

Antes da primeira atualização documental de 24/10/2026, main continha apenas `README.md` com o título.
O bootstrap e a arena estavam em PRs draft; a documentação original também
estava numa branch separada. Por isso, dizer que não existe protótipo em todo
o repositório era incorreto, assim como dizer que main já contém o jogo.

## Como o executor deve incorporar os documentos

1. Conferir o HEAD de sua branch, main, o PR que está executando e alterações locais.
2. Ler README, DECISOES e NARRATIVA atuais; se estiver numa branch antiga, consultar
   esses arquivos em main sem sobrescrever seu trabalho.
3. Não fazer merge cego do PR #1: o README antigo diz que não há protótipo e a
   versão histórica pode omitir resoluções narrativas agora escritas.
4. Ao integrar código, conciliar README: manter apresentação e narrativa da main,
   acrescentar comandos reais da base integrada e corrigir a tabela de status.
5. Se houver nomes/IDs do código diferentes dos IDs documentais propostos,
   registrar o mapeamento; não invalidar saves ou renomear recursos automaticamente.
6. Confirmar o estado do PR #2 antes de mudar a base do #3. A atualização da main
   documental não integra automaticamente nenhum dos dois.

Este documento não autoriza o executor a resolver os PRs fora da tarefa recebida.
Ele permite continuar leitura/auditoria sem esperar a revisão de detalhes narrativos
que não afetem sua tarefa técnica.

## Entregue versus planejado

| Sistema | Evidência disponível | Limite |
| --- | --- | --- |
| Bootstrap | Relatório do PR #2 | Rever logs atuais e validar no Editor |
| Arena | Relatório do PR #3: 16 testes locais / 68 asserts à época da entrega | Não representa Ato I ou integração em main |
| Atributos completos | Catálogo de design e prompts | Não assumir que o level-up provisório conclui o sistema |
| Skills | 12 nomes no planejamento; Giro Ceifador demonstrativo na arena | Árvores, ranks e efeitos completos ainda precisam de execução |
| Mapas | Arena fixa em branch; geografia e progressão documentadas | Gerador e zonas de campanha não são entregues por documentos |
| Loot | Item demonstrativo na arena | Raridades, afixos, conjuntos e receitas precisam de dados e testes próprios |
| História | Cânone v0.4 e novela adaptada com prólogo, 14 capítulos e quatro finais | Prosa e documentação publicadas; diálogos, escolhas, alianças e cenas ainda não implementados |
| Save e build PC | Instruções no pacote de prompts | Nenhum artefato entregue por esta revisão |

## Fronteira entre narrativa e gameplay

A geografia foi preservada, mas origem do pacto, Halric, chefes e desfechos seguem
agora a direção v0.4. Consulte [IMPACTO_NARRATIVO_V04.md](IMPACTO_NARRATIVO_V04.md)
antes de implementar conteúdo ou revisar o PR #4.
Isso não decide quantidade de inimigos, níveis, dano, tamanho de mapa, preços,
cooldowns ou duração de cenas. O executor deve consumir contratos aprovados,
não transformar uma metáfora narrativa em uma regra numérica improvisada.

Revisão editorial não é atestado de CI. Verificação de Markdown não substitui
playtest; executar testes do jogo sem mudança de código tampouco provaria a
qualidade narrativa. Esta frente valida coerência, links e conteúdo documental.

## Coordenação da revisão v0.4

Esta atualização não altera a branch de Health nem amplia sua tarefa para narrativa.
Halric não deve ser selado na cripta e Orwyn não é mais o chefe do Ato I.
Os rascunhos e prompts antigos são históricos nos trechos conflitantes; a direção
mais recente do responsável em NARRATIVA prevalece. Não fazer merge cego de
documentação antiga que reintroduza o deus, Irrik final ou Halric morto.


A v0.4 define Odran, Maera, Edrin, Lysa e quatro desfechos. A fundição experimental
antecede o nascimento do protagonista. Perder nome/voz não apaga IDs ou saves.

## Novela e provas externas de arte

A adaptação literária está em [NOVELA_CANONICA.md](NOVELA_CANONICA.md); seus
limites e o mapa de atos estão em [INTEGRACAO_NOVELA.md](INTEGRACAO_NOVELA.md).
A main permanece documental. Os oito PRs abertos estavam em draft no momento
da consulta; nenhum foi mesclado ou teve base, head ou descrição alterados.

ARTE-00 e ARTE-01A são entregas externas relatadas pelo executor, não assets
integrados. O relatório ARTE-01A recebido em 25/10/2026 recomenda provisoriamente
lápide com 60% da altura frontal de referência de 36 px: alvo 21,6 px, escala
aproximada 0,291892 para os 74 px visíveis da lápide. A medição anterior em outro
frame não fixa uma escala universal. Filtro linear foi preferido pelo executor
para a avaliação; iluminação, contraste e sombras continuam pendentes.

Não foram reproduzidos aqui os testes gráficos ou inspecionadas as capturas
locais desse relatório. Não há aprovação artística final, liberação comercial
específica do Meshy ou publicação dos assets de terceiros por esta atualização.
