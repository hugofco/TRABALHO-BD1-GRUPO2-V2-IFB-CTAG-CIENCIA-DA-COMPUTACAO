# Conexão Python + MySQL (Docker)

Este projeto mostra como conectar uma aplicação Python a um banco de dados MySQL rodando localmente via Docker, e como executar queries SQL de forma segura.

## Requisitos

- Python 3.7+
- Banco de dados MySQL rodando em um container Docker (configurado e testado via MySQL Workbench)
- Biblioteca `mysql-connector-python`

Instalação da biblioteca:

```bash
pip install mysql-connector-python
```

## Estrutura do código

### 1. Conexão com o banco (`get_connection`)

```python
def get_connection():
    try:
        connection = mysql.connector.connect(
            host="127.0.0.1",
            port=3306,
            user="your_username",
            password="your_password",
            database="your_database_name"
        )
        return connection
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        return None
```

**O que faz:** abre uma conexão com o banco de dados MySQL.

- `host`: endereço do banco. Como o MySQL está rodando localmente via Docker, normalmente é `127.0.0.1` ou `localhost`.
- `port`: a porta exposta pelo container Docker (a mesma usada para conectar no MySQL Workbench, geralmente `3306`).
- `user` / `password`: suas credenciais de acesso ao banco.
- `database`: o nome do banco de dados que você quer acessar.
- O `try/except` garante que, se a conexão falhar (porta errada, container parado, credenciais incorretas etc.), o erro é capturado e exibido em vez de travar o programa.

### 2. Execução de queries (`get_records`)

```python
def get_records(min_value):
    connection = get_connection()
    if connection is None:
        return []

    try:
        cursor = connection.cursor(dictionary=True)
        query = "SELECT * FROM my_table WHERE some_column >= %s"
        cursor.execute(query, (min_value,))
        results = cursor.fetchall()
        return results
    except Error as e:
        print(f"Error executing query: {e}")
        return []
    finally:
        cursor.close()
        connection.close()
```

**O que faz:** executa uma query SELECT com um parâmetro e retorna os resultados.

- `connection.cursor(dictionary=True)`: cria um "cursor", que é o objeto usado para executar comandos SQL. O parâmetro `dictionary=True` faz com que cada linha retornada seja um dicionário (`{'coluna': valor}`), em vez de uma tupla — isso facilita acessar os dados pelo nome da coluna.
- `%s`: é o placeholder usado para inserir valores na query de forma seguraevitando SQL Injection. Os valores reais são passados separadamente, na tupla `(min_value,)`.
- `cursor.execute(query, params)`: executa a query, substituindo o `%s` pelo valor informado.
- `cursor.fetchall()`: busca todos os resultados retornados pela query.
- `finally`: garante que o cursor e a conexão sejam **sempre fechados**, mesmo se ocorrer um erro — isso evita conexões "presas" no banco.

### 3. Função reutilizável para qualquer query (`run_query`)

```python
def run_query(query, params=None):
    connection = get_connection()
    if connection is None:
        return []
    try:
        cursor = connection.cursor(dictionary=True)
        cursor.execute(query, params or ())
        if query.strip().lower().startswith("select"):
            return cursor.fetchall()
        connection.commit()
        return cursor.rowcount
    except Error as e:
        print(f"Error: {e}")
        return []
    finally:
        cursor.close()
        connection.close()
```

**O que faz:** generaliza a lógica de conexão e execução para qualquer tipo de query (SELECT, INSERT, UPDATE, DELETE), evitando repetir o mesmo código várias vezes.

- Se a query for um `SELECT`, retorna os resultados com `fetchall()`.
- Se for `INSERT`, `UPDATE` ou `DELETE`, executa `connection.commit()` (necessário para salvar alterações no banco) e retorna o número de linhas afetadas (`cursor.rowcount`).
- `params or ()`: permite chamar a função sem parâmetros, caso a query não precise de nenhum.

## Exemplo de uso

```python
rows = run_query("SELECT * FROM users WHERE age > %s AND city = %s", (25, "Lisbon"))
for row in rows:
    print(row)
```
