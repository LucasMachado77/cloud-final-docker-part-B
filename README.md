# Cloud Final Project - Part B

**Cloud Computing and Virtualization – Docker Swarm + Rails + PostgreSQL + Monitoring**

Projeto de provisionamento automatizado de um ambiente completo com Docker Swarm, balanceamento de carga, alta disponibilidade de banco de dados, monitoramento, service discovery e deploy automatizado de aplicação Ruby on Rails.

## Sumário

- [Visão Geral](#visão-geral)
- [Arquitetura](#arquitetura)
- [Pré-requisitos](#pré-requisitos)
- [Subindo o Ambiente](#subindo-o-ambiente)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Como Usar](#como-usar)
- [Monitoramento](#monitoramento)
- [Service Discovery](#service-discovery)
- [Credenciais e Segredos](#credenciais-e-segredos)
- [FAQ e Solução de Problemas](#faq-e-solução-de-problemas)
- [Autores](#autores)

---

## Visão Geral

Este projeto implementa um ecossistema cloud *moderno* para execução de aplicações web de forma resiliente, monitorada e escalável, utilizando:
- **Docker Swarm** para orquestração e alta disponibilidade,
- **Ruby on Rails** como aplicação principal,
- **PostgreSQL** (com repmgr) replicado,
- **Nginx** como reverse proxy,
- **Prometheus** e **Grafana** para monitoramento,
- **Consul** para service discovery,
- **cAdvisor** para monitoramento de containers.

## Arquitetura

Internet
│
[NGINX Reverse Proxy] <--- Load balancing (porta 8080)
│
[Docker Swarm Services]
├─ workout-app (Rails, porta 3010)
├─ PostgreSQL Master (porta 5432)
├─ PostgreSQL Replica (porta 5433)
├─ Prometheus (porta 9090)
├─ Grafana (porta 3000)
├─ Consul (porta 8500)
└─ cAdvisor (porta 8081)

yaml
Copiar
Editar

---

## Pré-requisitos

- **Vagrant** (com provider VirtualBox)
- **Docker** e **Docker Compose**
- **Git**
- Recomendado: 8GB RAM (mínimo 6GB), CPU 2+ cores
- Acesso à internet para baixar imagens

---

## Subindo o Ambiente

### 1. Clone o repositório

```bash
git clone https://github.com/LucasMachado77/cloud-final-docker-part-B.git
cd cloud-final-docker-part-B
```
```bash
2. Gere as chaves SSH (se necessário)
ssh-keygen -t ed25519 -C "your_email@example.com"
Salve em ~/.ssh/id_ed25519 (padrão).
```
```bash
3. Suba as VMs com Vagrant
vagrant up
Espere todos os hosts subirem (manager, worker-1, worker-2).
```
```bash
4. Acesse a VM manager:
vagrant ssh manager
cd /vagrant
```
```bash
5. Build da aplicação Rails (dentro do manager):
docker build -t workout-app:1.0 ./workoutday
```
```bash
6. Suba o stack Docker Swarm
docker stack deploy -c docker-compose.yml cloud-final-docker
```
```bash
7. Verifique os serviços
docker service ls
Todos os serviços devem aparecer como REPLICAS X/X.
```
Estrutura do Projeto
.
├── app/                # Código-fonte da aplicação (Rails)
├── nginx/              # Configuração do NGINX
├── prometheus/         # Config do Prometheus/Grafana
├── provision/          # Scripts/Ansible/Vagrant de provisionamento
├── secrets/            # Arquivos de segredos
├── ws/                 # (opcional) outros serviços ou web servers
├── Dockerfile          # Dockerfile da aplicação principal
├── docker-compose.yml  # Stack do Docker Swarm
├── Vagrantfile         # Infraestrutura VM local
├── entrypoint.sh       # Script de entrypoint do container Rails
└── README.md
Como Usar
Acesso à aplicação:
http://localhost:8080 (reverse proxy balanceando para o Rails)

Prometheus:
http://localhost:9090

Grafana:
http://localhost:3000
Login padrão: admin/admin

Consul:
http://localhost:8500

cAdvisor:
http://localhost:8081

Monitoramento
Prometheus coleta métricas dos serviços.

Grafana conecta no Prometheus para dashboards prontos.

cAdvisor expõe métricas detalhadas de containers Docker.

Service Discovery
Consul permite visualizar e registrar os serviços do ecossistema.

Serviços são automaticamente registrados via Docker Compose.

Credenciais e Segredos
Os arquivos de segredos devem ser criados em ./secrets/, por exemplo:

postgres_password.txt

repmgr_password.txt

db_user_password.txt

rails_secret_key_base.txt

db_connection_string.txt

Copie ou gere estes arquivos com as senhas adequadas antes de subir o stack!

FAQ e Solução de Problemas
Problema: Erro de banco de dados na aplicação.

Solução: Verifique o arquivo config/database.yml e os segredos.

Problema: Serviços não sobem.

Solução: Veja logs com docker service logs <service> --tail 100.

Problema: Erros de permissão ou segredos.

Solução: Os arquivos de segredos precisam estar com permissões corretas e sem quebras de linha extras.

Problema: Rails não conecta ao banco.

Solução: Certifique-se que as variáveis/segredos estão configuradas e que o banco está ativo (docker service ps cloud-final-docker_postgresql-node1).

Autor
Lucas Machado – @LucasMachado77

Projeto acadêmico - Mestrado em Engenharia de Computação (Instituto Politécnico de Tomar)
