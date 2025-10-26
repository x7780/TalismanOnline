# Mga Direktoryo ng Mapa

## 🌐 Wika / Language / 语言 / Idioma

<div align="center">

**Piliin ang Wika / Choose Language / 选择语言 / Escolha o Idioma:**

[![English](https://img.shields.io/badge/English-EN-blue?style=flat-square)](../README.md)
[![中文](https://img.shields.io/badge/中文-CN-red?style=flat-square)](README_CN.md)
[![Filipino](https://img.shields.io/badge/Filipino-PH-green?style=flat-square)](README_PH.md)
[![Português (BR)](https://img.shields.io/badge/Português%20(BR)-BR-yellow?style=flat-square)](README_PT_BR.md)

</div>

---

## 📋 Pangkalahatang-ideya
Ang direktoryong ito ay naglalaman ng mga mapa ng laro, data ng terrain, at mga asset ng disenyo ng antas para sa TalismanOnline.

## 📁 Istraktura ng Direktoryo
```
Maps/
├── Terrain/        # Mga height map at terrain data
├── Textures/       # Mga texture ng terrain at materyales
├── Objects/        # Mga bagay sa mapa at props
├── Lighting/       # Mga data ng pag-iilaw at configuration
├── SpawnPoints/    # Mga spawn point ng manlalaro at nilalang
└── Boundaries/     # Mga hangganan ng zone at collision data
```

## 🔍 Mga Puntos sa Pagsusuri ng Mapa
Kapag nagsusuri ng mga file ng mapa, magtuon sa:
- **Topology ng terrain** - Mga pagbabago sa taas, slope, anyong tubig
- **Pag-map ng texture** - Resolution ng texture, kalidad ng UV mapping
- **Paglalagay ng bagay** - Density ng props, pattern ng distribution
- **Configuration ng spawn point** - Mga simulang lokasyon ng manlalaro, spawn point ng kalaban
- **Mga hangganan ng zone** - Sukat ng mapa, mga limitadong lugar
- **Mga metric ng performance** - Bilang ng polygon, paggamit ng texture memory

## 📊 Mga Teknikal na Pagtutukoy
Ang mga file ng mapa ay karaniwang naglalaman ng:
- **Height map** - 8-bit o 16-bit grayscale na mga imahe
- **Mga layer ng texture** - Multi-layer na halo-halong texture
- **Collision mesh** - Pinasimpleng geometric collision
- **Data ng pag-iilaw** - Mga lightmap at dynamic na mga ilaw
- **Mga zone ng tunog** - Mga trigger zone ng ambient na tunog

## 🛠️ Mga Kasangkapan sa Pagsusuri
Inirerekomendang mga kasangkapan sa pagsusuri ng mapa:
- **World Machine** - Propesyonal na pagbuo at pagsusuri ng terrain
- **Terragen** - Mataas na kalidad na pag-render ng terrain
- **QGIS** - Pagsusuri at pag-visualize ng geograpikong data
- **Custom na map viewer** - Mga tool na partikular sa laro
- **Performance profiler** - Paggamit ng memorya at performance ng pag-render

## ⚡ Mga Pokus sa Pag-optimize
Mahahalagang lugar sa pag-optimize ng mapa:
- **Level ng detalye ng terrain** - Pag-simplify ng malayuang terrain
- **Atlas ng texture** - Pagbawas sa pagpapalit ng texture
- **Occlusion culling** - Pagtatago ng mga hindi nakikitang bagay
- **LOD system** - Dynamic na antas ng detalye
- **Streaming na pag-load** - Pag-load ng mapa sa chunks

## 📈 Mga Pinakamahusay na Kasanayan
1. **Panatilihin ang backup** - Version control ng mga orihinal na file ng mapa
2. **Subukan ang iba't ibang configuration** - Performance testing sa iba't ibang hardware
3. **Itala ang mga pagbabago** - Detalyadong log ng mga pagbabago at dahilan
4. **Magtuon sa performance budget** - Paunang naitakdang limitasyon ng polygon at texture
5. **Patunayan ang compatibility** - Tiyakin ang pagiging tugma sa bersyon ng game engine