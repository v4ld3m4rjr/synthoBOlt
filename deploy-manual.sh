#!/bin/bash

# Script para deploy manual na Hostinger
# Execute: chmod +x deploy-manual.sh && ./deploy-manual.sh

echo "🚀 Iniciando deploy para Hostinger..."

# Verificar se npm está instalado
if ! command -v npm &> /dev/null; then
    echo "❌ npm não encontrado. Instale o Node.js primeiro."
    exit 1
fi

# Instalar dependências
echo "📦 Instalando dependências..."
npm install

# Build do projeto
echo "🔨 Fazendo build do projeto..."
npm run build

# Verificar se o build foi criado
if [ ! -d "dist" ]; then
    echo "❌ Pasta dist não encontrada. Build falhou."
    exit 1
fi

echo "✅ Build concluído com sucesso!"
echo "📁 Arquivos prontos na pasta 'dist/'"
echo ""
echo "📋 Próximos passos:"
echo "1. Acesse o File Manager da Hostinger"
echo "2. Navegue até public_html"
echo "3. Delete arquivos existentes"
echo "4. Faça upload de todos os arquivos da pasta 'dist/'"
echo "5. Certifique-se que o arquivo .htaccess foi enviado"
echo ""
echo "🌐 Seu site estará disponível em: https://synthonia.bio"