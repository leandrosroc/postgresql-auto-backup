# Script de Backup Automatizado para PostgreSQL em Docker

Este é um script Bash para realizar backups automatizados de um banco de dados PostgreSQL em um contêiner Docker e salvar o backup em um diretório no sistema host.

## Uso

1. Clone este repositório:

   ```bash
   git clone https://github.com/leandrosroc/postgresql-auto-backup.git
   ```
2. Execute o script `pg_backup.sh`:
    ```bash
    ./backup_postgresql.sh
    ```

O script irá criar um arquivo de backup dentro do contêiner Docker e copiá-lo para o diretório local do host.

## Configuração

Antes de usar o script, é importante configurar algumas variáveis para que ele funcione corretamente de acordo com o seu ambiente:

- `BACKUP_INIT`: Especifique o diretório de origem para o backup.
- `BACKUP_DIR`: Especifique o diretório de destino onde os backups serão salvos.

## Pré-requisitos

Antes de executar o script, certifique-se de que você atenda aos seguintes pré-requisitos:

- **Docker**: O Docker deve estar instalado no sistema host.
- **Acesso ao Contêiner PostgreSQL**: O script assume que você tem acesso ao contêiner Docker onde o PostgreSQL está sendo executado.

## Contribuição

Sinta-se à vontade para contribuir ou relatar problemas neste repositório. Contribuições são bem-vindas!

## Licença

Este projeto é licenciado sob a [Licença MIT](LICENSE) - consulte o arquivo [LICENSE](LICENSE) para obter detalhes.
