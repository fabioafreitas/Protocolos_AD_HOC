[![Network Simulator 2](https://img.shields.io/badge/simulator-ns2-lightgrey.svg)](https://www.isi.edu/nsnam/ns/)

# Redes Sem Fio

Comparação da performance dos procolos AODV, DSDV e DSR combinando os seguintes valores de quantidade de nós e velocidade de movimentação:
  - Quantidade de nós móveis: 12, 32 e 52
  - Velocidade dos nós: 1, 5 e 10 m/s

## Execução

Executa a simulação
#### `ns [file.tcl]` 

Inicia a animação da simulação
#### `nam [file.nam]`

Calcula o Packet Delivery Ratio
#### `./GetPDR.sh`