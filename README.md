# OSSUVAR: Os Treze Sinos

> Um sino tocou onde não devia. Agora os mortos de Ossuvar não descansam, e você é o último coveiro de uma ordem que já não existe.

ARPG de fantasia sombria em **2D isométrico**, planejado para **Godot 4**, com combate de peso, progressão de personagem e loot como recompensa.

> **Estado: pré-produção.** Este repositório contém somente documentação. Não há código, protótipo nem build jogável. Tudo o que é descrito abaixo como jogo é **planejado** e pode mudar.

## Estado do projeto

| Área | Estado |
| --- | --- |
| Documentação de design e arquitetura | Publicada no PR #1, em revisão |
| M0, Fundação (projeto, CI, `CombatMath`) | Planejado; o início depende de autorização formal (tarefa T-001) |
| Combate, loot, skills, mundo e interface | Planejado |
| Build jogável | Não existe |

**Legenda.** *Planejado*: descrito em documento, sem código. *Em andamento*: existe PR draft com trabalho aberto. *Implementado*: PR integrado, testes executados e resultado validado no Editor do Godot. No momento, nenhum item está em *Em andamento* ou *Implementado*.

## O jogo

OSSUVAR busca a sensação dos ARPGs clássicos: ações com duração e consequência, chance de acertar, bloqueio, resistências elementais, builds por atributos e árvore de skills, e loot com raridades e afixos. A visão é isométrica 2:1, com um mundo sombrio e legível, onde a história é contada por itens, chefes e ambientes.

## História

O reino de **Norvhal** cresceu em torno de **Ossuvar**, a cidade-catedral cujos **Treze Sinos** eram tocados a cada morte para guiar os mortos ao descanso. Durante trezentos anos, funcionou. Então alguém fundiu um **Décimo Quarto Sino** e o tocou. Desde então ninguém parte: os mortos sobem, a terra apodrece e a cidade espera o fim.

Você é um **Penitente**, último jurado da **Ordem do Pó**, coveiros-guerreiros que enterravam e selavam os mortos inquietos. Seu mestre desapareceu na **Cripta dos Pranteadores**. Para encontrá-lo, você atravessará quatro atos, das cinzas de Norvhal ao coração da cidade.

| Ato | Nome | Ambientação |
| --- | --- | --- |
| I | Cinzas de Norvhal | Acampamento Vigília de Cal, campos calcinados, bosque, mosteiro e cripta |
| II | O Afogadouro | Ossário inundado sob a cidade |
| III | Os Dentes | Mina de ossos nas montanhas |
| IV | O Campanário | Os níveis mais altos da cidade-catedral |

No acampamento Vigília de Cal você encontra a ferreira Dagna, a curandeira Irmã Cael, o mercador Velho Tobbe e o Corvo Mudo, guardião dos Marcos de Cal.

## Pilares de design

1. **Combate com peso:** cada ação tem duração, compromisso e recuperação.
2. **Build importa:** atributos, árvore de skills com sinergias e equipamentos que mudam o estilo de jogo.
3. **Loot é a recompensa:** raridades, afixos, sockets e itens únicos.
4. **Mundo hostil e legível:** poucas palavras, muita atmosfera.
5. **Rejogabilidade:** áreas procedurais por semente, ciclos de dificuldade e chefes repetíveis.

## Escopo previsto do MVP

*Planejado e sujeito a revisão.*

- Uma classe jogável, o **Penitente**, com 12 skills em três árvores: Ferro (ataque), Cal (defesa e auras) e Cinza (fogo e maldições).
- Ato I completo: acampamento, quatro áreas, uma masmorra e um chefe.
- Recursos Vida, Mana e Vigor exibidos em barras horizontais no HUD; atributos Força, Destreza, Vitalidade e Energia.
- Loot completo: raridades, afixos, sockets e inventário em grade.
- Mapas procedurais por semente, com salas especiais fixas.
- Ciclos de dificuldade previstos na arquitetura; entrega prevista para o M5.

