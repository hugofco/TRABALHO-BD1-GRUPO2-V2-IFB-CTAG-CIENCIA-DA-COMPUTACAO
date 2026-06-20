# TRABALHO-BD1-GRUPO2-V2-IFB-CTAG-CIENCIA-DA-COMPUTACAO
Versão 2 de um trabalho prático em grupo de modelagem e implementação de um banco de dados teórico em SQL para a disciplina de banco de dados 1, ministrada pelo Dr. Fabiano Cavalcanti Fernandes.

Imagine que você tenha que modelar um sistema de administração de uma Universidade. Com as entidades Aluno, Curso e Disciplina. Um aluno pode se matricular em várias disciplinas e em apenas um curso, um curso possui N disciplinas e N alunos, uma disciplina possui N alunos.

## DER (Diagrama Entidade-Relacionamento)

<img width="1189" height="641" alt="Screenshot From 2026-06-19 22-34-49" src="https://github.com/user-attachments/assets/92b0e0c2-4873-4736-b703-9e5df1c56729" />

`Caso seja necessário, esse diagrama em formato .xml se encontra na pasta 'diagramas' do repositório.`

## Criando o banco de dados (MYSQL WorkBench ou qualquer SGBD de sua preferência)

### [ATENÇÃO!] 

Sempre cerifique-se de executar o script de criação do banco em um ambiente novo e limpo, sempre certifique-se de que a execução não causará nenhum dano à um banco ou quaisquer informações existentes.

### Criação do contêiner (docker) 

```bash
docker run -d --name Banco_Universidade_grupo2 -e MYSQL_ROOT_PASSWORD=admin -p 3307:3306 mysql:8
```

## Utilize o seguinte endereço para a configuração do hostname e test connection

```bash
172.17.0.2
```
### Criação do Banco de Dados (MYSQL WorkBench ou um SGBD de sua preferência compatível com SQL)

Na pasta 'sql-scripts' no repositório, você encontrará o arquivo: Universidade_exerciciobd1_grupo2.sql
Neste arquivo está todo o script de construção do banco, com as respectivas tabelas, atributos, população de tabelas (com valores simbólicos) e estabelecimento de relações de acordo com o que foi proposto na modelagem anteriormente.

