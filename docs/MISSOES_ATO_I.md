> **Contém spoilers do Ato I.** Especificação narrativa v0.2; IDs propostos para discussão com o Codex, ainda não implementados.

# Ato I — Progressão de missões

## Fluxo principal

`Vigília de Cal → Campos Calcinados → Bosque dos Enforcados → Estrada dos Ossários → Mosteiro Sem Voz → Cripta dos Pranteadores → Vigília de Cal`.

Os IDs abaixo são identificadores documentais estáveis propostos. Se o código já possuir IDs equivalentes, preservar compatibilidade por mapeamento, sem renomear saves cegamente.

| ID | Missão | Gatilho narrativo | Objetivo verificável | Conclusão e próximo passo |
| --- | --- | --- | --- | --- |
| act1_01_last_oath | O Último Juramento | Conversa inicial com Cael | Encontrar o posto funerário de Halric nos Campos | Bilhete indica que o mestre seguiu pelo bosque; investigar o trajeto |
| act1_02_names_without_graves | Nomes sem Sepultura | Chegada ao bosque com o bilhete | Recuperar o registro do destacamento num ponto fixo alcançável | Marcas de transporte identificam cargas da Estrada dos Ossários |
| act1_03_bone_convoy | A Carga dos Mortos | Descoberta da rota de transporte | Examinar a carroça principal e sua guia de carga | Selo da ordem aponta para o arquivo do Mosteiro Sem Voz |
| act1_04_silent_archive | O Arquivo sem Voz | Acesso ao mosteiro | Abrir o arquivo e obter o registro ritual que dá acesso à cripta | Mostrar que o rito mantém algo contido; seguir os sinais de Halric |
| act1_05_the_mourner | Aqueles que Ela Guardou | Entrada da cripta e primeiro contato com Halric | Alcançar a antecâmara, enfrentar Orwyn e interromper o condutor local | Halric é selado; registro da drenagem revela a passagem do Afogadouro |
| act1_06_return_to_vigil | O Que Ainda Vive | Retorno após o confronto | Informar os sobreviventes e registrar a rota reaberta | Ato I concluído; Ato II permanece conteúdo futuro até implementação própria |

## Informação obrigatória e dependências

- Pistas principais são colocadas em landmarks garantidos pelo gerador; não dependem de chance de drop.
- Registro de transporte e acesso ritual são pistas/flags. Não exigem inventário de quest ocupando espaço até que essa política seja aprovada.
- Cada transição deve funcionar após fechar/carregar o jogo, conforme o contrato de save que vier a ser implementado.
- A indicação de local deve ser suficiente sem ler todos os diálogos opcionais. Recapitular objetivo no diário.
- Destravar passagem e conceder recompensa são operações únicas por personagem/quest. Repetir conversa não repete o crédito.
- Não definir aqui quantidades de XP, ouro, itens, níveis ou porcentagens; o contrato de gameplay fornecerá esses dados.

## Estados propostos para cada missão

| Estado | Significado |
| --- | --- |
| unavailable | Dependência narrativa ainda não satisfeita |
| available | Pode ser recebida por conversa ou descoberta prevista |
| active | Objetivo em andamento |
| objective_met | Evidência ou confronto concluído, falta encerramento quando aplicável |
| completed | Encerrada e com recompensa única registrada |

Nem toda missão exige todas as etapas na interface. A ordem lógica não pode depender da presença de uma janela de diálogo aberta. Se o jogador alcançar um landmark antes de receber a missão, registrar a descoberta e reconciliar quando ela ficar disponível; não gerar um softlock.

## Cena da cripta

1. Halric avisa que sua voz já foi usada para chamar os mortos. O controle do jogador não é retirado durante combate ativo.
2. Orwyn apresenta seu abrigo e impede a retirada do mestre. A entrada do chefe sinaliza o confronto.
3. O encontro termina com a derrota de Orwyn, não com uma solução global para os sinos.
4. Sem inimigos ativos, Halric confirma sua morte anterior e ajuda a romper o condutor. O Penitente sela os restos do mestre.
5. O jogador recebe a indicação do Afogadouro e retorna ao hub. O fim do recorte não força o carregamento de um Ato II inexistente.

Apresentação, duração, fases de combate, arenas, falas finais e animações exigem subtask própria. Se houver cutscene, ela será pulável; pular não pode omitir flags, itens necessários ou a informação essencial no diário.

## Arcos opcionais sem bloquear a campanha

| NPC | Descoberta | Mudança narrativa no hub |
| --- | --- | --- |
| Dagna | Marcas de ferramentas nas carroças | Reconhece a participação involuntária de sua oficina e passa a identificar as peças da fundição |
| Cael | Nomes de vítimas preservados no bosque | Decide continuar tratando sobreviventes mesmo sem confiar na instituição |
| Tobbe | Guia da carga para o mosteiro | Admite conhecer as rotas e entrega o registro que antes ocultava |
| Corvo Mudo | Marco funerário restaurado | Acrescenta uma inscrição sobre não responder a vozes vindas das sepulturas |

Esses arcos não dão uma terceira opção secreta no final nem introduzem reputação numérica automaticamente. Se houver recompensa mecânica, ela será definida em dados por tarefa própria.

## Critérios para o futuro playtest

- A rota dos seis objetivos é alcançável para todas as seeds homologadas.
- Falhar, morrer, voltar ao hub ou pular apresentação não bloqueia o objetivo.
- Halric está morto e sob vínculo; nenhum diálogo posterior o trata como mestre vivo disponível no acampamento.
- Concluir Orwyn repetidamente não repete a recompensa de quest nem revive Halric na cronologia.
- O diário explica onde continuar e encerra o Ato I sem prometer conteúdo já entregue no II.
- Os objetivos são identificáveis em português e as pistas principais continuam presentes após save/load.
