# Diretório de Mapas

## 🌐 Idioma / Language / 语言 / Wika

<div align="center">

**Escolha o Idioma / Choose Language / 选择语言 / Piliin ang Wika:**

[![English](https://img.shields.io/badge/English-EN-blue?style=flat-square)](../README.md)
[![中文](https://img.shields.io/badge/中文-CN-red?style=flat-square)](README_CN.md)
[![Filipino](https://img.shields.io/badge/Filipino-PH-green?style=flat-square)](README_PH.md)
[![Português (BR)](https://img.shields.io/badge/Português%20(BR)-BR-yellow?style=flat-square)](README_PT_BR.md)

</div>

---

## 📋 Visão Geral
Este diretório contém mapas de jogo, dados de terreno e ativos de design de nível para TalismanOnline.

## 📁 Estrutura do Diretório
```
Maps/
├── Terrain/        # Mapas de altura e dados de terreno
├── Textures/       # Texturas e materiais de terreno
├── Objects/        # Objetos de mapa e adereços
├── Lighting/       # Dados e configurações de iluminação
├── SpawnPoints/    # Pontos de spawn de jogadores e monstros
└── Boundaries/     # Dados de limites de zonas e colisões
```

## 🔍 Pontos de Análise de Mapa
Ao analisar arquivos de mapa, foque em:
- **Topologia do terreno** - Mudanças de altura, inclinações, corpos d'água
- **Mapeamento de textura** - Resolução de textura, qualidade de mapeamento UV
- **Colocação de objetos** - Densidade de adereços, padrões de distribuição
- **Configuração de spawn points** - Localizações iniciais de jogadores, pontos de spawn de monstros
- **Limites de zonas** - Tamanho do mapa, áreas restritas
- **Métricas de desempenho** - Contagem de polígonos, uso de memória de textura

## 📊 Especificações Técnicas
Arquivos de mapa geralmente contêm:
- **Height maps** - Imagens de escala de cinza de 8 ou 16 bits
- **Camadas de textura** - Texturas de mistura de múltiplas camadas
- **Malhas de colisão** - Geometria de colisão simplificada
- **Dados de iluminação** - Lightmaps e fontes de luz dinâmicas
- **Zonas de som** - Áreas de gatilho de som ambiente

## 🛠️ Ferramentas de Análise
Ferramentas recomendadas para análise de mapas:
- **World Machine** - Geração e análise profissional de terreno
- **Terragen** - Renderização de terreno de alta qualidade
- **QGIS** - Análise e visualização de dados geográficos
- **Visualizadores de mapa personalizados** - Ferramentas específicas do jogo
- **Analisadores de desempenho** - Uso de memória e desempenho de renderização

## ⚡ Focos de Otimização
Áreas-chave para otimização de mapas:
- **Níveis de detalhe do terreno** - Simplificação de terreno distante
- **Atlas de textura** - Reduzir mudanças de textura
- **Oclusão de corte** - Ocultar objetos não visíveis
- **Sistema LOD** - Nível de detalhe dinâmico
- **Carregamento por streaming** - Carregamento de mapa em blocos

## 📈 Melhores Práticas
1. **Mantenha backups** - Controle de versão de arquivos de mapa originais
2. **Teste diferentes configurações** - Teste de desempenho em diferentes hardwares
3. **Documente mudanças** - Log detalhado de alterações e razões
4. **Foque no orçamento de desempenho** - Limites predefinidos de polígonos e texturas
5. **Valide compatibilidade** - Garanta compatibilidade com versão do motor do jogo