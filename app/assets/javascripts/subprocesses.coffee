# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
###
validar:
  1- cuando se suelte un elemento validar si hay espacio
  2- realizar n calculos en elementos afectados
  3- ingresar y sacar elementos del portapaples
  4- pegar el portapapeles en algun sitio
  5- 

  sortable OK
  1-restar "deduct" tiempo disponible (cuando entra un pedido)
  2-sumar "increase" tiempo disponible (cuando sale un pedido)
###
sort = { 
deduct: (element,value)->#resta tiempo al dia
  current = $(element).attr 'minutes-available'
  $(element).attr 'minutes-available', current - value
  $(element).find('label').text(current - value)
increase: (element,value)->#incrementa tiempo al dia
  current = $(element).attr 'minutes-available'
  sum = parseInt(current) + parseInt(value)
  $(element).attr 'minutes-available', sum
  $(element).find('label').text(sum)
calculateTime: ->#actualiza en todos los dias el tiempo disponible
  $('.sortable').each ->
    @minutes = parseInt $(this).attr('minutes')
    @minutes_occupied = parseInt $(this).attr('minutes-occupied')
    $(this).attr('minutes-available', @minutes - @minutes_occupied)
    $(this).find('label').text(@minutes - @minutes_occupied)#actualizar el label
validateTimeAvailable: (day,minutes) ->#valida si hay espacio en un dia
  @minutes_available = parseInt $(day).attr('minutes-available')
  @minutes = parseInt minutes
  if @minutes_available >= @minutes
    console.log(true)
    true
  else
    console.log(false)
    false
}
$ ->
	$( ".days > .sortable, #clipboard" ).sortable
      connectWith: ".connectedSortable"
      cancel: ".ui-state-disabled"
      items: "li:not(.ui-state-disabled)"
      revert: true
      cursor: "move"
      cancel: "a,button"
      containment: ".days"
      cursorAt: { bottom: 5 }
      opacity: 0.8
      start: (event, ui) ->
        sort.increase $(ui.item).parent(), $(ui.item).attr('minutes')
        #console.log $(ui.item).parent().attr('id')
      stop: (event, ui) ->
        @minutes = $(ui.item).attr('minutes')
        if sort.validateTimeAvailable( $(ui.item).parent() , @minutes )
          sort.deduct $(ui.item).parent(), @minutes
        else
          $(this).sortable('cancel')
          alert("No hay espacio en este dia. :(")
          sort.deduct $(ui.item).parent(), @minutes

      	#console.log $(ui.item).parent().attr('id')
    .disableSelection()

    $('#clipboard-helper').sortable
    	containment: "parent"
    $('.days > .sortable > li:not(.ui-state-disabled) > input').click ->
    	if $(this).is ":checked"
    		# $(this).parent().appendTo('#clipboard')
    		$("<li id='#{$(this).parent()[0]['id']}'>ss</li>").text($(this).parent().text()).addClass("ui-state-default").appendTo('#clipboard-helper')
    		# $(this).parent().appendTo('#clipboard')
    		console.log $(this).parent()[0]['id']
    	else
    $('li').click ->
      #console.log $(this).attr('minutes')
    sort.calculateTime()
      


