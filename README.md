# pdv-modulo_path-assincrono

- Descrição:

Atualizar o moduloPHPPDV no Ubuntu 22 e desativar o path_comum Assincrono.

- Como usar:

Clonar o repositório e executar o Script `run.sh`
___
## Atualizar o moduloPHPPDV

Copie o arquivo `móduloPHPPDV_{VERSAO}_php_8_1.zip` para o diretório `atualizamodulo`.  
Execute o Script, coloque o usuário e a senha do Docker quando pedir.  

```bash
bash atualizamodulo.sh
````
___
## Apenas desativar o path_comum

Se for apenas desativar o path_comum, não precisa baixar o repositório completo.
Dá pra executar direto o Script para desativar:

- Usando curl
```bash
curl -s https://raw.githubusercontent.com/elppans/pdv-modulo_path-assincrono/refs/heads/main/desativar_path_comum_assincrono.sh | bash
```

- Usando wget
```bash
wget -qO- https://raw.githubusercontent.com/elppans/pdv-modulo_path-assincrono/refs/heads/main/desativar_path_comum_assincrono.sh | bash
```
