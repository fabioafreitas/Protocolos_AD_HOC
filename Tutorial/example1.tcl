# EXEMPLO DE DOIS NÓS CONECTADOS


#criando um objeto Simulator
set ns [new Simulator]



#variável nf representa o arquivo que será escrito com os dados de saída
#o arquivo é aberto em modo de escrita "w"
set nf [open outExample1.nam w]



#indicando de qual Simulator o arquivo receberá os dados
$ns namtrace-all $nf



proc finish {} {
  global ns nf
  $ns flush-trace
  close $nf
  exec nam outExample1.nam &
  exit 0
}

# testando a utilização de parâmetros
proc finish2 {simulation arquivo} {
  $simulation flush-trace
  close $arquivo
  exec nam outExample1.nam &
  exit 0
}



#adicionando dois nós à simulação
set n0 [$ns node]
set n1 [$ns node]



#conecta os nós n0 e n1 com duples-link
#indica uma largura de banda de 1Mb, delay de 10ms e algoritmo de fila DropTail
$ns duplex-link $n0 $n1 1Mb 10ms DropTail



#criando um agente UDP e anexando-o ao nó n0
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0



#criando um tráfego constante de bits (CBR) ligado ao agenre UDP
#tamanho dos pacores 500Bytes
#intervalo 200 por segundo
#anexando CBR ao UDP
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0



#criando um agente nulo, que serve como um dissipador de tráfego (traffic sink) no nó n1
set null0 [new Agent/Null]
$ns attach-agent $n1 $null0



#conecta os agentes de comunicação (Analogia a um VCC e GND)
$ns connect $udp0 $null0



#indicando quando o CBR enviará dados e quando parará
$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"



#indicando que o procedimento "finish" será executado 5
#segundos após o início da simulação
#Recomendado é deixar este comando antes do RUN
$ns at 5.0 "finish2 $ns $nf"



#iniciando a simulação
#DEVE FICAR NO FIM DO ARQUIVO
$ns run
