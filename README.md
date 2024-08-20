# PROJETO LINUX

## Requisitos AWS:

- Gerar uma chave pública para acesso ao ambiente.
- Criar 1 instância EC2 com o sistema operacional Amazon Linux 2 (Família t3.small, 16 GB SSD).
- Gerar 1 elastic IP e anexar à instância EC2.
- Liberar as portas de comunicação para acesso público: 
  - 22/TCP
  - 111/TCP e UDP
  - 2049/TCP/UDP
  - 80/TCP
  - 443/TCP

## Requisitos no Linux:

- Configurar o NFS entregue.
- Criar um diretório dentro do filesystem do NFS com seu nome.
- Subir um Apache no servidor - o Apache deve estar online e rodando.
- Criar um script que valide se o serviço está online e envie o resultado da validação para o seu diretório no NFS.
- O script deve conter:
  - Data e hora
  - Nome do serviço
  - Status
  - Mensagem personalizada de "ONLINE" ou "OFFLINE"
- O script deve gerar 2 arquivos de saída: 1 para o serviço online e 1 para o serviço OFFLINE.
- Preparar a execução automatizada do script a cada 5 minutos.

## Configuração na AWS

1. **Criar VPC**:
   - Crie uma VPC (Virtual Private Cloud) para isolar sua rede virtual na AWS.
   
2. **Criar Subnet**:
   - Dentro da VPC, crie uma Subnet para definir um bloco de endereços IP e hospedar os recursos.
   
3. **Criar Gateway**:
   - Configure um Internet Gateway para permitir que os recursos na VPC se comuniquem com a internet.
   
4. **Criar Tabela de Rotas**:
   - Defina uma Tabela de Rotas para controlar o tráfego de rede dentro da VPC, direcionando o tráfego para o Gateway.
   
5. **Criar a Instância**:
   - Lance uma instância EC2 dentro da Subnet criada para executar seus aplicativos ou serviços.
   
6. **Criar o Security Group**:
   - Crie um Security Group para definir regras de firewall, controlando o tráfego de entrada e saída da instância EC2.
   
7. **Criar o Elastic IP**:
   - Alinhe um Elastic IP à instância EC2 para fornecer um endereço IP estático, facilitando o acesso público.


## Configuração no Linux

1. **Configurar NFS**:
   - Instale o servidor NFS para compartilhamento de arquivos.
   ```bash
   sudo yum install nfs-utils -y
   ```
   - Edite o arquivo `/etc/exports`, adicione a linha de configuração para compartilhar o diretório desejado e reinicie o serviço NFS:

```bash
sudo vi /etc/exports

   



