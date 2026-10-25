> **Contém spoilers do prólogo e do Ato I.** Cânone v0.4, com conciliação literária de 25/10/2026. Preserva a cadeia v0.3 e incorpora provas e alianças v0.4; implementação e contratos mecânicos continuam separados.

**Perspectiva vigente em 25/10/2026:** visão lateral com plataformas; consulte
[DIRECAO_LATERAL.md](DIRECAO_LATERAL.md). A mudança preserva o cânone e os quatro
finais. Parâmetros isométricos dos materiais antigos não orientam os novos mapas.


# Prólogo e Ato I — A última vigília

Cenas de referência: prólogo e capítulos 1–6 de [NOVELA_CANONICA.md](NOVELA_CANONICA.md). Os IDs abaixo permanecem documentais e não são alterados pela numeração literária.

## Fluxo narrativo

Funeral de um Penitente → três batidas no caixão e silêncio dos Treze → chegada do mensageiro → carta de Halric → morte do mensageiro → busca pela cripta.

A carta contém a orientação exata:

> “Encontre-me na Cripta dos Pranteadores. Não confie em quem disser que os sinos protegem os vivos.”

O funeral não é do personagem jogável. Halric é o autor da carta, mas não aparece pessoalmente no prólogo ou no Ato I. A encenação do prólogo, inclusive eventual cutscene, precisa ser pulável sem perder flags ou objetivo no diário.

## Percurso do ato

`Vigília de Cal → Campos Calcinados → Bosque dos Enforcados → Estrada dos Ossários → Mosteiro Sem Voz → Cripta dos Pranteadores → passagem para o Afogadouro`.

O hub continua acessível conforme o contrato de viagem. A campanha pode registrar a escadaria descoberta sem carregar um Ato II ainda inexistente. Em uma build limitada ao Ato I, apresentar o encerramento do recorte e permitir retorno seguro.

## Objetivos propostos

IDs são documentais. Preservar IDs técnicos já distribuídos por mapeamento e migração explícita; não renomear saves automaticamente.

| ID proposto | Missão | Evidência ou objetivo garantido | Resultado narrativo |
| --- | --- | --- | --- |
| prologue_last_vigil | A Última Vigília | Presenciar funeral e receber a carta do mensageiro | Registrar a busca de Halric e o aviso sobre os sinos |
| act1_01_last_oath | O Último Juramento | Reconstituir os primeiros rastros do mestre nos Campos | Orientação de seguir para o bosque, sem substituir a carta por um bilhete contraditório |
| act1_02_names_without_graves | Nomes sem Sepultura | Examinar memórias repetidas e registros de enterro no bosque | Reconhecer o apagamento de identidades e localizar a rota dos ossários |
| act1_03_bone_convoy | A Carga dos Mortos | Examinar transporte funerário e a guia da carroça principal | Relacionar a rota ao arquivo do mosteiro |
| act1_04_silent_archive | O Arquivo sem Voz | Encontrar registros de acesso e seguir os vestígios de Halric | Entrar na cripta e investigar túmulos/inscrições apagados |
| act1_05_mausoleum_door | A Porta dos Soldados | Ler o registro de “apagar provas”, enfrentar o comandante e abrir a porta do mausoléu | Descobrir a escadaria para o ossário inundado; Halric continua desaparecido |
| act1_06_return_to_vigil | A Escada sob Ossuvar | Registrar a descoberta e atualizar os sobreviventes, sem exigir viagem impossível | Encerrar o recorte do Ato I e indicar o Afogadouro como continuação |

O encerramento pode ocorrer pelo diário e pela atualização do hub. Não bloquear o avanço ao Afogadouro com um retorno artificial se o desenho aprovado permitir seguir diretamente. Recompensa e gate exatos serão contratados pelo executor.

## Correções obrigatórias em relação à v0.2

