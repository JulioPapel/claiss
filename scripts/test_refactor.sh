#!/bin/bash

# Função para mostrar o menu de ajuda
show_help() {
    echo "Uso: $0 [OPÇÕES]"
    echo ""
    echo "Opções:"
    echo "  --dry-run     Mostra as alterações que seriam feitas sem aplicar"
    echo "  --diff       Mostra as diferenças entre os arquivos originais e refatorados"
    echo "  --apply      Aplica as alterações de refatoração"
    echo "  --help       Mostra esta mensagem de ajuda"
    echo ""
    echo "Exemplos:"
    echo "  $0 --dry-run    # Visualiza as alterações"
    echo "  $0 --diff      # Mostra as diferenças"
    echo "  $0 --apply     # Aplica as alterações"
}

# Verifica se o diretório de origem existe
if [ ! -d "test_projects/crewai" ]; then
    echo "Erro: Diretório de origem 'test_projects/crewai' não encontrado."
    echo "Por favor, clone o repositório primeiro com:"
    echo "  git clone git@github.com:crewAIInc/crewAI.git test_projects/crewai"
    exit 1
fi

# Processa os argumentos
DRY_RUN=false
SHOW_DIFF=false
APPLY_CHANGES=false

for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=true
            ;;
        --diff)
            SHOW_DIFF=true
            ;;
        --apply)
            APPLY_CHANGES=true
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Erro: Argumento inválido: $arg"
            show_help
            exit 1
            ;;
    esac
done

# Se nenhuma opção for fornecida, mostra o menu de ajuda
if [ "$DRY_RUN" = false ] && [ "$SHOW_DIFF" = false ] && [ "$APPLY_CHANGES" = false ]; then
    show_help
    exit 0
fi

# Cria o diretório de destino se não existir
if [ ! -d "test_projects/laiss_cognitive_ai" ]; then
    echo "Criando diretório de destino..."
    cp -r test_projects/crewai test_projects/laiss_cognitive_ai
fi

# Função para mostrar as diferenças
show_diff() {
    echo -e "\n=== MOSTRANDO DIFERENÇAS ===\n"
    
    # Encontra todos os arquivos modificados
    find test_projects/crewai -type f | while read -r file; do
        rel_path="${file#test_projects/crewai/}"
        new_file="test_projects/laiss_cognitive_ai/$rel_path"
        
        # Verifica se o arquivo existe no diretório de destino
        if [ -f "$new_file" ]; then
            # Verifica se há diferenças
            if ! cmp -s "$file" "$new_file"; then
                echo -e "\n\033[1mArquivo: $rel_path\033[0m"
                # Mostra as diferenças lado a lado com cor
                diff -y --color=always --suppress-common-lines "$file" "$new_file" | head -n 20
                echo "... (mais diferenças não mostradas)"
                echo ""
            fi
        fi
    done
    
    echo -e "\n=== FIM DAS DIFERENÇAS ===\n"
}

# Executa o dry-run se solicitado
if [ "$DRY_RUN" = true ]; then
    echo -e "\n=== TESTE DRY RUN ===\n"
    bundle exec exe/claiss refactor test_projects/laiss_cognitive_ai crewai_to_laiss --dry-run
    echo -e "\n=== FIM DO DRY RUN ===\n"
    
    # Pergunta se quer ver as diferenças
    if [ "$SHOW_DIFF" = false ]; then
        read -p "Deseja ver as diferenças detalhadas? (s/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            SHOW_DIFF=true
        fi
    fi
fi

# Mostra as diferenças se solicitado
if [ "$SHOW_DIFF" = true ]; then
    show_diff
fi

# Aplica as alterações se solicitado
if [ "$APPLY_CHANGES" = true ]; then
    echo -e "\n=== APLICANDO ALTERAÇÕES ===\n"
    
    # Se não for dry-run, aplica as alterações
    if [ "$DRY_RUN" = false ]; then
        # Cria uma cópia limpa se não existir
        if [ ! -d "test_projects/laiss_cognitive_ai" ]; then
            echo "Criando cópia limpa do diretório..."
            cp -r test_projects/crewai test_projects/laiss_cognitive_ai
        fi
    fi
    
    # Aplica as alterações
    bundle exec exe/claiss refactor test_projects/laiss_cognitive_ai crewai_to_laiss
    
    echo -e "\n=== ALTERAÇÕES APLICADAS EM test_projects/laiss_cognitive_ai ===\n"
    
    # Mostra um resumo das alterações
    echo "Resumo das alterações:"
    echo "- Arquivos modificados: $(find test_projects/laiss_cognitive_ai -type f -exec grep -l "LaissCognitiveAI" {} \; | wc -l)"
    echo "- Ocorrências de 'crewAI' substituídas por 'LaissCognitiveAI'"
    echo "- Ocorrências de 'agent' substituídas por 'LCF'"
    echo "- Informações de contato e autoria atualizadas"
    echo ""
    
    # Pergunta se quer ver as diferenças
    if [ "$SHOW_DIFF" = false ]; then
        read -p "Deseja ver as diferenças detalhadas? (s/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            show_diff
        fi
    fi
fi

echo -e "\n=== PROCESSO CONCLUÍDO ===\n"