## Tecnologia prevista

*Definições do Tech Lead, ainda sem implementação.*

- Godot 4.7.2, GDScript tipado e renderer Compatibility.
- Exclusivamente 2D: tiles 64×32, oito direções, nenhum asset ou cena 3D.
- Lógica de combate em código puro e testável, separada das cenas.
- Testes headless com GUT, lint com gdtoolkit e integração contínua no GitHub Actions.
- Arte provisória até o M3; metas de desempenho só após o benchmark do M1.

Detalhes de fórmulas, arquitetura e regras de trabalho estão no [Documento Mestre](docs/DOCUMENTO_MESTRE.md).

## Roadmap

*Sem datas. Cada marco só é concluído após homologação.*

| Marco | Entrega prevista | Estado |
| --- | --- | --- |
| M0, Fundação | Projeto, CI e `CombatMath` testado | Planejado |
| M1, Combate core | Arena jogável: andar, atacar, morrer e subir de nível | Planejado |
| M2, Loot | Itens, afixos, inventário e equipamentos | Planejado |
| M3, Skills | As 12 skills do Penitente e a primeira arte real | Planejado |
| M4, Ato I | Mapas, acampamento, NPCs, chefe e save | Planejado |
| M5, Polimento | Ciclos de dificuldade, Ato II e balanceamento | A definir após o M4 |

## Como executar

Ainda não é possível executar o jogo. Quando o M0 for integrado, esta seção explicará como abrir o projeto no Godot 4.7.2 e rodar os testes.

## Gestão e papéis

| Papel | Quem | Responsabilidades |
| --- | --- | --- |
| Responsável pelo projeto | @Sarhuman | Dono do repositório. Aprova decisões formais, autoriza o início de cada tarefa, valida o resultado no Editor do Godot e faz o merge. Executa as alterações documentais definidas pelo Tech Lead. |
| Tech Lead e Product Owner | Claude (assistente de IA da Anthropic) | Define design, arquitetura, backlog e critérios de aceite; revisa as entregas e recomenda sua homologação; mantém o registro de decisões. Atua por conversa com o responsável, sem acesso de escrita ao repositório nem ao Editor. |
| Executor | Codex (agente de código da OpenAI) | Implementa uma tarefa delimitada por vez, em PR draft, sem merge automático, e entrega relatório com arquivos alterados, testes executados e pontos a validar no Editor. Não decide design nem arquitetura; dúvidas vão na seção "Perguntas" do PR. |

**Fluxo.** Uma tarefa corresponde a um PR pequeno. A próxima tarefa dependente só é liberada depois da revisão do Tech Lead e da validação prática do responsável. Uma decisão só vale quando registrada em [docs/DECISOES.md](docs/DECISOES.md).

## Documentação

- [Documento Mestre v0.1](docs/DOCUMENTO_MESTRE.md): visão de design, fórmulas de combate, arquitetura, regras de trabalho e backlog T-001 a T-012. **Contém spoilers da história.**
- [Registro de decisões](docs/DECISOES.md): o que está fechado, o que é proposta e o que está em aberto.

## Decisões em aberto e itens não aprovados

Os itens abaixo **não são decisões fechadas**; o status completo está em [docs/DECISOES.md](docs/DECISOES.md).

- Nome definitivo e verificação de marca.
- Autorização formal para iniciar a T-001.
- Chefes dos Atos II e III e desfecho da história.
- Licença do projeto.

## Contribuições, licença e créditos

Por ora o trabalho é conduzido pelo responsável do projeto e pelo executor, sob a gestão do Tech Lead; não há processo para contribuições externas.

**Licença:** a definir pelo responsável do projeto. Enquanto não houver um arquivo `LICENSE`, o conteúdo deste repositório não é de uso livre.

OSSUVAR é um projeto independente, inspirado no gênero ARPG clássico, e não tem vínculo com os títulos que o inspiram.
