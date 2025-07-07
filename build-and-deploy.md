# Deploy na Hostinger - Guia Completo

## 1. Preparação do Projeto para Build

### Configurações de Build
O projeto React precisa ser buildado para produção antes do deploy.

### Comandos de Build
```bash
# Instalar dependências
npm install

# Build para produção
npm run build
```

### Arquivos Gerados
Após o build, será criada uma pasta `dist/` com todos os arquivos estáticos.

## 2. Configuração no GitHub

### 2.1 Criar Repositório
1. Acesse [GitHub](https://github.com)
2. Clique em "New repository"
3. Nome: `synthonia-dashboard`
4. Marque como "Public" ou "Private"
5. Clique em "Create repository"

### 2.2 Fazer Push do Código
```bash
# Inicializar git (se ainda não foi feito)
git init

# Adicionar remote do GitHub
git remote add origin https://github.com/SEU_USUARIO/synthonia-dashboard.git

# Adicionar arquivos
git add .

# Commit
git commit -m "Initial commit - Synthonia Dashboard"

# Push para GitHub
git push -u origin main
```

## 3. Configuração na Hostinger

### 3.1 Acesso ao Painel
1. Faça login no painel da Hostinger
2. Vá para "Hospedagem" → "Gerenciar"
3. Acesse o "File Manager" ou use FTP

### 3.2 Preparar Diretório
1. Navegue até a pasta `public_html`
2. Delete arquivos padrão (index.html, etc.)
3. Esta será a pasta raiz do seu site

### 3.3 Upload dos Arquivos
Você tem duas opções:

#### Opção A: Upload Manual
1. Faça o build local: `npm run build`
2. Compacte a pasta `dist/` em um arquivo ZIP
3. No File Manager da Hostinger, faça upload do ZIP
4. Extraia o conteúdo diretamente na pasta `public_html`

#### Opção B: Git Deploy (Recomendado)
1. No painel da Hostinger, procure por "Git Deploy" ou "Auto Deploy"
2. Conecte com seu repositório GitHub
3. Configure para fazer deploy automático da branch `main`

## 4. Configuração de DNS

### 4.1 Verificar Nameservers
Certifique-se que o domínio `synthonia.bio` está usando os nameservers da Hostinger:
- `ns1.dns-parking.com`
- `ns2.dns-parking.com`

### 4.2 Configurar Registros DNS
No painel da Hostinger, vá para "DNS Zone":

```
Tipo: A
Nome: @
Valor: [IP do servidor da Hostinger]
TTL: 300

Tipo: CNAME
Nome: www
Valor: synthonia.bio
TTL: 300
```

## 5. Configuração para SPA (Single Page Application)

### 5.1 Arquivo .htaccess
Crie um arquivo `.htaccess` na pasta `public_html`:

```apache
RewriteEngine On
RewriteBase /

# Handle Angular and React Router
RewriteRule ^index\.html$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.html [L]

# Security headers
Header always set X-Frame-Options DENY
Header always set X-Content-Type-Options nosniff
Header always set X-XSS-Protection "1; mode=block"
Header always set Referrer-Policy "strict-origin-when-cross-origin"

# Compression
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/x-javascript
</IfModule>

# Cache static assets
<IfModule mod_expires.c>
    ExpiresActive on
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/svg+xml "access plus 1 year"
</IfModule>
```

## 6. Automatização com GitHub Actions

### 6.1 Criar Workflow
Crie o arquivo `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Hostinger

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Build
      run: npm run build
    
    - name: Deploy to Hostinger via FTP
      uses: SamKirkland/FTP-Deploy-Action@4.3.3
      with:
        server: ${{ secrets.FTP_SERVER }}
        username: ${{ secrets.FTP_USERNAME }}
        password: ${{ secrets.FTP_PASSWORD }}
        local-dir: ./dist/
        server-dir: /public_html/
```

### 6.2 Configurar Secrets no GitHub
No repositório GitHub, vá para Settings → Secrets and variables → Actions:

```
FTP_SERVER: ftp.synthonia.bio (ou IP do servidor)
FTP_USERNAME: seu_usuario_ftp
FTP_PASSWORD: sua_senha_ftp
```

## 7. Verificação e Testes

### 7.1 Checklist de Deploy
- [ ] Build executado com sucesso
- [ ] Arquivos enviados para public_html
- [ ] .htaccess configurado
- [ ] DNS propagado
- [ ] Site acessível via synthonia.bio
- [ ] Todas as rotas funcionando

### 7.2 Comandos de Verificação
```bash
# Testar build local
npm run build
npm run preview

# Verificar DNS
nslookup synthonia.bio

# Testar conectividade
ping synthonia.bio
```

## 8. Manutenção

### 8.1 Updates Automáticos
Com o GitHub Actions configurado, cada push na branch `main` fará deploy automático.

### 8.2 Monitoramento
- Verifique logs no painel da Hostinger
- Configure alertas de uptime
- Monitore performance do site

## Próximos Passos
1. Configurar SSL/HTTPS na Hostinger
2. Configurar CDN se necessário
3. Implementar analytics
4. Configurar backup automático