# TRABALHO-BD1-GRUPO2-V2-IFB-CTAG-CIENCIA-DA-COMPUTACAO
Versão 2 de um trabalho prático em grupo de modelagem e implementação de um banco de dados teórico em SQL para a disciplina de banco de dados 1, ministrada pelo Dr. Fabiano Cavalcanti Fernandes. SEMESTRE(2026/1)

## Contexto:
Imagine que você tenha que modelar um sistema de administração de uma Universidade. Com as entidades Aluno, Curso e Disciplina. Um aluno pode se matricular em várias disciplinas e em apenas um curso, um curso possui N disciplinas e N alunos, uma disciplina possui N alunos.

## Descrição Geral:
1- Faça um DER de uma universidade conforme contextualizado em sala.

2- Crie o modelo relacional apenas das entidades Aluno, Disciplina e Curso, seus relacionamentos e atributos.

3- No laboratório crie um esquema (Banco) no Mysql chamado Banco_Universidade com as relações do item 2.

4- Crie um SQL que popule o banco com pelo menos 10 alunos, disciplinas de Calculo 1, Física 1, Quimica 1, Algebra Linear, Bioquimica e Banco de dados, curso de Ciencia da Computação, Física, Engenharia Quimica.

5- Crie um SQL que retorne os alunos matriculados em Ciencia da Computação, Física, Engenharia Quimica.

6- Crie um SQL que retorne os alunos matriculados em cada disciplina no semestre atual e no semestre passado.

7- Implemente uma aplicação em Java ou Python que acesse o BD Banco_Universidade e permita que o usuário realize as consultas acima.

8- Crie um github do grupo com a documentação acima.

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

### Endereço de ip padrão para a configuração do hostname e test connection

```bash
172.17.0.2
```
### Criação do Banco de Dados (MYSQL WorkBench ou um SGBD de sua preferência compatível com SQL)

Na pasta 'SQL-Scripts' no repositório, você encontrará o arquivo 'build_database_script_trabalho_bd1_grupo2_v2.sql'
Neste arquivo está todo o script de construção do banco, com as respectivas tabelas, atributos, população de tabelas (com valores simbólicos) e estabelecimento de relações de acordo com o que foi proposto na modelagem anteriormente. Na mesma pasta, também se encontram todos os scripts para a consulta descrita nos items 5 e 6 da descrição do trabalho.
