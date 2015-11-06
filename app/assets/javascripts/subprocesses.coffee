# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
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
      beforeStop: (event, ui) ->
      	console.log ui
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