- A missão antiga `act1_05_the_mourner` descrevia Orwyn e o selamento de Halric. Ela foi substituída no roteiro por `act1_05_mausoleum_door`.
- **Não remapear uma missão concluída cegamente:** a conclusão antiga não prova que o jogador venceu o comandante nem viu as novas pistas. Se existirem saves reais, definir migração/replay seguro antes de alterar flags.
- Halric não pode ser encontrado morto, ajudar a romper um condutor ou ser selado no Ato I.
- A Pranteadora fica no Ato II. Sua mecânica de identificar vozes e interromper ritual não pertence ao confronto do comandante.
- O comandante guarda uma passagem, não um tesouro. Loot de combate pode existir, mas não explica sua motivação nem determina se a porta abre.
- Pistas principais não dependem de sorte; memórias passivas não exigem matar todos os mortos para avançar.

## Consequências no acampamento

| NPC | Registro narrativo possível no primeiro ato | Continuidade posterior |
| --- | --- | --- |
| Dagna | Respeito à sua proposta e autonomia | Lidera defesa se confiar; pode partir com combatentes se ignorada ou usada |
| Cael | Provas entregues e oportunidade de investigar | Decifra rito e nomes; recusa apagamento deliberado da verdade |
| Tobbe | Reconhecimento dos erros da Ordem, sem exigir mentira | Abre passagem e ajuda com rito/pó; pressão para mentir rompe ajuda |
| Corvo Mudo | Desenhos do sino rachado e rosto sem olhos preservados no diário | A primeira lista aparece no Ato II; a devolução do nome e o testemunho podem ocorrer no retorno à Vigília após o Afogadouro |

Esta tabela não define uma escala numérica de reputação. Condições para presença, sobrevivência e apoio no final precisam de fatos explícitos de missão e aviso antes de decisões irreversíveis.

## Pistas desenvolvidas na novela

- Campos: memórias passivas e identificação dos mortos, sem extermínio obrigatório.
- Bosque: registros de abastecimento, fome e violência; material para investigação posterior.
- Estrada: guias funerárias, selos de Halric e carta sobre a recusa dos soldados.
- Mosteiro: versões distintas dos ofícios, assinatura de Maera, sucessão de guardiões e arquivo de sucessão real.
- Cripta: nota recente de Halric, relatórios de apagamento e comandante guardando a passagem.

São referências de conteúdo. Não acrescentam missão, nome definitivo de chefe, recompensa ou gate técnico. A entrega das provas a Cael e o tratamento do Corvo podem iniciar os arcos de confiança sem antecipar a fala de Edrin ou o encontro pessoal de Halric.

## Estados e critérios de validação futura

Manter estados documentais `unavailable`, `available`, `active`, `objective_met` e `completed` quando úteis. Conclusões e recompensas têm identidade única e não dependem de uma janela de diálogo aberta.

- Próximo objetivo continua claro após pular o prólogo, morrer, voltar ao hub ou carregar save.
- Carta, carroça, arquivo, registro da cripta e porta são alcançáveis em toda configuração homologada da campanha; geração procedural lateral ainda depende de contrato.
- Descobertas antecipadas são registradas e reconciliadas sem softlock.
- Mortos não hostis têm apresentação distinta e não geram objetivo obrigatório de extermínio.
- Nenhuma fala revela o encontro pessoal de Halric antes do Ato III.
- O comandante só concede a recompensa de quest uma vez; repetir encontro não desfaz a cronologia.
- A build do Ato I encerra seu conteúdo sem fingir que Afogadouro já está implementado.

## Continuidade com os quatro desfechos

As primeiras pistas do massacre podem surgir neste ato sem antecipar toda a
revelação. Preservar documentos como fatos, sem consumi-los como moeda de serviços.
A primeira lista é encontrada no Afogadouro; a fala de Edrin pode ocorrer no retorno à Vigília, ainda na sequência narrativa do Ato II. A origem de Lysa e
do fragmento não é conhecida pelo protagonista no prólogo. Requisitos e custos
estão em [PACTO_E_DESFECHOS.md](PACTO_E_DESFECHOS.md). Não tornar as três âncoras
objetivo obrigatório de toda rota. Sem novas flags executáveis nesta revisão.


