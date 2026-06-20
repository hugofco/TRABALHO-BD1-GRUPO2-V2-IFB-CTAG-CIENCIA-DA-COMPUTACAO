import mysql.connector
from mysql.connector import Error
import os
import time


def get_connection():
    try:
        connection = mysql.connector.connect(
            host="172.17.0.2", #altere os dados caso você tenha feito uma config/setup diferente do
            port=3306,         #apresentado no repo do github
            user="admin",
            password="admin",
            database="Banco_Universidade"
        )
        return connection
    except Error as e:
        print(f"Erro ao conectar ao MySQL: {e}")
        return None


def get_alunos_por_curso(min_value, nomes_cursos): #aqui o curso e digitado pelo usuario, no script de consulta .sql
    """                                            #Ele ja retorna os tres requisitados
    min_value: quantos registros retornar (LIMIT)
    nomes_cursos: lista de nomes de curso (ex: ['Fisica', 'Ciencia da Computacao'])
    """
    connection = get_connection()
    if connection is None:
        return []

    cursor = None
    try:
        cursor = connection.cursor(dictionary=True)
        # placeholders dinâmicos: %s, %s, %s... um para cada curso da lista
        placeholders = ", ".join(["%s"] * len(nomes_cursos))
        query = f"""
            SELECT c.Nome_Curso AS Curso, a.Matricula, a.Nome AS Aluno, i.Metodo
            FROM Ingressa i
            JOIN Aluno a ON i.Matricula = a.Matricula
            JOIN Curso c ON i.ID_Curso = c.ID_Curso
            WHERE c.Nome_Curso IN ({placeholders})
            ORDER BY c.Nome_Curso, a.Nome
            LIMIT %s
        """
        params = (*nomes_cursos, min_value)
        cursor.execute(query, params)
        return cursor.fetchall()
    except Error as e:
        print(f"Erro ao executar a consulta: {e}")
        return []
    finally:
        if cursor is not None:
            cursor.close()
        connection.close()


def get_alunos_por_disc_e_semestre_atual_ou_passado(min_value):
    connection = get_connection()
    if connection is None:
        return []

    cursor = None
    try:
        cursor = connection.cursor(dictionary=True)
        query = """
            SELECT ms.Semestre, d.Nome_D AS Disciplina, a.Matricula, a.Nome AS Aluno
            FROM Matricula_Se ms
            JOIN Aluno a ON ms.Matricula = a.Matricula
            JOIN Disciplina d ON ms.ID_Disciplina = d.ID_Disciplina
            WHERE ms.Semestre IN ('2025-1', '2024-2')
            ORDER BY ms.Semestre DESC, d.Nome_D, a.Nome
            LIMIT %s
        """
        cursor.execute(query, (min_value,))
        return cursor.fetchall()
    except Error as e:
        print(f"Erro ao executar a consulta: {e}")
        return []
    finally:
        if cursor is not None:
            cursor.close()
        connection.close()


def print_table(results):
    """Imprime uma lista de dicts como tabela alinhada no terminal."""
    if not results:
        print("\nNenhum resultado encontrado.\n")
        return

    colunas = list(results[0].keys())
    larguras = {
        col: max(len(col), max(len(str(row[col])) for row in results))
        for col in colunas
    }

    def linha_separadora():
        return "+" + "+".join("-" * (larguras[col] + 2) for col in colunas) + "+"

    def linha_dados(valores):
        return "|" + "|".join(
            f" {str(valores[col]):<{larguras[col]}} " for col in colunas
        ) + "|"

    print()
    print(linha_separadora())
    print(linha_dados({col: col for col in colunas}))
    print(linha_separadora())
    for row in results:
        print(linha_dados(row))
    print(linha_separadora())
    print(f"Total: {len(results)} registro(s)\n")


def ler_inteiro_positivo(prompt):
    """Pede um inteiro positivo ao usuario ate receber um valor valido."""
    while True:
        valor = input(prompt).strip()
        try:
            n = int(valor)
            if n <= 0:
                print("Por favor, digite um numero inteiro maior que zero.")
                continue
            return n
        except ValueError:
            print("Entrada invalida. Digite um numero inteiro.")


def print_menu():
    print("====== Trabalho-BD1-Banco_Universidade_Grupo2 ======")
    print("Selecione a acao:")
    print("1- Selecionar alunos por curso")
    print("2- Selecionar alunos por disciplina no semestre atual e no passado")
    print("3- Sair")
    print("Cursos disponiveis para consulta: ")


def pausar_e_limpar():
    time.sleep(2)
    os.system('cls' if os.name == 'nt' else 'clear')


def main():
    while True:
        print_menu()
        escolha_raw = input("Opcao: ").strip()

        if not escolha_raw.isdigit():
            print("Tipo de operação invalida, tente novamente.")
            pausar_e_limpar()
            continue

        acao = int(escolha_raw)

        if acao == 1:
            cursos_raw = input(
                "Digite o(s) nome(s) do(s) curso(s) "
                "(separe por virgula se mais de um): "
            ).strip()
            nomes_cursos = [c.strip() for c in cursos_raw.split(",") if c.strip()]

            if not nomes_cursos:
                print("Você precisa digitar ao menos um nome de curso.")
                pausar_e_limpar()
                continue

            quantidade = ler_inteiro_positivo(
                "Digite quantos alunos devem ser retornados: "
            )
            resultados = get_alunos_por_curso(quantidade, nomes_cursos)
            print_table(resultados)
            input("Pressione ENTER para continuar...")

        elif acao == 2:
            quantidade = ler_inteiro_positivo(
                "Digite quantos registros devem ser retornados: "
            )
            resultados = get_alunos_por_disc_e_semestre_atual_ou_passado(quantidade)
            print_table(resultados)
            input("Pressione ENTER para continuar...")

        elif acao == 3:
            print("Saindo...")
            break

        else:
            print("Tipo de operação invalida, tente novamente.")
            pausar_e_limpar()
            continue

        pausar_e_limpar()


if __name__ == "__main__":
    main()