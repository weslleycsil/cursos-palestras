# Scripts para Utilizar junto ao Serviço

Aqui encontramos dois scripts simples para ajudar em algumas tarefas do dia a dia.
O aconselhável é manter os dois na mesma pasta, pois um alimenta o outro

## new_nfs.sh

Esse script basicamente cria uma nova pasta dentro da pasta principal do compartilhamento, após criar ela adiciona as permissões padroes e adicionar no arquivo '/etc/exports' o novo compartilhamento. Após isso ele expoem o novo compartilhamento e adiciona esse novo compartilhamento no script 'du.sh' para que na sua proxima execução já possa se ter o uso do novo compartilhamento.

Talvez possa ser necessário a modificação do mesmo, caso você opte por utilizar outra localização padrão diferente do utilizado nos exemplos de configuração e também no script.

## du.sh

Esse script basicamente apresenta a estatisticas de uso de disco para cada volume compartilhado.