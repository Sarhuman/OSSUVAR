# Integração narrativa v0.4

**Perspectiva vigente em 25/10/2026:** visão lateral com plataformas; consulte
[DIRECAO_LATERAL.md](DIRECAO_LATERAL.md). A mudança preserva o cânone e os quatro
finais. Parâmetros isométricos dos materiais antigos não orientam os novos mapas.


Data: 24/10/2026. Fonte: definições do responsável sobre os soldados, pacto,
Corvo, protagonista, quatro desfechos e consequências das alianças.

## Fonte vigente

[NARRATIVA.md](NARRATIVA.md) e [PACTO_E_DESFECHOS.md](PACTO_E_DESFECHOS.md)
formam o roteiro vigente. [MISSOES_ATO_I.md](MISSOES_ATO_I.md) apresenta o recorte
inicial. Histórico v0.1 e nota v0.3 não prevalecem sobre estas definições.

| Tema | Direção a consumir |
| --- | --- |
| Rei e soldados | Odran Vhal, fome/impostos, massacre e usurpação; execução para impedir testemunho |
| Fundadora | Maera, divisão dos nomes, primeira guardiã e presença que volta a se manifestar |
| Corvo | Edrin, testemunha infantil preservada; fala breve após lista/nome devolvidos |
| Protagonista | Filho de Lysa, resgatado por Halric e ligado ao pacto por fragmento experimental |
| Cronologia | Material experimental antes do nascimento; conclusão e toque pleno depois |
| Três âncoras | Estruturas do Afogadouro, distintas da âncora humana e dos Treze Sinos |
| Finais | O Silêncio, A Testemunha, O Guardião e Os Nomes dos Vivos |
| Confiança | Fatos e tratamento dos aliados, sem pontuação secreta que substitua provas |

## Contratos futuros

1. Preservar as correções v0.3: Halric vivo, comandante no Ato I, Pranteadora no II,
   antigo Penitente no III e confronto com Halric no IV.
2. Não inventar quem é o Corvo, o rosto, a mãe ou a razão do pacto: estão definidos.
   Cenas, datas exatas e contratos técnicos específicos ainda precisam de trabalho.
3. Substituir final binário e denúncia independente pelos quatro desfechos. Não
   afirmar que o final oculto é proibido pela v0.2.
4. Distinguir abrir passagem para testemunho de alterar o rito para libertar sem
   transformar vozes em arma; não reduzir ambos a textos para o mesmo resultado.
5. Definir estados explícitos de provas, lista, nome, confiança, método, pó, rito
   e testemunha informada. Nomes de campos/IDs são trabalho do contrato, não APIs
   automaticamente criadas por uma frase do roteiro.
6. Âncoras quebradas são requisito da destruição, não da derrota da Pranteadora.
   Preservar retorno ao Afogadouro depois das minas e aviso antes de bloquear rota.
7. Presença, preparações e perdas em A Testemunha vêm de fatos, sem rolagem oculta
   na tela final. Guardião/final oculto não ressuscitam aliados previamente mortos.
8. Pular cenas preserva fatos e informação essencial no diário. O jogador conhece
   o custo antes de confirmar, inclusive a pessoa que testemunha a decisão do Guardião.
9. Perder nome/voz não apaga personagem, save ou referências de inventário. É uma
   consequência narrativa a representar na apresentação e no epílogo.

## PRs e trabalho em andamento

O PR #4 foi proposto sobre a v0.2 e precisa da conciliação narrativa anterior,
agora também com estas definições. Sua branch não foi alterada por esta frente.
Health, Stats, adapters e RNG não mudam como consequência desta revisão.

Esta atualização não mescla PRs, não altera código do executor, não aprova
balanceamento nem implementa alianças/finais/persistência. Tarefas de conteúdo
devem consultar a main atual antes de editar.

## Conciliação literária de 25/10/2026

A [novela adaptada](NOVELA_CANONICA.md) concretiza em prosa a v0.4; o mapa de
capítulos e a precedência estão em [INTEGRACAO_NOVELA.md](INTEGRACAO_NOVELA.md).
A versão original de OSSUVAR.docx não deve ser usada para reintroduzir Irrik/Edda
como causa do desastre, o Sepultado como origem do pacto, Halric morto na cripta
ou um final binário obrigatório.

A devolução do nome de Edrin pode ocorrer no retorno ao hub após o Afogadouro.
A revelação de Lysa acontece antes da decisão final; os quatro epílogos são
alternativos. O Silêncio não impõe quebra das âncoras às demais rotas.

Esta revisão mantém as interfaces e os valores dos PRs de código. Não aplicar
cherry-pick, merge ou rebase automático da documentação sobre o trabalho local.
