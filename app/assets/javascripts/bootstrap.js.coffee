jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  
$ ->
 # enable chosen js
 $('.chosen-select').chosen
   allow_single_deselect: true
   no_results_text: 'No results matched'
   width: '200px'