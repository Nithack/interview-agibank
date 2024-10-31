# Interview Agibank

## Descrição do Projeto

Este projeto é uma implementação para o estudo de caso fornecido pela Agibank, envolvendo o **Cadastro de Clientes** e a **Contratação de Seguros**. O sistema consiste em duas APIs separadas que interagem entre si:

1. **Client Service API**: Responsável pelo gerenciamento dos dados dos clientes.
2. **Insurance Service API**: Responsável pela simulação e contratação de seguros para os clientes cadastrados.

## Enunciado

**Estudo de Caso:** Cadastro de Clientes durante a jornada de contratação de seguro.

Nosso time de atendimento em loja necessita realizar cadastros de clientes. Para seguir com a Jornada de Onboarding no Banco, é necessário informar alguns dados como:

- **CPF**
- **Nome**
- **Data de Nascimento**
- **Telefone**
- **Endereço Completo**

Após realizar o cadastro, o cliente terá acesso a uma jornada muito importante de **"Contratação de Seguros"**, onde será possível simular e contratar os Seguros **Bronze**, **Prata** e **Ouro**.

### Técnico:

1. **Construir uma API - Cadastro** (Client Service API)
   - CRUD para manipular o cadastro do cliente (4 serviços).
2. **Construir uma API - Seguros** (Insurance Service API)
   - Simular qual seguro o cliente vai contratar (1 serviço).
   - Realizar a contratação de fato do seguro (1 serviço).
3. **Integrar com Banco de Dados**
   - Dica: Usar PostgreSQL ou MongoDB.
4. **Realizar Chamada Back to Back entre as APIs**
   - Exemplo: No momento de contratar o seguro, consultar o cliente na API de Cadastro para ter certeza que ele existe.
   - Implementar mecanismo de resiliência.
5. **Documentação**
   - Utilizar Swagger.
6. **Testes Unitários**
   - Utilizar JUnit.

**Super DICA:** Gostamos de boas práticas com **Código Limpo**, **SOLID** e **Arquitetura Hexagonal**/Clean.

## Estrutura do Projeto

O projeto está organizado em dois microserviços independentes, seguindo os princípios de arquitetura hexagonal:

- **client-service-api**: Responsável pelo cadastro e gerenciamento de clientes.
- **insurance-service-api**: Responsável pela simulação e contratação de seguros.

## Fluxo de Uso da Aplicação

1. **Cadastro de Cliente:**
   - O cliente é cadastrado através da **Client Service API**, fornecendo CPF, nome, data de nascimento, telefone e endereço completo.
   - Os dados são validados e armazenados no banco de dados PostgreSQL.

2. **Listagem de Seguros Disponíveis:**
   - O cliente pode visualizar os seguros disponíveis (Bronze, Prata e Ouro) através da **Insurance Service API**.

3. **Simulação de Seguro:**
   - O cliente seleciona um seguro para simular.
   - A **Insurance Service API** faz uma chamada à **Client Service API** para verificar se o cliente existe e obter seu CPF.
   - Se o cliente existir, a simulação é realizada com base nos dados do cliente e do seguro escolhido.

4. **Contratação de Seguro:**
   - Após a simulação, o cliente pode optar por contratar o seguro.
   - Novamente, a **Insurance Service API** verifica a existência do cliente através da **Client Service API**.
   - Se tudo estiver correto, o seguro é contratado e os dados são armazenados.

5. **Consulta e Gerenciamento:**
   - O cliente pode consultar seus seguros contratados.


## Configuração do Projeto

### Pré-requisitos

- **Java 17** ou superior
- **Maven 3.8** ou superior
- **Docker** e **Docker Compose**

### Estrutura de Diretórios

```
interview-agibank/
├── client-service-api/
│   ├── src/
│   ├── Dockerfile
│   └── ...
├── insurance-service-api/
│   ├── src/
│   ├── Dockerfile
│   └── ...
├── docker-compose.yml
└── .env
```

### Arquivos de Configuração

#### Arquivo `.env`

Crie um arquivo `.env` na raiz do projeto `interview-agibank` com o seguinte conteúdo:

```dotenv
# Configurações do Banco de Dados PostgreSQL
POSTGRES_DB_URL=jdbc:postgresql://postgres:5432/client_insurance
POSTGRES_DB_USERNAME=INTERNET
POSTGRES_DB_PASSWORD=q1w2e3r4

# Client Service
CLIENT_SERVICE_URL=http://client-service-api:3030

# Configurações da Aplicação
CLIENT_PORT=3030
INSURANCE_PORT=3031
```

#### Arquivo `docker-compose.yml`

O arquivo `docker-compose.yml` está configurado na raiz do projeto `interview-agibank`:

