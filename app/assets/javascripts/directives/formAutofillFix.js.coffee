window.App.directive 'formAutofillFix', ->
  (scope, e, attrs) ->
    # Fixes Chrome bug: https://groups.google.com/forum/#!topic/angular/6NlucSskQjY

    elem.prop 'method', 'POST'


    # Fix autofill issues where Angular doesn't know about autofilled inputs
    if attrs.ngSubmit
      setTimeout ->
        elem.unbind('submit').bind 'submit', (e) ->
          e.preventDefault()
          elem.find('input, textarea, select').trigger('input').trigger('change').trigger 'keydown'
          scope.$apply attrs.ngSubmit
      , 0