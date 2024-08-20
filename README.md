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

1. **Gerar Chave Pública de Acesso ao Ambiente:**
   - No console da AWS, vá para **EC2** > **Chaves de Acesso** > **Criar Par de Chaves**.
   - Escolha o tipo de chave (RSA ou ED25519) e forneça um nome. Baixe a chave privada (`.pem`) ou (`.ppk`) se for utilizar o Putty.

2. **Criar 1 Instância EC2 com o Sistema Operacional Amazon Linux 2 (Família t3.small, 16 GB SSD):**
   - No console da AWS, vá para **EC2** > **Instâncias** > **Lançar Instância**.
   - Escolha **Amazon Linux 2** como o sistema operacional.
   - Na seção de tipo de instância, selecione a família `t3.small`.
   - Configure o armazenamento com 16 GB SSD.

3. **Criar VPC:**
   - No console da AWS, vá para **VPC** > **Criar VPC**.
   - Escolha o nome da VPC, um bloco CIDR (por exemplo, `10.0.0.0/16`), e configure as outras opções conforme necessário.

4. **Criar Sub-rede:**
   - No console da AWS, vá para **VPC** > **Sub-redes** > **Criar Sub-rede**.
   - Escolha a VPC criada anteriormente, defina o bloco CIDR (por exemplo, `10.0.1.0/24`), e selecione uma zona de disponibilidade.
   - Nomeie a sub-rede e conclua a criação.

5. **Criar Gateway da Internet:**
   - No console da AWS, vá para **VPC** > **Gateways da Internet** > **Criar Gateway da Internet**.
   - Nomeie o gateway, crie e anexe-o à VPC criada anteriormente.
   
6. **Criar Tabela de Rotas:**
   - No console da AWS, vá para **VPC** > **Tabelas de Rotas** > **Criar Tabela de Rotas**.
   - Nomeie a tabela de rotas, associe-a à VPC, e adicione uma rota padrão (0.0.0.0/0) apontando para o Gateway da Internet criado anteriormente.

7. **Gerar Elastic IP:**
   - No console da AWS, vá para **EC2** > **Elastic IPs** > **Alocar Novo Endereço Elastic IP**.
   - Associe o Elastic IP à instância EC2 que você criou anteriormente.

8. **Liberar as Portas de Comunicação para Acesso Público:**
   - No console da AWS, vá para **EC2** > **Grupos de Segurança** > selecione o grupo associado à instância > **Editar Regras de Entrada**.
   - Adicione regras para as portas necessárias:
     - `22/TCP` para SSH
     - `111/TCP e UDP` para RPCBind
     - `2049/TCP e UDP` para NFS
     - `80/TCP` para HTTP
     - `443/TCP` para HTTPS



## Configuração no Linux

1. **Configurar NFS**:
   - Instale o servidor NFS para compartilhamento de arquivos.
   ```bash
   sudo yum install nfs-utils -y
   ```
   - Edite o arquivo `/etc/exports`, adicione a linha de configuração para compartilhar o diretório desejado e reinicie o serviço NFS:
   ```bash
      sudo nano /etc/exports
   ```
   - Adicione a linha:
    ```bash
      /mnt/compartilhar *(rw,sync,no_root_squash)
   ```
   - Salve e feche o arquivo, depois reinicie o serviço NFS:
   ```bash
      sudo systemctl restart nfs-server
      sudo systemctl enable nfs-server
   ```
2. **Criar um Diretório no Filesystem do NFS:**
    - Crie um diretório dentro do filesystem do NFS com o seu nome.
   ```bash
   sudo mkdir /mnt/compartilhar/lucas
   ```
   
3. **Subir um Apache no servidor**:
    - Instale o servidor Apache.
   ```bash
   sudo yum install httpd -y
   ```

   - Inicie o serviço Apache.
   ```bash
   sudo systemctl start httpd
   sudo systemctl enable httpd
   ```

  
   
4. **Criar um Script de Validação**:
    - Crie um script para verificar se o serviço Apache está online e salve-o no NFS.
   ```bash
   sudo nano /usr/local/bin/check_apache.sh
   ```
   - Adicione o seguinte conteúdo ao script:
   ```bash
   #!/bin/bash
    service="httpd"
    date_time=$(date '+%Y-%m-%d %H:%M:%S')
    status=$(systemctl is-active $service)
    if [ "$status" = "active" ]; then
        echo "$date_time - $service - ONLINE" >> /mnt/compartilhar/seu_nome/online_status.log
    else
        echo "$date_time - $service - OFFLINE" >> /mnt/compartilhar/seu_nome/offline_status.log
    fi

   ```
    - Torne o script executável.
   ```bash
   sudo chmod +x /usr/local/bin/check_apache.sh

   ```

5. **Automatizar a Execução do Script**:
    - Configure o cron para rodar o script a cada 5 minutos.
   ```bash
   sudo crontab -e
   ```

   - Adicione a seguinte linha ao cron:
   ```bash
   */5 * * * * /usr/local/bin/check_apache.sh
   ```
