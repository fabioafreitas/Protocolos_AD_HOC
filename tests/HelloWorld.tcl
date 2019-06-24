set nsim [new Simulator]
$nsim at 1 "puts \"Hello World!\""
$nsim at 1.5 "exit"
$nsim run
