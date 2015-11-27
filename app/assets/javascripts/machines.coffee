###
validar:
  1- cuando se suelte un elemento validar si hay espacio OK
  2- realizar n calculos en elementos afectados 
  3- ingresar y sacar elementos del portapaples OK
  4- pegar el portapapeles en algun sitio OK
  5- 

  sortable OK
  1-restar "deduct" tiempo disponible (cuando entra un pedido)
  2-sumar "increase" tiempo disponible (cuando sale un pedido)

  items cruzados
  1-un item puede estar en 2 dias
  2-se debe restar del tiempo disponible del dia 2 el sobrante de tiempo del item
  3-el item debe ser el ultimo en el dia 1
  4-si el dia libera tiempo debe restarlo del dia 2
  5-un dia totalmente programado equivale a 0 minutos disponibles
###
clipboard = {
  items : []
  createItemHelper: ->
    $('#item-helper-clipboard').remove()
    html = '<li id="item-helper-clipboard"class="ui-state-default" minutes="0">
              <dl id="clipboard-helper">
              </dl>
            </li>'
    $('#clipboard').append(html)
  add: (item)->
    @items.push(item)
    name_item = $(item).find('table tr  td:first').text()
    $("<dd id='c#{$(item).attr('id')}'>ss</dd>").text(name_item).addClass("ui-state-default").appendTo('#clipboard-helper')
    #incrementar item-helper-clipboard 
    minutes_helper = parseInt($('#item-helper-clipboard').attr('minutes'))
    $('#item-helper-clipboard').attr('minutes', minutes_helper + parseInt($(item).attr('minutes')))
    @updateItemHelper()
  remove: (item)->
    @items = @items.filter (element)->#quitar los elementos que coincidan con el valor recibido
      $(element).attr('id') != $(item).attr('id')
    #quitar elemento del sortable 
    $('#clipboard-helper').find("#c"+"#{$(item).attr('id')}").remove()
    #deduct item-helper-clipboard 
    minutes_helper = parseInt($('#item-helper-clipboard').attr('minutes'))
    $('#item-helper-clipboard').attr('minutes', minutes_helper - parseInt($(item).attr('minutes')))
    @updateItemHelper()
  view: ->
    for item in @items
      console.log $(item).text()
  paste: (day)->
    # for item in @items
    #   sort.increase($(item).parent(), $(item).attr('minutes'))#aumenta el tiempo-d del dia origen
    #   $(item).appendTo(day)#mueve el item al destino
    #   sort.deduct($(item).parent(), $(item).attr('minutes'))#disminuye el tiempo-d del dia destino
    $('#item-helper-clipboard').replaceWith(@items)
    @clear()
    sort.calculateTime()
  clear: ->#quita los check de los items y limpia todos los items
    for item in @items
      $(item).find('input').prop('checked',false)
      $(item).removeClass('ui-state-highlight')#le quita la clase que lo identifica sleccionado
    $('#labelItemClipboard').text("vacio")
    @createItemHelper()
    @items = []#clear
  updateItemHelper:->
    item = $('#item-helper-clipboard')
    $('#labelItemClipboard').text "minutes #{$(item).attr('minutes')}"+'"'
}
#––––––––––––––––––––––––––––---------------------------------------------------------------------------
sort = { 
deduct: (element,value)->#resta tiempo al dia
  available = $(element).attr 'minutes-available'
  occupied = $(element).attr 'minutes-occupied'
  $(element).attr 'minutes-available', available - value
  $(element).attr 'minutes-occupied', parseInt(occupied) + parseInt(value)
  @updateInfo(element)
increase: (element,value)->#incrementa tiempo al dia
  available = $(element).attr 'minutes-available'
  occupied = $(element).attr 'minutes-occupied'
  sum = parseInt(available) + parseInt(value)
  $(element).attr 'minutes-available', sum
  $(element).attr 'minutes-occupied', occupied - value
  @updateInfo(element)
  
calculateTime: ->#actualiza en todos los dias el tiempo disponible menos el portapapeles
  $('.sortable:not(#clipboard)').each ->
    minutes = parseInt $(this).attr('minutes')
    minutes_occupied = 0
    $(this).children('li').each (index)->
      minutes_occupied = minutes_occupied + parseInt($(this).attr('minutes'))
    $(this).attr('minutes-occupied', minutes_occupied)
    $(this).attr('minutes-available', minutes - minutes_occupied)
    sort.updateInfo(this)
validateTimeAvailable: (day,minutes) ->#valida si hay espacio en un dia
  @minutes_available = parseInt $(day).attr('minutes-available')
  @minutes = parseInt minutes
  if @minutes_available >= @minutes
    console.log(true)
    true
  else
    console.log(false)
    false
updateInfo:(element)->
  minutes = parseInt($(element).attr('minutes'))
  available = parseInt($(element).attr('minutes-available'))
  occupied = parseInt($(element).attr('minutes-occupied'))
  moment.locale('es')
  name_day = moment($(element).attr('day'),"YYYY-MM-DD").format("dddd DD MMMM YYYY")
  # #{available} / #{minutes} 
  $(element).find('.date').text(name_day)
  $(element).find('.equivalence').text("#{available} de #{minutes} minutos")
  $(element).find('.progress span')
  .css("width","#{Math.round((occupied/minutes)*100)}%")
  .find('.percent').text("#{Math.round((occupied/minutes)*100)}%")
}
#------------------------------------------------------------------------------------------------------------
$ ->
	$( ".days > .sortable" ).sortable
      connectWith: ".connectedSortable"
      cancel: ".ui-state-disabled"
      items: "li:not(.ui-state-disabled)"
      placeholder: "ui-state-highlight"
      handle: ".handle"
      revert: true
      cursor: "move"
      cancel: "a,button,input"
      containment: ".days"
      cursorAt: { bottom: 5 }
      opacity: 0.8
      start: (event, ui) ->
        sort.increase $(ui.item).parent(), $(ui.item).attr('minutes')
      stop: (event, ui) ->
        @minutes = $(ui.item).attr('minutes')
        clipboard.clear()#cancela los cambios si se hace un cambio por fuera del clipboard
        if sort.validateTimeAvailable( $(ui.item).parent() , @minutes )
          sort.deduct $(ui.item).parent(), @minutes
        else
          $(this).sortable('cancel')
          alert("No hay espacio en este dia. :(")
          sort.deduct $(ui.item).parent(), @minutes
      update: ->
        data = $(this).sortable('serialize')
        console.log(data)

    .disableSelection()

    $('#clipboard').sortable
      revert: true
      connectWith: ".connectedSortable"
      placeholder: "ui-state-highlight"
      items :"#item-helper-clipboard"
      start: (event, ui) ->
        if $(ui.item).attr('minutes') == "0"
          console.log(this)
          #$(this).sortable('cancel')
      stop: (event, ui) ->
        @minutes = $(ui.item).attr('minutes')
        if sort.validateTimeAvailable( $(ui.item).parent() , @minutes )#valida si el dia tiene tiempo disponible
          clipboard.paste($(ui.item).parent())
        else
          alert("No hay espacio en este dia. :(")
          $(this).sortable('cancel')

    .disableSelection()

    $('.days').selectable
      filter:'li'
      cancel:'.handle'
      stop:(event,ui)->
        clipboard.clear()
        $('.ui-selected',this).each ->
          clipboard.add this
    .find( "li" )
      .addClass( "ui-corner-all" )
      .prepend( "<div class='handle'><span class='ui-icon ui-icon-carat-2-n-s'></span></div>")

    $('#btnViewClipboard').click ->
      clipboard.view()

    clipboard.createItemHelper()
    sort.calculateTime()
      


