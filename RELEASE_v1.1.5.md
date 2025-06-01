# 🚀 CLAISS v1.1.5 - Visualização de Alterações

## ✨ Novas Funcionalidades

### 🔍 Comando `diff`
Visualize as alterações antes de aplicar as refatorações! O novo comando `diff` permite que você veja exatamente o que será modificado antes de fazer qualquer alteração.

**Como usar:**
```bash
claiss diff CAMINHO_DO_PROJETO ARQUIVO_DE_REGRAS.json
```

**Opções disponíveis:**
- `--context=N` - Controla o número de linhas de contexto (padrão: 3)
- `--color` - Ativa/desativa cores na saída (padrão: ativado)

### 🔄 Modo Dry-Run
Adicionado suporte a `--dry-run` no comando `refactor` para simular as alterações sem modificar os arquivos.

## 🛠 Melhorias

- **Desempenho** otimizado no processamento de múltiplos arquivos
- **Mensagens de log** mais descritivas e úteis
- **Tratamento de erros** mais robusto e informativo
- **Documentação** completa em português e inglês

## 🐛 Correções

- Corrigido problema ao lidar com diretórios vazios
- Resolvido erro ao processar arquivos com caracteres especiais
- Melhorias na formatação do README

## 📦 Instalação

```bash
gem install claiss
```

## 📚 Documentação Completa

Consulte o [README](https://github.com/JulioPapel/claiss#readme) para exemplos detalhados de uso.

## 🙌 Agradecimentos

Obrigado a todos os contribuidores que ajudaram a melhorar o CLAISS!

---

**Nota de Atualização:** Recomendamos fortemente atualizar para esta versão para aproveitar as melhorias de desempenho e as novas funcionalidades.

📅 **Data de Lançamento:** 1 de Junho de 2025  
🔗 **GitHub Release:** [v1.1.5](https://github.com/JulioPapel/claiss/releases/tag/v1.1.5)  
🐛 **Relatar Problemas:** [Issues](https://github.com/JulioPapel/claiss/issues)