```yaml
version: '3.8'

services:

  client-service-api:
    build:
      context: ./client-service-api
      dockerfile: Dockerfile
    ports:
      - "${CLIENT_PORT}:${CLIENT_PORT}"
    environment:
      - POSTGRES_DB_URL=${POSTGRES_DB_URL}
      - POSTGRES_DB_USERNAME=${POSTGRES_DB_USERNAME}
      - POSTGRES_DB_PASSWORD=${POSTGRES_DB_PASSWORD}
      - CLIENT_PORT=${CLIENT_PORT}
    depends_on:
      - postgres

  insurance-service-api:
    build:
      context: ./insurance-service-api
      dockerfile: Dockerfile
    ports:
      - "${INSURANCE_PORT}:${INSURANCE_PORT}"
    environment:
      - POSTGRES_DB_URL=${POSTGRES_DB_URL}
      - POSTGRES_DB_USERNAME=${POSTGRES_DB_USERNAME}
      - POSTGRES_DB_PASSWORD=${POSTGRES_DB_PASSWORD}
      - CLIENT_SERVICE_URL=${CLIENT_SERVICE_URL}
      - INSURANCE_PORT=${INSURANCE_PORT}
    depends_on:
      - postgres
      - client-service-api

  postgres:
    image: postgres:latest
    environment:
      POSTGRES_DB: client_insurance
      POSTGRES_USER: ${POSTGRES_DB_USERNAME}
      POSTGRES_PASSWORD: ${POSTGRES_DB_PASSWORD}
    ports:
      - "5432:5432"
```

### Gerando os Artefatos Necessários

Antes de executar o Docker Compose, é necessário gerar os arquivos JAR que serão utilizados pelos Dockerfiles. Para facilitar esse processo, você pode utilizar um script que automatiza a geração dos artefatos.

#### Baixar os modulos

Necessario para baixar os repositorios dos serviços.

```bash
git submodule update --init --recursive
```


#### Dê permissão de execução ao script:

```bash
chmod +x build.sh
```

#### Executando o Script de Build

Para gerar os arquivos JAR necessários, execute:

```bash
./build.sh
```

Este script irá entrar em cada pasta de serviço, executar o Maven para gerar os arquivos necessários, e retornar à raiz do projeto.

### Executando com Docker Compose

Após gerar os artefatos, você pode iniciar os serviços com o Docker Compose:

```bash
docker-compose up --build -d
```

Isso irá iniciar:

- **Client Service API** na porta definida em `${CLIENT_PORT}` (por padrão, `3030`).
- **Insurance Service API** na porta definida em `${INSURANCE_PORT}` (por padrão, `3031`).
- **Banco de Dados PostgreSQL** na porta `5432`.

### Acesso às APIs

- **Client Service API**: [http://localhost:3030/swagger-ui/index.html](http://localhost:3030/swagger-ui/index.html)
- **Insurance Service API**: [http://localhost:3031/swagger-ui/index.html](http://localhost:3031/swagger-ui/index.html)

## Testes

Os projetos incluem testes unitários e de integração utilizando **JUnit 5** e **Mockito**. Para executar os testes, utilize o comando:

```bash
./mvnw test
```

na raiz de cada serviço (`client-service-api` e `insurance-service-api`).

## Boas Práticas Adotadas

- **Código Limpo**: Esforço para manter o código legível, organizado e fácil de entender.
- **Princípios SOLID**: Aplicação dos princípios de design orientado a objetos para melhorar a manutenibilidade e extensibilidade do código.
- **Arquitetura Hexagonal**: Separação clara das responsabilidades e dependências, facilitando testes e manutenção.

## Considerações Finais

Este projeto demonstra a implementação de um sistema de cadastro e contratação de seguros, seguindo boas práticas de desenvolvimento e padrões arquiteturais modernos. A separação em microserviços permite escalabilidade e facilidade de manutenção, enquanto a integração entre eles demonstra a capacidade de comunicação e resiliência necessárias em sistemas distribuídos.

**Autor:** Andrey Henrique Nithack

**Contato:** nithack.contato@gmail.com

---

**Observação:** Certifique-se de que o Docker e o Docker Compose estão instalados em seu sistema. O script `build.sh` deve ser executado antes de iniciar os contêineres para garantir que os artefatos necessários estejam disponíveis para os Dockerfiles.

### Possíveis Ajustes

- Se necessário, ajuste as variáveis de ambiente no arquivo `.env` conforme suas necessidades.
- Caso encontre problemas de permissão, assegure-se de que os arquivos `mvnw` e `build.sh` têm permissão de execução.

### Executando os Serviços Individualmente (Opcional)

Se preferir executar os serviços individualmente sem Docker, siga os passos:

1. **Configurar o Banco de Dados PostgreSQL** com as credenciais especificadas.
2. **Iniciar o Client Service API**:
   ```bash
   cd client-service-api
   ./mvnw spring-boot:run
   ```
3. **Iniciar o Insurance Service API**:
   ```bash
   cd insurance-service-api
   ./mvnw spring-boot:run
   ```
   Certifique-se de que o Client Service API está em execução antes de iniciar o Insurance Service API.

### Interagindo com as APIs

Utilize ferramentas como **Postman** ou **cURL** para testar os endpoints das APIs conforme documentado no Swagger.