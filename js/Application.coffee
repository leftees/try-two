window.Application = () ->
  aM =
    csonify: (obj, indent) ->
      indent = if indent then indent + 1 else 1
      prefix = Array(indent).join '  '
      return ' "' + obj + '"' if typeof obj is 'string'
      return ' ' + obj if typeof obj isnt 'object'
      return ' [' + (aM.csonify(value) for value in obj).join(',') + ' ]' if Array.isArray obj
      return ('\n' + prefix + '"' + key + '":' + aM.csonify(value, indent) for key, value of obj).join ''
    
  init: () ->
    $.getJSON 'http://localhost:3000/users.json'
    .done (data) ->
      $('#work-space').loadTemplate $('#users-table'), {},
        afterInsert: ->
          $('#users-list').loadTemplate $('#user'), data
    
  test_stub: () ->
    $.getJSON 'http://localhost:3000/users.json'
    .done (data) ->
      $('#work-space').loadTemplate $('#users-table'), {},
        afterInsert: ->
          $('#users-list').loadTemplate $('#user'), data
